// Edge Function: shopee-batch-sync (standalone)
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hash);
}


async function shopeeGraphQL<T = any>(query: string, variables: Record<string, any> = {}): Promise<T> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");
  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");

  const payloadStr = JSON.stringify({ query, variables });
  const timestamp = Math.floor(Date.now() / 1000);
  const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
  const sign = await sha256Hex(factor);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://open-api.affiliate.shopee.com.br";
  const url = `${shopeeHost}/graphql`;
  const payloadBytes = new TextEncoder().encode(payloadStr);

  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
      "Content-Type": "application/json",
    },
    body: payloadBytes,
  });

  const json = await res.json();
  if (json.errors && json.errors.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors.map((e: any) => e.message).join(", ")}`);
  }
  return json.data as T;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const sb = createClient(supabaseUrl, supabaseKey);

  let logId: string | null = null;

  try {
    const body = await req.json().catch(() => ({}));
    const userId = body?.userId || null;

    // Create sync log
    const { data: logEntry } = await sb
      .from("shopee_sync_logs")
      .insert({ sync_type: "batch_sync", status: "running", triggered_by: userId })
      .select("id")
      .single();
    logId = logEntry?.id || null;

    // Fetch all active shopee mappings
    const { data: mappings, error: fetchErr } = await sb
      .from("shopee_product_mappings")
      .select("*, products(id, title, price, original_price, is_active, sales_count)")
      .eq("sync_status", "active");

    if (fetchErr) throw fetchErr;

    if (!mappings || mappings.length === 0) {
      if (logId) {
        await sb.from("shopee_sync_logs").update({
          status: "success", items_processed: 0, completed_at: new Date().toISOString(),
        }).eq("id", logId);
      }
      return new Response(JSON.stringify({ updated: 0, deactivated: 0, total: 0, details: [] }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const BATCH_SIZE = 20;
    let totalUpdated = 0;
    let totalDeactivated = 0;
    const details: any[] = [];
    const debug_info: any[] = [];

    for (let i = 0; i < mappings.length; i += BATCH_SIZE) {
      const batch = mappings.slice(i, i + BATCH_SIZE);
      const itemIds = batch.map((m: any) => String(m.shopee_item_id));

      const aliasQueries = itemIds.map((id: string) => `
        item_${id}: productOfferV2(itemId: ${id}) {
          nodes {
            itemId
            price
            priceMin
            priceMax
            commissionRate
            sales
            appExistRate
            appNewRate
            webExistRate
            webNewRate
            commission
            periodStartTime
            periodEndTime
            productCatIds
            ratingStar
            priceDiscountRate
            shopType
            sellerCommissionRate
            shopeeCommissionRate
          }
        }
      `).join("\n");

      const query = `
        query {
          ${aliasQueries}
        }
      `;

      let shopeeItems: any[] = [];
      let rawData: any = null;
      try {
        rawData = await shopeeGraphQL(query);
        shopeeItems = Object.values(rawData || {}).flatMap((offer: any) => offer?.nodes || []);
        console.log(`Shopee GraphQL Response for batch ${i / BATCH_SIZE}:`, JSON.stringify(shopeeItems, null, 2));
      } catch (e: any) {
        console.warn(`Batch ${i / BATCH_SIZE} query failed:`, e);
        debug_info.push({ error_type: "query_failed", message: e.message, query });
        continue;
      }

      debug_info.push({
        event: "api_fetched",
        rawData: rawData,
        shopeeItemsLength: shopeeItems.length,
        queryStr: query
      });

      if (shopeeItems.length === 0) {
        console.warn(`Batch ${i / BATCH_SIZE} returned empty shopeeItems, skipping to prevent false deactivation.`);
        continue;
      }

      const shopeeMap = new Map(shopeeItems.map((item: any) => [String(item.itemId), item]));

      for (const mapping of batch) {
        const shopeeItem = shopeeMap.get(mapping.shopee_item_id);
        const product = (mapping as any).products;

        if (!shopeeItem) {
          if (product?.is_active) {
            await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id);
            await sb.from("shopee_product_mappings").update({
              sync_status: "unavailable", last_synced_at: new Date().toISOString(),
            }).eq("id", mapping.id);
            totalDeactivated++;
            details.push({ id: mapping.product_id, title: (product as any)?.title || "Produto Desconhecido", status: "deactivated" });
          }
          continue;
        }

        // Calculate prices exactly like shopee-import-product
        const baseRaw = parseFloat(shopeeItem.priceMax) || parseFloat(shopeeItem.price) || parseFloat(shopeeItem.priceMin) || 0;
        const basePrice = baseRaw > 100000 ? baseRaw / 100000 : baseRaw;

        const discountRate = parseFloat(shopeeItem.priceDiscountRate) || 0;

        let finalPrice = basePrice;
        let finalOriginalPrice: number | null = null;

        if (discountRate > 0) {
          finalOriginalPrice = basePrice;
          finalPrice = basePrice * (1 - (discountRate / 100));
        } else {
          finalPrice = basePrice;
          finalOriginalPrice = null;
        }

        const updates: Record<string, any> = {};
        
        // Update price
        const currentPrice = parseFloat(product?.price || 0);
        const finalPriceSanitized = finalPrice > 0 ? finalPrice : 0.01;
        if (Math.abs(finalPriceSanitized - currentPrice) > 0.01) {
          updates.price = finalPriceSanitized;
        }

        // Update original_price
        const currentOriginalPrice = parseFloat(product?.original_price || 0);
        if (finalOriginalPrice !== null && finalOriginalPrice !== currentOriginalPrice) {
          updates.original_price = finalOriginalPrice;
        } else if (finalOriginalPrice === null && product?.original_price != null) {
          // If the original price shouldn't exist anymore, we nullify it
          updates.original_price = null;
        }
        
        const newSales = Number(shopeeItem.sales) || 0;
        if (newSales > 0 && newSales !== Number(product?.sales_count || 0)) {
          updates.sales_count = newSales;
        }

        debug_info.push({
          product_id: mapping.product_id,
          title: (product as any)?.title,
          shopee_raw_price: shopeeItem.price,
          shopee_raw_priceMin: shopeeItem.priceMin,
          shopee_raw_priceMax: shopeeItem.priceMax,
          baseRaw: baseRaw,
          basePrice: basePrice,
          discountRate: discountRate,
          calcPrice: finalPrice,
          calcOriginalPrice: finalOriginalPrice,
          dbCurrentPrice: currentPrice,
          dbFinalPrice: finalPriceSanitized,
          priceDiff: Math.abs(finalPriceSanitized - currentPrice),
          willUpdatePrice: Math.abs(finalPriceSanitized - currentPrice) > 0.01,
        });

        // Update rating in products
        const currentRating = Number(product?.rating || 0);
        const newRating = Number(shopeeItem.ratingStar || 0);
        if (newRating > 0 && newRating !== currentRating) {
          updates.rating = newRating;
        }

        let status = "updated";
        if (!product?.is_active) {
          updates.is_active = true;
          status = "reactivated";
          await sb.from("shopee_product_mappings").update({ sync_status: "active" }).eq("id", mapping.id);
        }

        if (Object.keys(updates).length > 0) {
          const { error: prodErr } = await sb.from("products").update(updates).eq("id", mapping.product_id);
          if (!prodErr) {
            totalUpdated++;
            if (status === "reactivated" || updates.price !== undefined) {
               details.push({ 
                 id: mapping.product_id, 
                 title: (product as any)?.title || "Produto Desconhecido", 
                 status, 
                 oldPrice: product?.price, 
                 newPrice: updates.price !== undefined ? updates.price : product?.price 
               });
            }
          } else {
             console.error(`Shopee Sync DB Update error product ${mapping.product_id}:`, prodErr);
             details.push({ error: prodErr.message, id: mapping.product_id });
          }
        }

        // Construct extra_data JSONB payload mapping all Shopee metrics
        const shopee_extra_data = {
          appExistRate: shopeeItem.appExistRate,
          appNewRate: shopeeItem.appNewRate,
          webExistRate: shopeeItem.webExistRate,
          webNewRate: shopeeItem.webNewRate,
          commission: shopeeItem.commission,
          productCatIds: shopeeItem.productCatIds,
          priceDiscountRate: shopeeItem.priceDiscountRate,
          shopType: shopeeItem.shopType,
          sellerCommissionRate: shopeeItem.sellerCommissionRate,
          shopeeCommissionRate: shopeeItem.shopeeCommissionRate
        };

        const validFrom = shopeeItem.periodStartTime ? new Date(shopeeItem.periodStartTime * 1000).toISOString() : null;
        const validTo = shopeeItem.periodEndTime ? new Date(shopeeItem.periodEndTime * 1000).toISOString() : null;

        await sb.from("shopee_product_mappings").update({
          last_synced_at: new Date().toISOString(),
          shopee_commission_rate: Number(shopeeItem.commissionRate) || mapping.shopee_commission_rate,
          offer_valid_from: validFrom,
          offer_valid_to: validTo,
          shopee_extra_data: shopee_extra_data
        }).eq("id", mapping.id);
      }
    }

    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "success",
        items_processed: mappings.length,
        items_updated: totalUpdated,
        items_deactivated: totalDeactivated,
        completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }

    return new Response(JSON.stringify({ total: mappings.length, updated: totalUpdated, deactivated: totalDeactivated, details, debug_info }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("shopee-batch-sync error:", err);
    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "error", error_message: err.message, completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
