// Edge Function: shopee-batch-sync — API Oficial GraphQL + fallback scraper
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// --- Shopee Affiliate GraphQL ---
function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hash);
}

async function shopeeGraphQL<T = unknown>(query: string, variables: Record<string, unknown> = {}): Promise<T> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");
  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");

  const payloadStr = JSON.stringify({ query, variables });
  const timestamp = Math.floor(Date.now() / 1000);
  const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
  const sign = await sha256Hex(factor);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://open-api.affiliate.shopee.com.br";
  const url = `${shopeeHost}/graphql`;

  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
      "Content-Type": "application/json",
    },
    body: new TextEncoder().encode(payloadStr),
  });

  const json = await res.json();
  if (json.errors?.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors.map((e: { message: string }) => e.message).join(", ")}`);
  }
  return json.data as T;
}

// --- Normalizar preço Shopee (vem em micro-unidades: valor * 100000) ---
function normalizeShopeePrice(raw: number | string | undefined | null): number {
  const num = Number(raw);
  if (!num || num <= 0) return 0;
  if (num > 100000) return num / 100000;
  return num;
}

// --- Handler Principal ---
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let logId: string | null = null;

  try {
    const body = await req.json().catch(() => ({}));
    const userId = body?.userId || null;
    const productId = body?.productId || null;

    // Criar log de sincronização
    const { data: logEntry } = await sb.from("shopee_sync_logs")
      .insert({ sync_type: productId ? "single_sync" : "batch_sync", status: "running", triggered_by: userId })
      .select("id").single();
    logId = logEntry?.id || null;

    // Buscar mappings
    let mappingsQuery = sb.from("shopee_product_mappings")
      .select("*, products(id, title, price, original_price, is_active, sales_count, rating)")
      .eq("sync_status", "active");

    if (productId) {
      mappingsQuery = mappingsQuery.eq("product_id", productId);
    }

    const { data: mappings, error: fetchErr } = await mappingsQuery;
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

    let totalUpdated = 0;
    let totalDeactivated = 0;
    const details: { id: string; title: string; status: string; oldPrice?: number; newPrice?: number }[] = [];
    const syncLogs: string[] = [];

    // Processar em batches de 10 via API GraphQL (busca por itemId)
    const BATCH_SIZE = 10;

    for (let i = 0; i < mappings.length; i += BATCH_SIZE) {
      const batch = mappings.slice(i, i + BATCH_SIZE);

      try {
        // Montar query GraphQL para buscar todos os itens do batch
        const aliasQueries = batch.map((m: Record<string, unknown>, idx: number) => {
          const itemId = m.shopee_item_id as string;
          return `item_${idx}: productOfferV2(itemId: ${itemId}) {
            nodes {
              itemId shopId productName price priceMin priceMax sales ratingStar
            }
          }`;
        }).join("\n");

        const batchData = await shopeeGraphQL<Record<string, { nodes: Record<string, unknown>[] }>>(`query { ${aliasQueries} }`);

        // Mapear resultados por itemId
        const resultMap = new Map<string, Record<string, unknown>>();
        for (const [, val] of Object.entries(batchData || {})) {
          const nodes = val?.nodes || [];
          for (const node of nodes) {
            resultMap.set(String(node.itemId), node);
          }
        }

        // Processar cada mapping do batch
        for (const mapping of batch) {
          const itemId = mapping.shopee_item_id as string;
          const product = mapping.products as Record<string, unknown> | null;
          const shopeeItem = resultMap.get(itemId);

          if (!shopeeItem) {
            // Item não retornado pela API — possivelmente fora do ar
            syncLogs.push(`[${itemId}] Sem dados da API.`);
            continue;
          }

          // Calcular preços
          const rawPriceMin = normalizeShopeePrice(shopeeItem.priceMin as number);
          const rawPriceMax = normalizeShopeePrice(shopeeItem.priceMax as number);
          const rawPrice = normalizeShopeePrice(shopeeItem.price as number);

          // priceMin = preço atual/promocional, priceMax = preço original
          const newPrice = rawPriceMin > 0 ? rawPriceMin : rawPrice;
          const newOriginalPrice = rawPriceMax > newPrice ? rawPriceMax : null;

          if (newPrice <= 0) {
            // Preço zero = produto possivelmente indisponível
            if ((product as Record<string, unknown>)?.is_active) {
              await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id as string);
              await sb.from("shopee_product_mappings").update({
                sync_status: "unavailable", last_synced_at: new Date().toISOString(),
              }).eq("id", mapping.id as string);
              totalDeactivated++;
              details.push({
                id: mapping.product_id as string,
                title: (product as Record<string, unknown>)?.title as string || "?",
                status: "deactivated",
              });
            }
            syncLogs.push(`[${itemId}] Preço zero — desativado.`);
            continue;
          }

          const currentPrice = Number((product as Record<string, unknown>)?.price || 0);
          const currentOriginalPrice = Number((product as Record<string, unknown>)?.original_price || 0);
          const updates: Record<string, unknown> = {};

          // Atualizar preço
          if (Math.abs(newPrice - currentPrice) > 0.01) {
            updates.price = newPrice;
          }

          // Atualizar preço original
          if (newOriginalPrice !== null && Math.abs(newOriginalPrice - currentOriginalPrice) > 0.01) {
            updates.original_price = newOriginalPrice;
          } else if (newOriginalPrice === null && currentOriginalPrice > 0) {
            updates.original_price = null;
          }

          // Atualizar vendas
          const newSales = Number(shopeeItem.sales) || 0;
          if (newSales > 0 && newSales !== Number((product as Record<string, unknown>)?.sales_count || 0)) {
            updates.sales_count = newSales;
          }

          // Atualizar rating
          const newRating = Number(shopeeItem.ratingStar) || 0;
          if (newRating > 0 && newRating !== Number((product as Record<string, unknown>)?.rating || 0)) {
            updates.rating = newRating;
          }

          // Reativar se estava inativo
          if (!(product as Record<string, unknown>)?.is_active) {
            updates.is_active = true;
            await sb.from("shopee_product_mappings").update({ sync_status: "active" }).eq("id", mapping.id as string);
          }

          let resultStatus = "unchanged";
          if (Object.keys(updates).length > 0) {
            const { error: updateErr } = await sb.from("products").update(updates).eq("id", mapping.product_id as string);
            if (!updateErr) {
              totalUpdated++;
              resultStatus = updates.price !== undefined ? "price_changed" : "updated";

              if (updates.price !== undefined) {
                await sb.from("price_history").insert({
                  product_id: mapping.product_id,
                  old_price: currentPrice,
                  new_price: updates.price,
                  changed_by: userId,
                });
              }

              details.push({
                id: mapping.product_id as string,
                title: (product as Record<string, unknown>)?.title as string || "?",
                status: resultStatus,
                oldPrice: currentPrice,
                newPrice: (updates.price as number) || currentPrice,
              });
            }
          }

          // Atualizar mapping
          await sb.from("shopee_product_mappings").update({
            last_synced_at: new Date().toISOString(),
          }).eq("id", mapping.id as string);

          syncLogs.push(`[${itemId}] ${resultStatus} — R$${currentPrice.toFixed(2)} → R$${newPrice.toFixed(2)}`);
        }
      } catch (batchErr) {
        const msg = batchErr instanceof Error ? batchErr.message : String(batchErr);
        syncLogs.push(`[Batch ${i}] Erro: ${msg}`);
        console.error(`[Shopee Sync] Batch error:`, batchErr);
      }
    }

    // Atualizar log
    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "success",
        items_processed: mappings.length,
        items_updated: totalUpdated,
        items_deactivated: totalDeactivated,
        completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }

    return new Response(JSON.stringify({
      total: mappings.length,
      updated: totalUpdated,
      deactivated: totalDeactivated,
      details,
      debug_trace: syncLogs,
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Erro interno";
    console.error("shopee-batch-sync error:", err);
    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "error", error_message: message, completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }
    return new Response(JSON.stringify({ error: message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
