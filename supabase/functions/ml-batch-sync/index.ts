// Edge Function: ml-batch-sync (standalone)
// Syncs all imported ML products exclusively via ScrapingBee & Cheerio
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// --- MULTI-SCRAPER ABSTRACTION (STANDALONE) ---
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
    api.searchParams.append("premium_proxy", "true");
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
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    api.searchParams.append("premium", "true");
    return api.toString();
  }
  throw new Error(`Scraper provider desconhecido: ${provider}`);
}

async function getActiveScraperConfig(sb: any): Promise<ScraperConfig> {
  try {
     const { data } = await sb.from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle();
     if (data?.value?.activeProvider && data?.value?.keys) {
        const provider = data.value.activeProvider;
        const apiKey = data.value.keys[provider];
        if (apiKey) return { provider, apiKey };
     }
  } catch(e) { /* ignore */ }
  
  // Legacy DB Fallback
  try {
     const { data: legacy } = await sb.from("admin_settings").select("value").eq("key", "active_scraper").maybeSingle();
     if (legacy?.value?.provider && legacy?.value?.apiKey) return legacy.value as ScraperConfig;
  } catch(e) { /* ignore */ }

  const scrapingBeeKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (scrapingBeeKey) return { provider: "scrapingbee", apiKey: scrapingBeeKey };
  throw new Error("Nenhum serviço de Web Scraper configurado com chave válida no banco de dados.");
}
// ----------------------------------------------

