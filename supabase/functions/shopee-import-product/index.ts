// Edge Function: shopee-import-product — Refatorado: API Interna JSON + API Oficial para link de afiliado
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

async function fetchJsonViaScraper(scraperConfig: ScraperConfig, targetUrl: string, maxRetries = 3): Promise<unknown> {
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
  throw new Error("Falha ao buscar dados do produto na Shopee.");
}

function normalizeShopeePrice(raw: number): number {
  if (!raw || raw <= 0) return 0;
  if (raw > 100000) return raw / 100000;
  return raw;
}

// --- Tipagem dos dados da API interna ---
interface ShopeeItemDetail {
  itemid: number;
  shopid: number;
  name: string;
  description: string;
  price: number;
  price_min: number;
  price_max: number;
  price_before_discount: number;
  price_min_before_discount: number;
  price_max_before_discount: number;
  image: string;
  images: string[];
  item_rating: { rating_star: number; rating_count: number[] };
  sold: number;
  historical_sold: number;
  shop_name: string;
  liked_count: number;
  stock: number;
  status: number;
  brand: string;
  categories: { catid: number; display_name: string }[];
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

    const scraperConfig = await getActiveScraperConfig(sb);
    const shopId = offer.shopId || "0";

    // 1. Buscar dados reais do produto via API Interna
    const itemUrl = `https://shopee.com.br/api/v4/item/get?shopid=${shopId}&itemid=${offer.itemId}`;
    console.log(`[Shopee Import] Buscando dados via API interna: ${itemUrl}`);

    let itemDetail: ShopeeItemDetail | null = null;
    try {
      const itemData = await fetchJsonViaScraper(scraperConfig, itemUrl) as { data: ShopeeItemDetail };
      itemDetail = itemData?.data || null;
    } catch (e) {
      console.warn("[Shopee Import] Falha ao buscar API interna, usando dados do offer:", e);
    }

    // 2. Calcular preços
    let finalPrice: number;
    let finalOriginalPrice: number | null = null;

    if (itemDetail) {
      const price = normalizeShopeePrice(itemDetail.price);
      const priceMin = normalizeShopeePrice(itemDetail.price_min);
      const priceBeforeDiscount = normalizeShopeePrice(itemDetail.price_before_discount || itemDetail.price_max_before_discount || 0);

      finalPrice = price > 0 ? price : priceMin;
      if (priceBeforeDiscount > 0 && priceBeforeDiscount > finalPrice) {
        finalOriginalPrice = priceBeforeDiscount;
      }

      console.log(`[Shopee Import] Preços da API interna — price: ${finalPrice}, original: ${finalOriginalPrice}`);
    } else {
      // Fallback: usar dados do offer (que vieram da busca)
      const rawPrice = Number(offer.pricePromotional) || Number(offer.priceMin) || Number(offer.price) || 0;
      const rawOriginal = Number(offer.priceMax) || Number(offer.price) || 0;
      finalPrice = normalizeShopeePrice(rawPrice);
      finalOriginalPrice = normalizeShopeePrice(rawOriginal);
      if (finalOriginalPrice <= finalPrice) finalOriginalPrice = null;
    }

    // 3. Gerar link de afiliado via API Oficial
    const productLink = offer.productLink || `https://shopee.com.br/product/${shopId}/${offer.itemId}`;
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

    // 4. Resolver plataforma
    let resolvedPlatformId = platformId;
    if (!resolvedPlatformId) {
      const { data: plat } = await sb.from("platforms").select("id").ilike("name", "%shopee%").maybeSingle();
      resolvedPlatformId = plat?.id || null;
    }

    // 5. Resolver categoria
    let resolvedCategoryId = categoryId || null;
    if (!resolvedCategoryId && itemDetail?.categories?.length) {
      const catName = itemDetail.categories[itemDetail.categories.length - 1]?.display_name;
      if (catName) {
        const { data: cat } = await sb.from("categories").select("id").ilike("name", catName).maybeSingle();
        if (cat) resolvedCategoryId = cat.id;
      }
    }

    // 6. Montar dados de imagem e galeria
    let imageUrl = offer.imageUrl || "";
    let galleryUrls: string[] = [];
    if (itemDetail?.images?.length) {
      galleryUrls = itemDetail.images.slice(0, 8).map((img: string) => `https://down-br.img.susercontent.com/file/${img}`);
      imageUrl = galleryUrls[0] || imageUrl;
    } else if (itemDetail?.image) {
      imageUrl = `https://down-br.img.susercontent.com/file/${itemDetail.image}`;
    }

    // 7. Outros dados
    const description = itemDetail?.description || null;
    const rating = itemDetail?.item_rating?.rating_star || Number(offer.ratingStar) || 0;
    const salesCount = itemDetail?.historical_sold || itemDetail?.sold || Number(offer.sales) || 0;
    const storeName = itemDetail?.shop_name || offer.shopName || "Shopee";
    const brand = itemDetail?.brand || null;

    // Comissão
    const rate = Number(offer.commissionRate) || 0;
    const commissionPct = rate < 1 && rate > 0 ? rate * 100 : rate;

    // 8. Inserir produto
    const { data: product, error: productErr } = await sb.from("products").insert({
      title: itemDetail?.name || offer.productName || "Produto Shopee",
      price: finalPrice > 0 ? finalPrice : 0.01,
      original_price: finalOriginalPrice,
      description,
      store: storeName,
      affiliate_url: shortLink,
      image_url: imageUrl,
      gallery_urls: galleryUrls.length > 0 ? galleryUrls : null,
      category_id: resolvedCategoryId,
      platform_id: resolvedPlatformId,
      is_active: true,
      rating,
      registered_by: userId || null,
      sales_count: salesCount,
      commission_rate: commissionPct > 0 ? Number(commissionPct.toFixed(2)) : null,
      badge: null,
      brand_id: null,
      extra_metadata: {
        shopee_itemid: offer.itemId,
        shopee_shopid: shopId,
        brand,
        stock: itemDetail?.stock,
      },
    }).select().single();

    if (productErr) throw productErr;

    // 9. Criar mapping
    const shopeeExtraData = {
      appExistRate: offer.appExistRate,
      appNewRate: offer.appNewRate,
      webExistRate: offer.webExistRate,
      webNewRate: offer.webNewRate,
      commission: offer.commission,
      priceDiscountRate: offer.priceDiscountRate,
      shopType: offer.shopType,
      sellerCommissionRate: offer.sellerCommissionRate,
      shopeeCommissionRate: offer.shopeeCommissionRate,
    };

    const validFrom = offer.periodStartTime ? new Date(offer.periodStartTime * 1000).toISOString() : null;
    const validTo = offer.periodEndTime ? new Date(offer.periodEndTime * 1000).toISOString() : null;

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
      offer_valid_from: validFrom,
      offer_valid_to: validTo,
      shopee_extra_data: shopeeExtraData,
    });

    if (mappingErr) console.error("Mapping insert error:", mappingErr);

    // 10. Log
    await sb.from("shopee_sync_logs").insert({
      sync_type: "import",
      status: "success",
      items_processed: 1,
      items_updated: 1,
      triggered_by: userId || null,
      completed_at: new Date().toISOString(),
    });

    return new Response(JSON.stringify({ success: true, product }), {
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
