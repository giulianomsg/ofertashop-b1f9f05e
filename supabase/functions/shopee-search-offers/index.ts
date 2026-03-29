// Edge Function: shopee-search-offers (standalone)
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

// --- MULTI-SCRAPER ABSTRACTION ---
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

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
    api.searchParams.append("proxy_type", "residential");
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
  } catch (e) { /* ignore */ }

  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  throw new Error("Nenhum serviço de Web Scraper configurado.");
}

async function fetchWithRetry(url: string, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const res = await fetch(url);
      if (res.ok) {
        let finalHtml = await res.text();
        try {
          const json = JSON.parse(finalHtml);
          if (json && typeof json.content === 'string') finalHtml = json.content;
        } catch (e) { /* raw html */ }
        return finalHtml;
      }
    } catch (err: any) {
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000 * Math.pow(2, i)));
  }
  throw new Error("Falha ao buscar página.");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { keyword, page = 1, limit = 20, sortType = 2, deepScrape = false } = await req.json();

    if (!keyword || typeof keyword !== "string") {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    let offers: any[] = [];
    let pageInfo: any = {};

    // 1. URL Direct Matcher
    const urlMatch = keyword.match(/i\.(\d+)\.(\d+)/) || keyword.match(/product\/(\d+)\/(\d+)/);
    
    if (urlMatch) {
      const itemId = urlMatch[2];
      const query = `
        query {
          productOfferV2(itemId: ${itemId}) {
            nodes {
              itemId shopId productName price priceMin priceMax imageUrl productLink commission commissionRate sales ratingStar shopName offerLink periodStartTime periodEndTime appExistRate appNewRate webExistRate webNewRate productCatIds priceDiscountRate shopType sellerCommissionRate shopeeCommissionRate
            }
          }
        }
      `;
      const data = await shopeeGraphQL(query);
      offers = data?.productOfferV2?.nodes || [];
      pageInfo = { page: 1, limit: 1, hasNextPage: false };
    } else {
      // 2. Standard Keyword Search
      const query = `
        query {
          productOfferV2(
            listType: 0
            sortType: ${sortType}
            page: ${page}
            limit: ${limit}
            keyword: "${keyword.replace(/"/g, '\\"')}"
          ) {
            nodes {
              itemId shopId productName price priceMin priceMax imageUrl productLink commission commissionRate sales ratingStar shopName offerLink periodStartTime periodEndTime appExistRate appNewRate webExistRate webNewRate productCatIds priceDiscountRate shopType sellerCommissionRate shopeeCommissionRate
            }
            pageInfo {
              page limit hasNextPage scrollId
            }
          }
        }
      `;
      const data = await shopeeGraphQL(query);
      offers = data?.productOfferV2?.nodes || [];
      pageInfo = data?.productOfferV2?.pageInfo || {};
    }

    // 3. Deep Scraping (Optional)
    if (deepScrape && offers.length > 0) {
      console.log(`[Shopee Search] Executing deep scrape for ${offers.length} items`);
      try {
        const scraperConfig = await getActiveScraperConfig(sb);
        const scrapePromises = offers.map(async (offer: any) => {
           try {
             const url = offer.productLink || offer.offerLink;
             if (!url) return;
             const proxyUrl = buildScraperUrl(scraperConfig, url);
             const html = await fetchWithRetry(proxyUrl, 1);
             const $ = cheerio.load(html);
             
             let scrapedFinalPrice: number | null = null;
             $('script').each((_: any, el: any) => {
               const scriptContent = $(el).html() || '';
               if (!scrapedFinalPrice) {
                 const priceMatch = scriptContent.match(/"price":\s*(\d{4,9})/);
                 if (priceMatch) {
                    const rawP = parseInt(priceMatch[1], 10);
                    if (rawP > 100000) scrapedFinalPrice = rawP / 100000;
                 }
               }
             });
             
             if (!scrapedFinalPrice) {
                const domPriceText = $(".pq5ilO, .pm1p0z, ._045P6p, .G27FPf, .Ou5R\\+P, .price, [class*='price']").first().text().trim();
                if (domPriceText) {
                   const numericMatch = domPriceText.replace(/\./g,'').replace(',','.').match(/\d+\.\d+/);
                   if (numericMatch) scrapedFinalPrice = parseFloat(numericMatch[0]);
                }
             }
             if (scrapedFinalPrice && scrapedFinalPrice > 0) {
                offer.priceMin_scraped = scrapedFinalPrice;
             }
           } catch(e) { } // ignore individual failure
        });
        await Promise.allSettled(scrapePromises);
      } catch(configErr) {
        console.warn("Could not setup deepScrape", configErr);
      }
    }

    const itemIds = offers.map((o: any) => String(o.itemId));
    const { data: existingMappings } = await sb
      .from("shopee_product_mappings")
      .select("shopee_item_id, product_id")
      .in("shopee_item_id", itemIds);

    const importedSet = new Set((existingMappings || []).map((m: any) => m.shopee_item_id));

    const enrichedOffers = offers.map((o: any) => ({
      ...o,
      already_imported: importedSet.has(String(o.itemId)),
    }));

    return new Response(JSON.stringify({ offers: enrichedOffers, pageInfo }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("shopee-search-offers error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
