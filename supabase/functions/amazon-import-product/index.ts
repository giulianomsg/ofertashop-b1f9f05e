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
  } catch(e) {}
  
  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  throw new Error("Nenhum serviço de Web Scraper configurado com chave válida no banco.");
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

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { item, userId } = await req.json();
    if (!item?.id) throw new Error("Item ASIN is missing.");

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    const targetUrl = `https://www.amazon.com.br/dp/${item.id}`;
    const proxyTargetUrl = buildScraperUrl(scraperConfig, targetUrl);

    console.log(`Importando Amazon ASIN: ${item.id} via ${scraperConfig.provider}`);
    const html = await fetchWithRetry(proxyTargetUrl);
    const $ = cheerio.load(html);

    // Extrair detalhes precisos da página mestre (Product Page)
    let description = $("#feature-bullets ul li span.a-list-item").map((_, el) => $(el).text().trim()).get().join("\n");
    if (!description) {
       description = $("#productDescription").text().trim();
    }
    
    // Tentar achar imagens de alta resolução do Grid principal da Amazon
    // Amazon usa blocos de Script para carregar a galeria:
    let galleryUrls = [item.thumbnail];
    const scriptBlocks = $("script:contains('ImageBlockATF')").text();
    const urlsMatch = scriptBlocks.match(/"hiRes":"(https:\/\/m\.media-amazon\.com\/images\/I\/[^"]+)/g);
    if (urlsMatch) {
        const uniqueHires = Array.from(new Set(urlsMatch.map(m => m.replace('"hiRes":"', ''))));
        if (uniqueHires.length > 0) galleryUrls = uniqueHires.slice(0, 5); // Traz as 5 maiores imagens
    }

    // 1. Categoria via Breadcrumb
    let resolvedCategoryId = null;
    let catName = $("#wayfinding-breadcrumbs_feature_div ul li a").last().text().trim();
    if (catName) {
      const { data: existingCat } = await sb.from("categories").select("id").ilike("name", catName).maybeSingle();
      if (existingCat) {
        resolvedCategoryId = existingCat.id;
      }
      // If not found, leave null for admin to set manually
    }

    // 2. Marca (Brand) via Header
    let resolvedBrandId = null;
    let brandName = $("#bylineInfo").text().trim() || $("#bylineInfo_feature_div a").text().trim();
    brandName = brandName.replace(/^Visite a loja\s+/i, "").replace(/^Marca:\s+/i, "").trim();
    if (brandName) {
      const { data: existingBrand } = await sb.from("brands").select("id").ilike("name", brandName).maybeSingle();
      if (existingBrand) {
         resolvedBrandId = existingBrand.id;
      } else {
         const slug = brandName.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
         const { data: newBrand } = await sb.from("brands").insert({ name: brandName, slug }).select("id").single();
         if (newBrand) resolvedBrandId = newBrand.id;
      }
    }

    // 3. Rating e Sales (Vendas Sociais)
    const domRating = parseFloat($(".a-icon-star .a-icon-alt").first().text().replace(",", ".")) || item.rating || 0;
    
    let domSalesCount = item.sold_quantity || 0;
    const salesText = $("#social-proofing-faceout-title-tk_bought span").text().toLowerCase();
    const salesMatch = salesText.match(/\d+/);
    if (salesMatch) {
        domSalesCount = parseInt(salesMatch[0]) * (salesText.includes("mil") ? 1000 : 1);
    }

    // 4. Features Técnicas (Variações / Specs)
    const features: any[] = [];
    $("#productOverview_feature_div .a-spacing-small table tr, .po-row").each((_: any, tr: any) => {
       const label = $(tr).find("td.a-span3 span, .a-span3 span").text().trim();
       const val = $(tr).find("td.a-span9 span, .a-span9 span").text().trim();
       if (label && val) features.push({ name: label, value: val });
    });
    if (features.length === 0) {
       $("#feature-bullets ul li span.a-list-item").each((_: any, li: any) => {
          const text = $(li).text().trim();
          if (text && text.length < 50) features.push({ name: "Detalhe", value: text });
       });
    }

    const extra_metadata = {
       prime: $("#bbop-check-box").length > 0 || $(".a-icon-prime").length > 0,
       shipping_details: $("#mir-layout-DELIVERY_BLOCK-slot-PRIMARY_DELIVERY_MESSAGE_LARGE span").text().trim() || "Consultar frete",
    };

    // Encontrar ou Criar Plataforma "Amazon"
    let platformId = null;
    const { data: plats } = await sb.from("platforms").select("id").ilike("name", "Amazon").maybeSingle();
    if (plats?.id) platformId = plats.id;
    else {
      const { data: newPlat } = await sb.from("platforms").insert({ name: "Amazon", logo_url: "https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg", color: "#FF9900" }).select().single();
      if (newPlat) platformId = newPlat.id;
    }

    // Criar o bundle do produto
    const productData = {
      title: item.title,
      description: description || null,
      image_url: galleryUrls[0],
      gallery_urls: galleryUrls.length > 0 ? galleryUrls : null,
      price: item.price,
      original_price: item.original_price,
      store: brandName || "Amazon Brasil",
      affiliate_url: targetUrl, 
      external_id: item.id, // ASIN
      badge: item.badge || null,
      sales_count: domSalesCount > 0 ? domSalesCount : null,
      rating: domRating,
      category_id: resolvedCategoryId,
      brand_id: resolvedBrandId,
      features: features.length > 0 ? features : null,
      extra_metadata: extra_metadata,
      platform_id: platformId,
      registered_by: userId,
      is_active: true,
    };

    const { data: newProduct, error: insertProdError } = await sb.from("products").insert(productData).select().single();
    if (insertProdError) throw insertProdError;

    // Criar Mapeamento
    const mappingData = {
      product_id: newProduct.id,
      amazon_item_id: item.id,
      amazon_current_price: item.price,
      amazon_original_price: item.original_price,
      amazon_status: "active",
      amazon_rating: item.rating,
      amazon_review_count: item.reviewCount
    };

    const { error: mappingError } = await sb.from("amazon_product_mappings").insert(mappingData);
    if (mappingError) throw mappingError;

    return new Response(JSON.stringify({ success: true, product_id: newProduct.id }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("amazon-import error:", err);
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
