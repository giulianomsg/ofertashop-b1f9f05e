// Edge Function: shopee-import-product — Scraping real com Cheerio + render_js + API GraphQL para link
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// --- Shopee Affiliate GraphQL (apenas para gerar link de afiliado) ---
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

  const res = await fetch(`${shopeeHost}/graphql`, {
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

// --- Multi-Scraper Proxy ---
interface ScraperConfig {
  provider: 'scrapingbee' | 'scrape.do' | 'scrapingant' | 'scraperapi';
  apiKey: string;
}

function buildScraperUrl(config: ScraperConfig, targetUrl: string, renderJs = true): string {
  const { provider, apiKey } = config;
  if (provider === 'scrapingbee') {
    const api = new URL("https://app.scrapingbee.com/api/v1");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("render_js", renderJs ? "true" : "false");
    api.searchParams.append("premium_proxy", "true");
    api.searchParams.append("country_code", "br");
    if (renderJs) api.searchParams.append("wait", "3000");
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    if (renderJs) api.searchParams.append("render", "true");
    return api.toString();
  }
  if (provider === 'scrapingant') {
    const api = new URL("https://api.scrapingant.com/v2/general");
    api.searchParams.append("x-api-key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("proxy_country", "BR");
    api.searchParams.append("browser", renderJs ? "true" : "false");
    api.searchParams.append("proxy_type", "residential");
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    api.searchParams.append("premium", "true");
    if (renderJs) api.searchParams.append("render", "true");
    return api.toString();
  }
  throw new Error(`Scraper provider desconhecido: ${provider}`);
}

// Busca config isolada da Shopee (shopee_scraper_config), com fallback para global
async function getShopeeScraperConfig(sb: ReturnType<typeof createClient>): Promise<ScraperConfig> {
  // 1. Config específica da Shopee
  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "shopee_scraper_config").maybeSingle();
    if (data?.value?.activeProvider && data?.value?.keys) {
      const provider = data.value.activeProvider;
      const apiKey = data.value.keys[provider];
      if (apiKey) return { provider, apiKey };
    }
  } catch (_e) { /* ignore */ }

  // 2. Fallback: config global
  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle();
    if (data?.value?.activeProvider && data?.value?.keys) {
      const provider = data.value.activeProvider;
      const apiKey = data.value.keys[provider];
      if (apiKey) return { provider, apiKey };
    }
  } catch (_e) { /* ignore */ }

  // 3. Fallback: env var
  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  throw new Error("Nenhum serviço de Web Scraper configurado para Shopee. Configure em Shopee Affiliate > Proxy Scraper.");
}

async function fetchHtmlViaScraper(config: ScraperConfig, targetUrl: string, maxRetries = 2): Promise<string> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const proxyUrl = buildScraperUrl(config, targetUrl, true);
      const res = await fetch(proxyUrl);
      if (res.ok) {
        let html = await res.text();
        try {
          const wrapper = JSON.parse(html);
          if (wrapper && typeof wrapper.content === 'string') html = wrapper.content;
        } catch (_e) { /* raw HTML */ }
        return html;
      }
      console.warn(`[Shopee Scraper] Tentativa ${i + 1} falhou: status ${res.status}`);
    } catch (err) {
      console.warn(`[Shopee Scraper] Tentativa ${i + 1} erro:`, err instanceof Error ? err.message : err);
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 2000 * Math.pow(2, i)));
  }
  throw new Error("Falha ao buscar página do produto na Shopee.");
}

