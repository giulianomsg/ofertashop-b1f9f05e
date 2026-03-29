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
  // DESCRIPTION
  // ====================================================
  const descSelectors = [".f7AU53", "[class*='product-detail']", "[class*='description']"];
  for (const sel of descSelectors) {
    const text = $(sel).first().text().trim();
    if (text && text.length > 20) {
      description = text.slice(0, 2000);
      break;
    }
  }

  // ====================================================
  // GALLERY
  // ====================================================
  $("img[src*='susercontent.com']").each((_: number, el: cheerio.Element) => {
    const src = $(el).attr("src");
    if (src && galleryUrls.length < 8) {
      const fullSrc = src.replace(/_tn$/, "").replace(/\?.*$/, "");
      if (!galleryUrls.includes(fullSrc)) galleryUrls.push(fullSrc);
    }
  });

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
    const productLink = offer.productLink || `https://shopee.com.br/product/${shopId}/${offer.itemId}`;

    // === 1. WEB SCRAPING (fonte primária de preço) ===
    let scrapedPrice = 0;
    let scrapedOriginalPrice: number | null = null;
    let scrapedDescription: string | null = null;
    let scrapedGallery: string[] = [];
    let priceSource = "api";
    let debugInfo: Record<string, unknown> | null = null;

    try {
      const scraperConfig = await getShopeeScraperConfig(sb);
      console.log(`[Shopee Import] Scraping ${productLink} via ${scraperConfig.provider} (render_js=true)`);

      const html = await fetchHtmlViaScraper(scraperConfig, productLink);
      console.log(`[Shopee Import] HTML recebido: ${html.length} chars`);

      // Pass API price as reference for sanity-checking scraped prices
      const apiRefPrice = normalizeShopeePrice(offer.price || offer.priceMin || offer.priceMax);
      const scraped = extractShopeeData(html, apiRefPrice);
      console.log(`[Shopee Import] Scraped — price: ${scraped.price}, original: ${scraped.originalPrice}, desc: ${(scraped.description || "").length} chars, gallery: ${scraped.galleryUrls.length} imgs`);

      if (scraped.price > 0) {
        scrapedPrice = scraped.price;
        scrapedOriginalPrice = scraped.originalPrice;
        priceSource = "scraping";
      }
      if (scraped.description) scrapedDescription = scraped.description;
      if (scraped.galleryUrls.length > 0) scrapedGallery = scraped.galleryUrls;

      // Build debug info
      if (debug) {
        // Extract samples from HTML for diagnosis
        const htmlHead = html.substring(0, 500);
        const htmlSize = html.length;
        const hasBody = html.includes("<body");
        const hasPrice = html.includes("R$");
        const hasDehydrated = html.includes("__DEHYDRATED_STATE__") || html.includes("__INITIAL_STATE__");
        const hasPriceClass = html.includes("pq96Uv") || html.includes("IZPeQz");
        const hasJsonLd = html.includes("application/ld+json");
        const hasMicroPrice = /\"price\"\s*:\s*\d{7,15}/.test(html);

        // Find all R$ occurrences
        const rMatches = html.match(/R\$\s?[\d.,]+/g) || [];
        // Find all micro-unit prices
        const microMatches = html.match(/"price[^"]*"\s*:\s*\d{7,15}/g) || [];

        debugInfo = {
          scraper: {
            provider: scraperConfig.provider,
            url: productLink,
            htmlSize,
            htmlHead,
          },
          htmlAnalysis: {
            hasBody,
            hasPrice_R$: hasPrice,
            hasDehydratedState: hasDehydrated,
            hasPriceCSS: hasPriceClass,
            hasJsonLd,
            hasMicroUnitPrices: hasMicroPrice,
          },
          foundPrices: {
            rDollarMatches: rMatches.slice(0, 20),
            microUnitMatches: microMatches.slice(0, 20),
          },
          extraction: {
            scrapedPrice: scraped.price,
            scrapedOriginalPrice: scraped.originalPrice,
            descriptionLength: (scraped.description || "").length,
            galleryCount: scraped.galleryUrls.length,
            apiRefPrice: apiRefPrice,
          },
          // Extract JSON-LD content for debug
          jsonLd: (() => {
            const results: unknown[] = [];
            const $d = cheerio.load(html);
            $d('script[type="application/ld+json"]').each((_: number, el: cheerio.Element) => {
              try { results.push(JSON.parse($d(el).html() || "")); } catch (_e) { /* */ }
            });
            return results;
          })(),
          // Show what CSS selectors found
          cssPrices: (() => {
            const $d = cheerio.load(html);
            const found: Record<string, string[]> = {};
            [".pq96Uv", ".IZPeQz", "._44q_F", ".B67UQ0"].forEach(sel => {
              const texts: string[] = [];
              $d(sel).each((_: number, el: cheerio.Element) => { texts.push($d(el).text().trim().substring(0, 50)); });
              if (texts.length) found[sel] = texts;
            });
            return found;
          })(),
        };
      }
    } catch (e) {
      const errMsg = e instanceof Error ? e.message : String(e);
      console.warn("[Shopee Import] Scraping falhou (usando fallback API):", errMsg);
      if (debug) {
        debugInfo = { scraper_error: errMsg };
      }
    }

    // === 2. FALLBACK: preços da API GraphQL (offer) ===
    let finalPrice = scrapedPrice;
    let finalOriginalPrice = scrapedOriginalPrice;

    if (finalPrice <= 0) {
      // Usar dados do offer da busca GraphQL
      const rawPriceMin = normalizeShopeePrice(offer.priceMin || offer.pricePromotional);
      const rawPriceMax = normalizeShopeePrice(offer.priceMax || offer.price);
      const rawPrice = normalizeShopeePrice(offer.price);

      finalPrice = rawPriceMin > 0 ? rawPriceMin : rawPrice;
      finalOriginalPrice = rawPriceMax > finalPrice ? rawPriceMax : null;
      priceSource = "api";
    }

    // Se não tem promoção, original_price = null
    if (finalOriginalPrice !== null && finalOriginalPrice <= finalPrice) {
      finalOriginalPrice = null;
    }

    console.log(`[Shopee Import] Final — price: ${finalPrice}, original: ${finalOriginalPrice}, source: ${priceSource}`);

    // === DEBUG MODE: retorna diagnóstico sem importar ===
    if (debug) {
      return new Response(JSON.stringify({
        debug: true,
        finalPrice,
        finalOriginalPrice,
        priceSource,
        offerPrices: {
          price: offer.price,
          priceMin: offer.priceMin,
          priceMax: offer.priceMax,
          pricePromotional: offer.pricePromotional,
        },
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