// Retry logic to handle occasional proxy/network failures gracefully
async function fetchHtmlWithRetry(url: string, options: any, retries = 3): Promise<{ html: string, status: number }> {
  const isDebug = options.isDebug;
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const res = await fetch(url, options);
      // Permite 404 passar para tratamento semilimitado em logica nativa
      if (!res.ok && res.status !== 404) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      
      let finalHtml = await res.text();
      try {
        const json = JSON.parse(finalHtml);
        if (json && typeof json.content === 'string') finalHtml = json.content;
      } catch(e) { /* not JSON, ignore */ }
      
      return { html: finalHtml, status: res.status };
    } catch (err: any) {
      if (attempt === retries) throw err;
      if (isDebug) console.warn(`Tentativa HTML ${attempt} falhou: ${err.message}. Retentando...`);
      await new Promise(r => setTimeout(r, attempt * 1000));
    }
  }
  return { html: "", status: 500 };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const userId = body.userId || null;
    const isDebug = body.debug === true;

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Dynamic Multi-Scraper Abstraction Loading
    const scraperConfig = await getActiveScraperConfig(sb);

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

    // Concurrency size of 5 requests at a time so we don't blow past standard ScrapingBee Rate limits
    const CHUNK_SIZE = 5;
    
    for (let i = 0; i < mappings.length; i += CHUNK_SIZE) {
      const chunk = mappings.slice(i, i + CHUNK_SIZE);
      
      const chunkPromises = chunk.map(async (mapping: any) => {
         const product = mapping.products;
         let debugLog: any = { 
             ml_id: mapping.ml_item_id, 
             title: product?.title,
             api_status: "SCRAPING", 
             db_status: product?.is_active ? "active" : "inactive",
             updates_applied: []
         };

         try {
           const fallbackUrl = `https://produto.mercadolivre.com.br/${mapping.ml_item_id.replace('MLB', 'MLB-')}`;
           const mlUrl = mapping.ml_permalink || fallbackUrl;
           
           const proxyScraperApiTargetUrl = buildScraperUrl(scraperConfig, mlUrl);

           const { html, status } = await fetchHtmlWithRetry(proxyScraperApiTargetUrl, { isDebug }, 3);
           const $ = cheerio.load(html);

           // 1. Verificação Estrita de 404 (via Header e HTML)
           const isNotFound = status === 404 || $('h3').text().includes('Parece que esta página não existe') || html.includes('está indisponível');
           if (isNotFound) {
              await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id);
              await sb.from("ml_product_mappings").update({ ml_status: "not_found", last_synced_at: new Date().toISOString() }).eq("id", mapping.id);
              deactivated++;
              debugLog.updates_applied.push("DEACTIVATED_404_PAGE_MISSING");
              return debugLog;
           }

           // 2. Extração Segura de Preço (pode faltar centavos)
           const isPaused = html.includes('Anúncio pausado') || $('.ui-pdp-message').text().toLowerCase().includes('pausado');
           const priceWhole = $('.ui-pdp-price__second-line .andes-money-amount__fraction').first().text().replace(/\./g, '');
           const priceCents = $('.ui-pdp-price__second-line .andes-money-amount__cents').first().text() || '00';
           
           const itemPrice = priceWhole ? parseFloat(`${priceWhole}.${priceCents}`) : 0;
           const currentPrice = parseFloat(product?.price) || 0;
           
           const productUpdates: any = {};
           const mappingUpdates: any = { last_synced_at: new Date().toISOString() };

           // Apenas atualiza o Preço se mudou no ML de verdade
           if (itemPrice > 0 && Math.abs(itemPrice - currentPrice) > 0.01) {
             productUpdates.price = itemPrice;
             mappingUpdates.ml_current_price = itemPrice;
             debugLog.updates_applied.push(`Price changed: ML ${itemPrice} vs Banco ${currentPrice}`);
           }

           // 3. Atualização de Status
           const newStatus = !isPaused;
           if (newStatus !== product?.is_active) {
             productUpdates.is_active = newStatus;
             mappingUpdates.ml_status = newStatus ? "active" : "paused";
             debugLog.updates_applied.push(`Status Invertido para: ${newStatus ? 'ACTIVE' : 'INACTIVE'} (Site estava ${isPaused ? 'Pausado' : 'Limpo'})`);
             if (!newStatus) deactivated++;
           } else if ((newStatus ? "active" : "paused") !== mapping.ml_status) {
             // Sincroniza apenas a tabela mapping pra manter os metadados vivos
             mappingUpdates.ml_status = newStatus ? "active" : "paused";
           }

           // 4. Salvar Updates se existirem
           if (Object.keys(productUpdates).length > 0) {
             const { error: prodErr } = await sb.from("products").update(productUpdates).eq("id", mapping.product_id);
             if (!prodErr) { 
                updated++; 
             } else { 
                debugLog.error = prodErr.message; 
             }
           }
           await sb.from("ml_product_mappings").update(mappingUpdates).eq("id", mapping.id);
           
           return debugLog;
         } catch (fallbackErr: any) {
           debugLog.error = `Scrape Error no ${mapping.ml_item_id}: ${fallbackErr.message}`;
           return debugLog;
         }
      });

      // Aguarda o chunk rodar de forma simultânea
      const results = await Promise.allSettled(chunkPromises);
      
      results.forEach((r) => {
         if (r.status === 'fulfilled') {
            processed++;
            if (r.value?.error) errors.push(r.value.error);
            if (r.value?.updates_applied?.length > 0 || r.value?.error) {
               debugTrace.push(r.value);
            }
         } else {
            console.error("Chunk failed entirely ->", r.reason);
            errors.push(String(r.reason));
         }
      });
      
      // Delay gentil para o limite de conexão simultânea proxy da API Rest do ScrapingBee
      if (i + CHUNK_SIZE < mappings.length) {
        await new Promise((r) => setTimeout(r, 600));
      }
    }

    // Log the sync attempt history visually
    await sb.from("ml_sync_logs").insert({
      sync_type: "batch_sync_scraping",
      status: errors.length > 0 ? "partial" : "success",
      items_processed: processed,
      items_updated: updated,
      items_deactivated: deactivated,
      error_message: errors.length > 0 ? errors.slice(0, 5).join("; ") : null,
      triggered_by: userId,
      completed_at: new Date().toISOString(),
    });

    console.log(`=== ML BATCH SYNC [SCRAPE] PROCESSED: ${processed} UPDATED: ${updated} DEACTIVATED: ${deactivated} ===`);

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