// Build scraper URL WITHOUT render_js (much cheaper, for JSON API calls)
function buildScraperUrlNoJs(config: ScraperConfig, targetUrl: string): string {
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

// --- Shopee Internal API (via scraper proxy, no JS rendering needed) ---
interface ShopeeApiPrices {
  price: number;
  originalPrice: number | null;
  description: string | null;
  galleryUrls: string[];
  rawApiData?: Record<string, unknown>;
}

function normalizeMicroPrice(raw: number | undefined | null): number {
  if (!raw || raw <= 0) return 0;
  // Shopee stores prices as price * 100000, e.g. 14999000000 = R$149,990.00 — wrong
  // Actually: 14999000000 / 100000 = 149990 — still wrong
  // The format is: price in cents * 100000, so 14999000000 / 100000 / 100 = 1499.9 — wrong
  // Actually Shopee micro-unit: divide by 100000, e.g. 14999000000 / 100000 = 149990 — hmm
  // Let me check: R$149.99 → stored as 14999000000? No.
  // R$149.99 → stored as 14999000 (price * 100000)? 14999000 / 100000 = 149.99 ✓
  if (raw > 10000000) return raw / 100000; // Micro-units: 14999000 → 149.99
  if (raw > 10000) return raw / 100; // Cents: 14999 → 149.99
  return raw; // Already in reais
}

async function fetchShopeeInternalApi(config: ScraperConfig, shopId: string, itemId: string): Promise<ShopeeApiPrices | null> {
  const apiUrl = `https://shopee.com.br/api/v4/item/get?shopid=${shopId}&itemid=${itemId}`;
  
  try {
    const proxyUrl = buildScraperUrlNoJs(config, apiUrl);
    console.log(`[Shopee API] Fetching internal API via ${config.provider} (no JS)`);
    
    const res = await fetch(proxyUrl);
    if (!res.ok) {
      console.warn(`[Shopee API] HTTP ${res.status}`);
      return null;
    }

    let text = await res.text();
    // Some scrapers wrap response
    try {
      const wrapper = JSON.parse(text);
      if (wrapper && typeof wrapper.content === 'string') text = wrapper.content;
    } catch (_e) { /* raw response */ }

    const json = JSON.parse(text);
    const item = json?.data?.item || json?.item || json?.data;
    
    if (!item) {
      console.warn("[Shopee API] No item data in response");
      return null;
    }

    // Extract prices (Shopee stores in micro-units)
    const priceRaw = item.price || 0;
    const priceMinRaw = item.price_min || item.price || 0;
    const priceMaxRaw = item.price_max || item.price || 0;
    const priceBeforeDiscountRaw = item.price_before_discount || item.price_max_before_discount || 0;
    const priceMinBeforeDiscountRaw = item.price_min_before_discount || 0;

    const price = normalizeMicroPrice(priceMinRaw);
    const priceMax = normalizeMicroPrice(priceMaxRaw);
    const priceBeforeDiscount = normalizeMicroPrice(priceBeforeDiscountRaw);
    const priceMinBeforeDiscount = normalizeMicroPrice(priceMinBeforeDiscountRaw);

    // The actual selling price is the lowest of price_min
    const finalPrice = price > 0 ? price : normalizeMicroPrice(priceRaw);
    
    // Original price = price_before_discount (if higher than current price)
    let originalPrice: number | null = null;
    const candidates = [priceBeforeDiscount, priceMinBeforeDiscount, priceMax].filter(p => p > 0);
    if (candidates.length > 0) {
      const maxOrig = Math.max(...candidates);
      if (maxOrig > finalPrice * 1.01) originalPrice = maxOrig;
    }

    // Description
    const description = item.description || null;

    // Gallery
    const galleryUrls: string[] = [];
    if (item.images && Array.isArray(item.images)) {
      for (const img of item.images) {
        if (typeof img === 'string' && galleryUrls.length < 8) {
          const url = img.startsWith('http') ? img : `https://down-br.img.susercontent.com/file/${img}`;
          galleryUrls.push(url);
        }
      }
    }

    console.log(`[Shopee API] Prices — min: ${finalPrice}, max: ${priceMax}, beforeDiscount: ${priceBeforeDiscount}, original: ${originalPrice}`);

    return {
      price: finalPrice,
      originalPrice,
      description,
      galleryUrls,
      rawApiData: {
        price: priceRaw, price_min: priceMinRaw, price_max: priceMaxRaw,
        price_before_discount: priceBeforeDiscountRaw,
        price_min_before_discount: priceMinBeforeDiscountRaw,
        stock: item.stock, sold: item.historical_sold || item.sold,
        name: item.name, brand: item.brand,
      },
    };
  } catch (err) {
    console.warn("[Shopee API] Error:", err instanceof Error ? err.message : err);
    return null;
  }
}

// --- Extração de preços via Cheerio ---
function parseBRLPrice(text: string): number[] {
  const prices: number[] = [];
  // Match R$ 36,98 or R$1.517,08 or R$ 120,00
  const matches = text.match(/R\$\s?[\d.,]+/g);
  if (matches) {
    for (const m of matches) {
      const cleaned = m.replace("R$", "").replace(/\s/g, "").replace(/\./g, "").replace(",", ".").trim();
      const val = parseFloat(cleaned);
      if (val > 0 && val < 1000000) prices.push(val);
    }
  }
  return prices;
}

interface ScrapedPrices {
  price: number;
  originalPrice: number | null;
  description: string | null;
  galleryUrls: string[];
}

function extractShopeeData(html: string, apiPrice?: number): ScrapedPrices {
  const $ = cheerio.load(html);
  let description: string | null = null;
  const galleryUrls: string[] = [];

  // Collect prices in priority tiers (higher priority = more trusted)
  const tier1Prices: number[] = [];  // JSON-LD (most reliable structured data)
  const tier2Prices: number[] = [];  // Specific Shopee CSS selectors
  const tier3Prices: number[] = [];  // SSR script data
  const originalPrices: number[] = [];

  // ====================================================
  // TIER 1: JSON-LD (most reliable — structured data)
  // ====================================================
  $('script[type="application/ld+json"]').each((_: number, el: cheerio.Element) => {
    try {
      const json = JSON.parse($(el).html() || "");
      if (json?.offers?.price) {
        tier1Prices.push(Number(json.offers.price));
      }
      if (json?.offers?.lowPrice) {
        tier1Prices.push(Number(json.offers.lowPrice));
      }
      if (json?.offers?.highPrice) {
        originalPrices.push(Number(json.offers.highPrice));
      }
      // Also check for array of offers
      if (Array.isArray(json?.offers)) {
        for (const off of json.offers) {
          if (off?.price) tier1Prices.push(Number(off.price));
          if (off?.lowPrice) tier1Prices.push(Number(off.lowPrice));
          if (off?.highPrice) originalPrices.push(Number(off.highPrice));
        }
      }
      // Extract Description & Images
      if (json?.description && !description) {
        description = String(json.description).slice(0, 2000);
      }
      if (json?.image) {
        const imgs = Array.isArray(json.image) ? json.image : [json.image];
        for (const img of imgs) {
          if (typeof img === 'string' && galleryUrls.length < 8 && !galleryUrls.includes(img)) {
            galleryUrls.push(img);
          }
        }
      }
    } catch (_e) { /* ignore */ }
  });

  // ====================================================
  // TIER 2: Specific Shopee CSS selectors ONLY
  // (NOT generic [class*='price'] — that captures shipping!)
  // ====================================================
  // Main product price container (the big red/orange number)
  const specificPriceSelectors = [
    ".pq96Uv",    // main price container
    ".IZPeQz",    // alternative price container
    "._44q_F",    // flash sale price
    ".B67UQ0",    // observed alternative
  ];
  for (const sel of specificPriceSelectors) {
    $(sel).each((_: number, el: cheerio.Element) => {
      // Exclude if it's inside a shipping/frete section
      const parentText = $(el).parents().slice(0, 5).text().toLowerCase();
      const isShipping = parentText.includes("frete") || parentText.includes("entrega") || parentText.includes("envio");
      if (!isShipping) {
        tier2Prices.push(...parseBRLPrice($(el).text()));
      }
    });
  }

  // Preço original (tachado)
  const origSelectors = [".v97vId", ".G2799_", "del", "[style*='line-through']"];
  for (const sel of origSelectors) {
    $(sel).each((_: number, el: cheerio.Element) => {
      originalPrices.push(...parseBRLPrice($(el).text()));
    });
  }

  // ====================================================
  // TIER 3: SSR micro-unit prices in script tags
  // ====================================================
  $("script").each((_: number, el: cheerio.Element) => {
    const content = $(el).html() || "";
    if (content.length < 100) return; // skip tiny scripts
    
    const microPricePatterns = [
      /"price"\s*:\s*(\d{7,15})/g,
      /"price_min"\s*:\s*(\d{7,15})/g,
      /"price_max"\s*:\s*(\d{7,15})/g,
      /"price_before_discount"\s*:\s*(\d{7,15})/g,
      /"price_min_before_discount"\s*:\s*(\d{7,15})/g,
      /"price_max_before_discount"\s*:\s*(\d{7,15})/g,
    ];
    
    for (const pattern of microPricePatterns) {
      let match;
      while ((match = pattern.exec(content)) !== null) {
        const raw = parseInt(match[1]);
        if (raw > 100000) {
          const normalized = raw / 100000;
          if (normalized > 0.5 && normalized < 1000000) {
            if (match[0].includes("before_discount") || match[0].includes("price_max")) {
              originalPrices.push(normalized);
            } else {
              tier3Prices.push(normalized);
            }
          }
        }
      }
    }
  });

  // ====================================================
  // ====================================================
  // ====================================================
  // DESCRIPTION
  // ====================================================
  const descSelectors = [".f_re31", ".f7AU53", ".pdp-description-content", "[class*='product-detail']", "[class*='description']"];
  if (!description) {
    // 1. Selector strategy
    for (const sel of descSelectors) {
      const text = $(sel).first().text().trim();
      if (text && text.length > 20) {
        description = text.slice(0, 2000);
        break;
      }
    }
    // 2. Next-sibling strategy (very robust on Shopee BR)
    if (!description) {
      $("div").each((_: number, el: cheerio.Element) => {
        if (!description && $(el).text().trim().toLowerCase() === "descrição do produto") {
           const nextDiv = $(el).next("div");
           if (nextDiv.length) {
              const text = nextDiv.text().trim();
              if (text.length > 20) description = text.slice(0, 2000);
           }
        }
      });
    }
  }

  // ====================================================
  // GALLERY
  // ====================================================
  // 1. Specific High-Priority Target (Thumbnails and Main Image)
  $("div.airUhU img, div.pdp-video-placeholder__image, div.pdp-block__main-image img").each((_: number, el: cheerio.Element) => {
     let src = $(el).attr("src") || $(el).attr("data-src") || $(el).attr("style");
     if (src && src.includes("susercontent.com") && galleryUrls.length < 8) {
       if (src.includes("background-image")) {
         const bgMatch = src.match(/url\(['"]?(.*?)['"]?\)/);
         if (bgMatch && bgMatch[1]) src = bgMatch[1];
       }
       const fullSrc = src.replace(/_tn$/, "").replace(/\?.*$/, "").replace(/_tn\.webp$/, "");
       const cleanSrc = fullSrc.startsWith("//") ? "https:" + fullSrc : fullSrc;
       if (!galleryUrls.includes(cleanSrc) && cleanSrc.startsWith("http")) galleryUrls.push(cleanSrc);
     }
  });
  $("img, div[style*='background-image']").each((_: number, el: cheerio.Element) => {
    let src = $(el).attr("src") || $(el).attr("data-src") || $(el).attr("style");
    if (src && src.includes("susercontent.com") && galleryUrls.length < 8) {
      if (src.includes("background-image")) {
        const bgMatch = src.match(/url\(['"]?(.*?)['"]?\)/);
        if (bgMatch && bgMatch[1]) src = bgMatch[1];
      }
      const fullSrc = src.replace(/_tn$/, "").replace(/\?.*$/, "").replace(/_tn\.webp$/, "");
      const cleanSrc = fullSrc.startsWith("//") ? "https:" + fullSrc : fullSrc;
      if (!galleryUrls.includes(cleanSrc) && cleanSrc.startsWith("http")) galleryUrls.push(cleanSrc);
    }
  });

  // FALLBACK SSR REGEX FOR IMAGES/DESC
  const imgMatchArr = html.match(/"images"\s*:\s*\[(.*?)\]/);
  if (imgMatchArr && imgMatchArr[1] && galleryUrls.length < 8) {
    const urls = imgMatchArr[1].match(/"([^"]+)"/g);
    if (urls) {
      urls.forEach(u => {
        const hash = u.replace(/"/g, '');
        if (hash.length > 20 && !hash.includes('{')) {
          const fullSrc = hash.startsWith('http') ? hash : `https://down-br.img.susercontent.com/file/${hash}`;
          if (!galleryUrls.includes(fullSrc) && galleryUrls.length < 8) galleryUrls.push(fullSrc);
        }
      });
    }
  }

  if (!description) {
    const descMatch = html.match(/"description"\s*:\s*"((?:\\"|[^"])+)"/);
    if (descMatch && descMatch[1]) {
      try {
        description = JSON.parse(`"${descMatch[1]}"`).slice(0, 2000);
      } catch (e) {
        description = descMatch[1].slice(0, 2000);
      }
    }
  }

  // ====================================================
  // CALCULATE FINAL PRICES (priority-based)
  // ====================================================
  // Use the highest-priority tier that has valid prices
  const filterValid = (arr: number[]) => arr.filter(p => p >= 1.0 && p < 1000000);

  const v1 = filterValid(tier1Prices);
  const v2 = filterValid(tier2Prices);
  const v3 = filterValid(tier3Prices);
  const vOrig = filterValid(originalPrices);

  // If we have an API reference price, use it to sanity-check scraped prices
  // Reject prices that are less than 10% of the API price (likely shipping/frete)
  const refPrice = apiPrice && apiPrice > 0 ? apiPrice : 0;
  const sanityFilter = (prices: number[]) => {
    if (refPrice <= 0) return prices;
    return prices.filter(p => p >= refPrice * 0.1); // must be at least 10% of API price
  };

  // Pick from highest-priority tier first
  let candidatePrices: number[] = [];
  if (v1.length > 0) {
    candidatePrices = sanityFilter(v1);
  }
  if (candidatePrices.length === 0 && v2.length > 0) {
    candidatePrices = sanityFilter(v2);
  }
  if (candidatePrices.length === 0 && v3.length > 0) {
    candidatePrices = sanityFilter(v3);
  }

  const price = candidatePrices.length > 0 ? Math.min(...candidatePrices) : 0;
  
  // Original price = highest across all sources
  const allForMax = [...candidatePrices, ...vOrig];
  const maxCandidate = allForMax.length > 0 ? Math.max(...allForMax) : 0;
  const originalPrice = maxCandidate > price * 1.01 ? maxCandidate : null;

  console.log(`[Shopee Extract] Tier1(JSON-LD): [${v1.join(",")}], Tier2(CSS): [${v2.join(",")}], Tier3(SSR): [${v3.join(",")}], Originals: [${vOrig.join(",")}]`);
  console.log(`[Shopee Extract] After sanity (ref=${refPrice}): candidates=[${candidatePrices.join(",")}] → price=${price}, original=${originalPrice}`);

  return { price, originalPrice, description, galleryUrls };
}

// --- Normalizar preço da API GraphQL (micro-unidades) ---
function normalizeShopeePrice(raw: number | string | undefined | null): number {
  const num = Number(raw);
  if (!num || num <= 0) return 0;
  if (num > 100000) return num / 100000;
  return num;
}

// --- Calcular preço PIX com subsídio da Shopee (Política 2026) ---
// Fonte: https://seller.br.shopee.cn/edu/article/26839
// Até R$79,99: sem desconto PIX
// R$80 - R$499,99: 5% de subsídio
// R$500+: 8% de subsídio
function calculateShopeePixPrice(price: number): { pixPrice: number; pixDiscount: number } {
  if (price < 80) return { pixPrice: price, pixDiscount: 0 };
  if (price < 500) {
    const pixPrice = Math.round(price * 0.95 * 100) / 100;
    return { pixPrice, pixDiscount: 5 };
  }
  const pixPrice = Math.round(price * 0.92 * 100) / 100;
  return { pixPrice, pixDiscount: 8 };
}

// --- Handler Principal ---
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const body = await req.json();
    const { offer, categoryId, platformId, userId, debug } = body;
    if (!offer || !offer.itemId) {
      return new Response(JSON.stringify({ error: "offer com itemId é obrigatório" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    // --- DEBUG: GraphQL introspection to discover all available fields ---
    if (debug) {
      let introspectionResult: unknown = null;
      let expandedOfferResult: unknown = null;

      try {
        // 1. Introspect the ProductOffer type to see ALL fields
        const introspectQuery = `{
          __type(name: "ProductOffer") {
            name
            fields {
              name
              type { name kind ofType { name kind } }
            }
          }
        }`;
        introspectionResult = await shopeeGraphQL(introspectQuery);
      } catch (e) {
        introspectionResult = { error: e instanceof Error ? e.message : String(e) };
      }

      try {
        // 2. Query the product with ALL possible fields (some may not exist)
        const expandedQuery = `query {
          productOfferV2(itemId: ${offer.itemId}) {
            nodes {
              itemId shopId productName price priceMin priceMax imageUrl productLink
              commission commissionRate sales ratingStar shopName offerLink
              periodStartTime periodEndTime
              appExistRate appNewRate webExistRate webNewRate
              productCatIds priceDiscountRate shopType
              sellerCommissionRate shopeeCommissionRate
            }
          }
        }`;
        expandedOfferResult = await shopeeGraphQL(expandedQuery);
      } catch (e) {
        expandedOfferResult = { error: e instanceof Error ? e.message : String(e) };
      }

      // Return introspection + expanded offer data BEFORE any scraping
      // This is a separate early return so we can see the API schema
      if (body.introspect) {
        return new Response(JSON.stringify({
          debug: true,
          introspect: true,
          schemaFields: introspectionResult,
          expandedOffer: expandedOfferResult,
        }, null, 2), {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
    }

    // Verificar se já importado (skip in debug mode)
    if (!debug) {
      const { data: existing } = await sb.from("shopee_product_mappings")
        .select("id, product_id").eq("shopee_item_id", String(offer.itemId)).maybeSingle();
      if (existing) {
        return new Response(JSON.stringify({ error: "Produto já importado", product_id: existing.product_id }), {
          status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
    }

    const shopId = offer.shopId || "0";
    const itemId = String(offer.itemId);
    const productLink = offer.productLink || `https://shopee.com.br/product/${shopId}/${itemId}`;

    // === PRICE EXTRACTION (4 strategies, first success wins) ===
    let scrapedPrice = 0;
    let scrapedOriginalPrice: number | null = null;
    let scrapedDescription: string | null = null;
    let scrapedGallery: string[] = [];
    let priceSource = "graphql_api";
    let debugInfo: Record<string, unknown> | null = null;

    // --- STRATEGY 0: Direct call to Shopee internal API (no proxy, from Edge Function) ---
    const directApiDebug: Record<string, unknown> = {};
    try {
      const endpoints = [
        `https://shopee.com.br/api/v4/item/get?shopid=${shopId}&itemid=${itemId}`,
        `https://shopee.com.br/api/v4/pdp/get_pc?shop_id=${shopId}&item_id=${itemId}`,
      ];

      for (const endpoint of endpoints) {
        try {
          const res = await fetch(endpoint, {
            headers: {
              "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
              "Accept": "application/json",
              "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
              "Referer": "https://shopee.com.br/",
              "sec-ch-ua": '"Not_A Brand";v="8", "Chromium";v="120"',
              "sec-ch-ua-platform": '"Windows"',
              "x-shopee-language": "pt-BR",
              "x-requested-with": "XMLHttpRequest",
              "x-api-source": "pc",
            },
          });

          const endpointName = endpoint.includes("pdp/get_pc") ? "pdp_get_pc" : "item_get";
          directApiDebug[endpointName] = { status: res.status };

          if (res.ok) {
            const json = await res.json();
            const item = json?.data?.item || json?.data || json?.item;

            if (item) {
              const priceMinRaw = item.price_min || item.price || 0;
              const priceMaxRaw = item.price_max || item.price || 0;
              const priceBeforeDiscountRaw = item.price_before_discount || item.price_max_before_discount || 0;
              const priceMinBeforeDiscountRaw = item.price_min_before_discount || 0;

              const price = normalizeMicroPrice(priceMinRaw);
              const priceMax = normalizeMicroPrice(priceMaxRaw);
              const priceBeforeDiscount = normalizeMicroPrice(priceBeforeDiscountRaw);
              const priceMinBeforeDiscount = normalizeMicroPrice(priceMinBeforeDiscountRaw);

              if (price > 0) {
                scrapedPrice = price;
                priceSource = `direct_${endpointName}`;

                // Original price
                const origCandidates = [priceBeforeDiscount, priceMinBeforeDiscount, priceMax].filter(p => p > 0);
                if (origCandidates.length > 0) {
                  const maxOrig = Math.max(...origCandidates);
                  if (maxOrig > scrapedPrice * 1.01) scrapedOriginalPrice = maxOrig;
                }

                // Description & gallery
                if (item.description) scrapedDescription = item.description;
                if (item.images && Array.isArray(item.images)) {
                  for (const img of item.images) {
                    if (typeof img === 'string' && scrapedGallery.length < 8) {
                      scrapedGallery.push(img.startsWith('http') ? img : `https://down-br.img.susercontent.com/file/${img}`);
                    }
                  }
                }

                directApiDebug[endpointName] = {
                  status: res.status,
                  success: true,
                  rawPrices: { price_min: priceMinRaw, price_max: priceMaxRaw, price_before_discount: priceBeforeDiscountRaw },
                  normalizedPrices: { price, priceMax, priceBeforeDiscount },
                  name: item.name,
                  stock: item.stock,
                  sold: item.historical_sold || item.sold,
                };

                console.log(`[Shopee Direct API] ✓ ${endpointName}: price=${price}, original=${scrapedOriginalPrice}`);
                break; // Success — stop trying endpoints
              }
            }
          } else {
            directApiDebug[endpointName] = { status: res.status, error: "non-ok" };
          }
        } catch (endpointErr) {
          const eName = endpoint.includes("pdp/get_pc") ? "pdp_get_pc" : "item_get";
          directApiDebug[eName] = { error: endpointErr instanceof Error ? endpointErr.message : String(endpointErr) };
        }
      }
    } catch (_e) { /* non-critical */ }

    // --- STRATEGIES 1-2: Via scraper proxy (only if direct API didn't work) ---
    if (scrapedPrice <= 0) try {
      const scraperConfig = await getShopeeScraperConfig(sb);

      // === STRATEGY 1: Shopee Internal JSON API via proxy ===
      let internalApiResult: ShopeeApiPrices | null = null;
      try {
        internalApiResult = await fetchShopeeInternalApi(scraperConfig, shopId, itemId);
      } catch (e) {
        console.warn("[Shopee Import] Internal API failed:", e instanceof Error ? e.message : e);
      }

      if (internalApiResult && internalApiResult.price > 0) {
        scrapedPrice = internalApiResult.price;
        scrapedOriginalPrice = internalApiResult.originalPrice;
        priceSource = "internal_api";
        if (internalApiResult.description) scrapedDescription = internalApiResult.description;
        if (internalApiResult.galleryUrls.length > 0) scrapedGallery = internalApiResult.galleryUrls;

        if (debug) {
          debugInfo = {
            strategy: "internal_api",
            scraper: { provider: scraperConfig.provider },
            internalApiData: internalApiResult.rawApiData,
            extraction: {
              scrapedPrice: internalApiResult.price,
              scrapedOriginalPrice: internalApiResult.originalPrice,
              descriptionLength: (internalApiResult.description || "").length,
              galleryCount: internalApiResult.galleryUrls.length,
            },
          };
        }
      } else {
        // === STRATEGY 2: HTML Scraping (render_js=true, expensive) ===
        console.log("[Shopee Import] Internal API returned no prices, trying HTML scraping...");
        try {
          const html = await fetchHtmlViaScraper(scraperConfig, productLink);
          console.log(`[Shopee Import] HTML recebido: ${html.length} chars`);

          const apiRefPrice = normalizeShopeePrice(offer.price || offer.priceMin || offer.priceMax);
          const scraped = extractShopeeData(html, apiRefPrice);

          if (scraped.price > 0) {
            scrapedPrice = scraped.price;
            scrapedOriginalPrice = scraped.originalPrice;
            priceSource = "html_scraping";
          }
          if (scraped.description) scrapedDescription = scraped.description;
          if (scraped.galleryUrls.length > 0) scrapedGallery = scraped.galleryUrls;

          if (debug) {
            const htmlHead = html.substring(0, 500);
            const rMatches = html.match(/R\$\s?[\d.,]+/g) || [];
            debugInfo = {
              strategy: "html_scraping",
              scraper: { provider: scraperConfig.provider, htmlSize: html.length, htmlHead },
              htmlAnalysis: {
                hasBody: html.includes("<body"),
                hasPrice_R$: html.includes("R$"),
                hasPriceCSS: html.includes("pq96Uv") || html.includes("IZPeQz"),
                hasJsonLd: html.includes("application/ld+json"),
              },
              foundPrices: { rDollarMatches: rMatches.slice(0, 20) },
              extraction: {
                scrapedPrice: scraped.price,
                scrapedOriginalPrice: scraped.originalPrice,
                apiRefPrice,
              },
              internalApiFailed: internalApiResult === null ? "no_response" : "no_prices",
            };
          }
        } catch (htmlErr) {
          console.warn("[Shopee Import] HTML scraping also failed:", htmlErr instanceof Error ? htmlErr.message : htmlErr);
          if (debug) {
            debugInfo = {
              strategy: "all_failed",
              internalApiResult: internalApiResult,
              htmlError: htmlErr instanceof Error ? htmlErr.message : String(htmlErr),
            };
          }
        }
      }
    } catch (e) {
      const errMsg = e instanceof Error ? e.message : String(e);
      console.warn("[Shopee Import] All scraping failed:", errMsg);
      if (debug) {
        debugInfo = { scraper_error: errMsg };
      }
    }

    // === 2. Determine base price (scraping or API) ===
    let basePrice = scrapedPrice;
    let baseOriginalPrice = scrapedOriginalPrice;

    if (basePrice <= 0) {
      // Usar dados do offer da busca GraphQL
      // 'apiBasePrice' previne duplo desconto PIX caso a busca já tenha aplicado
      const rawPriceMin = normalizeShopeePrice(offer.apiBasePrice || offer.priceMin || offer.pricePromotional);
      const rawPriceMax = normalizeShopeePrice(offer.priceMax || offer.price);
      const rawPrice = normalizeShopeePrice(offer.apiBasePrice || offer.price);

      basePrice = rawPriceMin > 0 ? rawPriceMin : rawPrice;
      baseOriginalPrice = rawPriceMax > basePrice ? rawPriceMax : null;
      priceSource = "graphql_api";
    }

    // === 3. Apply Shopee PIX subsidy (Política 2026) ===
    const { pixPrice, pixDiscount } = calculateShopeePixPrice(basePrice);
    const finalPrice = pixPrice;
    let finalOriginalPrice: number | null = null;

    // original_price = the base price (before PIX discount) if PIX discount applies
    if (pixDiscount > 0 && basePrice > pixPrice) {
      finalOriginalPrice = basePrice;
    } else if (baseOriginalPrice && baseOriginalPrice > pixPrice * 1.01) {
      // If there was already an original price from scraping/API, keep the highest
      finalOriginalPrice = baseOriginalPrice;
    }

    console.log(`[Shopee Import] Base: ${basePrice}, PIX(${pixDiscount}%): ${pixPrice}, Original: ${finalOriginalPrice}, Source: ${priceSource}`);

    // === DEBUG MODE: retorna diagnóstico sem importar ===
    if (debug) {
      return new Response(JSON.stringify({
        debug: true,
        finalPrice,
        finalOriginalPrice,
        basePrice,
        pixDiscount,
        priceSource,
        offerPrices: {
          price: offer.price,
          priceMin: offer.priceMin,
          priceMax: offer.priceMax,
          pricePromotional: offer.pricePromotional,
        },
        directApi: directApiDebug,
        ...debugInfo,
      }, null, 2), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // === 3. GERAR LINK DE AFILIADO ===
    let shortLink = offer.offerLink || productLink;
    try {
      const linkQuery = `
        query {
          generateShortLink(
            originUrl: "${productLink.replace(/"/g, '\\"')}"
            subId: "ofertashop"
          ) { shortLink }
        }
      `;
      const linkData = await shopeeGraphQL<{ generateShortLink: { shortLink: string } }>(linkQuery);
      if (linkData?.generateShortLink?.shortLink) {
        shortLink = linkData.generateShortLink.shortLink;
      }
    } catch (e) {
      console.warn("[Shopee Import] Falha ao gerar short link:", e);
    }

    // === 4. RESOLVER PLATAFORMA E CATEGORIA ===
    let resolvedPlatformId = platformId;
    if (!resolvedPlatformId) {
      const { data: plat } = await sb.from("platforms").select("id").ilike("name", "%shopee%").maybeSingle();
      resolvedPlatformId = plat?.id || null;
    }

    // === 5. IMAGEM ===
    let imageUrl = offer.imageUrl || "";
    if (scrapedGallery.length > 0) {
      imageUrl = scrapedGallery[0];
    }

    // === 6. COMISSÃO ===
    const rate = Number(offer.commissionRate) || 0;
    const commissionPct = rate < 1 && rate > 0 ? rate * 100 : rate;

    // === 7. INSERIR PRODUTO ===
    const { data: product, error: productErr } = await sb.from("products").insert({
      title: offer.productName || "Produto Shopee",
      price: finalPrice > 0 ? finalPrice : 0.01,
      original_price: finalOriginalPrice,
      description: scrapedDescription,
      store: offer.shopName || "Shopee",
      affiliate_url: shortLink,
      image_url: imageUrl,
      gallery_urls: scrapedGallery.length > 0 ? scrapedGallery : null,
      category_id: categoryId || null,
      platform_id: resolvedPlatformId,
      is_active: true,
      rating: Number(offer.ratingStar) || 0,
      registered_by: userId || null,
      sales_count: Number(offer.sales) || 0,
      commission_rate: commissionPct > 0 ? Number(commissionPct.toFixed(2)) : null,
      badge: null,
      brand_id: null,
      extra_metadata: {
        shopee_itemid: offer.itemId,
        shopee_shopid: shopId,
        price_source: priceSource,
      },
    }).select().single();

    if (productErr) throw productErr;

    // === 8. CRIAR MAPPING ===
    const { error: mappingErr } = await sb.from("shopee_product_mappings").insert({
      product_id: product.id,
      shopee_item_id: String(offer.itemId),
      shopee_shop_id: String(shopId),
      shopee_offer_id: "",
      shopee_commission_rate: Number(offer.commissionRate) || null,
      shopee_image_url: offer.imageUrl || null,
      shopee_product_url: productLink,
      shopee_short_link: shortLink,
      sync_status: "active",
      offer_valid_from: offer.periodStartTime ? new Date(offer.periodStartTime * 1000).toISOString() : null,
      offer_valid_to: offer.periodEndTime ? new Date(offer.periodEndTime * 1000).toISOString() : null,
      shopee_extra_data: {
        appExistRate: offer.appExistRate, appNewRate: offer.appNewRate,
        webExistRate: offer.webExistRate, webNewRate: offer.webNewRate,
        commission: offer.commission, priceDiscountRate: offer.priceDiscountRate,
        shopType: offer.shopType, sellerCommissionRate: offer.sellerCommissionRate,
        shopeeCommissionRate: offer.shopeeCommissionRate,
      },
    });
    if (mappingErr) console.error("Mapping insert error:", mappingErr);

    // === 9. LOG ===
    await sb.from("shopee_sync_logs").insert({
      sync_type: "import",
      status: "success",
      items_processed: 1,
      items_updated: 1,
      triggered_by: userId || null,
      completed_at: new Date().toISOString(),
    });

    return new Response(JSON.stringify({ success: true, product, priceSource }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Erro interno";
    console.error("shopee-import-product error:", err);
    return new Response(JSON.stringify({ error: message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
