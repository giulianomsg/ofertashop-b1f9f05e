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
      "1. Responda APENAS em JSON valido, sem usar markdown (```json) envelopando a resposta.",
      `2. Siga EXATAMENTE esta estrutura JSON:\n${jsonStructure}`,
      "3. A REGRA DA CURADORIA TÉCNICA: Posicione-se como um curador rigoroso. Se o produto for tech, embase o custo-benefício tecnicamente na copy.",
      "4. AUTOMAÇÃO MANYCHAT (INSTA/TIKTOK): NUNCA coloque a URL ou mande para 'link na bio'. A CTA DEVE induzir atrito positivo (ex: 'Comente *EU QUERO* que te mando no direct').",
      "5. USO DO LINK DIRETO: APENAS no WhatsApp insira a URL de compra explicitamente.",
      "6. GESTÃO DE PROVA SOCIAL: Referencie validações de forma orgânica ('Mais de X já receberam e marcaram nos Destaques').",
      "7. ENRIQUECIMENTO VISUAL OBRIGATÓRIO (WHATSAPP): O texto DEVE ser altamente escaneável usando a sintaxe nativa do WhatsApp: Use `*negrito*` para destacar benefícios e novos preços; Use `~tachado~` EXCLUSIVAMENTE para a ancoragem de preço antigo (ex: De ~R$ 199~ por *R$ 99*); Use `_itálico_` para ganchos emocionais ou escassez; Use ``` `monoespaçado` ``` para destacar CUPONS; Use citações `> ` para depoimentos. Estruture listas obrigatoriamente com Emojis temáticos ou hifens `- `.",
      "8. ENRIQUECIMENTO VISUAL OBRIGATÓRIO (FEED INSTAGRAM): Como o Instagram não aceita formatação nativa (bold/italic), você DEVE criar hierarquia visual usando CAIXA ALTA (Caps Lock) nos ganchos de abertura e CTAs. Intercale com Emojis elegantes (🔥, 🚨, ✅, 🛒) e garanta respiro visual utilizando dupla quebra de linha literal (`\\\\n\\\\n`) entre os parágrafos.",
      "9. ENRIQUECIMENTO VISUAL OBRIGATÓRIO (ROTEIROS DE VÍDEO): Nos roteiros do TikTok/Reels, utilize sintaxe Markdown Rica para orientar o locutor: use `**negrito**` nas palavras que exigem ênfase vocal, `> blockquotes` para descrever ações visuais de tela e gravação, e listas ordenadas para os frames do vídeo.",
      "10. FOCO EXCLUSIVO: Não mencione plataformas terceiras de marketplaces. O produto pertence e é chancelado pelo 'OfertaShop'."
    ];

    if (requestedPlatform === "design") {
      systemRules.push('11. ARQUITETURA VISUAL DE DESIGN: O `image_generation_prompt` NÃO DEVE ter link de imagem, mas DEVE instruir a geradora a copiar rigorosamente a imagem que for anexada junto ao prompt. Adicione EXATAMENTE o trecho em inglês no início do prompt: "Use the attached reference image exactly as it is, maintaining physical characteristics, proportions, format, textures, and keeping natural imperfections without any retouch. Visibly integrate the attached OfertaShop logo clearly at the top of the image with a transparent background. Create a visible bounding banner or dark gradient footer at the bottom specifically to highlight the overlay text. Ensure the central product is entirely visible and not covered or obscured by the footer, logo or overlays." Adicione os atributos: "hyper-realistic, 8k resolution, raw style, Camera: Canon R5, 85mm f/1.2 lens, ISO 100, cinematic color grading --ar 9:16". APÓS os atributos de câmera, adicione OBRIGATORIAMENTE o seguinte bloco EXATO de tipografia: "Typography & Layout Rules: Font Style: Use a modern, clean, geometric Sans-Serif font (like Montserrat, Gotham, or Helvetica) for all text. Color: All text must be pure white or black for maximum contrast. Header (Top): in Semi-Bold, medium size, centered below the logo. Old price in Regular font, small size and strikethrough; promotional price in Extra-Bold font, large size to emphasize.. Rating (Bottom): followed by five stars (yellow/gold fill). Footer (Banner): in Bold, medium size, centered inside the dark bottom banner." Após esse bloco, quebre duas linhas LITERAIS usando `\\\\n\\\\n` e liste os Overlays em PT-BR. CADA dado em uma linha única. Estrutura EXATA:\\\\nOverlay: [Nome do Produto]\\\\nOverlay: De [Preço Antigo] por apenas [Preço Novo] ([Desconto]% OFF)\\\\nOverlay: [Nota/Vendas] (Instrução: Representar as estrelas do rating na cor amarela e com preenchimento de acordo com a pontuação)\\\\nOverlay: Cupom: [Código, se houver]\\\\nOverlay: 🔒 ofertashop.com.br\\\\nOverlay (Rodapé com fundo delimitador): Link na Bio.');
      systemRules.push('12. PROMPT DE ÁUDIO / NARRAÇÃO: O `audio_generation_prompt` deve OBRIGATORIAMENTE começar com EXATAMENTE esta frase fixa: "Gere um áudio de 30 segundos com o texto abaixo. Use uma voz feminina, com tom profissional e sofisticado, em português do Brasil." seguida de uma linha em branco (`\\\\n\\\\n`), e então o roteiro de locução completo em PT-BR com TODOS OS ACENTOS E CEDILHAS CORRETOS (é, ã, ç, ó, etc). O roteiro deve descrever o produto passando MUITA EMOÇÃO, criar urgência de compra e finalizar com CTA forte ("Clique no link da bio", "Link disponível na bio", etc). IMPORTANTE: NO ROTEIRO DE ÁUDIO, NUNCA use o símbolo % — escreva sempre por extenso "por cento" ou "porcentagem". NUNCA use o símbolo R$ — escreva apenas o valor numérico precedido de "Reais" ou apenas o número. Ex: "de 199 por apenas 99 reais". As quebras de parágrafo usarão literais `\\\\n`.');
      systemRules.push('13. PROIBIÇÃO DE QUEBRA DE LINHA REAL: Como a resposta deve ser um JSON estrito, você NUNCA deve dar um ENTER/Quebra de linha real no meio dos valores. Use SEMPRE os caracteres literais `\\\\n` para simular quebras.');
    }

    const systemPrompt = `Você é um estrategista de conteúdo sênior focado em arquitetura da informação e conversão.\n${personaBlock}\n${toneBlock}\n${triggerBlock}\n\nREGRAS CRÍTICAS:\n${systemRules.join("\n")}`;

    const userPrompt = `Produto: ${product.title}\nPreço atual: ${priceFormatted}\nPreço original: ${originalPriceFormatted}\nDesconto: ${discount}%\nDescrição: ${(product.description || "").substring(0, 500)}\nLink: ${productLink}\n\nGere o conteúdo altamente escaneável para: ${platformTasks}`;

    const response = await fetch("[https://openrouter.ai/api/v1/chat/completions](https://openrouter.ai/api/v1/chat/completions)", {
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