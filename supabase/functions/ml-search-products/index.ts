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
    let targetUrl = `https://lista.mercadolivre.com.br/${querySlug}${desdeSlug}_NoIndex_True`;
    
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

    // Seletores clássicos do ML
    $(".ui-search-layout__item").each((_, el) => {
      const titleElem = $(el).find(".ui-search-item__title");
      const title = titleElem.text().trim();
      
      const priceElem = $(el).find(".price-tag-fraction").first();
      const priceText = priceElem.text().replace(/\./g, "").replace(",", ".");
      const price = parseFloat(priceText) || 0;

      const centsElem = $(el).find(".price-tag-cents").first();
      const cents = parseFloat(centsElem.text()) / 100 || 0;
      const finalPrice = price + cents;

      const linkElem = $(el).find(".ui-search-link");
      const permalink = linkElem.attr("href")?.split("#")[0] || "";
      
      const matchId = permalink.match(/MLB-?(\d+)/i) || permalink.match(/MLB(\d+)/i);
      const id = matchId ? `MLB${matchId[1]}` : `mlb_${Math.random().toString(36).substr(2, 9)}`;

      // A thumb original costuma estar no source data-src por lazy loading
      let thumbnail = $(el).find("img.ui-search-result-image__element").attr("data-src") || 
                      $(el).find("img.ui-search-result-image__element").attr("src") || "";

      const shippingElem = $(el).find(".ui-search-item__shipping--free");
      const shipping_free = shippingElem.length > 0;
      
      const sellerElem = $(el).find(".ui-search-official-store-label");
      const sellerNickname = sellerElem.text().replace("por ", "").trim() || "Vendedor Local";

      if (title && finalPrice > 0 && permalink) {
        results.push({
          id,
          title,
          price: finalPrice,
          original_price: null, // Pode extrair do HTML se estiver riscado (ui-search-price--original)
          currency_id: "BRL",
          thumbnail,
          permalink,
          condition: "new",
          sold_quantity: 0,
          available_quantity: 99,
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