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
  
  try {
     const { data: legacy } = await sb.from("admin_settings").select("value").eq("key", "active_scraper").maybeSingle();
     if (legacy?.value?.provider && legacy?.value?.apiKey) return legacy.value as ScraperConfig;
  } catch(e) {}

  const scrapingBeeKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (scrapingBeeKey) return { provider: "scrapingbee", apiKey: scrapingBeeKey };
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
          if (json && typeof json.content === 'string') {
             finalHtml = json.content;
          }
        } catch(e) {}
        return finalHtml;
      }
      if (res.status === 401 || res.status === 403) {
        throw new Error("API Key de Scraper inválida ou limite excedido");
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
    const { keyword = "", offset = 0, searchType = "default", categoryId = "" } = await req.json();

    if (searchType === "default" && !keyword) {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    let targetUrl = "";
    const page = Math.floor(offset / 48) + 1; // Amazon generally shows ~48 results per page

    if (searchType === "ofertas") {
       // Buscar a página de Today's Deals via search para usar a mesma listagem
       // Ou se categoryId for provido (Daily Deals node)
       const cleanKeyword = keyword ? `k=${encodeURIComponent(keyword)}&` : "";
       targetUrl = `https://www.amazon.com.br/s?${cleanKeyword}rh=p_n_deal_type%3A23565510011&page=${page}`;
    } else if (searchType === "maisVendidos") {
       // Best Sellers
       targetUrl = categoryId ? `https://www.amazon.com.br/gp/bestsellers/${categoryId}` : `https://www.amazon.com.br/gp/bestsellers/`;
    } else {
       // Default search
       targetUrl = `https://www.amazon.com.br/s?k=${encodeURIComponent(keyword)}&page=${page}`;
    }

    const proxyTargetUrl = buildScraperUrl(scraperConfig, targetUrl);
    console.log(`Buscando na Amazon via ${scraperConfig.provider}: ${targetUrl}`);
    const html = await fetchWithRetry(proxyTargetUrl);

    const $ = cheerio.load(html);
    const results: any[] = [];
    
    // Tratando Busca Normal e Ofertas (s-search-result)
    $("div[data-component-type='s-search-result']").each((_, el) => {
      const asin = $(el).attr("data-asin");
      if (!asin) return;

      const title = $(el).find("h2 a span").text().trim();
      const linkElem = $(el).find("h2 a").attr("href");
      const permalink = linkElem ? `https://www.amazon.com.br${linkElem}` : `https://www.amazon.com.br/dp/${asin}`;
      
      const priceWhole = $(el).find(".a-price-whole").first().text().replace(/[.,]/g, "");
      const priceFraction = $(el).find(".a-price-fraction").first().text();
      let price = parseFloat(`${priceWhole}.${priceFraction}`);
      
      // Fallback para grids novos
      if (isNaN(price) || price === 0) {
         const altPrice = $(el).find(".a-price .a-offscreen").first().text().replace(/[^\d,]/g, "").replace(",", ".");
         price = parseFloat(altPrice) || 0;
      }

      let original_price = null;
      const origText = $(el).find(".a-text-price .a-offscreen").first().text().replace(/[^\d,]/g, "").replace(",", ".");
      if (origText) {
          const parsedOrig = parseFloat(origText);
          if (parsedOrig > price) original_price = parsedOrig;
      }

      const thumbnail = $(el).find(".s-image").attr("src") || "";
      const ratingText = $(el).find(".a-icon-alt").text(); // "4,6 de 5 estrelas"
      let rating = 0;
      if (ratingText) rating = parseFloat(ratingText.replace(",", ".")) || 0;

      const reviewCountText = $(el).find("span[aria-label*='avaliações'], span.a-size-base.s-underline-text").text();
      const reviewCount = parseInt(reviewCountText.replace(/[^\d]/g, "")) || 0;
      
      const badge = $(el).find(".a-badge-text").text().trim() || null;
      
      if (title && price > 0) {
         results.push({
            id: asin,
            title,
            price,
            original_price,
            thumbnail,
            permalink,
            rating,
            reviewCount,
            badge,
            seller: { nickname: "Amazon.com.br" }, // We don't know the exact seller from search easily
         });
      }
    });

    // Tratando Best Sellers page (caso ocorra)
    if (results.length === 0 && searchType === "maisVendidos") {
       $(".zg-grid-general-faceout").each((_, el) => {
          const title = $(el).find(".p13n-sc-truncate-desktop-type2").text().trim();
          const link = $(el).find("a.a-link-normal").attr("href");
          let asin = "";
          if (link) {
             const match = link.match(/\/dp\/([A-Z0-9]{10})/);
             if (match) asin = match[1];
          }
          if (!asin) return;

          const permalink = `https://www.amazon.com.br/dp/${asin}`;
          const priceText = $(el).find(".p13n-sc-price").text().replace(/[^\d,]/g, "").replace(",", ".");
          const price = parseFloat(priceText) || 0;
          const thumbnail = $(el).find("img").attr("src") || "";
          
          if (title && price > 0) {
             results.push({
                id: asin, title, price, original_price: null, thumbnail, permalink, seller: { nickname: "Amazon" }
             });
          }
       });
    }

    // Identificar quais já foram importados
    const asins = results.map((r: any) => r.id);
    let importedSet = new Set();
    if (asins.length > 0) {
      const { data: existing } = await sb.from("amazon_product_mappings").select("amazon_item_id").in("amazon_item_id", asins);
      importedSet = new Set((existing || []).map((m: any) => m.amazon_item_id));
    }

    const enrichedResults = results.map((r: any) => ({
      ...r,
      already_imported: importedSet.has(r.id),
    }));

    return new Response(JSON.stringify({ results: enrichedResults, paging: { offset, limit: 48 } }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
