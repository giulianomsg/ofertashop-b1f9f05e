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
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    api.searchParams.append("render", "true");
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
  const cleaned = text.replace(/[^\d,\.]/g, "").replace(",", ".");
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

    // Process them in series or limited parallel
    for (const mapping of mappings) {
       if (!mapping.products?.affiliate_url) continue;
       
       const proxyTargetUrl = buildScraperUrl(scraperConfig, mapping.products.affiliate_url);
       const html = await fetchWithRetry(proxyTargetUrl);
       if (!html) {
          debug_trace.push({ id: mapping.id, status: "failed_to_fetch" });
          continue;
       }

       const $ = cheerio.load(html);

       const priceText = $("[class*='sellingPrice'], [class*='price--current'], [class*='Price'] [class*='selling'], .price-best").first().text().trim();
       let newPrice = parsePrice(priceText);
       
       const origText = $("[class*='listPrice'], [class*='price--old'], del, [class*='Price'] [class*='list']").first().text().trim();
       let newOrigPrice = parsePrice(origText);

       let isUnavailable = false;
       if ($("[class*='unavailable'], [class*='Unavailable'], [class*='outOfStock']").length > 0) {
          isUnavailable = true;
          newPrice = 0;
       }

       if (newPrice > 0) {
          if (!newOrigPrice || newOrigPrice <= newPrice) {
             newOrigPrice = newPrice;
          }

          const currentPrice = mapping.products.price;
          const status = "active";
          const isActive = true;

          const updates = {
             price: newPrice,
             original_price: newOrigPrice > newPrice ? newOrigPrice : null,
             is_active: isActive
          };

          // Compare
          if (newPrice !== currentPrice || mapping.products.is_active !== isActive) {
             debug_trace.push({ id: mapping.id, old_price: currentPrice, new_price: newPrice });
             await sb.from("products").update(updates).eq("id", mapping.product_id);

             // Log price history trigger will handle it automatically in DB if price differs
          }

          // Update mapping
          await sb.from("natura_product_mappings").update({
             natura_current_price: newPrice,
             natura_original_price: updates.original_price,
             natura_status: status,
             last_synced_at: new Date().toISOString()
          }).eq("id", mapping.id);

          synced++;
       } else if (isUnavailable || newPrice === 0) {
          // Mark as unavailable
          debug_trace.push({ id: mapping.id, status: "unavailable" });
          await sb.from("products").update({ is_active: false }).eq("id", mapping.product_id);
          await sb.from("natura_product_mappings").update({
             natura_status: "unavailable",
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
