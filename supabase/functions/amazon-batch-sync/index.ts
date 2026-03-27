import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

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

async function getActiveScraperConfig(sb: any): Promise<ScraperConfig> {
  try {
     const { data } = await sb.from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle();
     if (data?.value?.activeProvider && data?.value?.keys) {
        const provider = data.value.activeProvider;
        const apiKey = data.value.keys[provider];
        if (apiKey) return { provider, apiKey };
     }
  } catch(e) {}
  
  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  throw new Error("Nenhum serviço de Web Scraper configurado com chave válida no banco.");
}

async function fetchWithRetry(url: string, maxRetries = 2) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const res = await fetch(url);
      if (res.ok) {
        let finalHtml = await res.text();
        try {
          const json = JSON.parse(finalHtml);
          if (json && typeof json.content === 'string') finalHtml = json.content;
        } catch(e) {}
        return finalHtml;
      }
    } catch (err) {
      if (i === maxRetries - 1) throw err;
    }
  }
  return null;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { userId, productId } = await req.json();
    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    let mappingsQuery = sb
      .from("amazon_product_mappings")
      .select("*, products(id, price, is_active)")
      .order("last_synced_at", { ascending: true });

    if (productId) {
      mappingsQuery = mappingsQuery.eq("product_id", productId);
    } else {
      mappingsQuery = mappingsQuery.limit(30);
    }

    const { data: mappings, error: mappingError } = await mappingsQuery;

    if (mappingError) throw mappingError;
    if (!mappings || mappings.length === 0) {
      return new Response(JSON.stringify({ success: true, message: "Nenhum produto para sincronizar." }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    const syncLogs: string[] = [];
    const concurrency = 3; // Limite de chamadas simultâneas para não estourar threads do edge ou block rate

    for (let i = 0; i < mappings.length; i += concurrency) {
      const batch = mappings.slice(i, i + concurrency);
      
      const promises = batch.map(async (mapping: any) => {
        const asin = mapping.amazon_item_id;
        try {
           const targetUrl = `https://www.amazon.com.br/dp/${asin}`;
           const proxyTargetUrl = buildScraperUrl(scraperConfig, targetUrl);
           const html = await fetchWithRetry(proxyTargetUrl, 2);
           
           if (!html) {
              syncLogs.push(`[${asin}] Falha ao baixar HTML.`);
              return;
           }
           
           const $ = cheerio.load(html);
           
           // Capturar o bloco de preço principal
           let priceText = $("#corePriceDisplay_desktop_feature_div .a-price.a-text-price.priceToPay .a-offscreen").text();
           if (!priceText) {
               // Fallback classes antigas
               priceText = $("#priceblock_ourprice").text() || $(".a-price-whole").first().text() + $(".a-price-fraction").first().text();
           }
           
           let newPrice = 0;
           if (priceText) {
               priceText = priceText.replace(/[^\d,]/g, "").replace(",", ".");
               newPrice = parseFloat(priceText) || 0;
           }
           
           // Fallback brutal de Regex (Anti-React Obfuscation) contra quedas da classe .a-price
           if (newPrice === 0) {
               const rawText = $("#corePriceDisplay_desktop_feature_div").text() || $("#centerCol").text() || $("body").text();
               const priceMatch = rawText.match(/R\$\s*(\d{1,3}(?:\.\d{3})*,\d{2})/i);
               if (priceMatch) {
                  newPrice = parseFloat(priceMatch[1].replace(/\./g, "").replace(",", "."));
               }
           }
           
           const isOutOfStock = $("#availability span").text().toLowerCase().includes("não disponível") || $("#outOfStock").length > 0;
           
           if (!isOutOfStock && newPrice > 0) {
              const currentPrice = Number(mapping.products?.price || 0);
              
              const updates: any[] = [];
              if (Math.abs(newPrice - currentPrice) > 0.01) {
                  // Atualizar produto
                  updates.push(sb.from("products").update({ price: newPrice, is_active: true }).eq("id", mapping.product_id));
                  
                  // Inserir histórico
                  updates.push(sb.from("price_history").insert({
                     product_id: mapping.product_id, old_price: currentPrice, new_price: newPrice, changed_by: userId
                  }));
                  syncLogs.push(`[${asin}] Preço atualizado: R$${currentPrice} -> R$${newPrice}`);
              } else if (!mapping.products?.is_active) {
                  updates.push(sb.from("products").update({ is_active: true }).eq("id", mapping.product_id));
                  syncLogs.push(`[${asin}] Reativado (em estoque).`);
              } else {
                  syncLogs.push(`[${asin}] Preço mantido e em estoque.`);
              }
              
              // Atualizar mapping
              updates.push(sb.from("amazon_product_mappings").update({
                  amazon_current_price: newPrice, amazon_status: 'active', last_synced_at: new Date().toISOString()
              }).eq("id", mapping.id));
              
              await Promise.all(updates);
           } else if (isOutOfStock && mapping.products?.is_active) {
              // Desativar produto se esgotou
              const reqs = [
                 sb.from("products").update({ is_active: false }).eq("id", mapping.product_id),
                 sb.from("amazon_product_mappings").update({ amazon_status: 'out_of_stock', last_synced_at: new Date().toISOString() }).eq("id", mapping.id)
              ];
              await Promise.all(reqs);
              syncLogs.push(`[${asin}] Pausado por falta de estoque.`);
           } else {
              // Só atualizar o last_synced_at
              await sb.from("amazon_product_mappings").update({ last_synced_at: new Date().toISOString() }).eq("id", mapping.id);
              syncLogs.push(`[${asin}] Esgotado ou página sem preço detectável.`);
           }
        } catch(e: any) {
           syncLogs.push(`[${asin}] Erro na request: ${e.message}`);
        }
      });
      
      await Promise.all(promises);
    }

    return new Response(JSON.stringify({ success: true, debug_trace: syncLogs }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
