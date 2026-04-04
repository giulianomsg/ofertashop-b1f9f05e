import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

interface Persona {
  name: string;
  tone: string;
  triggers: string[];
  description?: string;
}

interface GenerateRequest {
  product: {
    id?: string;
    title: string;
    price?: number;
    original_price?: number;
    store?: string;
    description?: string;
    rating?: number;
    affiliate_url?: string;
    video_url?: string;
    image_url?: string;
  };
  settings: {
    persona?: Persona | null;
    tone?: string;
    trigger?: string;
    campaignName?: string;
    campaignType?: string;
    includeHashtags?: boolean;
    includeCTA?: boolean;
    optimizeSEO?: boolean;
    platform?: string;
  };
}

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
      const sanitizedKey = data.value.apiKey.toString().replace(/^['"]|['"]$/g, "").trim();
      return { apiKey: sanitizedKey, model: data.value.model };
    }
  } catch (e) {
    console.warn("Falha ao buscar config OpenRouter:", e);
  }
  const envKey = Deno.env.get("OPENROUTER_API_KEY");
  if (envKey) {
    const sanitizedEnvKey = envKey.toString().replace(/^['"]|['"]$/g, "").trim();
    return { apiKey: sanitizedEnvKey, model: "google/gemini-2.0-flash-exp:free" };
  }
  throw new Error("API Key do OpenRouter não configurada.");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const body: GenerateRequest = await req.json();
    const { product, settings } = body;

    if (!product?.title) {
      return new Response(JSON.stringify({ error: "Produto com título é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const sb = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const config = await getOpenRouterConfig(sb);

    const priceFormatted = product.price ? `R$ ${Number(product.price).toFixed(2).replace(".", ",")}` : "";
    const originalPriceFormatted = product.original_price ? `R$ ${Number(product.original_price).toFixed(2).replace(".", ",")}` : "";
    const discount = product.original_price && product.price
      ? Math.round(((product.original_price - product.price) / product.original_price) * 100)
      : 0;
    const productLink = product.id ? `https://www.ofertashop.com.br/produto/${product.id}` : (product.affiliate_url || "");

    const personaBlock = settings.persona ? `Persona: "${settings.persona.name}" — ${settings.persona.description || ""}.` : "";
    const toneBlock = settings.tone ? `Tom de voz: ${settings.tone}.` : "";
    const triggerBlock = settings.trigger ? `Gatilho mental: ${settings.trigger}.` : "";

    const requestedPlatform = settings.platform || "feed";

    let jsonStructure = "";
    let platformTasks = "";

    if (requestedPlatform === "feed") {
      jsonStructure = `{ "feed": { "legendas": ["legenda 1", "legenda 2"] } }`;
      platformTasks = "Feed Instagram (2 opções de legenda).";
    } else if (requestedPlatform === "whatsapp") {
      jsonStructure = `{ "whatsapp": { "mensagem": "mensagem para grupo", "versao_curta": "versão curta lista de transmissão" } }`;
      platformTasks = "WhatsApp (grupo + lista).";
    } else if (requestedPlatform === "tiktok") {
      jsonStructure = `{ "tiktok_shorts": { "roteiro": "Gancho (0-3s): ... \\n\\nCorpo: ... \\n\\nCTA: ..." } }`;
      platformTasks = "Roteiro de vídeo curto (TikTok/Reels/Shorts).";
    } else if (requestedPlatform === "design") {
      jsonStructure = `{ "prompts_visuais": { "image_generation_prompt": "prompt visual da imagem em inglês... --ar 9:16\\\\n\\\\nOverlay: [Nome]\\\\nOverlay: [Preços]", "audio_generation_prompt": "roteiro para locução de áudio" } }`;
      platformTasks = "Prompts Visuais e Roteiro de Narração de Áudio.";
    }

    const systemRules = [
      "1. Responda APENAS em JSON valido, sem markdown.",
      `2. Siga EXATAMENTE esta estrutura JSON:\n${jsonStructure}`,
      "3. A REGRA DA CURADORIA TÉCNICA: Posicione-se como um curador confiável. Se o produto for de tecnologia (placas de vídeo, processadores, hardware, etc), adicione um breve comentário técnico atestando a qualidade e explicando por que a peça tem um ótimo custo-benefício para o setup do usuário.",
      "4. AUTOMAÇÃO MANYCHAT: No Feed Instagram e TikTok/Reels, NUNCA coloque a URL ou 'link na bio'. Use a estratégia Manychat: a Call to Action DEVE incentivar o usuário a comentar uma palavra (ex: 'Comente EU QUERO que o robô te manda no direct agora').",
      "5. USO DO LINK DIRETO: APENAS no formato WhatsApp, insira a URL de compra explicitamente.",
      "6. GESTÃO DE PROVA SOCIAL: Nas mensagens de Feed ou WhatsApp, sempre que fizer sentido, adicione gatilhos como 'Veja nos destaques quem já comprou e recebeu' para validar a confiabilidade do OfertaShop.",
      "7. FOCO EXCLUSIVO: Não mencione plataformas terceiras. Toda credibilidade pertence ao 'OfertaShop'."
    ];

    if (requestedPlatform === "tiktok") {
      systemRules.push("8. A ENGENHARIA DO VÍDEO CURTO: Divida o roteiro rigorosamente nestas 3 etapas: A) Gancho (3 segundos iniciais): Interrompa o padrão focando em uma dor ou num preço histórico surreal. B) Corpo (A Prova): Instrua mostrar a tela, o site oficial e o desconto aplicado. C) CTA (Escassez + Manychat): Finalize induzindo o comentário para disparar automação.");
    }

    const systemPrompt = `Você é um estrategista de conteúdo focado em conversão e growth.\n${personaBlock}\n${toneBlock}\n${triggerBlock}\n\nREGRAS CRÍTICAS:\n${systemRules.join("\n")}`;

    const userPrompt = `Produto: ${product.title}\nPreço atual: ${priceFormatted}\nPreço original: ${originalPriceFormatted}\nDesconto: ${discount}%\nDescrição: ${(product.description || "").substring(0, 500)}\nLink: ${productLink}\n\nGere o conteúdo focado em: ${platformTasks}`;

    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${config.apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: config.model,
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
      }),
    });

    if (!response.ok) throw new Error(`OpenRouter error: ${response.status}`);

    const aiResponse = await response.json();
    const rawContent = aiResponse.choices?.[0]?.message?.content || "";

    let parsedContent;
    try {
      const jsonMatch = rawContent.match(/\{[\s\S]*\}/);
      parsedContent = JSON.parse(jsonMatch ? jsonMatch[0] : "{}");

      const cleanStrings = (obj: any): any => {
        if (typeof obj === "string") return obj.replace(/\\n/g, "\n").replace(/\\(?!\n)/g, "");
        if (Array.isArray(obj)) return obj.map(cleanStrings);
        if (obj && typeof obj === "object") return Object.fromEntries(Object.entries(obj).map(([k, v]) => [k, cleanStrings(v)]));
        return obj;
      };
      parsedContent = cleanStrings(parsedContent);
    } catch (e) {
      throw new Error("Falha ao ler JSON da IA.");
    }

    let mergedLatest: any = {};
    if (product.id) {
      try {
        const { data: existing } = await sb.from("products").select("ai_content_metadata").eq("id", product.id).maybeSingle();
        const currentMeta = existing?.ai_content_metadata || {};
        mergedLatest = { ...(currentMeta.latest || {}), ...parsedContent };
        const history = Array.isArray(currentMeta.history) ? currentMeta.history : [];

        history.unshift({ content: parsedContent, model: config.model, settings, generated_at: new Date().toISOString() });
        if (history.length > 10) history.length = 10;

        await sb.from("products").update({ ai_content_metadata: { ...currentMeta, latest: mergedLatest, history } }).eq("id", product.id);
      } catch (e) { console.warn("Failed to save meta:", e); }
    }

    return new Response(JSON.stringify({ success: true, content: mergedLatest, model: config.model }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});