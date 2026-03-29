// Edge Function: shopee-import-product — API Oficial GraphQL + scraper apenas para enriquecimento
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

// --- Multi-Scraper Proxy (usado apenas para enriquecimento de descrição/galeria) ---
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

async function getActiveScraperConfig(sb: ReturnType<typeof createClient>): Promise<ScraperConfig | null> {
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
  return null;
}

async function tryFetchItemDetail(scraperConfig: ScraperConfig | null, shopId: string, itemId: string): Promise<Record<string, unknown> | null> {
  if (!scraperConfig) return null;
  try {
    const targetUrl = `https://shopee.com.br/api/v4/item/get?shopid=${shopId}&itemid=${itemId}`;
    const proxyUrl = buildScraperUrl(scraperConfig, targetUrl);
    const res = await fetch(proxyUrl);
    if (res.ok) {
      let text = await res.text();
      try {
        const wrapper = JSON.parse(text);
        if (wrapper && typeof wrapper.content === 'string') text = wrapper.content;
      } catch (_e) { /* raw */ }
      const json = JSON.parse(text);
      return json?.data || null;
    }
  } catch (e) {
    console.warn("[Shopee Import] API interna falhou (normal):", e instanceof Error ? e.message : e);
  }
  return null;
}

// --- Normalizar preço Shopee ---
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

    // 1. Preços vêm do offer (que já veio da API GraphQL com micro-unidades normalizadas pela search)
    const rawPriceMin = normalizeShopeePrice(offer.priceMin || offer.pricePromotional);
    const rawPriceMax = normalizeShopeePrice(offer.priceMax || offer.price);
    const rawPrice = normalizeShopeePrice(offer.price);

    // priceMin = preço atual/promocional, priceMax = preço original
    let finalPrice = rawPriceMin > 0 ? rawPriceMin : rawPrice;
    let finalOriginalPrice: number | null = rawPriceMax > finalPrice ? rawPriceMax : null;

    console.log(`[Shopee Import] Preços do offer — price: ${finalPrice}, original: ${finalOriginalPrice}`);

    // 2. Tentar enriquecer com dados da API Interna (descrição, galeria, etc.)
    const scraperConfig = await getActiveScraperConfig(sb);
    const itemDetail = await tryFetchItemDetail(scraperConfig, shopId, offer.itemId);

    let description: string | null = null;
    let galleryUrls: string[] = [];
    let imageUrl = offer.imageUrl || "";
    let salesCount = Number(offer.sales) || 0;
    let rating = Number(offer.ratingStar) || 0;
    let storeName = offer.shopName || "Shopee";
    let brand: string | null = null;

    if (itemDetail) {
      console.log("[Shopee Import] API interna retornou dados extras.");
      description = (itemDetail.description as string) || null;

      // Galeria
      const images = itemDetail.images as string[] | null;
      if (images?.length) {
        galleryUrls = images.slice(0, 8).map((img: string) => `https://down-br.img.susercontent.com/file/${img}`);
        imageUrl = galleryUrls[0] || imageUrl;
      } else if (itemDetail.image) {
        imageUrl = `https://down-br.img.susercontent.com/file/${itemDetail.image}`;
      }

      // Preços mais precisos da API interna (se disponíveis)
      const internalPrice = normalizeShopeePrice(itemDetail.price as number);
      const internalPriceMin = normalizeShopeePrice(itemDetail.price_min as number);
      const internalOriginal = normalizeShopeePrice(
        (itemDetail.price_before_discount as number) || (itemDetail.price_max_before_discount as number) || 0
      );

      if (internalPrice > 0 || internalPriceMin > 0) {
        finalPrice = internalPriceMin > 0 ? internalPriceMin : internalPrice;
        if (internalOriginal > finalPrice) {
          finalOriginalPrice = internalOriginal;
        }
        console.log(`[Shopee Import] Preços da API interna — price: ${finalPrice}, original: ${finalOriginalPrice}`);
      }

      // Metadata
      salesCount = Number(itemDetail.historical_sold) || Number(itemDetail.sold) || salesCount;
      const itemRating = itemDetail.item_rating as Record<string, unknown> | null;
      rating = Number(itemRating?.rating_star) || rating;
      storeName = (itemDetail.shop_name as string) || storeName;
      brand = (itemDetail.brand as string) || null;
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
    if (!resolvedCategoryId && itemDetail) {
      const cats = itemDetail.categories as { display_name: string }[] | null;
      if (cats?.length) {
        const catName = cats[cats.length - 1]?.display_name;
        if (catName) {
          const { data: cat } = await sb.from("categories").select("id").ilike("name", catName).maybeSingle();
          if (cat) resolvedCategoryId = cat.id;
        }
      }
    }

    // 6. Comissão
    const rate = Number(offer.commissionRate) || 0;
    const commissionPct = rate < 1 && rate > 0 ? rate * 100 : rate;

    // 7. Inserir produto
    const { data: product, error: productErr } = await sb.from("products").insert({
      title: offer.productName || "Produto Shopee",
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
      },
    }).select().single();

    if (productErr) throw productErr;

    // 8. Criar mapping
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

    // 9. Log
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
