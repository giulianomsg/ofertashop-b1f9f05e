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

function extractShopeeData(html: string): ScrapedPrices {
  const $ = cheerio.load(html);

  // --- Preço promocional/atual (o menor valor visível) ---
  const allPrices: number[] = [];

  // Seletores primários de preço
  const priceSelectors = [
    ".pq96Uv", ".IZPeQz", "._44q_F",  // containers de preço conhecidos
    "[class*='price']",                   // qualquer classe com 'price'
  ];
  for (const sel of priceSelectors) {
    $(sel).each((_, el) => {
      allPrices.push(...parseBRLPrice($(el).text()));
    });
  }

  // Fallback: regex em todo o HTML para R$ xxx,xx
  if (allPrices.length === 0) {
    allPrices.push(...parseBRLPrice($("body").text()));
  }

  // --- Preço original (tachado / line-through) ---
  let originalPrice: number | null = null;
  const originalSelectors = [
    ".v97vId", ".G2799_",               // classes conhecidas de preço tachado
    "del",                                // tag HTML de deletado
    "[style*='line-through']",           // inline style
  ];
  for (const sel of originalSelectors) {
    $(sel).each((_, el) => {
      const prices = parseBRLPrice($(el).text());
      for (const p of prices) {
        if (p > 0) originalPrice = Math.max(originalPrice || 0, p);
      }
    });
  }

  // --- Descrição ---
  let description: string | null = null;
  const descSelectors = [
    ".f7AU53",                             // container de descrição conhecido
    "[class*='product-detail']",
    "[class*='description']",
  ];
  for (const sel of descSelectors) {
    const text = $(sel).first().text().trim();
    if (text && text.length > 20) {
      description = text.slice(0, 2000);
      break;
    }
  }

  // --- Galeria de imagens ---
  const galleryUrls: string[] = [];
  $("img[src*='susercontent.com']").each((_, el) => {
    const src = $(el).attr("src");
    if (src && !galleryUrls.includes(src) && galleryUrls.length < 8) {
      // Converter thumbnails para full size
      const fullSrc = src.replace(/_tn$/, "").replace(/\?.*$/, "");
      if (!galleryUrls.includes(fullSrc)) galleryUrls.push(fullSrc);
    }
  });

  // --- Calcular preço final (menor entre todos encontrados) ---
  // Filtrar preços muito pequenos (< 0.50) que podem ser artefatos
  const validPrices = allPrices.filter(p => p >= 0.50);
  const price = validPrices.length > 0 ? Math.min(...validPrices) : 0;

  // Se original é menor ou igual ao price, não faz sentido
  if (originalPrice !== null && originalPrice <= price) originalPrice = null;

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
    const { offer, categoryId, platformId, userId } = await req.json();
    if (!offer || !offer.itemId) {
      return new Response(JSON.stringify({ error: "offer com itemId é obrigatório" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    // Verificar se já importado
    const { data: existing } = await sb.from("shopee_product_mappings")
      .select("id, product_id").eq("shopee_item_id", String(offer.itemId)).maybeSingle();
    if (existing) {
      return new Response(JSON.stringify({ error: "Produto já importado", product_id: existing.product_id }), {
        status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const shopId = offer.shopId || "0";
    const productLink = offer.productLink || `https://shopee.com.br/product/${shopId}/${offer.itemId}`;

    // === 1. WEB SCRAPING (fonte primária de preço) ===
    let scrapedPrice = 0;
    let scrapedOriginalPrice: number | null = null;
    let scrapedDescription: string | null = null;
    let scrapedGallery: string[] = [];
    let priceSource = "api";

    try {
      const scraperConfig = await getShopeeScraperConfig(sb);
      console.log(`[Shopee Import] Scraping ${productLink} via ${scraperConfig.provider} (render_js=true)`);

      const html = await fetchHtmlViaScraper(scraperConfig, productLink);
      console.log(`[Shopee Import] HTML recebido: ${html.length} chars`);

      const scraped = extractShopeeData(html);
      console.log(`[Shopee Import] Scraped — price: ${scraped.price}, original: ${scraped.originalPrice}, desc: ${(scraped.description || "").length} chars, gallery: ${scraped.galleryUrls.length} imgs`);

      if (scraped.price > 0) {
        scrapedPrice = scraped.price;
        scrapedOriginalPrice = scraped.originalPrice;
        priceSource = "scraping";
      }
      if (scraped.description) scrapedDescription = scraped.description;
      if (scraped.galleryUrls.length > 0) scrapedGallery = scraped.galleryUrls;
    } catch (e) {
      console.warn("[Shopee Import] Scraping falhou (usando fallback API):", e instanceof Error ? e.message : e);
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
