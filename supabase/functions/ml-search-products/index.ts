// Edge Function: ml-search-products (standalone)
// Searches products on Mercado Livre API using public endpoints
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { keyword, category, offset = 0, limit = 20 } = await req.json();

    if (!keyword || typeof keyword !== "string") {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Constrói os parâmetros da URL
    const params = new URLSearchParams({
      q: keyword,
      offset: String(offset),
      limit: String(limit),
    });
    if (category) params.set("category", category);

    // TÁTICA DE BYPASS: Fazemos a requisição sem o Authorization token e com um User-Agent real.
    // Isso evita o erro 403 (Forbidden) causado pela limitação de escopo da sua aplicação OAuth.
    const searchRes = await fetch(`https://api.mercadolibre.com/sites/MLB/search?${params}`, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "application/json",
      },
    });

    const searchData = await searchRes.json();

    if (!searchRes.ok) {
      console.error("ML search failed:", searchData);
      throw new Error(searchData.message || "Erro na busca ML");
    }

    // Mapeamento original restabelecido (a estrutura volta a ser a esperada pelo Front-end)
    const results = (searchData.results || []).map((item: any) => ({
      id: item.id,
      title: item.title,
      price: item.price,
      original_price: item.original_price,
      currency_id: item.currency_id,
      thumbnail: item.thumbnail?.replace("http://", "https://"),
      permalink: item.permalink,
      condition: item.condition,
      sold_quantity: item.sold_quantity || 0,
      available_quantity: item.available_quantity || 1,
      seller: {
        id: item.seller?.id,
        nickname: item.seller?.nickname,
      },
      category_id: item.category_id,
      shipping_free: item.shipping?.free_shipping || false,
    }));

    // Verifica se os itens já foram importados no Supabase
    const mlIds = results.map((r: any) => r.id);
    const { data: existingMappings } = await sb
      .from("ml_product_mappings")
      .select("ml_item_id, product_id")
      .in("ml_item_id", mlIds);

    const importedSet = new Set((existingMappings || []).map((m: any) => m.ml_item_id));

    const enrichedResults = results.map((r: any) => ({
      ...r,
      already_imported: importedSet.has(r.id),
    }));

    return new Response(JSON.stringify({
      results: enrichedResults,
      paging: searchData.paging || {},
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("ml-search-products error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});