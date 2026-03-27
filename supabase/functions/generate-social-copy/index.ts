// Edge Function: generate-social-copy (standalone)
// Uses Lovable AI Gateway to generate social media copy for affiliate products
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { product } = await req.json();
    if (!product || !product.title) {
      return new Response(JSON.stringify({ error: "Produto com título é obrigatório" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const LOVABLE_API_KEY = Deno.env.get("LOVABLE_API_KEY");
    if (!LOVABLE_API_KEY) throw new Error("LOVABLE_API_KEY não configurada");

    const priceFormatted = product.price ? `R$ ${Number(product.price).toFixed(2).replace('.', ',')}` : "";
    const originalPriceFormatted = product.original_price ? `R$ ${Number(product.original_price).toFixed(2).replace('.', ',')}` : "";
    const discount = product.original_price && product.price 
      ? Math.round(((product.original_price - product.price) / product.original_price) * 100) 
      : 0;

    const systemPrompt = `Você é um copywriter brasileiro especialista em marketing de afiliados e conversão. 
Seu objetivo é criar conteúdo persuasivo, com gatilhos mentais de urgência e escassez, que gere cliques e vendas.
Responda APENAS em formato JSON válido, sem markdown, sem blocos de código. O JSON deve ter exatamente estas chaves:
{
  "instagram_captions": ["legenda1", "legenda2", "legenda3"],
  "whatsapp_message": "mensagem",
  "reels_hook": "hook"
}`;

    const userPrompt = `Gere conteúdo de redes sociais para este produto de afiliado:

Produto: ${product.title}
${product.store ? `Loja: ${product.store}` : ""}
${priceFormatted ? `Preço atual: ${priceFormatted}` : ""}
${originalPriceFormatted ? `Preço original: ${originalPriceFormatted}` : ""}
${discount > 0 ? `Desconto: ${discount}%` : ""}
${product.description ? `Descrição: ${product.description.substring(0, 300)}` : ""}
${product.rating ? `Avaliação: ${product.rating}/5` : ""}

REGRAS OBRIGATÓRIAS:
1. 3 variações de legendas para Instagram (com emojis relevantes e 5-8 hashtags cada, incluindo #oferta #desconto e hashtags do nicho)
2. 1 mensagem curta e persuasiva para WhatsApp (com emojis, no máximo 3 linhas, direta ao ponto)
3. 1 hook curto para Reels/Stories (máximo 10 palavras, impactante, com emoji)

Use gatilhos: urgência ("por tempo limitado"), escassez ("últimas unidades"), prova social ("mais vendido"), autoridade ("recomendado").
Inclua CTAs como "Link na bio 🔗", "Corre que acaba rápido!", "Aproveite agora!".`;

    const response = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${LOVABLE_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "google/gemini-3-flash-preview",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
      }),
    });

    if (!response.ok) {
      if (response.status === 429) {
        return new Response(JSON.stringify({ error: "Rate limit excedido. Tente novamente em instantes." }), {
          status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      if (response.status === 402) {
        return new Response(JSON.stringify({ error: "Créditos de IA insuficientes." }), {
          status: 402, headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      const errText = await response.text();
      throw new Error(`AI Gateway error: ${response.status} - ${errText}`);
    }

    const aiResponse = await response.json();
    const rawContent = aiResponse.choices?.[0]?.message?.content || "";

    // Parse JSON from AI response
    let parsedContent;
    try {
      // Try to extract JSON from the response (may contain markdown fences)
      const jsonMatch = rawContent.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        parsedContent = JSON.parse(jsonMatch[0]);
      } else {
        throw new Error("No JSON found in response");
      }
    } catch (parseErr) {
      console.warn("Failed to parse AI JSON, returning raw:", parseErr);
      parsedContent = {
        instagram_captions: [rawContent],
        whatsapp_message: rawContent,
        reels_hook: "",
      };
    }

    return new Response(JSON.stringify({ success: true, content: parsedContent }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("generate-social-copy error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
