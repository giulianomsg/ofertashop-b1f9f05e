// Edge Function: ml-search-products
// Searches products using Mercado Livre via ScrapingBee
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

async function fetchWithRetry(url: string, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const res = await fetch(url);
      if (res.ok) {
        return await res.text();
      }
      console.warn(`Attempt ${i + 1} failed with status: ${res.status}`);
      if (res.status === 401 || res.status === 403) {
        throw new Error("ScrapingBee API Key inválida ou limite excedido");
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
    const { keyword, offset = 0 } = await req.json();

    if (!keyword || typeof keyword !== "string") {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const SCRAPINGBEE_API_KEY = Deno.env.get("SCRAPINGBEE_API_KEY");
    if (!SCRAPINGBEE_API_KEY) throw new Error("SCRAPINGBEE_API_KEY não configurada.");

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Formatação de URL de busca Mercado Livre
    // O offset no ML funciona como _Desde_51, _Desde_101
    // Offset recebido do front geralmente é de 50 em 50: 0, 50, 100
    const querySlug = keyword.trim().toLowerCase().replace(/\s+/g, "-");
    const desdeSlug = offset > 0 ? `_Desde_${offset + 1}` : "";
    let targetUrl = `https://lista.mercadolivre.com.br/${querySlug}${desdeSlug}`;
    
    // Fallback: se houver problemas consistentes na URL limpa, usar o path search?q=
    // let targetUrl = `https://lista.mercadolivre.com.br/search?q=${encodeURIComponent(keyword)}&offset=${offset}`;

    const scrapingbeeUrl = new URL("https://app.scrapingbee.com/api/v1/");
    scrapingbeeUrl.searchParams.append("api_key", SCRAPINGBEE_API_KEY);
    scrapingbeeUrl.searchParams.append("url", targetUrl);
    scrapingbeeUrl.searchParams.append("render_js", "false"); // ML HTML returns enough info in SSR
    scrapingbeeUrl.searchParams.append("premium_proxy", "true"); // Evita bloqueios do ML
    scrapingbeeUrl.searchParams.append("country_code", "br");

    console.log(`Buscando no ML via ScrapingBee: ${targetUrl}`);
    const html = await fetchWithRetry(scrapingbeeUrl.toString());

    const $ = cheerio.load(html);
    const results: any[] = [];

    // Suporta ambos seletores: Antigos (ui-search) e Novos (poly- / andes-)
    $(".ui-search-layout__item, .andes-card").each((_, el) => {
      const titleElem = $(el).find(".ui-search-item__title, .poly-component__title");
      const title = titleElem.text().trim();
      
      const priceElem = $(el).find(".price-tag-fraction, .andes-money-amount__fraction").first();
      const priceText = priceElem.text().replace(/\./g, "").replace(",", ".");
      const price = parseFloat(priceText) || 0;

      const centsElem = $(el).find(".price-tag-cents, .andes-money-amount__cents").first();
      const cents = parseFloat(centsElem.text()) / 100 || 0;
      const finalPrice = price + cents;

      let linkElem = $(el).find(".ui-search-link");
      if (linkElem.length === 0) {
        linkElem = $(el).find("a[href*='/p/MLB'], a[href*='produto.mercadolivre.com']").first();
      }
      
      const permalink = linkElem.attr("href")?.split("#")[0] || "";
      const matchId = permalink.match(/MLB-?(\d+)/i) || permalink.match(/MLB(\d+)/i);
      const id = matchId ? `MLB${matchId[1]}` : `mlb_${Math.random().toString(36).substr(2, 9)}`;

      // Thumb
      let thumbnail = $(el).find("img.ui-search-result-image__element, .poly-component__picture").attr("data-src") || 
                      $(el).find("img").attr("src") || "";
                      
      // Em layouts 'poly', a imagem no SSR pode ficar no source srcset 
      if (!thumbnail.includes("http")) {
         const srcset = $(el).find("img").attr("srcset");
         if (srcset) {
            thumbnail = srcset.split(",")[0].split(" ")[0] || thumbnail;
         }
      }

      const shippingElem = $(el).find(".ui-search-item__shipping--free, .poly-component__shipping");
      const shipping_free = shippingElem.text().toLowerCase().includes("grátis") || shippingElem.length > 0;
      
      const sellerElem = $(el).find(".ui-search-official-store-label, .poly-component__seller");
      const sellerNickname = sellerElem.text().replace("por ", "").trim() || "Vendedor Local";

      if (title && finalPrice > 0 && permalink && permalink.includes("mercadolivre")) {
        results.push({
          id,
          title,
          price: finalPrice,
          original_price: null,
          currency_id: "BRL",
          thumbnail,
          permalink,
          condition: "new",
          sold_quantity: 0,
          available_quantity: 99, // Assumption: visible in search means it has stock
          seller: { id: id, nickname: sellerNickname },
          category_id: "MLB", 
          shipping_free
        });
      }
    });

    if (results.length === 0) {
      console.warn("Nenhum produto extraído via ScrapingBee do HTML retornado");
    }

    // Identificar quais já foram importados
    const mlIds = results.map((r: any) => r.id).filter(id => id.startsWith("MLB"));
    let importedSet = new Set();

    if (mlIds.length > 0) {
      const { data: existingMappings } = await sb
        .from("ml_product_mappings")
        .select("ml_item_id")
        .in("ml_item_id", mlIds);

      importedSet = new Set((existingMappings || []).map((m: any) => m.ml_item_id));
    }

    const enrichedResults = results.map((r: any) => ({
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