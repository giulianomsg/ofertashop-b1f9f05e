// Edge Function: shopee-search-offers
// Busca ofertas na Shopee Affiliate API por keyword
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
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
    const { keyword, page = 1, limit = 20, sortType = 2 } = await req.json();

    if (!keyword || typeof keyword !== "string") {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // GraphQL query para buscar ofertas por keyword
    const query = `
      query {
        productOfferV2(
          listType: 0
          sortType: ${sortType}
          page: ${page}
          limit: ${limit}
          keyword: "${keyword.replace(/"/g, '\\"')}"
        ) {
          nodes {
            itemId
            shopId
            productName
            priceMin
            priceMax
            imageUrl
            productLink
            commission
            commissionRate
            sales
            ratingStar
            shopName
            offerLink
            periodStartTime
            periodEndTime
            shopeeShortLink
          }
          pageInfo {
            page
            limit
            hasNextPage
            scrollId
          }
        }
      }
    `;

    const data = await shopeeGraphQL(query);
    const offers = data?.productOfferV2?.nodes || [];
    const pageInfo = data?.productOfferV2?.pageInfo || {};

    // Check which items are already imported
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    const itemIds = offers.map((o: any) => String(o.itemId));
    const { data: existingMappings } = await sb
      .from("shopee_product_mappings")
      .select("shopee_item_id, product_id")
      .in("shopee_item_id", itemIds);

    const importedSet = new Set((existingMappings || []).map((m: any) => m.shopee_item_id));

    const enrichedOffers = offers.map((o: any) => ({
      ...o,
      already_imported: importedSet.has(String(o.itemId)),
    }));

    return new Response(
      JSON.stringify({ offers: enrichedOffers, pageInfo }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    console.error("shopee-search-offers error:", err);
    return new Response(
      JSON.stringify({ error: err.message || "Erro interno" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
