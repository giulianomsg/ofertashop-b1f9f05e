// Edge Function: compare-prices
// Searches for similar products across platforms and uses OpenRouter AI to analyze the price data
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface OpenRouterConfig {
  apiKey: string;
  model: string;
}

async function getOpenRouterConfig(sb: any): Promise<OpenRouterConfig | null> {
  try {
    const { data } = await sb
      .from("admin_settings")
      .select("value")
      .eq("key", "openrouter_config")
      .maybeSingle();
    if (data?.value?.apiKey && data?.value?.model) {
      return { apiKey: data.value.apiKey, model: data.value.model };
    }
  } catch (_e) {}
  const envKey = Deno.env.get("OPENROUTER_API_KEY");
  if (envKey) return { apiKey: envKey, model: "google/gemini-2.0-flash-exp:free" };
  return null;
}

async function getAIAnalysis(config: OpenRouterConfig, currentProduct: any, results: any[]): Promise<string> {
  const productLines = results.flatMap((group: any) =>
    group.products.map((p: any) =>
      `- ${p.title} | ${p.platform} | R$ ${p.price.toFixed(2)} ${p.original_price ? `(de R$ ${p.original_price.toFixed(2)})` : ""} ${p.isCurrent ? "[PRODUTO ATUAL]" : ""}`
    )
  );

  const prompt = `Você é um analista de preços brasileiro especialista em e-commerce e programas de afiliados.

PRODUTO ANALISADO: "${currentProduct.title}"
PREÇO ATUAL: R$ ${currentProduct.price.toFixed(2)}
PLATAFORMA ATUAL: ${currentProduct.platform}

PREÇOS ENCONTRADOS EM OUTRAS PLATAFORMAS:
${productLines.join("\n")}

Analise os dados acima e responda em JSON válido (sem markdown):
{
  "is_good_deal": true/false,
  "verdict": "frase curta de 1 linha sobre se o preço atual é bom ou não",
  "recommendation": "recomendação de 2-3 linhas explicando onde está mais barato e se vale a pena comprar agora",
  "best_platform": "nome da plataforma com melhor preço",
  "savings_tip": "dica curta de economia se aplicável"
}

Regras:- Seja direto e objetivo
- Se o produto atual já é o mais barato, elogie a oferta 
- Se existe mais barato em outra plataforma, indique claramente
- Considere não apenas o preço, mas também desconto real vs preço inflado`;

  const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${config.apiKey}`,
      "Content-Type": "application/json",
      "HTTP-Referer": "https://ofertashop.com",
      "X-Title": "OfertaShop",
    },
    body: JSON.stringify({
      model: config.model,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!response.ok) return "";
  const aiRes = await response.json();
  return aiRes.choices?.[0]?.message?.content || "";
}

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

    results.sort((a, b) => a.cheapestPrice - b.cheapestPrice);
    const cheapestOverall = results.length > 0 ? results[0] : null;

    // AI Analysis via OpenRouter
    let aiAnalysis: any = null;
    if (currentProduct && results.length > 0) {
      const openRouterConfig = await getOpenRouterConfig(sb);
      if (openRouterConfig) {
        try {
          const currentProductForAI = {
            title: currentProduct.title,
            price: currentProduct.price,
            original_price: currentProduct.original_price,
            platform: (currentProduct as any).platforms?.name || "Desconhecida",
          };
          const rawAI = await getAIAnalysis(openRouterConfig, currentProductForAI, results);
          if (rawAI) {
            const jsonMatch = rawAI.match(/\{[\s\S]*\}/);
            if (jsonMatch) {
              aiAnalysis = JSON.parse(jsonMatch[0]);
            }
          }
        } catch (aiErr: any) {
          console.warn("AI analysis failed (non-blocking):", aiErr.message);
        }
      }
    }

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
      aiAnalysis,
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
