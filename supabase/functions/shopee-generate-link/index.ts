// Edge Function: shopee-generate-link
// Gera short links de afiliado para URLs de produtos da Shopee
import { shopeeGraphQL } from "../_shared/shopee-auth.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { originUrl } = await req.json();

    if (!originUrl) {
      return new Response(JSON.stringify({ error: "originUrl é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const query = `
      query {
        generateShortLink(
          originUrl: "${originUrl.replace(/"/g, '\\"')}"
          subId: "ofertashop"
        ) {
          shortLink
        }
      }
    `;

    const data = await shopeeGraphQL(query);
    const shortLink = data?.generateShortLink?.shortLink;

    if (!shortLink) {
      throw new Error("Shopee não retornou um short link");
    }

    return new Response(
      JSON.stringify({ shortLink }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    console.error("shopee-generate-link error:", err);
    return new Response(
      JSON.stringify({ error: err.message || "Erro interno" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
