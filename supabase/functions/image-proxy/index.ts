import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

async function uploadToStorage(imageData: ArrayBuffer, contentType: string): Promise<string> {
  const ext = contentType.split("/")[1]?.split(";")[0]?.split("+")[0] || "jpg";
  const fileName = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  const { error: uploadError } = await supabase.storage
    .from("product-images")
    .upload(fileName, imageData, { contentType });

  if (uploadError) {
    console.error("Upload error:", uploadError);
    throw new Error("Erro ao fazer upload da imagem");
  }

  const { data: urlData } = supabase.storage
    .from("product-images")
    .getPublicUrl(fileName);

  return urlData.publicUrl;
}

async function fetchImageFromUrl(url: string): Promise<{ data: ArrayBuffer; contentType: string }> {
  const response = await fetch(url, {
    headers: { "User-Agent": "Mozilla/5.0 (compatible; OfertaShop/1.0)" },
    redirect: "follow",
  });

  if (!response.ok) {
    throw new Error(`Falha ao baixar imagem: ${response.status}`);
  }

  const contentType = response.headers.get("content-type") || "image/jpeg";
  const data = await response.arrayBuffer();
  return { data, contentType };
}

async function extractOgImage(url: string): Promise<string | null> {
  try {
    // 1. First attempt: use a free metatags extractor API (simulates full browser exactly like WhatsApp/iMessage)
    const mlResponse = await fetch(`https://api.microlink.io?url=${encodeURIComponent(url)}`);
    if (mlResponse.ok) {
      const mlData = await mlResponse.json();
      if (mlData?.data?.image?.url) {
        return mlData.data.image.url;
      }
    }
  } catch (e) {
    console.error("Microlink error:", e);
  }

  try {
    // 2. Fallback attempt: Manual fetch using Facebook/WhatsApp bot user agent
    // Many CDNs like Cloudflare whitelist the facebookexternalhit user-agent used by WhatsApp to generate link previews.
    const response = await fetch(url, {
      headers: {
        "User-Agent": "facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7"
      },
      redirect: "follow",
    });

    if (!response.ok) return null;

    const html = await response.text();

    const ogMatch = html.match(/<meta[^>]*property=["']og:image["'][^>]*content=["']([^"']+)["']/i)
      || html.match(/<meta[^>]*content=["']([^"']+)["'][^>]*property=["']og:image["']/i);

    if (ogMatch?.[1]) return ogMatch[1].replace(/&amp;/g, '&');

    const twMatch = html.match(/<meta[^>]*name=["']twitter:image["'][^>]*content=["']([^"']+)["']/i)
      || html.match(/<meta[^>]*content=["']([^"']+)["'][^>]*name=["']twitter:image["']/i);

    if (twMatch?.[1]) return twMatch[1].replace(/&amp;/g, '&');

    return null;
  } catch (e) {
    console.error("Manual OG extraction error:", e);
    return null;
  }
}

function isImageUrl(url: string): boolean {
  return /\.(jpg|jpeg|png|gif|webp|bmp|svg|avif)(\?.*)?$/i.test(url);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { imageUrl } = await req.json();

    if (!imageUrl || typeof imageUrl !== "string") {
      return new Response(JSON.stringify({ error: "URL inválida" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    let finalImageUrl = imageUrl;

    // If not a direct image URL, extract OG image from the page (like WhatsApp does)
    if (!isImageUrl(imageUrl)) {
      const ogImage = await extractOgImage(imageUrl);
      if (ogImage) {
        finalImageUrl = ogImage;
      } else {
        return new Response(JSON.stringify({ error: "Não foi possível encontrar uma imagem neste link. Tente colar o link direto da imagem." }), {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
    }

    const { data, contentType } = await fetchImageFromUrl(finalImageUrl);
    const publicUrl = await uploadToStorage(data, contentType);

    return new Response(JSON.stringify({ publicUrl }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("Proxy error:", error);
    return new Response(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
