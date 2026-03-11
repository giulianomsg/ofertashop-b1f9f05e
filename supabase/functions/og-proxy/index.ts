import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version',
};

const BOT_REGEX = /bot|facebookexternalhit|whatsapp|twitterbot|linkedinbot|pinterest|slackbot|telegrambot|discordbot|googlebot|bingbot|yandex|crawler|spider|preview/i;
const SITE_URL = "https://ofertashop.lovable.app";

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const url = new URL(req.url);
    const productId = url.searchParams.get('productId');
    const userAgent = req.headers.get('user-agent') || '';
    const isBot = BOT_REGEX.test(userAgent);

    if (!productId) {
      return new Response('Missing productId parameter', { status: 400, headers: corsHeaders });
    }

    const productUrl = `${SITE_URL}/produto/${productId}`;

    // Real users get redirected to the actual page
    if (!isBot) {
      return new Response(null, {
        status: 302,
        headers: { ...corsHeaders, 'Location': productUrl },
      });
    }

    // Bots get the HTML with OG tags
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || '';
    const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') || '';
    const supabase = createClient(supabaseUrl, supabaseKey);

    const { data: product, error } = await supabase
      .from('products')
      .select('*')
      .eq('id', productId)
      .single();

    if (error || !product) {
      return new Response(null, {
        status: 302,
        headers: { ...corsHeaders, 'Location': SITE_URL },
      });
    }

    const title = `${product.title} | OfertaShop`;
    let plainDescription = "Confira esta oferta incrível no OfertaShop!";
    if (product.description) {
      const stripped = product.description.replace(/<[^>]+>/g, '').trim();
      if (stripped.length > 0) {
        plainDescription = stripped.substring(0, 160);
      }
    }

    const defaultImage = "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1200&auto=format&fit=crop";
    const ogImage = product.image_url || (product.gallery_urls && product.gallery_urls.length > 0 ? product.gallery_urls[0] : defaultImage);

    // Escape HTML entities to prevent XSS
    const esc = (s: string) => s.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

    const html = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${esc(title)}</title>
    <meta name="description" content="${esc(plainDescription)}" />
    <meta property="og:type" content="product" />
    <meta property="og:title" content="${esc(product.title)}" />
    <meta property="og:description" content="${esc(plainDescription)}" />
    <meta property="og:image" content="${esc(ogImage)}" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
    <meta property="og:url" content="${esc(productUrl)}" />
    <meta property="og:site_name" content="OfertaShop" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="${esc(product.title)}" />
    <meta name="twitter:description" content="${esc(plainDescription)}" />
    <meta name="twitter:image" content="${esc(ogImage)}" />
    <link rel="canonical" href="${esc(productUrl)}" />
</head>
<body>
    <p>Redirecionando para <a href="${esc(productUrl)}">${esc(product.title)}</a>...</p>
    <script>window.location.href="${productUrl.replace(/"/g, '\\"')}";</script>
</body>
</html>`;

    return new Response(html, {
      status: 200,
      headers: {
        ...corsHeaders,
        'Content-Type': 'text/html; charset=utf-8',
        'Cache-Control': 'public, max-age=3600',
      },
    });

  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
