// Edge Function: shopee-import-product
// Importa uma oferta da Shopee como produto no catálogo
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
    const { offer, categoryId, platformId, userId } = await req.json();

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

    // Calculate prices
    const priceMin = Number(offer.priceMin) || 0;
    const priceMax = Number(offer.priceMax) || priceMin;
    const price = priceMin > 0 ? priceMin / 100000 : 0; // Shopee returns price in micro units
    const originalPrice = priceMax > priceMin ? priceMax / 100000 : null;

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
        category: categoryId || "geral",
        platform_id: resolvedPlatformId,
        is_active: true,
        rating: Number(offer.ratingStar) || 0,
        registered_by: userId || null,
        badge: offer.commission ? `${Number(offer.commissionRate || 0).toFixed(1)}% comissão` : null,
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

    if (mappingErr) {
      console.error("Mapping insert error:", mappingErr);
    }

    // Log sync
    await sb.from("shopee_sync_logs").insert({
      sync_type: "import",
      status: "success",
      items_processed: 1,
      items_updated: 1,
      triggered_by: userId || null,
      completed_at: new Date().toISOString(),
    });

    return new Response(
      JSON.stringify({ success: true, product }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    console.error("shopee-import-product error:", err);
    return new Response(
      JSON.stringify({ error: err.message || "Erro interno" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
