import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

interface OpenRouterConfig {
  apiKey: string;
  model: string;
}

async function getOpenRouterConfig(sb: any): Promise<OpenRouterConfig> {
  try {
    const { data } = await sb
      .from("admin_settings")
      .select("value")
      .eq("key", "openrouter_config")
      .maybeSingle();
    if (data?.value?.apiKey && data?.value?.model) {
      return { apiKey: data.value.apiKey, model: data.value.model };
    }
  } catch (e) {
    console.warn("Falha ao buscar config OpenRouter:", e);
  }
  const envKey = Deno.env.get("OPENROUTER_API_KEY");
  if (envKey) return { apiKey: envKey, model: "google/gemini-2.0-flash-exp:free" };
  throw new Error("API Key do OpenRouter não configurada.");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const sb = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const config = await getOpenRouterConfig(sb);

    // Get top products for context
    const { data: topProducts } = await sb
      .from("products")
      .select("title, category, price, clicks, store")
      .eq("is_active", true)
      .order("clicks", { ascending: false })
      .limit(20);

    const productContext = (topProducts || [])
      .map((p: any) => `- ${p.title} (${p.store}, R$${p.price}, ${p.clicks} cliques, cat: ${p.category})`)
      .join("\n");

    const prompt = `Analise as seguintes ofertas populares de um site de afiliados brasileiro e identifique tendências de mercado, categorias em alta, faixas de preço mais clicadas e oportunidades.

Produtos mais clicados:
${productContext}

Responda em JSON válido com esta estrutura:
{
  "trends": [
    { "trend": "descrição da tendência", "category": "categoria", "confidence": "alta|média|baixa", "recommendation": "recomendação acionável" }
  ],
  "top_categories": ["categoria1", "categoria2"],
  "price_insights": "análise de faixas de preço",
  "opportunities": ["oportunidade1", "oportunidade2"],
  "competitor_suggestions": [
    { "name": "nome do concorrente/nicho", "source": "mercado", "content": "o que analisar" }
  ]
}`;

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
        messages: [
          { role: "system", content: "Você é um analista de mercado especialista em e-commerce e marketing de afiliados no Brasil. Responda apenas em JSON válido." },
          { role: "user", content: prompt },
        ],
      }),
    });

    if (!response.ok) {
      const errText = await response.text();
      throw new Error(`OpenRouter error: ${response.status} - ${errText}`);
    }

    const aiResponse = await response.json();
    const rawContent = aiResponse.choices?.[0]?.message?.content || "";

    let parsedAnalysis: any;
    try {
      const jsonMatch = rawContent.match(/\{[\s\S]*\}/);
      parsedAnalysis = jsonMatch ? JSON.parse(jsonMatch[0]) : { trends: [], error: "Parse failed" };
    } catch {
      parsedAnalysis = { trends: [], raw: rawContent };
    }

    // Save competitor suggestions to tracking table
    if (parsedAnalysis.competitor_suggestions?.length) {
      for (const cs of parsedAnalysis.competitor_suggestions) {
        await sb.from("ai_competitor_tracking").insert({
          source: cs.source || "ai_analysis",
          competitor_name: cs.name || "Desconhecido",
          content_analyzed: cs.content || "",
          detected_trends: parsedAnalysis.trends || [],
        });
      }
    }

    return new Response(
      JSON.stringify({ success: true, analysis: parsedAnalysis, model: config.model }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (err: any) {
    console.error("analyze-market-trends error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
