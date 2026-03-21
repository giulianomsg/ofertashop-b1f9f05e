// Edge Function: ml-search-products (standalone)
// Searches products on Mercado Livre API
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

async function getValidToken(sb: any, appId: string, clientSecret: string): Promise<string> {
  const { data: token } = await sb
    .from("ml_tokens")
    .select("*")
    .order("updated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!token) throw new Error("Nenhum token ML encontrado. Autorize via OAuth primeiro.");

  const expiresAt = new Date(token.expires_at).getTime();
  if (Date.now() < expiresAt - 5 * 60 * 1000) {
    return token.access_token;
  }

  // Refresh
  const res = await fetch("https://api.mercadolibre.com/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "refresh_token",
      client_id: appId,
      client_secret: clientSecret,
      refresh_token: token.refresh_token,
    }),
  });

  const data = await res.json();
  if (!res.ok || !data.access_token) throw new Error("Falha ao renovar token ML");

  await sb.from("ml_tokens").update({
    access_token: data.access_token,
    refresh_token: data.refresh_token,
    expires_at: new Date(Date.now() + data.expires_in * 1000).toISOString(),
    updated_at: new Date().toISOString(),
  }).eq("id", token.id);

  return data.access_token;
}

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

    const ML_APP_ID = Deno.env.get("ML_APP_ID");
    const ML_CLIENT_SECRET = Deno.env.get("ML_CLIENT_SECRET");
    if (!ML_APP_ID || !ML_CLIENT_SECRET) throw new Error("ML_APP_ID e ML_CLIENT_SECRET não configurados.");

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    const accessToken = await getValidToken(sb, ML_APP_ID, ML_CLIENT_SECRET);

    // Build search URL
    const params = new URLSearchParams({
      q: keyword,
      offset: String(offset),
      limit: String(limit),
    });
    if (category) params.set("category", category);

    const searchRes = await fetch(`https://api.mercadolibre.com/sites/MLB/search?${params}`, {
      headers: { Authorization: `Bearer ${accessToken}` },
    });

    const searchData = await searchRes.json();

    if (!searchRes.ok) {
      console.error("ML search failed:", searchData);
      throw new Error(searchData.message || "Erro na busca ML");
    }

    const results = (searchData.results || []).map((item: any) => ({
      id: item.id,
      title: item.title,
      price: item.price,
      original_price: item.original_price,
      currency_id: item.currency_id,
      thumbnail: item.thumbnail?.replace("http://", "https://"),
      permalink: item.permalink,
      condition: item.condition,
      sold_quantity: item.sold_quantity,
      available_quantity: item.available_quantity,
      seller: {
        id: item.seller?.id,
        nickname: item.seller?.nickname,
      },
      category_id: item.category_id,
      shipping_free: item.shipping?.free_shipping || false,
    }));

    // Check already imported
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
