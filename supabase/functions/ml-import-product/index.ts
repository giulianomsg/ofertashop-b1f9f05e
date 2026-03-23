// Edge Function: ml-import-product (standalone)
// Imports a product from Mercado Livre into the local database
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { z } from "https://deno.land/x/zod@v3.22.4/mod.ts";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Zod Schemas
const ItemSchema = z.object({
  id: z.string().min(1),
  title: z.string().min(1),
  price: z.number().nonnegative(),
  original_price: z.number().nullable().optional(),
  thumbnail: z.string().url().or(z.string().length(0)),
  permalink: z.string().url().or(z.string().length(0)),
  condition: z.string().optional(),
  sold_quantity: z.number().optional(),
  available_quantity: z.number().optional(),
  seller: z.object({
    id: z.any().optional(),
    nickname: z.string().optional()
  }).optional(),
  category_id: z.string().optional(),
  shipping_free: z.boolean().optional(),
}).passthrough();

const RequestSchema = z.object({
  item: ItemSchema,
  categoryId: z.string().uuid().optional(),
  platformId: z.string().uuid().optional(),
  userId: z.string().uuid().optional(),
});

// --- MULTI-SCRAPER ABSTRACTION (STANDALONE) ---
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
  } catch(e) { /* ignore */ }
  
  try {
     const { data: legacy } = await sb.from("admin_settings").select("value").eq("key", "active_scraper").maybeSingle();
     if (legacy?.value?.provider && legacy?.value?.apiKey) return legacy.value as ScraperConfig;
  } catch(e) { /* ignore */ }

  const scrapingBeeKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (scrapingBeeKey) return { provider: "scrapingbee", apiKey: scrapingBeeKey };
  throw new Error("Nenhum serviço de Web Scraper configurado.");
}

