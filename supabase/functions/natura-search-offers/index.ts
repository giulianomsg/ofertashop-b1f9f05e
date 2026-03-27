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
  
  try {
     const { data: legacy } = await sb.from("admin_settings").select("value").eq("key", "active_scraper").maybeSingle();
     if (legacy?.value?.provider && legacy?.value?.apiKey) return legacy.value as ScraperConfig;
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
  throw new Error("Falha ao buscar página Natura/Avon.");
}

function parsePrice(text: string): number {
  if (!text) return 0;
  const cleaned = text.replace(/[^\d,\.]/g, "").replace(",", ".");
  return parseFloat(cleaned) || 0;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { keyword = "", offset = 0, searchType = "default", categoryId = "", brand = "natura" } = await req.json();

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
    const scraperConfig = await getActiveScraperConfig(sb);

    let targetUrl = "";
    const page = Math.floor(offset / 48) + 1; // Basic pagination
    
    // Construct search URL for Minha Loja Natura/Avon or standard Natura domain
    // For now, mirroring the requested active search approach
    if (searchType === "default" && keyword) {
        targetUrl = `https://www.natura.com.br/busca?q=${encodeURIComponent(keyword)}&page=${page}`;
    } else {
        // Fallback to minhaloja
        targetUrl = `https://www.minhaloja.natura.com/consultoria/ofertashop?marca=${brand}&page=${page}`;
    }

    const proxyTargetUrl = buildScraperUrl(scraperConfig, targetUrl);
    console.log(`Buscando Natura/Avon via ${scraperConfig.provider}: ${targetUrl}`);
    const html = await fetchWithRetry(proxyTargetUrl);

    const $ = cheerio.load(html);
    const results: any[] = [];
    
    $(".product-card, [class*='ProductCard'], [class*='product-item'], .showcase-item, article[class*='product']").each((_, el) => {
      const title = $(el).find("[class*='name'], [class*='title'], h3, h2").first().text().trim();
      const linkEl = $(el).find("a[href*='/p/'], a[href*='natura.com']").first();
      let permalink = linkEl.attr("href") || "";
      if (permalink && !permalink.startsWith("http")) {
          permalink = `https://www.natura.com.br${permalink}`; // Default base
      }

      // Extract a unique ID from permalink
      let id = "";
      const idMatch = permalink.match(/-(\d+)$/); // e.g., /p/blabla-123456
      if (idMatch) {
          id = idMatch[1];
      } else {
          // Hash fallback
          id = "nat_" + Math.random().toString(36).substr(2, 9);
      }

      let thumbnail = $(el).find("img").first().attr("src") || $(el).find("img").first().attr("data-src") || "";
      if (thumbnail && thumbnail.startsWith("//")) thumbnail = `https:${thumbnail}`;

      const priceText = $(el).find("[class*='price'], [class*='Price'], .price").last().text().trim();
      const originalPriceText = $(el).find("[class*='old'], [class*='original'], del, s, [class*='from']").first().text().trim();
      const price = parsePrice(priceText);
      const originalPrice = parsePrice(originalPriceText);

      // Extract Rating snippet if present
      let rating = 0;
      let reviewCount = 0;
      const ratingText = $(el).find("[class*='rating'], [class*='Rating']").text().trim(); // Simplistic
      if (ratingText) {
          const m = ratingText.match(/(\d[\.,]\d)/);
          if (m) rating = parseFloat(m[1].replace(",", "."));
      }

      if (title && price > 0 && permalink) {
         results.push({
            id,
            title,
            price,
            original_price: originalPrice > price ? originalPrice : null,
            thumbnail,
            permalink,
            rating,
            reviewCount,
            seller: { nickname: brand.toUpperCase() === "AVON" ? "Avon" : "Natura" },
         });
      }
    });

    // Identificar importados
    const itemIds = results.map((r: any) => r.id);
    let importedSet = new Set();
    if (itemIds.length > 0) {
      const { data: existing } = await sb.from("natura_product_mappings").select("natura_item_id").in("natura_item_id", itemIds);
      importedSet = new Set((existing || []).map((m: any) => m.natura_item_id));
    }

    const enrichedResults = results.map((r: any) => ({
      ...r,
      already_imported: importedSet.has(r.id),
      badge: r.original_price ? "Oferta" : null
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
