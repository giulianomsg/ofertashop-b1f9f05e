import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

// Set CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const url = new URL(req.url);
    const productId = url.searchParams.get('productId');
    const targetUrl = url.searchParams.get('url') || '';

    if (!productId) {
      return new Response('Missing productId parameter', { status: 400, headers: corsHeaders });
    }

    // Initialize Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || '';
    const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') || '';
    const supabase = createClient(supabaseUrl, supabaseKey);

    // Query the product
    const { data: product, error } = await supabase
      .from('products')
      .select('*')
      .eq('id', productId)
      .single();

    if (error || !product) {
      return new Response('Product not found', { status: 404, headers: corsHeaders });
    }

    // Process variables
    const title = `${product.title} | OfertaShop`;
    
    // Safely strip HTML tags for description
    let plainDescription = "Confira esta oferta incrível no OfertaShop!";
    if (product.description) {
      // Remove HTML tags using regex
      const stripped = product.description.replace(/<[^>]+>/g, '').trim();
      if (stripped.length > 0) {
        plainDescription = stripped.substring(0, 160);
      }
    }

    const defaultImage = "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1200&auto=format&fit=crop";
    const ogImage = product.image_url || (product.gallery_urls && product.gallery_urls.length > 0 ? product.gallery_urls[0] : defaultImage);
    const ogUrl = targetUrl || `https://ofertashop.lovable.app/produto/${productId}`;

    // Fetch the original index.html
    // If targetUrl is provided, we fetch from there origin. Otherwise we use a generic placeholder or relative url.
    let htmlContent = '';
    
    // In many SPA hostings, if we know the domain, we just fetch it. 
    // Usually the Rewrite rule passes the domain in `url` param or we can use the origin.
    // We will attempt to fetch the static HTML.
    let indexFetchUrl = targetUrl;
    
    // If we don't know the exact URL or if fetching fails, fallback to a base HTML
    try {
      if (indexFetchUrl) {
        // Fetch original HTML to inject metas
        const originResponse = await fetch(indexFetchUrl);
        if (originResponse.ok) {
          htmlContent = await originResponse.text();
        }
      }
    } catch (e) {
      console.error("Failed to fetch origin HTML", e);
    }

    // If we couldn't fetch the real HTML, provide a fallback valid skeleton.
    if (!htmlContent) {
      htmlContent = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>OfertaShop</title>
</head>
<body>
    <div id="root">A carregar OfertaShop...</div>
</body>
</html>`;
    }

    // Inject our OM/Meta tags into the <head>
    // We inject them just before the closing </head> or right after <head>
    const metaTags = `
    <title>${title}</title>
    <meta name="description" content="${plainDescription}" />
    <meta property="og:type" content="product" />
    <meta property="og:title" content="${product.title}" />
    <meta property="og:description" content="${plainDescription}" />
    <meta property="og:image" content="${ogImage}" />
    <meta property="og:url" content="${ogUrl}" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="${product.title}" />
    <meta name="twitter:description" content="${plainDescription}" />
    <meta name="twitter:image" content="${ogImage}" />
    <meta name="twitter:url" content="${ogUrl}" />
    `;

    // Replace the existing title block or just append to head.
    // If htmlContent has <title>, we can remove it or just append our tags at the end of <head>.
    // Given React Helmet will overwrite it anyway on the client, appending to <head> is easiest.
    let updatedHtml = htmlContent;
    
    // Attempt to remove existing og tags to avoid duplicates (very basic removal, React Helmet handles runtime)
    updatedHtml = updatedHtml.replace(/<title>(.*?)<\/title>/g, '');
    updatedHtml = updatedHtml.replace(/<meta property="og:(.*?)"(.*?)>/g, '');
    updatedHtml = updatedHtml.replace(/<meta name="twitter:(.*?)"(.*?)>/g, '');
    updatedHtml = updatedHtml.replace(/<meta name="description"(.*?)/g, '');

    // Inject new tags before </head>
    if (updatedHtml.includes('</head>')) {
      updatedHtml = updatedHtml.replace('</head>', `${metaTags}\n</head>`);
    } else {
      updatedHtml = `${metaTags}\n${updatedHtml}`;
    }

    return new Response(updatedHtml, {
      headers: {
        ...corsHeaders,
        'Content-Type': 'text/html; charset=utf-8',
      },
    });

  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json"
      }
    });
  }
});
