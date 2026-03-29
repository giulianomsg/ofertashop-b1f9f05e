// Edge Function: shopee-batch-sync — Refatorado: API Interna JSON para preços reais
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// --- Multi-Scraper Proxy ---
interface ScraperConfig {
  provider: 'scrapingbee' | 'scrape.do' | 'scrapingant' | 'scraperapi';
  apiKey: string;
}

function buildScraperUrl(config: ScraperConfig, targetUrl: string): string {
  const { provider, apiKey } = config;
  if (provider === 'scrapingbee') {
    const api = new URL("https://app.scrapingbee.com/api/v1");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("render_js", "false");
    api.searchParams.append("country_code", "br");
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    return api.toString();
  }
  if (provider === 'scrapingant') {
    const api = new URL("https://api.scrapingant.com/v2/general");
    api.searchParams.append("x-api-key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("proxy_country", "BR");
    api.searchParams.append("browser", "false");
    api.searchParams.append("proxy_type", "residential");
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    return api.toString();
  }
  throw new Error(`Scraper provider desconhecido: ${provider}`);
}

async function getActiveScraperConfig(sb: ReturnType<typeof createClient>): Promise<ScraperConfig> {
  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle();
    if (data?.value?.activeProvider && data?.value?.keys) {
      const provider = data.value.activeProvider;
      const apiKey = data.value.keys[provider];
      if (apiKey) return { provider, apiKey };
    }
  } catch (_e) { /* ignore */ }

  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  throw new Error("Nenhum serviço de Web Scraper configurado.");
}

async function fetchJsonViaScraper(scraperConfig: ScraperConfig, targetUrl: string, maxRetries = 2): Promise<unknown | null> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const proxyUrl = buildScraperUrl(scraperConfig, targetUrl);
      const res = await fetch(proxyUrl);
      if (res.ok) {
        let text = await res.text();
        try {
          const wrapper = JSON.parse(text);
          if (wrapper && typeof wrapper.content === 'string') text = wrapper.content;
        } catch (_e) { /* raw response */ }
        return JSON.parse(text);
      }
    } catch (err) {
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000 * Math.pow(2, i)));
  }
  return null;
}

function normalizeShopeePrice(raw: number): number {
  if (!raw || raw <= 0) return 0;
  if (raw > 100000) return raw / 100000;
  return raw;
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

    const scraperConfig = await getActiveScraperConfig(sb);
    const CONCURRENCY = 3;
    let totalUpdated = 0;
    let totalDeactivated = 0;
    const details: { id: string; title: string; status: string; oldPrice?: number; newPrice?: number }[] = [];
    const syncLogs: string[] = [];

    // Processar em batches com concorrência limitada
    for (let i = 0; i < mappings.length; i += CONCURRENCY) {
      const batch = mappings.slice(i, i + CONCURRENCY);

      await Promise.all(batch.map(async (mapping: Record<string, unknown>) => {
        const itemId = mapping.shopee_item_id as string;
        const shopId = (mapping.shopee_shop_id as string) || "0";
        const product = mapping.products as Record<string, unknown> | null;

        try {
          // Buscar dados via API Interna
          const itemUrl = `https://shopee.com.br/api/v4/item/get?shopid=${shopId}&itemid=${itemId}`;
          const itemData = await fetchJsonViaScraper(scraperConfig, itemUrl) as { data?: Record<string, unknown> } | null;
          const item = itemData?.data || null;

          if (!item) {
            syncLogs.push(`[${itemId}] Falha ao buscar dados.`);
            return;
          }

          // Verificar se fora de estoque
          const stock = Number(item.stock) || 0;
          const status = Number(item.status) || 0;
          const isOutOfStock = stock === 0 || status !== 1;

          if (isOutOfStock && (product as Record<string, unknown>)?.is_active) {
            await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id as string);
            await sb.from("shopee_product_mappings").update({
              sync_status: "unavailable", last_synced_at: new Date().toISOString(),
            }).eq("id", mapping.id as string);
            totalDeactivated++;
            details.push({
              id: mapping.product_id as string,
              title: (product as Record<string, unknown>)?.title as string || "Produto Desconhecido",
              status: "deactivated",
            });
            return;
          }

          // Calcular preços
          const newPrice = normalizeShopeePrice(Number(item.price) || Number(item.price_min) || 0);
          const priceBeforeDiscount = normalizeShopeePrice(
            Number(item.price_before_discount) || Number(item.price_max_before_discount) || 0
          );

          if (newPrice <= 0) {
            syncLogs.push(`[${itemId}] Preço zero ou inválido.`);
            return;
          }

          const currentPrice = Number((product as Record<string, unknown>)?.price || 0);
          const updates: Record<string, unknown> = {};

          // Atualizar preço
          if (Math.abs(newPrice - currentPrice) > 0.01) {
            updates.price = newPrice;
          }

          // Atualizar preço original
          const newOriginalPrice = priceBeforeDiscount > newPrice ? priceBeforeDiscount : null;
          const currentOriginalPrice = Number((product as Record<string, unknown>)?.original_price || 0);
          if (newOriginalPrice !== null && Math.abs(newOriginalPrice - currentOriginalPrice) > 0.01) {
            updates.original_price = newOriginalPrice;
          } else if (newOriginalPrice === null && currentOriginalPrice > 0) {
            updates.original_price = null;
          }

          // Atualizar vendas
          const newSales = Number(item.historical_sold) || Number(item.sold) || 0;
          if (newSales > 0 && newSales !== Number((product as Record<string, unknown>)?.sales_count || 0)) {
            updates.sales_count = newSales;
          }

          // Atualizar rating
          const itemRating = item.item_rating as Record<string, unknown> | null;
          const newRating = Number(itemRating?.rating_star || 0);
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
                // Registrar no histórico de preços
                await sb.from("price_history").insert({
                  product_id: mapping.product_id,
                  old_price: currentPrice,
                  new_price: updates.price,
                  changed_by: userId,
                });
              }

              details.push({
                id: mapping.product_id as string,
                title: (product as Record<string, unknown>)?.title as string || "Produto Desconhecido",
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
        } catch (e: unknown) {
          const msg = e instanceof Error ? e.message : String(e);
          syncLogs.push(`[${itemId}] Erro: ${msg}`);
        }
      }));
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