async function fetchHtmlWithRetry(url: string, retries = 3): Promise<string> {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const res = await fetch(url);
      if (!res.ok && res.status !== 404) throw new Error(`HTTP ${res.status}`);
      let html = await res.text();
      try {
        const json = JSON.parse(html);
        if (json && typeof json.content === 'string') html = json.content;
      } catch(e) { /* html cru */ }
      return html;
    } catch (err: any) {
      if (attempt === retries) throw err;
      await new Promise(r => setTimeout(r, 1000 * attempt));
    }
  }
  throw new Error("Falha no scraper detalhado.");
}
// ----------------------------------------------

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    
    // Validate request using Zod
    const validationResult = RequestSchema.safeParse(body);
    if (!validationResult.success) {
      return new Response(JSON.stringify({ error: "Dados inválidos", details: validationResult.error.format() }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { item, categoryId, platformId, userId } = validationResult.data;

    const ML_APP_ID = Deno.env.get("ML_APP_ID");
    const ML_CLIENT_SECRET = Deno.env.get("ML_CLIENT_SECRET");
    if (!ML_APP_ID || !ML_CLIENT_SECRET) throw new Error("ML_APP_ID e ML_CLIENT_SECRET não configurados.");

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Initial check (non-locked) to return 409 quickly if already 100% exists
    const { data: existingMap } = await sb
      .from("ml_product_mappings")
      .select("id, product_id")
      .eq("ml_item_id", item.id)
      .maybeSingle();

    if (existingMap) {
      return new Response(
        JSON.stringify({ error: "Produto já importado", product_id: existingMap.product_id }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // === 1. Deep Scraping (Extração Profunda da PDP) ===
    const scraperConfig = await getActiveScraperConfig(sb);
    const pdpUrl = item.permalink || `https://produto.mercadolivre.com.br/MLB-${item.id.replace("MLB", "")}`;
    const proxyUrl = buildScraperUrl(scraperConfig, pdpUrl);
    
    console.log(`[Deep Scraping] Acessando PDP do ML: ${pdpUrl}`);
    const html = await fetchHtmlWithRetry(proxyUrl);
    const $ = cheerio.load(html);

    // Precificação
    const priceText = $(".ui-pdp-price__second-line .andes-money-amount__fraction").first().text().replace(/\./g, "").replace(",", ".");
    const scrapedPrice = parseFloat(priceText) || item.price || 0.01;

    const originalPriceText = $(".ui-pdp-price__original-value .andes-money-amount__fraction").first().text().replace(/\./g, "").replace(",", ".");
    const scrapedOriginalPrice = originalPriceText ? parseFloat(originalPriceText) : null;
    const finalOriginalPrice = scrapedOriginalPrice && scrapedOriginalPrice > scrapedPrice ? scrapedOriginalPrice : null;

    // Rating
    const domRating = parseFloat($(".ui-pdp-review__rating").first().text().trim().replace(",", ".")) || item.rating || 0;

    // Vendedor e Vendas
    const sellerHeader = $(".ui-pdp-seller__header__title").text().trim();
    const storeName = sellerHeader || item.seller?.nickname || "Mercado Livre";
    
    let domSalesCount = item.sold_quantity || 0;
    const subtitleFull = $(".ui-pdp-subtitle").text().trim(); // Ex: "Novo  |  +100 vendidos"
    if (subtitleFull.includes("|")) {
       const salesPart = subtitleFull.split("|")[1].toLowerCase();
       const m = salesPart.match(/\d+/);
       if (m) domSalesCount = parseInt(m[0]) * (salesPart.includes("mil") ? 1000 : 1);
    } else {
       const sellerSalesText = $(".ui-pdp-seller__sales-description").text().toLowerCase();
       const matchSales = sellerSalesText.match(/\d+/);
       if (matchSales) domSalesCount = parseInt(matchSales[0]) * (sellerSalesText.includes("mil") ? 1000 : 1);
    }

    // Condições Meli+ e Cashback
    const meliPlusHeader = $(".ui-pdp-media__title").text().toLowerCase();
    const isMeliPlus = meliPlusHeader.includes("meli+");
    const shippingFree = meliPlusHeader.includes("grátis") || isMeliPlus || item.shipping_free;
    
    // Extraindo cashback através do dom GREEN fraction + cents
    const cbFraction = $(".ui-pdp-price__part.ui-pdp-color--GREEN .andes-money-amount__fraction").first().text().trim();
    const cbCents = $(".ui-pdp-price__part.ui-pdp-color--GREEN .andes-money-amount__cents").first().text().trim();
    const cashbackAmount = cbCents ? `${cbFraction},${cbCents}` : cbFraction;
    const cashbackText = cashbackAmount ? `R$ ${cashbackAmount} de cashback` : "";
    
    const sellerReputationText = $(".ui-pdp-seller__reputation-info").text().trim();

    // Galeria de Imagens de Alta Resolução e Thumbnail
    const galleryUrls: string[] = [];
    $(".ui-pdp-gallery__figure img").each((_: any, img: any) => {
       const url = $(img).attr("data-zoom") || $(img).attr("src") || "";
       if (url.startsWith("http") && !url.includes("data:image")) galleryUrls.push(url);
    });
    const finalImageUrl = galleryUrls.length > 0 ? galleryUrls[0] : (item.thumbnail || "");

    // Variações de modelo / cor detalhadas
    const features: any[] = [];
    const variations_tree: any[] = [];
    $("#outside_variations .ui-pdp-outside_variations__picker, .ui-pdp-variations__picker").each((_: any, el: any) => {
       let groupName = $(el).find(".ui-pdp-outside_variations__title__label, .ui-pdp-variations__title__label").first().text().replace(":", "").trim();
       if (!groupName) groupName = $(el).find(".ui-pdp-outside_variations__title, .ui-pdp-variations__title").first().text().split(":")[0].trim();
       if (!groupName) return; // ignora picker vazio

       features.push({ name: groupName, value: "Disponível" });
       
       let options: string[] = [];
       // Tentativa 1: Thumbnails de Variação (ex: link images = Cores)
       $(el).find(".ui-pdp-outside_variations__thumbnails__item img").each((_: any, img: any) => {
          const altText = $(img).attr("alt");
          if (altText) {
            options.push(altText.trim());
          }
       });

       // Tentativa 2: Dropdown ou botões normais (ex: Tamanhos "Escolha")
       if (options.length === 0) {
          // Buscamos pelos elementos de menu Dropdown, ou text boxes estáticos
          $(el).find(".andes-listbox__option .andes-listbox__label, .ui-pdp-variations__selector .andes-listbox__label, .ui-vpp-fit-as-expected__fit-as-expected").each((_: any, opt: any) => {
             const txt = $(opt).text().trim();
             if (txt && !txt.includes("Escolha") && txt !== "Tamanho") options.push(txt);
          });
          
          if (options.length === 0) {
             // Raspa label visual do dropdown se nada for clicado / injetado
             const placeholderText = $(el).find(".andes-dropdown__placeholder").text().trim();
             if (placeholderText && placeholderText !== "Escolha") options.push(placeholderText);
          }
       }
       variations_tree.push({ group: groupName, options: options });
    });

    const extra_metadata = {
       meli_plus: isMeliPlus,
       cashback: cashbackText,
       seller_reputation: sellerReputationText,
       shipping_details: shippingFree ? "Frete Grátis" : "Consultar CEP",
       variations: variations_tree
    };

    // Descrição (Tentamos pegar do DOM do PDP se SSR, senão da API oficial aberta)
    let descriptionHTML = $(".ui-pdp-description__content").html()?.trim() || "";
    if (!descriptionHTML) {
       try {
         const descRes = await fetch(`https://api.mercadolibre.com/items/${item.id}/description`);
         if (descRes.ok) {
           const d = await descRes.json();
           descriptionHTML = d.plain_text || d.text || "";
         }
       } catch(_) { /* fallback empty */ }
    }

    // Resolvendo Plataforma
    let resolvedPlatformId = platformId;
    if (!resolvedPlatformId) {
      const { data: mlPlatform } = await sb.from("platforms").select("id").ilike("name", "%mercado%livre%").maybeSingle();
      if (mlPlatform) {
        resolvedPlatformId = mlPlatform.id;
      } else {
        const { data: newPlat } = await sb.from("platforms").insert({ name: "Mercado Livre" }).select("id").single();
        if (newPlat) resolvedPlatformId = newPlat.id;
      }
    }

    // Categoria via Breadcrumb da PDP
    let resolvedCategoryId = categoryId || null;
    if (!resolvedCategoryId) {
       const catName = $(".andes-breadcrumb__item a").last().text().trim() || "Diversos";
       const { data: existingCat } = await sb.from("categories").select("id").ilike("name", catName).maybeSingle();
       if (existingCat) {
          resolvedCategoryId = existingCat.id;
       } else {
          const slug = catName.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
          const { data: newCat } = await sb.from("categories").insert({ name: catName, slug }).select("id").single();
          if (newCat) resolvedCategoryId = newCat.id;
       }
    }

    // Geração do Objeto de Produto Upsert
    const { data: product, error: productErr } = await sb
      .from("products")
      .insert({
        title: item.title || "Produto Mercado Livre",
        price: scrapedPrice,
        original_price: finalOriginalPrice,
        store: storeName,
        affiliate_url: pdpUrl,
        image_url: finalImageUrl,
        gallery_urls: galleryUrls.length > 0 ? galleryUrls : null,
        description: descriptionHTML || null,
        category_id: resolvedCategoryId,
        platform_id: resolvedPlatformId,
        is_active: true,
        rating: domRating,
        registered_by: userId || null,
        sales_count: domSalesCount,
        available_quantity: item.available_quantity || null,
        features: features.length > 0 ? features : null,
        badge: item.condition === "used" ? "Usado" : "Novo",
        extra_metadata: extra_metadata,
      })
      .select()
      .single();

    if (productErr) throw productErr;

    // Vincular Tracking Identificador no Mapeamento
    const { error: mappingErr } = await sb
      .from("ml_product_mappings")
      .upsert({
        product_id: product.id,
        ml_item_id: item.id,
        ml_permalink: pdpUrl,
        ml_category_id: null,
        ml_seller_id: null,
        ml_condition: item.condition,
        ml_sold_quantity: domSalesCount,
        ml_status: "active",
        ml_original_price: finalOriginalPrice,
        ml_current_price: scrapedPrice,
        ml_thumbnail: finalImageUrl,
        sync_status: "active",
      }, { onConflict: 'ml_item_id' }); 

    if (mappingErr) console.warn("Error inserting mapping:", mappingErr.message);

    await sb.from("ml_sync_logs").insert({
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
  } catch (err: any) {
    console.error("ml-import-product error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
