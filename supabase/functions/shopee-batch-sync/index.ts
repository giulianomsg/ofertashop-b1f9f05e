// Edge Function: shopee-batch-sync
// Sincroniza preços e disponibilidade de todos os produtos mapeados da Shopee
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { shopeeGraphQL } from "../_shared/shopee-auth.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

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
      .insert({
        sync_type: "batch_sync",
        status: "running",
        triggered_by: userId,
      })
      .select("id")
      .single();
    logId = logEntry?.id || null;

    // Fetch all active shopee mappings
    const { data: mappings, error: fetchErr } = await sb
      .from("shopee_product_mappings")
      .select("*, products(id, price, original_price, is_active)")
      .eq("sync_status", "active");

    if (fetchErr) throw fetchErr;

    if (!mappings || mappings.length === 0) {
      if (logId) {
        await sb.from("shopee_sync_logs").update({
          status: "success",
          items_processed: 0,
          completed_at: new Date().toISOString(),
        }).eq("id", logId);
      }
      return new Response(
        JSON.stringify({ updated: 0, deactivated: 0, total: 0 }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Process in batches of 20 item IDs
    const BATCH_SIZE = 20;
    let totalUpdated = 0;
    let totalDeactivated = 0;

    for (let i = 0; i < mappings.length; i += BATCH_SIZE) {
      const batch = mappings.slice(i, i + BATCH_SIZE);
      const itemIds = batch.map((m: any) => String(m.shopee_item_id));

      // Query Shopee for current offer data
      const query = `
        query {
          productOfferV2(
            listType: 0
            sortType: 2
            page: 1
            limit: ${BATCH_SIZE}
            itemIds: [${itemIds.map(id => `"${id}"`).join(",")}]
          ) {
            nodes {
              itemId
              priceMin
              priceMax
              productName
              imageUrl
              offerLink
              shopeeShortLink
              commissionRate
            }
          }
        }
      `;

      let shopeeItems: any[] = [];
      try {
        const data = await shopeeGraphQL(query);
        shopeeItems = data?.productOfferV2?.nodes || [];
      } catch (e) {
        console.warn(`Batch ${i / BATCH_SIZE} query failed:`, e);
        continue;
      }

      const shopeeMap = new Map(shopeeItems.map((item: any) => [String(item.itemId), item]));

      for (const mapping of batch) {
        const shopeeItem = shopeeMap.get(mapping.shopee_item_id);
        const product = (mapping as any).products;

        if (!shopeeItem) {
          // Product no longer available on Shopee → deactivate
          if (product?.is_active) {
            await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id);
            await sb.from("shopee_product_mappings").update({ sync_status: "unavailable", last_synced_at: new Date().toISOString() }).eq("id", mapping.id);
            totalDeactivated++;
          }
          continue;
        }

        // Update price if changed
        const newPrice = Number(shopeeItem.priceMin) / 100000;
        const newOriginal = Number(shopeeItem.priceMax) > Number(shopeeItem.priceMin) 
          ? Number(shopeeItem.priceMax) / 100000 
          : null;

        const updates: Record<string, any> = {};
        if (newPrice > 0 && Math.abs(newPrice - Number(product?.price || 0)) > 0.01) {
          updates.price = newPrice;
        }
        if (newOriginal !== null && newOriginal !== Number(product?.original_price || 0)) {
          updates.original_price = newOriginal;
        }

        // Re-activate if was deactivated
        if (!product?.is_active) {
          updates.is_active = true;
          await sb.from("shopee_product_mappings").update({ sync_status: "active" }).eq("id", mapping.id);
        }

        if (Object.keys(updates).length > 0) {
          await sb.from("products").update(updates).eq("id", mapping.product_id);
          totalUpdated++;
        }

        // Update mapping sync timestamp
        await sb.from("shopee_product_mappings").update({ 
          last_synced_at: new Date().toISOString(),
          shopee_commission_rate: Number(shopeeItem.commissionRate) || mapping.shopee_commission_rate,
        }).eq("id", mapping.id);
      }
    }

    // Update log
    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "success",
        items_processed: mappings.length,
        items_updated: totalUpdated,
        items_deactivated: totalDeactivated,
        completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }

    return new Response(
      JSON.stringify({
        total: mappings.length,
        updated: totalUpdated,
        deactivated: totalDeactivated,
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    console.error("shopee-batch-sync error:", err);
    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "error",
        error_message: err.message,
        completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }
    return new Response(
      JSON.stringify({ error: err.message || "Erro interno" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
