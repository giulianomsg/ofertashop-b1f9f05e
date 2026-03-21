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
            productName
            imageUrl
            offerLink
            shopeeShortLink
            commissionRate
            sales
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
        const rawPrice = parseFloat(shopeeItem.price) || parseFloat(shopeeItem.priceMin) || 0;
        const rawMax = parseFloat(shopeeItem.priceMax) || rawPrice;
        const price = rawPrice > 100000 ? rawPrice / 100000 : rawPrice;
        const maxPrice = rawMax > 100000 ? rawMax / 100000 : rawMax;
        const originalPrice = maxPrice > price ? maxPrice : null;

        const updates: Record<string, any> = {};
        
        // Update price
        const currentPrice = parseFloat(product?.price || 0);
        const finalPrice = price > 0 ? price : 0.01;
        if (Math.abs(finalPrice - currentPrice) > 0.01) {
          updates.price = finalPrice;
        }

        // Update original_price
        const currentOriginalPrice = parseFloat(product?.original_price || 0);
        if (originalPrice !== null && originalPrice !== currentOriginalPrice) {
          updates.original_price = originalPrice;
        } else if (originalPrice === null && product?.original_price != null) {
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
          rawPrice: rawPrice,
          rawMax: rawMax,
          calcPrice: price,
          calcMaxPrice: maxPrice,
          calcOriginalPrice: originalPrice,
          dbCurrentPrice: currentPrice,
          dbFinalPrice: finalPrice,
          priceDiff: Math.abs(finalPrice - currentPrice),
          willUpdatePrice: Math.abs(finalPrice - currentPrice) > 0.01,
        });

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

        await sb.from("shopee_product_mappings").update({
          last_synced_at: new Date().toISOString(),
          shopee_commission_rate: Number(shopeeItem.commissionRate) || mapping.shopee_commission_rate,
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
