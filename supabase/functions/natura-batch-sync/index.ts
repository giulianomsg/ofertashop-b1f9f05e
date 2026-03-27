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
    api.searchParams.append("render_js", "true");
    api.searchParams.append("premium_proxy", "true");
    api.searchParams.append("country_code", "br");
    api.searchParams.append("wait", "7000"); // Wait for Next.js SPA hydration
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    api.searchParams.append("render", "true");
    api.searchParams.append("wait", "7000");
    return api.toString();
  }
  if (provider === 'scrapingant') {
    const api = new URL("https://api.scrapingant.com/v2/general");
    api.searchParams.append("x-api-key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("proxy_country", "BR");
    api.searchParams.append("browser", "true");
    api.searchParams.append("proxy_type", "residential");
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    api.searchParams.append("render", "true");
    return api.toString();
  }
  return targetUrl;
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
  throw new Error("Nenhum serviço de Web Scraper configurado.");
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
    } catch (err: any) {
      if (i === maxRetries - 1) throw err;
    }
  }
  return null;
}

function parsePrice(text: string): number {
  if (!text) return 0;
  // Remove tudo que não é dígito, ponto ou vírgula
  let cleaned = text.replace(/[^\d.,]/g, "");
  // Formato BR: ponto = milhar, vírgula = decimal → remove pontos, troca vírgula por ponto
  cleaned = cleaned.replace(/\./g, "").replace(",", ".");
  return parseFloat(cleaned) || 0;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { userId } = await req.json();
    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    // Fetch batch of mappings to sync
    const { data: mappings, error: fetchErr } = await sb
      .from("natura_product_mappings")
      .select("*, products(id, price, original_price, affiliate_url, is_active)")
      .order("last_synced_at", { ascending: true, nullsFirst: true })
      .limit(10); // Process 10 items at a time to stay under function timeouts

    if (fetchErr) throw fetchErr;
    if (!mappings || mappings.length === 0) {
       return new Response(JSON.stringify({ success: true, message: "No items to sync" }), { headers: corsHeaders });
    }

    const debug_trace: any[] = [];
    let synced = 0;

    for (const mapping of mappings) {
       if (!mapping.products?.affiliate_url) continue;
       
       const proxyTargetUrl = buildScraperUrl(scraperConfig, mapping.products.affiliate_url);
       const html = await fetchWithRetry(proxyTargetUrl);
       if (!html) {
          debug_trace.push({ id: mapping.id, status: "failed_to_fetch" });
          // Do NOT deactivate the product on fetch failure — it's a scraper issue, not product unavailability
          await sb.from("natura_product_mappings").update({
             last_synced_at: new Date().toISOString()
          }).eq("id", mapping.id);
          synced++;
          continue;
       }

       const $ = cheerio.load(html);

       // Use the same Minhaloja-specific selectors as natura-search-offers and natura-import-product
       let priceText = $("[id='product-price-por']").first().text().trim();
       if (!priceText) priceText = $("[id*='price']:not([id*='de']):not([id*='desconto'])").last().text().trim();
       if (!priceText) priceText = $("[class*='sellingPrice'], [class*='price--current'], .price-best").first().text().trim();
       const newPrice = parsePrice(priceText);
       
       let origText = $("[id='product-price-de']").first().text().trim();
       if (!origText) origText = $("[class*='listPrice'], [class*='price--old'], del").first().text().trim();
       let newOrigPrice = parsePrice(origText);

       // Only consider truly unavailable if the page explicitly says so via a product-unavailable banner
       // AND the page has loaded (has a <title> or <h1>)
       const pageHasContent = $("title").text().trim().length > 0 || $("h1").text().trim().length > 0;
       const hasExplicitUnavailable = $("[data-testid='product-unavailable'], [id='product-unavailable']").length > 0;
       const isUnavailable = pageHasContent && hasExplicitUnavailable;

       if (newPrice > 0) {
          // Product is available, update price
          if (!newOrigPrice || newOrigPrice <= newPrice) {
             newOrigPrice = 0; // No discount case
          }

          const currentPrice = parseFloat(String(mapping.products.price));
          const status = "active";

          const productUpdates: Record<string, any> = {
             is_active: true,
          };

          // Only update price if the scraped price differs from the CURRENT mapped price
          // (not the manually edited products.price), to respect manual overrides
          if (newPrice !== mapping.natura_current_price) {
             productUpdates.price = newPrice;
             if (newOrigPrice > newPrice) {
                productUpdates.original_price = newOrigPrice;
                productUpdates.badge = `${Math.round(((newOrigPrice - newPrice) / newOrigPrice) * 100)}% OFF`;
             }
          }

          debug_trace.push({
            id: mapping.id,
            status: "active",
            old_mapped_price: mapping.natura_current_price,
            new_price: newPrice,
            price_changed: newPrice !== mapping.natura_current_price,
          });

          await sb.from("products").update(productUpdates).eq("id", mapping.product_id);

          // Update mapping
          await sb.from("natura_product_mappings").update({
             natura_current_price: newPrice,
             natura_original_price: newOrigPrice > newPrice ? newOrigPrice : null,
             natura_status: status,
             last_synced_at: new Date().toISOString()
          }).eq("id", mapping.id);

          synced++;
       } else if (isUnavailable) {
          // Only deactivate if the page explicitly shows unavailable
          debug_trace.push({ id: mapping.id, status: "unavailable" });
          await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id);
          await sb.from("natura_product_mappings").update({
             natura_status: "unavailable",
             last_synced_at: new Date().toISOString()
          }).eq("id", mapping.id);
          synced++;
       } else {
          // Could not extract price but page is not explicitly unavailable
          // This means selectors failed or page didn't fully render — do NOT deactivate
          debug_trace.push({ id: mapping.id, status: "price_not_found_skipped", page_has_content: pageHasContent });
          await sb.from("natura_product_mappings").update({
             last_synced_at: new Date().toISOString()
          }).eq("id", mapping.id);
          synced++;
       }
    }

    return new Response(JSON.stringify({ success: true, synced, debug_trace }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("natura-batch-sync error:", err);
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
