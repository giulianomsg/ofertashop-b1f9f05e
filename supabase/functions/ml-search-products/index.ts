// Edge Function: ml-search-products
// Searches products using Mercado Livre via ScrapingBee
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

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
    api.searchParams.append("proxy_type", "residential"); // Critical for bypassing ML CAPTCHAs
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
  
  // Legacy DB Fallback
  try {
     const { data: legacy } = await sb.from("admin_settings").select("value").eq("key", "active_scraper").maybeSingle();
     if (legacy?.value?.provider && legacy?.value?.apiKey) return legacy.value as ScraperConfig;
  } catch(e) { /* ignore */ }

  const scrapingBeeKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (scrapingBeeKey) return { provider: "scrapingbee", apiKey: scrapingBeeKey };
  throw new Error("Nenhum serviço de Web Scraper configurado com chave válida no banco de dados.");
}
// ----------------------------------------------

async function fetchWithRetry(url: string, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const res = await fetch(url);
      if (res.ok) {
        let finalHtml = await res.text();
        console.log(`[Scraper Trace] Resposta Bruta (Init):`, finalHtml.substring(0, 800));
        
        try {
          const json = JSON.parse(finalHtml);
          console.log(`[Scraper Trace] JSON detectado. Chaves:`, Object.keys(json));
          if (json && typeof json.content === 'string') {
             console.log(`[Scraper Trace] Extraindo campo .content (${json.content.length} chars)`);
             finalHtml = json.content;
          }
        } catch(e) { 
          console.log(`[Scraper Trace] Resposta não é JSON. Tratando como HTML Cru.`);
        }
        return finalHtml;
      }
      console.warn(`Attempt ${i + 1} failed with status: ${res.status}`);
      if (res.status === 401 || res.status === 403) {
        throw new Error("API Key inválida ou limite excedido");
      }
    } catch (err: any) {
      console.error(`Fetch error on attempt ${i + 1}:`, err.message);
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000 * Math.pow(2, i)));
  }
  throw new Error("Falha ao buscar página após múltiplas tentativas.");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { keyword = "", offset = 0, searchType = "default" } = await req.json();

    if (searchType === "default" && (!keyword || typeof keyword !== "string")) {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    const scraperConfig = await getActiveScraperConfig(sb);

    let targetUrl = "";
    if (searchType === "ofertas") {
       const page = Math.floor(offset / 50) + 1;
       targetUrl = `https://www.mercadolivre.com.br/ofertas?page=${page}`;
    } else if (searchType === "relampago") {
       const page = Math.floor(offset / 50) + 1;
       targetUrl = `https://www.mercadolivre.com.br/ofertas?promotion_type=lightning&page=${page}`;
    } else {
       // Formatação segura de URL de busca Mercado Livre para busca Exata (SEO)
       const cleanKeyword = keyword.normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim().toLowerCase();
       const querySlug = cleanKeyword.replace(/[^\w\s-]/g, "").replace(/\s+/g, "-");
       const desdeSlug = offset > 0 ? `_Desde_${offset + 1}` : "";
       targetUrl = `https://lista.mercadolivre.com.br/${querySlug}${desdeSlug}`;
    }

    const proxyTargetUrl = buildScraperUrl(scraperConfig, targetUrl);

    console.log(`Buscando no ML via ${scraperConfig.provider}: ${targetUrl}`);
    const html = await fetchWithRetry(proxyTargetUrl);

    const $ = cheerio.load(html);
    const pageTitle = $("title").text().trim();
    console.log(`[MultiScraper] Page Title Extraído: "${pageTitle}"`);
    
    if (pageTitle.toLowerCase().includes("verifique se você é") || pageTitle.toLowerCase().includes("captcha")) {
       console.warn(`[MultiScraper] AVISO: O provedor ${scraperConfig.provider} foi bloqueado pelo Anti-Bot do ML (CAPTCHA).`);
    }

    const results: any[] = [];

    // Suporta ambos seletores: Antigos (ui-search), Novos (poly- / andes-) e Abas de Oferta (promotion-item)
    $(".ui-search-layout__item, .andes-card, .promotion-item").each((_: any, el: any) => {
      const titleElem = $(el).find(".ui-search-item__title, .poly-component__title, .promotion-item__title");
      const title = titleElem.text().trim();
      
      const priceElem = $(el).find(".price-tag-fraction, .andes-money-amount__fraction, .promotion-item__price span").first();
      const priceText = priceElem.text().replace(/\./g, "").replace(",", ".");
      let price = parseFloat(priceText) || 0;

      const centsElem = $(el).find(".price-tag-cents, .andes-money-amount__cents").first();
      const cents = parseFloat(centsElem.text()) / 100 || 0;
      let finalPrice = price + cents;

      if (finalPrice <= 0) {
         // Fallback brutal caso promotion-item__price jogue o preço em string completa sem spans
         const fullTextPrice = $(el).find(".promotion-item__price").text().replace(/[^\d.,]/g, "").replace(/\./g, "").replace(",", ".");
         finalPrice = parseFloat(fullTextPrice) || 0;
      }

      let linkElem = $(el).find(".ui-search-link, .promotion-item__link-container");
      if (linkElem.length === 0) {
        linkElem = $(el).find("a[href*='/p/MLB'], a[href*='produto.mercadolivre.com']").first();
      }
      
      const permalink = linkElem.attr("href")?.split("#")[0] || "";
      const matchId = permalink.match(/MLB-?(\d+)/i) || permalink.match(/MLB(\d+)/i);
      const id = matchId ? `MLB${matchId[1]}` : `mlb_${Math.random().toString(36).substr(2, 9)}`;

      // Thumb
      let thumbnail = $(el).find("img.ui-search-result-image__element, .poly-component__picture, .promotion-item__img").attr("data-src") || 
                      $(el).find("img").attr("src") || "";
                      
      // Em layouts 'poly' ou 'promo', a imagem no SSR pode ficar no source srcset 
      if (!thumbnail.includes("http")) {
         const srcset = $(el).find("img").attr("srcset");
         if (srcset) {
            thumbnail = srcset.split(",")[0].split(" ")[0] || thumbnail;
         }
      }

      const shippingElem = $(el).find(".ui-search-item__shipping--free, .poly-component__shipping, .promotion-item__shipping");
      const shipping_free = shippingElem.text().toLowerCase().includes("grátis") || shippingElem.length > 0;
      
      // sellerNickname já é extraído acima, vamos garantir:
      const sellerElem = $(el).find(".ui-search-official-store-label, .poly-component__seller, .promotion-item__seller");
      const sellerText = sellerElem.text().trim() || "";
      const sellerNickname = sellerText.replace(/^por\s+/i, "").trim() || "Vendedor Local";

      // Extrair condição (novo, usado, recondicionado)
      const conditionElem = $(el).find(".ui-search-item__condition, .poly-component__condition");
      const conditionText = conditionElem.text().toLowerCase() || "";
      let condition = "new";
      if (conditionText.includes("usado")) condition = "used";
      else if (conditionText.includes("recondicionado")) condition = "refurbished";

      // Extrair vendas (+1000 vendidos, etc)
      let sold_quantity = 0;
      const salesElem = $(el).find(".poly-component__sales, .ui-search-item__group__element");
      salesElem.each((i: any, node: any) => {
        const text = $(node).text().toLowerCase();
        if (text.includes("vendido")) {
           const match = text.match(/\+?(?:de )?(\d+(?:\.\d+)?|mil)(?: mil)?/);
           if (match) {
              if (match[1].includes("mil") || text.includes("mil")) {
                sold_quantity = (parseFloat(match[1]) || 1) * 1000;
              } else {
                sold_quantity = parseInt(match[1].replace(".", ""));
              }
           }
        }
      });

      // Extrair reputação / rating
      let rating = 0;
      let reviewCount = 0;
      const ratingElem = $(el).find(".ui-search-reviews__rating-number, .poly-reviews__rating");
      if (ratingElem.length) rating = parseFloat(ratingElem.text()) || 0;
      
      const countElem = $(el).find(".ui-search-reviews__amount, .poly-reviews__total");
      if (countElem.length) {
        reviewCount = parseInt(countElem.text().replace(/\D/g, "")) || 0;
      }

      // Descrição (No ML Search List, apenas atributos curtos aparecem)
      let description = "";
      const attrElems = $(el).find(".ui-search-item__group__element, .poly-component__attributes");
      if (attrElems.length > 0) {
        const attrList: string[] = [];
        attrElems.each((i: any, attr: any) => {
           const t = $(attr).text().trim();
           if (t && !t.toLowerCase().includes("vendido") && !t.toLowerCase().includes("frete")) {
             attrList.push(t);
           }
        });
        description = attrList.join(" • ");
      }

      if (title && finalPrice > 0 && permalink && permalink.includes("mercadolivre")) {
        const productData = {
          id,
          title,
          price: finalPrice,
          original_price: null,
          currency_id: "BRL",
          thumbnail,
          permalink,
          condition, // -> Vai para a coluna 'badge' ou status no painel
          sold_quantity, // -> Vai para 'sales_count'
          available_quantity: 99, 
          seller: { id: id, nickname: sellerNickname }, // -> Vai para 'store'
          category_id: "MLB", 
          shipping_free,
          rating, // -> Vai para 'rating'
          reviewCount, // extra debug info
          description, // -> Vai para 'description', mas costuma ser melhor baixar o full no import
        };

        // Solicitação do User: Log de debug de cada item para ver o mapa
        console.log(`\n=== DEBUG ML ITEM: ${id} ===\n`, JSON.stringify(productData, null, 2));

        results.push(productData);
      }
    });

    if (results.length === 0) {
      console.warn("Nenhum produto extraído via ScrapingBee do HTML retornado");
    }

    // Dedup results based on MLB ID to avoid mirrored copies from Cheerio selecting parent/children overlaps
    const uniqueResults = results.filter((item, index, self) =>
      index === self.findIndex((t) => t.id === item.id)
    );

    // Identificar quais já foram importados
    const mlIds = uniqueResults.map((r: any) => r.id).filter(id => id.startsWith("MLB"));
    let importedSet = new Set();

    if (mlIds.length > 0) {
      const { data: existingMappings } = await sb
        .from("ml_product_mappings")
        .select("ml_item_id")
        .in("ml_item_id", mlIds);

      importedSet = new Set((existingMappings || []).map((m: any) => m.ml_item_id));
    }

    const enrichedResults = uniqueResults.map((r: any) => ({
      ...r,
      already_imported: importedSet.has(r.id),
    }));

    return new Response(JSON.stringify({
      results: enrichedResults,
      paging: { offset, limit: 50, total: 1000 },
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("ml-search-products error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno no ScrapingBee" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});