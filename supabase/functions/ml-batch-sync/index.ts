// Edge Function: ml-batch-sync (standalone)
// Syncs all imported ML products: updates price, status, stock
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

async function fetchWithRetry(url: string, options: any, retries = 3): Promise<any> {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const res = await fetch(url, options);
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      return await res.json();
    } catch (err: any) {
      if (attempt === retries) throw err;
      console.warn(`Tentativa ${attempt} falhou (${url}): ${err.message}. Retentando em ${attempt * 1000}ms...`);
      await new Promise(r => setTimeout(r, attempt * 1000));
    }
  }
}

async function getValidToken(sb: any, appId: string, clientSecret: string): Promise<string> {
  const { data: token } = await sb
    .from("ml_tokens")
    .select("*")
    .order("updated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!token) throw new Error("Nenhum token ML encontrado.");

  const expiresAt = new Date(token.expires_at).getTime();
  if (Date.now() < expiresAt - 5 * 60 * 1000) return token.access_token;

  const res = await fetch("https://api.mercadolibre.com/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "refresh_token",
      client_id: appId,
      client_secret: clientSecret,
      refresh_token: token.refresh_token,
    }),
  });
  const data = await res.json();
  if (!res.ok || !data.access_token) throw new Error("Falha ao renovar token ML");

  await sb.from("ml_tokens").update({
    access_token: data.access_token,
    refresh_token: data.refresh_token,
    expires_at: new Date(Date.now() + data.expires_in * 1000).toISOString(),
    updated_at: new Date().toISOString(),
  }).eq("id", token.id);

  return data.access_token;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const userId = body.userId || null;

    const ML_APP_ID = Deno.env.get("ML_APP_ID");
    const ML_CLIENT_SECRET = Deno.env.get("ML_CLIENT_SECRET");
    if (!ML_APP_ID || !ML_CLIENT_SECRET) throw new Error("ML_APP_ID e ML_CLIENT_SECRET não configurados.");

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    const accessToken = await getValidToken(sb, ML_APP_ID, ML_CLIENT_SECRET);

    // Get all active ML mappings with extended fields needed for full sync
    const { data: mappings, error: mapErr } = await sb
      .from("ml_product_mappings")
      .select("*, products(id, title, price, original_price, is_active, sales_count, available_quantity, badge, image_url)")
      .eq("sync_status", "active");

    if (mapErr) throw mapErr;
    if (!mappings || mappings.length === 0) {
      return new Response(JSON.stringify({ message: "Nenhum produto ML para sincronizar" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    let processed = 0, updated = 0, deactivated = 0;
    const errors: string[] = [];
    const debugTrace: any[] = [];

    // Process in batches of 20 using multiget
    const batchSize = 20;
    for (let i = 0; i < mappings.length; i += batchSize) {
      const batch = mappings.slice(i, i + batchSize);
      const ids = batch.map((m: any) => m.ml_item_id).join(",");

      try {
        // Removed attributes param to see if ML API is rejecting standard fields for affiliates
        const items = await fetchWithRetry(`https://api.mercadolibre.com/items?ids=${ids}`, {
          headers: { Authorization: `Bearer ${accessToken}` },
        });

        if (!Array.isArray(items)) {
          errors.push(`API Error: ${JSON.stringify(items)}`);
          continue;
        }

        for (const itemWrapper of items) {
          processed++;
          const item = itemWrapper.body;

          if (itemWrapper.code === 404) {
            const mapping = batch.find((m: any) => m.ml_item_id === (item?.id || itemWrapper.body?.id || itemWrapper.body?.message?.match(/MLB\d+/)?.[0]));
            if (mapping) {
              await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id);
              await sb.from("ml_product_mappings").update({ ml_status: "not_found", last_synced_at: new Date().toISOString() }).eq("id", mapping.id);
              deactivated++;
              debugTrace.push({ id: mapping.ml_item_id, action: "DEACTIVATED_404", reason: "API returned 404" });
            }
            continue;
          }

          if (itemWrapper.code !== 200 || !item) {
            errors.push(`Item ${itemWrapper.code}: ${JSON.stringify(itemWrapper)}`);
            debugTrace.push({ error: `Item HTTP ${itemWrapper.code}`, payload: itemWrapper });
            continue;
          }

          const mapping = batch.find((m: any) => m.ml_item_id === item.id);
          if (!mapping) continue;

          const product = mapping.products;
          const productUpdates: any = {};
          const mappingUpdates: any = { last_synced_at: new Date().toISOString() };
          
          let debugLog: any = { 
             ml_id: item.id, 
             title: product.title,
             api_status: item.status, 
             db_status: product.is_active ? "active" : "inactive",
             api_price: item.price,
             db_price: product.price,
             updates_applied: []
          };

          // Price changes - robust float parsing
          const itemPrice = parseFloat(item.price) || 0;
          const currentPrice = parseFloat(product?.price) || 0;
          if (itemPrice > 0 && Math.abs(itemPrice - currentPrice) > 0.01) {
            productUpdates.price = itemPrice;
            mappingUpdates.ml_current_price = itemPrice;
            debugLog.updates_applied.push(`Price changed from ${currentPrice} to ${itemPrice}`);
          }
          
          if (item.original_price !== undefined) {
            const itemOp = parseFloat(item.original_price) || 0;
            const op = itemOp > itemPrice ? itemOp : null;
            if (op !== (parseFloat(product?.original_price) || null)) {
              productUpdates.original_price = op;
              mappingUpdates.ml_original_price = op;
            }
          }

          // Status changes
          const newStatus = item.status === "active";
          if (newStatus !== product?.is_active) {
            productUpdates.is_active = newStatus;
            mappingUpdates.ml_status = item.status || "inactive";
            debugLog.updates_applied.push(`Status changed to ${newStatus ? 'ACTIVE' : 'INACTIVE'} (API said: ${item.status})`);
            if (!newStatus) deactivated++;
          } else if (item.status !== mapping.ml_status) {
            mappingUpdates.ml_status = item.status;
          }

          // Complete Extended Info Sync: Condition, Stock, Sales
          const conditionBadge = item.condition === "new" ? "Novo" : item.condition === "used" ? "Usado" : null;
          if (conditionBadge && product?.badge !== conditionBadge) {
             productUpdates.badge = conditionBadge;
             mappingUpdates.ml_condition = item.condition;
          }

          if (item.sold_quantity !== undefined) {
             const soldQuantity = parseInt(item.sold_quantity) || 0;
             if (soldQuantity !== parseInt(product?.sales_count || "0")) {
                productUpdates.sales_count = soldQuantity;
                mappingUpdates.ml_sold_quantity = soldQuantity;
             }
          }

          if (item.available_quantity !== undefined) {
             const availableQuantity = parseInt(item.available_quantity) || 0;
             if (availableQuantity !== parseInt(product?.available_quantity || "0")) {
                productUpdates.available_quantity = availableQuantity;
                mappingUpdates.ml_available_quantity = availableQuantity;
             }
          }

          // Title
          if (item.title && item.title !== product?.title) {
            productUpdates.title = item.title;
          }

          // Thumbnail
          if (item.thumbnail) {
            const thumb = item.thumbnail.replace("http://", "https://");
            if (mapping.ml_thumbnail !== thumb || product?.image_url !== thumb) {
               mappingUpdates.ml_thumbnail = thumb;
               productUpdates.image_url = thumb;
            }
          }

          // Apply updates
          if (Object.keys(productUpdates).length > 0) {
            const { error: prodErr } = await sb.from("products").update(productUpdates).eq("id", mapping.product_id);
            if (!prodErr) {
              updated++;
            } else {
              errors.push(`Product Update Error for ${item.id}: ${prodErr.message}`);
              debugLog.error = prodErr.message;
            }
          }
          await sb.from("ml_product_mappings").update(mappingUpdates).eq("id", mapping.id);
          
          if (debugLog.updates_applied.length > 0 || debugLog.api_status !== "active") {
             debugTrace.push(debugLog);
          }
        }
      } catch (batchErr: any) {
        errors.push(`Batch error: ${batchErr.message}`);
        debugTrace.push({ batchError: batchErr.message });
      }

      // Rate limit: small delay between batches
      if (i + batchSize < mappings.length) {
        await new Promise((r) => setTimeout(r, 500));
      }
    }

    // Log
    await sb.from("ml_sync_logs").insert({
      sync_type: "batch_sync",
      status: errors.length > 0 ? "partial" : "success",
      items_processed: processed,
      items_updated: updated,
      items_deactivated: deactivated,
      error_message: errors.length > 0 ? errors.slice(0, 5).join("; ") : null,
      triggered_by: userId,
      completed_at: new Date().toISOString(),
    });

    console.log("=== ML BATCH SYNC DEBUG TRACE ===", JSON.stringify(debugTrace, null, 2));

    return new Response(JSON.stringify({
      success: true,
      processed,
      updated,
      deactivated,
      errors: errors.length,
      error_details: errors,
      debug_trace: debugTrace
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("ml-batch-sync error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
