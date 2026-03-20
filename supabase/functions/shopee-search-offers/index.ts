// Edge Function: shopee-search-offers (standalone)
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hash);
}

async function shopeeGraphQL<T = any>(query: string, variables: Record<string, any> = {}): Promise<T> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");
  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");

  const payloadStr = JSON.stringify({ query, variables });
  const timestamp = Math.floor(Date.now() / 1000);
  const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
  const sign = await sha256Hex(factor);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://open-api.affiliate.shopee.com.br";
  const url = `${shopeeHost}/graphql`;
  const payloadBytes = new TextEncoder().encode(payloadStr);

  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
      "Content-Type": "application/json",
    },
    body: payloadBytes,
  });

  const json = await res.json();
  if (json.errors && json.errors.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors.map((e: any) => e.message).join(", ")}`);
  }
  return json.data as T;
}

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

    return new Response(JSON.stringify({ offers: enrichedOffers, pageInfo }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("shopee-search-offers error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
