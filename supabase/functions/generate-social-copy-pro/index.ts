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
    platform?: string; // e.g. "feed", "reels", "stories", "whatsapp", "tiktok", "design", "all"
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
  prompts_visuais: { 
     image_generation_prompt: string; 
     audio_generation_prompt?: string;
  };
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
    const hashtagInstr = settings.includeHashtags !== false ? "Inclua SEMPRE #ofertashop_promo e a menção @ofertashop_promo nos seus textos. Evite tags genéricas." : "NÃO inclua hashtags.";
    const ctaInstr = settings.includeCTA !== false ? 'Inclua CTAs fortes como "Compre agora 👇", "Corre que acaba!", "Aproveite!".' : "";
    const seoInstr = settings.optimizeSEO ? "Otimize textos para SEO: use palavras-chave naturais do produto nos primeiros 100 caracteres." : "";
    const requestedPlatform = settings.platform || "all";

    let jsonStructure = "";
    let platformTasks = "";

    if (requestedPlatform === "all") {
       jsonStructure = `{
  "feed": { "legendas": ["legenda1 com link", "legenda2 com link", "legenda3 com link"] },
  "reels": { "audio_sugerido": "nome da música/áudio trending", "cenas": [{ "cena": 1, "duracao": "0-3s", "acao_visual": "descrição", "texto_sobreposto": "texto", "audio": "narração" }] },
  "stories": { "texto_curto": "texto impactante curto", "enquete": { "pergunta": "pergunta engajadora", "opcao1": "opção 1", "opcao2": "opção 2" } },
  "whatsapp": { "mensagem": "mensagem longa formatada para grupo com emojis e link", "versao_curta": "versão curta para lista de transmissão com link" },
  "tiktok_shorts": { "roteiro": "roteiro completo com hook nos primeiros 3s" },
  "prompts_visuais": { 
      "image_generation_prompt": "prompt em inglês fotorrealista... --ar 9:16\\\\n\\\\nOverlay: [Nome]\\\\nOverlay: [Preços]\\\\nOverlay: [Outros...]",
      "audio_generation_prompt": "script emotivo para locução do video e chamada pro link na bio"
   }
}`;
       platformTasks = "Feed Instagram (3 legendas), Roteiro de Reels (4-6 cenas), Story com enquete, WhatsApp (grupo + lista), TikTok/Shorts e Prompts Visuais.";
    } else if (requestedPlatform === "feed") {
       jsonStructure = `{ "feed": { "legendas": ["legenda1 com link", "legenda2 com link", "legenda3 com link"] } }`;
       platformTasks = "Feed Instagram (3 legendas).";
    } else if (requestedPlatform === "reels") {
       jsonStructure = `{ "reels": { "audio_sugerido": "nome trending", "cenas": [{ "cena": 1, "duracao": "0-3s", "acao_visual": "descrição", "texto_sobreposto": "texto", "audio": "narração" }] } }`;
       platformTasks = "Roteiro de Reels (4-6 cenas).";
    } else if (requestedPlatform === "stories" || requestedPlatform === "story") {
       jsonStructure = `{ "stories": { "texto_curto": "texto", "enquete": { "pergunta": "...", "opcao1": "...", "opcao2": "..." } } }`;
       platformTasks = "Story com enquete.";
    } else if (requestedPlatform === "whatsapp") {
       jsonStructure = `{ "whatsapp": { "mensagem": "mensagem longa", "versao_curta": "versão curta" } }`;
       platformTasks = "WhatsApp (grupo + lista).";
    } else if (requestedPlatform === "tiktok") {
       jsonStructure = `{ "tiktok_shorts": { "roteiro": "roteiro com hook nos 3s" } }`;
       platformTasks = "Roteiro de TikTok/Shorts.";
    } else if (requestedPlatform === "design") {
       jsonStructure = `{ "prompts_visuais": { "image_generation_prompt": "prompt visual da imagem em inglês... --ar 9:16\\\\n\\\\nOverlay: [Nome]\\\\nOverlay: [Preços]\\\\nOverlay: [Outros...]", "audio_generation_prompt": "roteiro/script para gerador de voz/audio narrando o produto com forte emoção e CTA para link na bio" } }`;
       platformTasks = "Prompts Visuais (Midjourney) com dados de overlay embutidos e Roteiro de Narração de Áudio.";
    }

    const systemRules = [
      "1. Responda APENAS em JSON valido, sem markdown, sem blocos de codigo.",
      `2. Siga EXATAMENTE esta estrutura JSON:\n${jsonStructure}`,
      `3. USO DO LINK DO PRODUTO:\n   - No Whatsapp/Lista de Transmissao: OBRIGATORIO colocar a URL (${productLink}) de forma explicita na mensagem.\n   - Nas Legendas (Instagram, TikTok, etc): NUNCA escreva a URL na legenda, pois la os links nao sao clicaveis! Ao inves disso, faca CTAs de CTA, ex: "Comente QUERO".`,
      "4. FORMATACAO DE PARAGRAFOS: Utilize ativamente a marcacao de quebra de linha e duplo espaco (\\\\n\\\\n) dentro dos textos gerados na sua string JSON.",
      "5. IGNORAR LOJAS TERCEIRAS: IMPORTANTE! NUNCA escreva 'Vendido e entregue por Shopee / Mercado Livre' ou qualquer loja externa. Dê TODA A VISIBILIDADE e créditos exlusivamente para o 'OfertaShop'. O produto pertence e é vendido no OfertaShop.",
      "6. FOCO NO PRODUTO: NUNCA devem usar, citar ou mostrar pessoas (nada de narração pessoal ou atores). Exiba e foque SOMENTE nos produtos.",
      '7. CUIDADO COM ACENTOS NOS VIDEOS: NAO USE ACENTOS GRAFICOS (nem til, nem agudo, nem circunflexo) OU CEDILHA nas palavras geradas. (Ex: escreva "acao", "video", "nao", "voce").'
    ];

    if (requestedPlatform === "all" || requestedPlatform === "feed") systemRules.push("8. " + hashtagInstr);
    if (requestedPlatform === "all" || requestedPlatform !== "design") systemRules.push("9. " + ctaInstr);
    if (requestedPlatform === "all" || requestedPlatform !== "design") systemRules.push("10. " + seoInstr);

    if (requestedPlatform === "all" || requestedPlatform === "reels" || requestedPlatform === "tiktok") {
      systemRules.push("11. ROTEIROS EM PARTES (CENAS): Divida os roteiros de video em multiplas partes ate concluir toda a mensagem. Cada cena/parte deve ter DURACAO MAXIMA DE 8 SEGUNDOS.");
      systemRules.push("12. Os primeiros 3 segundos da primeira cena devem focar em um hook forte de retencao.");
    }

    if (requestedPlatform === "all" || requestedPlatform === "design") {
      systemRules.push('13. ARQUITETURA VISUAL DE DESIGN: O `image_generation_prompt` NÃO DEVE ter link de imagem, mas DEVE instruir a geradora a copiar rigorosamente a imagem que for anexada junto ao prompt. Adicione EXATAMENTE o trecho em inglês no início do prompt: "Use the attached reference image exactly as it is, maintaining physical characteristics, proportions, format, textures, and keeping natural imperfections without any retouch. Visibly integrate the attached OfertaShop logo clearly at the top of the image with a transparent background. Create a visible bounding banner or dark gradient footer at the bottom specifically to highlight the overlay text. Ensure the central product is entirely visible and not covered or obscured by the footer, logo or overlays." Adicione os atributos: "hyper-realistic, 8k resolution, raw style, Camera: Canon R5, 85mm f/1.2 lens, ISO 100, cinematic color grading --ar 4:5". APÓS os atributos de câmera, adicione OBRIGATORIAMENTE o seguinte bloco EXATO de tipografia: "Typography & Layout Rules: Font Style: Use a modern, clean, geometric Sans-Serif font (like Montserrat, Gotham, or Helvetica) for all text. Color: All text must be pure white or black for maximum contrast. Header (Top): in Semi-Bold, medium size, centered below the logo. Pricing (Lower Third): in Regular, small size, price in Extra-Bold, large size for emphasis. Rating (Bottom): followed by five stars (yellow/gold fill). Footer (Banner): in Bold, medium size, centered inside the dark bottom banner." Após esse bloco, quebre duas linhas LITERAIS usando `\\\\n\\\\n` e liste os Overlays em PT-BR. CADA dado em uma linha única. Estrutura EXATA:\\\\nOverlay: [Nome do Produto]\\\\nOverlay: De [Preço Antigo] por apenas [Preço Novo] ([Desconto]% OFF)\\\\nOverlay: [Nota/Vendas] (Instrução: Representar as estrelas do rating na cor amarela e com preenchimento de acordo com a pontuação)\\\\nOverlay: Cupom: [Código, se houver]\\\\nOverlay: 🔒 ofertashop.com.br\\\\nOverlay (Rodapé com fundo delimitador): Link na Bio.');
      systemRules.push('14. PROMPT DE ÁUDIO / NARRAÇÃO: O `audio_generation_prompt` deve OBRIGATORIAMENTE começar com EXATAMENTE esta frase fixa: "Gere um áudio de 30 segundos com o texto abaixo. Use uma voz feminina, com tom profissional e sofisticado, em português do Brasil." seguida de uma linha em branco (`\\\\n\\\\n`), e então o roteiro de locução completo em PT-BR com TODOS OS ACENTOS E CEDILHAS CORRETOS (é, ã, ç, ó, etc). O roteiro deve descrever o produto passando MUITA EMOÇÃO, criar urgência de compra e finalizar com CTA forte ("Clique no link da bio", "Link disponível na bio", etc). IMPORTANTE: NO ROTEIRO DE ÁUDIO, NUNCA use o símbolo % — escreva sempre por extenso "por cento" ou "porcentagem". NUNCA use o símbolo R$ — escreva apenas o valor numérico precedido de "Reais" ou apenas o número. Ex: "de 199 por apenas 99 reais". As quebras de parágrafo usarão literais `\\\\n`.');
      systemRules.push('15. PROIBIÇÃO DE QUEBRA DE LINHA REAL: Como a resposta deve ser um JSON estrito, você NUNCA deve dar um ENTER/Quebra de linha real no meio dos valores. Use SEMPRE os caracteres literais `\\\\n` para simular quebras.');
    }

    const systemPrompt = `Voce e um copywriter brasileiro especialista em marketing de afiliados, conversao e redes sociais.
${personaBlock}
${toneBlock}
${triggerBlock}
${campaignBlock}

REGRAS CRITICAS:
${systemRules.join("\n")}`;

    const userPrompt = `Gere conteúdo multicanal completo para este produto de afiliado:

Produto: ${product.title}
${priceFormatted ? `Preço atual: ${priceFormatted}` : ""}
${originalPriceFormatted ? `Preço original: ${originalPriceFormatted}` : ""}
${discount > 0 ? `Desconto: ${discount}%` : ""}
${product.description ? `Descrição: ${product.description.substring(0, 500)}` : ""}
${product.rating ? `Avaliação: ${product.rating}/5` : ""}
Link do produto: ${productLink}

Gere o conteúdo completo para: ${platformTasks}`;

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

        // Recursively clean all string values:
        // 1. Convert literal \\n sequences to real newlines
        // 2. Remove stray lone backslashes that the AI sometimes leaves at line ends
        const cleanStrings = (obj: unknown): unknown => {
          if (typeof obj === "string") {
            return obj
              .replace(/\\n/g, "\n")       // literal \n  →  real newline
              .replace(/\\(?!\n)/g, "");   // lone \ not before newline → removed
          }
          if (Array.isArray(obj)) return obj.map(cleanStrings);
          if (obj && typeof obj === "object") {
            return Object.fromEntries(
              Object.entries(obj).map(([k, v]) => [k, cleanStrings(v)])
            );
          }
          return obj;
        };

        parsedContent = cleanStrings(parsedContent) as ProContent;
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
        prompts_visuais: { 
            image_generation_prompt: ""
        },
      } as any;
    }

    let mergedLatest: Partial<ProContent> = {};
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
        mergedLatest = { ...(currentMeta.latest || {}), ...parsedContent };
        
        history.unshift({
          content: parsedContent, // só do que salvou
          model: config.model,
          settings,
          generated_at: new Date().toISOString(),
        });
        // Keep only last 10 generations
        if (history.length > 10) history.length = 10;

        await sb
          .from("products")
          .update({ ai_content_metadata: { ...currentMeta, latest: mergedLatest, history } })
          .eq("id", product.id);
      } catch (e) {
        console.warn("Failed to save ai_content_metadata:", e);
      }
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        content: mergedLatest, 
        model: config.model,
        promptSent: {
          system: systemPrompt,
          user: userPrompt
        }
      }),
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
