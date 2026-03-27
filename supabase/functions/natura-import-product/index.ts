// Edge Function: natura-import-product (standalone)
// Web scraping import for Natura and Avon products
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
        let html = await res.text();
        try {
          const json = JSON.parse(html);
          if (json && typeof json.content === 'string') html = json.content;
        } catch (e) { /* raw html */ }
        return html;
      }
    } catch (err: any) {
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((r) => setTimeout(r, 1000 * Math.pow(2, i)));
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
    const body = await req.json();
    const { action, url, brand, userId, categoryId, platformId } = body;

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    // ACTION: search — scrape product listing page
    if (action === "search") {
      const brandKey = (brand || "natura").toLowerCase();
      const searchUrl = url || `https://www.minhaloja.natura.com/consultoria/ofertashop?marca=${brandKey}`;
      
      console.log(`[Natura] Scraping listing: ${searchUrl}`);
      const proxyUrl = buildScraperUrl(scraperConfig, searchUrl);
      const html = await fetchWithRetry(proxyUrl);
      const $ = cheerio.load(html);

      const products: any[] = [];

      // Parse product cards from the listing page
      $(".product-card, [class*='ProductCard'], [class*='product-item'], .showcase-item, article[class*='product']").each((_: any, el: any) => {
        const title = $(el).find("[class*='name'], [class*='title'], h3, h2").first().text().trim();
        const linkEl = $(el).find("a[href*='/p/'], a[href*='natura.com']").first();
        const productLink = linkEl.attr("href") || "";
        const imageUrl = $(el).find("img").first().attr("src") || $(el).find("img").first().attr("data-src") || "";
        
        const priceText = $(el).find("[class*='price'], [class*='Price'], .price").last().text().trim();
        const originalPriceText = $(el).find("[class*='old'], [class*='original'], del, s, [class*='from']").first().text().trim();
        
        const price = parsePrice(priceText);
        const originalPrice = parsePrice(originalPriceText);

        if (title && price > 0) {
          products.push({
            title,
            price,
            originalPrice: originalPrice > price ? originalPrice : null,
            imageUrl: imageUrl.startsWith("//") ? `https:${imageUrl}` : imageUrl,
            productLink: productLink.startsWith("http") ? productLink : (productLink ? `https://www.minhaloja.natura.com${productLink}` : ""),
            brand: brandKey === "avon" ? "Avon" : "Natura",
          });
        }
      });

      // Fallback: try generic selectors
      if (products.length === 0) {
        $("a[href*='/p/']").each((_: any, el: any) => {
          const title = $(el).text().trim().substring(0, 120);
          const href = $(el).attr("href") || "";
          if (title.length > 5) {
            products.push({
              title,
              price: 0,
              originalPrice: null,
              imageUrl: "",
              productLink: href.startsWith("http") ? href : `https://www.minhaloja.natura.com${href}`,
              brand: brandKey === "avon" ? "Avon" : "Natura",
            });
          }
        });
      }

      return new Response(JSON.stringify({ success: true, products, total: products.length }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // ACTION: import — import a single product by scraping its detail page
    if (action === "import") {
      const { product } = body;
      if (!product || !product.productLink) {
        return new Response(JSON.stringify({ error: "product com productLink é obrigatório" }), {
          status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // Check duplicate by affiliate_url
      const { data: existing } = await sb
        .from("products")
        .select("id")
        .eq("affiliate_url", product.productLink)
        .maybeSingle();

      if (existing) {
        return new Response(
          JSON.stringify({ error: "Produto já importado", product_id: existing.id }),
          { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      // Scrape the product detail page for enrichment
      let description: string | null = null;
      let galleryUrls: string[] = [];
      let enrichedPrice = product.price || 0;
      let enrichedOriginalPrice = product.originalPrice || null;
      let enrichedTitle = product.title || "";
      let enrichedImageUrl = product.imageUrl || "";

      try {
        console.log(`[Natura] Scraping PDP: ${product.productLink}`);
        const proxyUrl = buildScraperUrl(scraperConfig, product.productLink);
        const html = await fetchWithRetry(proxyUrl);
        const $ = cheerio.load(html);

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

        // Description
        const descText = $("[class*='productDescription'], [class*='description'], #description, [class*='details']").first().text().trim();
        if (descText && descText.length > 20) description = descText.substring(0, 2000);

        // Gallery
        $("[class*='productImage'] img, [class*='gallery'] img, [class*='carousel'] img, .swiper-slide img").each((_: any, img: any) => {
          const src = $(img).attr("data-src") || $(img).attr("src") || "";
          if (src && src.startsWith("http") && !src.includes("data:image")) {
            galleryUrls.push(src);
          }
        });
        galleryUrls = [...new Set(galleryUrls)].slice(0, 8);
        if (galleryUrls.length > 0 && !enrichedImageUrl) enrichedImageUrl = galleryUrls[0];

        // OG image fallback
        if (!enrichedImageUrl) {
          const ogImg = $('meta[property="og:image"]').attr("content");
          if (ogImg) enrichedImageUrl = ogImg;
        }
      } catch (scrapeErr) {
        console.warn("[Natura] PDP scraping failed (non-blocking):", scrapeErr);
      }

      // Resolve platform
      let resolvedPlatformId = platformId || null;
      if (!resolvedPlatformId) {
        const brandName = product.brand || "Natura";
        const { data: plat } = await sb.from("platforms").select("id").ilike("name", `%${brandName}%`).maybeSingle();
        if (plat) {
          resolvedPlatformId = plat.id;
        } else {
          const { data: newPlat } = await sb.from("platforms").insert({ name: brandName }).select("id").single();
          if (newPlat) resolvedPlatformId = newPlat.id;
        }
      }

      // Resolve category (search only, no auto-create)
      let resolvedCategoryId = categoryId || null;
      if (!resolvedCategoryId) {
        const catNames = ["Beleza", "Cosméticos", "Perfumaria"];
        for (const catName of catNames) {
          const { data: cat } = await sb.from("categories").select("id").ilike("name", `%${catName}%`).maybeSingle();
          if (cat) { resolvedCategoryId = cat.id; break; }
        }
      }

      const { data: newProduct, error: prodErr } = await sb.from("products").insert({
        title: enrichedTitle || "Produto Natura/Avon",
        price: enrichedPrice > 0 ? enrichedPrice : 0.01,
        original_price: enrichedOriginalPrice,
        description: description,
        store: product.brand || "Natura",
        affiliate_url: product.productLink,
        image_url: enrichedImageUrl || null,
        gallery_urls: galleryUrls.length > 0 ? galleryUrls : null,
        category_id: resolvedCategoryId,
        platform_id: resolvedPlatformId,
        is_active: true,
        registered_by: userId || null,
      }).select().single();

      if (prodErr) throw prodErr;

      return new Response(JSON.stringify({ success: true, product: newProduct }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ error: "action inválida. Use 'search' ou 'import'." }), {
      status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("natura-import-product error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
