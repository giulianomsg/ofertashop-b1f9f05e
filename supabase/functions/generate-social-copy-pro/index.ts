import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

// ---------- Types ----------
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
  };
}

interface OpenRouterConfig {
  apiKey: string;
  model: string;
}

interface ReelsScene {
  cena: number;
  duracao: string;
  acao_visual: string;
  texto_sobreposto: string;
  audio: string;
}

interface ProContent {
  feed: { legendas: string[] };
  reels: { audio_sugerido: string; cenas: ReelsScene[] };
  stories: { texto_curto: string; enquete: { pergunta: string; opcao1: string; opcao2: string } };
  whatsapp: { mensagem: string; versao_curta: string };
  tiktok_shorts: { roteiro: string };
  prompts_visuais: { feed_background: string; story_background: string };
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
  if (envKey) {
    return { apiKey: envKey, model: "google/gemini-2.0-flash-exp:free" };
  }
  throw new Error("API Key do OpenRouter não configurada. Acesse Administração > IA / Conteúdo para configurar.");
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

    const priceFormatted = product.price
      ? `R$ ${Number(product.price).toFixed(2).replace(".", ",")}`
      : "";
    const originalPriceFormatted = product.original_price
      ? `R$ ${Number(product.original_price).toFixed(2).replace(".", ",")}`
      : "";
    const discount =
      product.original_price && product.price
        ? Math.round(((product.original_price - product.price) / product.original_price) * 100)
        : 0;
    const productLink = product.id ? `https://www.ofertashop.com.br/produto/${product.id}` : (product.affiliate_url || "");

    // Build persona instructions
    const personaBlock = settings.persona
      ? `Persona de público-alvo: "${settings.persona.name}" — ${settings.persona.description || ""}. Tom preferido: ${settings.persona.tone}. Gatilhos preferidos: ${(settings.persona.triggers || []).join(", ")}.`
      : "";
    const toneBlock = settings.tone ? `Tom de voz principal: ${settings.tone}.` : "";
    const triggerBlock = settings.trigger ? `Gatilho de venda prioritário: ${settings.trigger}.` : "";
    const campaignBlock =
      settings.campaignName || settings.campaignType
        ? `Campanha sazonal ativa: ${settings.campaignName || settings.campaignType}. Adapte o conteúdo ao contexto dessa campanha.`
        : "";
    const hashtagInstr = settings.includeHashtags !== false ? "Inclua 5-10 hashtags relevantes no Feed." : "NÃO inclua hashtags.";
    const ctaInstr = settings.includeCTA !== false ? 'Inclua CTAs fortes como "Compre agora 👇", "Corre que acaba!", "Aproveite!".' : "";
    const seoInstr = settings.optimizeSEO ? "Otimize textos para SEO: use palavras-chave naturais do produto nos primeiros 100 caracteres." : "";

    const jsonStructure = `{
  "feed": { "legendas": ["legenda1 com link", "legenda2 com link", "legenda3 com link"] },
  "reels": { "audio_sugerido": "nome da música/áudio trending", "cenas": [{ "cena": 1, "duracao": "0-3s", "acao_visual": "descrição", "texto_sobreposto": "texto", "audio": "narração" }] },
  "stories": { "texto_curto": "texto impactante curto", "enquete": { "pergunta": "pergunta engajadora", "opcao1": "opção 1", "opcao2": "opção 2" } },
  "whatsapp": { "mensagem": "mensagem longa formatada para grupo com emojis e link", "versao_curta": "versão curta para lista de transmissão com link" },
  "tiktok_shorts": { "roteiro": "roteiro completo com hook nos primeiros 3s" },
  "prompts_visuais": { "feed_background": "prompt em inglês para gerar fundo de feed no Midjourney", "story_background": "prompt em inglês para gerar fundo de story no Midjourney" }
}`;

