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
        } catch(e) {}
        return finalHtml;
      }
    } catch (err: any) {
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000 * Math.pow(2, i)));
  }
  throw new Error("Falha ao buscar página.");
}

function parsePrice(text: string): number {
  if (!text) return 0;
  const cleaned = text.replace(/[^\d,\.]/g, "").replace(",", ".");
  return parseFloat(cleaned) || 0;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { item, userId, platformId, categoryId } = await req.json();
    if (!item?.permalink) throw new Error("Item permalink (URL) is missing.");

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    console.log(`Importando Natura: ${item.permalink} via ${scraperConfig.provider}`);
    const proxyTargetUrl = buildScraperUrl(scraperConfig, item.permalink);
    const html = await fetchWithRetry(proxyTargetUrl);
    const $ = cheerio.load(html);

    let description: string | null = null;
    let galleryUrls: string[] = [];
    let enrichedPrice = item.price || 0;
    let enrichedOriginalPrice = item.original_price || null;
    let enrichedTitle = item.title || "";
    let enrichedImageUrl = item.thumbnail || "";

    // Title
    const domTitle = $("h1, [class*='productName'], [class*='product-name']").first().text().trim();
    if (domTitle && domTitle.length > 5) enrichedTitle = domTitle;

    // Price
    const priceText = $("[class*='sellingPrice'], [class*='price--current'], [class*='Price'] [class*='selling'], .price-best").first().text().trim();
    const domPrice = parsePrice(priceText);
    if (domPrice > 0) enrichedPrice = domPrice;

    const origText = $("[class*='listPrice'], [class*='price--old'], del, [class*='Price'] [class*='list']").first().text().trim();
    const domOrig = parsePrice(origText);
    if (domOrig > enrichedPrice) enrichedOriginalPrice = domOrig;

    // Description text processing (clean HTML tags via text extraction)
    const descText = $("[class*='productDescription'], [class*='description'], #description, [class*='details']").first().text().trim();
    if (descText && descText.length > 20) description = descText.substring(0, 2000);

    // Gallery
    // Avoid generic carousel/swiper classes to prevent capturing related products
    $("[class*='gallery'] img, [class*='productImage'] img, [id*='gallery'] img, .product-image img").each((_: any, img: any) => {
      const src = $(img).attr("data-src") || $(img).attr("src") || "";
      if (src && src.startsWith("http") && !src.includes("data:image")) {
        // Prevent duplicates
        if (!galleryUrls.includes(src)) {
            galleryUrls.push(src);
        }
      }
    });

    if (galleryUrls.length > 0) {
      if (!enrichedImageUrl) enrichedImageUrl = galleryUrls[0];
    } else if (!enrichedImageUrl) {
      const ogImg = $('meta[property="og:image"]').attr("content");
      if (ogImg) enrichedImageUrl = ogImg;
    }

    // Platform Resolve
    let resolvedPlatformId = platformId || null;
    if (!resolvedPlatformId) {
      const brandName = item.seller?.nickname || "Natura";
      const { data: plat } = await sb.from("platforms").select("id").ilike("name", `%${brandName}%`).maybeSingle();
      if (plat) resolvedPlatformId = plat.id;
    }

    // Additional Features extraction
    const features: any[] = [];
    // Product variants, Fragrances, Sizes based on schema tags
    $("[class*='sku'], [class*='variant'], [class*='Selector'] span").each((_: any, feat: any) => {
        const text = $(feat).text().trim();
        if (text && text.length < 30) features.push({ name: "Variante", value: text });
    });

    const isFreeShipping = $("[class*='shipping']").text().toLowerCase().includes("grátis");
    const extra_metadata = {
      shipping_details: isFreeShipping ? "Frete Grátis" : "Consultar frete",
    };

    // Calculate dynamic discount_percentage
    let discount = 0;
    if (enrichedOriginalPrice && enrichedOriginalPrice > enrichedPrice) {
      discount = Math.round(((enrichedOriginalPrice - enrichedPrice) / enrichedOriginalPrice) * 100);
    }
    const badge = discount > 0 ? `${discount}% OFF` : item.badge || null;

    const productData = {
      title: enrichedTitle || item.title,
      description: description,
      image_url: enrichedImageUrl,
      gallery_urls: galleryUrls.length > 0 ? galleryUrls : null,
      price: enrichedPrice,
      original_price: enrichedOriginalPrice,
      store: item.seller?.nickname || "Natura",
      affiliate_url: item.permalink, 
      external_id: item.id,
      badge: badge,
      rating: item.rating || 0,
      category_id: categoryId || null,
      features: features.length > 0 ? features : null,
      extra_metadata: extra_metadata,
      platform_id: resolvedPlatformId,
      registered_by: userId,
      is_active: true,
    };

    const { data: newProduct, error: insertProdError } = await sb.from("products").insert(productData).select().single();
    if (insertProdError) throw insertProdError;

    // Criar Mapeamento natura_product_mappings
    const mappingData = {
      product_id: newProduct.id,
      natura_item_id: item.id, // Derived ID from search
      natura_current_price: enrichedPrice,
      natura_original_price: enrichedOriginalPrice,
      natura_status: "active",
      natura_rating: item.rating,
      natura_review_count: item.reviewCount
    };

    const { error: mappingError } = await sb.from("natura_product_mappings").insert(mappingData);
    if (mappingError) throw mappingError;

    return new Response(JSON.stringify({ success: true, product_id: newProduct.id }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("natura-import error:", err);
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
