// Edge Function: compare-prices (standalone)
// Searches for the same product across multiple platforms
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { productId, searchTerm } = await req.json();
    if (!productId && !searchTerm) {
      return new Response(JSON.stringify({ error: "productId ou searchTerm obrigatório" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    // Get product info if productId provided
    let query = searchTerm || "";
    let currentProduct: any = null;
    if (productId) {
      const { data: product } = await sb.from("products").select("*, platforms(name)").eq("id", productId).single();
      if (!product) throw new Error("Produto não encontrado");
      currentProduct = product;
      // Use first 5 meaningful words of the title for searching
      const words = product.title.split(/\s+/).filter((w: string) => w.length > 2).slice(0, 5);
      query = words.join(" ");
    }

    // Search for similar products in the database (cross-platform)
    const { data: similarProducts } = await sb
      .from("products")
      .select("id, title, price, original_price, store, platform_id, image_url, affiliate_url, is_active, platforms(name)")
      .ilike("title", `%${query.split(" ").slice(0, 3).join("%")}%`)
      .eq("is_active", true)
      .order("price", { ascending: true })
      .limit(20);

    // Group results by platform
    const results: any[] = [];
    const platformMap = new Map<string, any[]>();

    for (const p of (similarProducts || [])) {
      const platformName = (p as any).platforms?.name || "Desconhecida";
      if (!platformMap.has(platformName)) {
        platformMap.set(platformName, []);
      }
      platformMap.get(platformName)!.push({
        id: p.id,
        title: p.title,
        price: p.price,
        original_price: p.original_price,
        store: p.store,
        platform: platformName,
        image_url: p.image_url,
        affiliate_url: p.affiliate_url,
        isCurrent: currentProduct ? p.id === currentProduct.id : false,
      });
    }

    for (const [platform, items] of platformMap) {
      const cheapest = items.reduce((a, b) => a.price < b.price ? a : b);
      results.push({
        platform,
        products: items.sort((a, b) => a.price - b.price),
        cheapestPrice: cheapest.price,
      });
    }

    // Sort platforms by cheapest price
    results.sort((a, b) => a.cheapestPrice - b.cheapestPrice);

    const cheapestOverall = results.length > 0 ? results[0] : null;

    return new Response(JSON.stringify({
      success: true,
      query,
      currentProduct: currentProduct ? {
        id: currentProduct.id,
        title: currentProduct.title,
        price: currentProduct.price,
        platform: (currentProduct as any).platforms?.name || "Desconhecida",
      } : null,
      results,
      cheapestPlatform: cheapestOverall?.platform || null,
      cheapestPrice: cheapestOverall?.cheapestPrice || null,
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("compare-prices error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