    const systemPrompt = `Voce e um copywriter brasileiro especialista em marketing de afiliados, conversao e redes sociais.
${personaBlock}
${toneBlock}
${triggerBlock}
${campaignBlock}

REGRAS CRITICAS:
1. Responda APENAS em JSON valido, sem markdown, sem blocos de codigo.
2. Siga EXATAMENTE esta estrutura JSON:
${jsonStructure}
3. INCLUA OBRIGATORIAMENTE o link do produto (${productLink}) em TODOS os textos gerados para as plataformas (legendas, roteiros, stories, whatsapp, etc).
4. Garanta que os textos estejam sempre bem formatados e organizados em linhas e paragrafos.
5. IMPORTANTE: Os roteiros NUNCA devem usar, citar ou mostrar pessoas (nada de narração pessoal ou atores). Exiba e foque SOMENTE nos produtos.
6. IMPORTANTE: NAO USE ACENTOS GRAFICOS (nem til, nem agudo, nem circunflexo) OU CEDILHA nas palavras geradas. Isso e por conta de incompatibilidade na geracao de videos. (Ex: escreva "acao", "video", "nao", "voce").
7. ${hashtagInstr}
8. ${ctaInstr}
9. ${seoInstr}
10. O roteiro de Reels/TikTok/Shorts deve ter 4-6 cenas com hook forte de retencao nos primeiros 3 segundos focado em curiosidade (focando so no produto).
11. Os prompts visuais devem ser detalhados em ingles, estilo Midjourney/Stable Diffusion, com aspectos de cor, iluminacao e composicao.`;

    const userPrompt = `Gere conteúdo multicanal completo para este produto de afiliado:

Produto: ${product.title}
${product.store ? `Loja: ${product.store}` : ""}
${priceFormatted ? `Preço atual: ${priceFormatted}` : ""}
${originalPriceFormatted ? `Preço original: ${originalPriceFormatted}` : ""}
${discount > 0 ? `Desconto: ${discount}%` : ""}
${product.description ? `Descrição: ${product.description.substring(0, 500)}` : ""}
${product.rating ? `Avaliação: ${product.rating}/5` : ""}
Link do produto: ${productLink}

Gere o conteúdo completo para: Feed Instagram (3 legendas), Roteiro de Reels (4-6 cenas), Story com enquete, WhatsApp (grupo + lista), TikTok/Shorts e Prompts Visuais.`;

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
        return new Response(JSON.stringify({ error: "Créditos de IA insuficientes no OpenRouter." }), {
          status: 402, headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      const errText = await response.text();
      throw new Error(`OpenRouter error: ${response.status} - ${errText}`);
    }

    const aiResponse = await response.json();
    const rawContent = aiResponse.choices?.[0]?.message?.content || "";

    let parsedContent: ProContent;
    try {
      const jsonMatch = rawContent.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        parsedContent = JSON.parse(jsonMatch[0]);
      } else {
        throw new Error("No JSON found in AI response");
      }
    } catch (_parseErr) {
      console.warn("Failed to parse AI JSON, returning fallback:", _parseErr);
      parsedContent = {
        feed: { legendas: [rawContent] },
        reels: { audio_sugerido: "", cenas: [] },
        stories: { texto_curto: "", enquete: { pergunta: "", opcao1: "", opcao2: "" } },
        whatsapp: { mensagem: rawContent, versao_curta: "" },
        tiktok_shorts: { roteiro: "" },
        prompts_visuais: { feed_background: "", story_background: "" },
      };
    }

    // Save to product ai_content_metadata
    if (product.id) {
      try {
        const { data: existing } = await sb
          .from("products")
          .select("ai_content_metadata")
          .eq("id", product.id)
          .maybeSingle();

        const currentMeta = (existing as any)?.ai_content_metadata || {};
        const history = Array.isArray(currentMeta.history) ? currentMeta.history : [];
        history.unshift({
          content: parsedContent,
          model: config.model,
          settings,
          generated_at: new Date().toISOString(),
        });
        // Keep only last 10 generations
        if (history.length > 10) history.length = 10;

        await sb
          .from("products")
          .update({ ai_content_metadata: { ...currentMeta, latest: parsedContent, history } })
          .eq("id", product.id);
      } catch (e) {
        console.warn("Failed to save ai_content_metadata:", e);
      }
    }

    return new Response(
      JSON.stringify({ success: true, content: parsedContent, model: config.model }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (err: any) {
    console.error("generate-social-copy-pro error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
