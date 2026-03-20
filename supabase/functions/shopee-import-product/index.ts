// Edge Function: shopee-import-product (standalone)
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
    const { offer, categoryId, platformId, userId } = await req.json();
    const categoryName = offer?.categoryName || null;

    if (!offer || !offer.itemId) {
      return new Response(JSON.stringify({ error: "offer com itemId é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Check if already imported
    const { data: existing } = await sb
      .from("shopee_product_mappings")
      .select("id, product_id")
      .eq("shopee_item_id", String(offer.itemId))
      .maybeSingle();

    if (existing) {
      return new Response(
        JSON.stringify({ error: "Produto já importado", product_id: existing.product_id }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Generate short link
    let shortLink = offer.shopeeShortLink || offer.offerLink || offer.productLink;
    try {
      if (offer.productLink || offer.offerLink) {
        const linkQuery = `
          query {
            generateShortLink(
              originUrl: "${(offer.offerLink || offer.productLink).replace(/"/g, '\\"')}"
              subId: "ofertashop"
            ) {
              shortLink
            }
          }
        `;
        const linkData = await shopeeGraphQL(linkQuery);
        if (linkData?.generateShortLink?.shortLink) {
          shortLink = linkData.generateShortLink.shortLink;
        }
      }
    } catch (e) {
      console.warn("Failed to generate short link, using original:", e);
    }

    // Get or find Shopee platform
    let resolvedPlatformId = platformId;
    if (!resolvedPlatformId) {
      const { data: shopeePlatform } = await sb
        .from("platforms")
        .select("id")
        .ilike("name", "%shopee%")
        .maybeSingle();
      resolvedPlatformId = shopeePlatform?.id || null;
    }

    // Resolve category_id: use provided or auto-create from categoryName
    let resolvedCategoryId = categoryId || null;
    if (!resolvedCategoryId && categoryName) {
      // Try to find existing category
      const { data: existingCat } = await sb
        .from("categories")
        .select("id")
        .ilike("name", categoryName)
        .maybeSingle();

      if (existingCat) {
        resolvedCategoryId = existingCat.id;
      } else {
        // Auto-create category
        const slug = categoryName.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
        const { data: newCat } = await sb
          .from("categories")
          .insert({ name: categoryName, slug })
          .select("id")
          .single();
        if (newCat) resolvedCategoryId = newCat.id;
      }
    }

    // Calculate prices - try 'price' field first, then priceMin/priceMax
    const rawPrice = Number(offer.price) || Number(offer.priceMin) || 0;
    const rawMax = Number(offer.priceMax) || rawPrice;
    // Detect micro-units (>100000) vs normal values
    const price = rawPrice > 100000 ? rawPrice / 100000 : rawPrice;
    const maxPrice = rawMax > 100000 ? rawMax / 100000 : rawMax;
    const originalPrice = maxPrice > price ? maxPrice : null;

    // Insert product
    const { data: product, error: productErr } = await sb
      .from("products")
      .insert({
        title: offer.productName || "Produto Shopee",
        price: price > 0 ? price : 0.01,
        original_price: originalPrice,
        store: offer.shopName || "Shopee",
        affiliate_url: shortLink || offer.productLink || "",
        image_url: offer.imageUrl || null,
        category: "geral",
        platform_id: resolvedPlatformId,
        is_active: true,
        rating: Number(offer.ratingStar) || 0,
        registered_by: userId || null,
        sales_count: Number(offer.sales) || 0,
        badge: (() => {
          const rate = Number(offer.commissionRate) || 0;
          const pct = rate < 1 && rate > 0 ? rate * 100 : rate;
          return pct > 0 ? `${pct.toFixed(1)}% comissão` : null;
        })(),
      })
      .select()
      .single();

    if (productErr) throw productErr;

    // Create mapping
    const { error: mappingErr } = await sb
      .from("shopee_product_mappings")
      .insert({
        product_id: product.id,
        shopee_item_id: String(offer.itemId),
        shopee_shop_id: String(offer.shopId || ""),
        shopee_offer_id: String(offer.offerId || ""),
        shopee_commission_rate: Number(offer.commissionRate) || null,
        shopee_image_url: offer.imageUrl || null,
        shopee_product_url: offer.productLink || null,
        shopee_short_link: shortLink || null,
        sync_status: "active",
      });

    if (mappingErr) console.error("Mapping insert error:", mappingErr);

    // Log sync
    await sb.from("shopee_sync_logs").insert({
      sync_type: "import",
      status: "success",
      items_processed: 1,
      items_updated: 1,
      triggered_by: userId || null,
      completed_at: new Date().toISOString(),
    });

    return new Response(JSON.stringify({ success: true, product }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("shopee-import-product error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
