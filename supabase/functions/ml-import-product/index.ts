// Edge Function: ml-import-product (standalone)
// Imports a product from Mercado Livre into the local database
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { z } from "https://deno.land/x/zod@v3.22.4/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Zod Schemas
const ItemSchema = z.object({
  id: z.string().min(1),
  title: z.string().min(1),
  price: z.number().nonnegative(),
  original_price: z.number().nullable().optional(),
  thumbnail: z.string().url().or(z.string().length(0)),
  permalink: z.string().url().or(z.string().length(0)),
  condition: z.string().optional(),
  sold_quantity: z.number().optional(),
  available_quantity: z.number().optional(),
  seller: z.object({
    id: z.any().optional(),
    nickname: z.string().optional()
  }).optional(),
  category_id: z.string().optional(),
  shipping_free: z.boolean().optional(),
}).passthrough();

const RequestSchema = z.object({
  item: ItemSchema,
  categoryId: z.string().uuid().optional(),
  platformId: z.string().uuid().optional(),
  userId: z.string().uuid().optional(),
});

async function getValidToken(sb: any, appId: string, clientSecret: string): Promise<string> {
  const { data: token } = await sb
    .from("ml_tokens")
    .select("*")
    .order("updated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!token) throw new Error("Nenhum token ML encontrado.");

  const expiresAt = new Date(token.expires_at).getTime();
  if (Date.now() < expiresAt - 5 * 60 * 1000) return token.access_token;

  const res = await fetch("https://api.mercadolibre.com/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "refresh_token",
      client_id: appId,
      client_secret: clientSecret,
      refresh_token: token.refresh_token,
    }),
  });
  const data = await res.json();
  if (!res.ok || !data.access_token) throw new Error("Falha ao renovar token ML");

  await sb.from("ml_tokens").update({
    access_token: data.access_token,
    refresh_token: data.refresh_token,
    expires_at: new Date(Date.now() + data.expires_in * 1000).toISOString(),
    updated_at: new Date().toISOString(),
  }).eq("id", token.id);

  return data.access_token;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    
    // Validate request using Zod
    const validationResult = RequestSchema.safeParse(body);
    if (!validationResult.success) {
      return new Response(JSON.stringify({ error: "Dados inválidos", details: validationResult.error.format() }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { item, categoryId, platformId, userId } = validationResult.data;

    const ML_APP_ID = Deno.env.get("ML_APP_ID");
    const ML_CLIENT_SECRET = Deno.env.get("ML_CLIENT_SECRET");
    if (!ML_APP_ID || !ML_CLIENT_SECRET) throw new Error("ML_APP_ID e ML_CLIENT_SECRET não configurados.");

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Initial check (non-locked) to return 409 quickly if already 100% exists
    const { data: existingMap } = await sb
      .from("ml_product_mappings")
      .select("id, product_id")
      .eq("ml_item_id", item.id)
      .maybeSingle();

    if (existingMap) {
      return new Response(
        JSON.stringify({ error: "Produto já importado", product_id: existingMap.product_id }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const accessToken = await getValidToken(sb, ML_APP_ID, ML_CLIENT_SECRET);

    // Fetch full item details from ML
    const detailRes = await fetch(`https://api.mercadolibre.com/items/${item.id}`, {
      headers: { Authorization: `Bearer ${accessToken}` },
    });
    const detail = detailRes.ok ? await detailRes.json() : {};

    // Fetch description via ML API
    let description = "";
    try {
      const descRes = await fetch(`https://api.mercadolibre.com/items/${item.id}/description`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (descRes.ok) {
        const descData = await descRes.json();
        description = descData.plain_text || descData.text || "";
      }
    } catch (_) { /* ignore */ }

    // Platform
    let resolvedPlatformId = platformId;
    if (!resolvedPlatformId) {
      const { data: mlPlatform } = await sb.from("platforms").select("id").ilike("name", "%mercado%livre%").maybeSingle();
      if (mlPlatform) {
        resolvedPlatformId = mlPlatform.id;
      } else {
        const { data: newPlat } = await sb.from("platforms").insert({ name: "Mercado Livre" }).select("id").single();
        if (newPlat) resolvedPlatformId = newPlat.id;
      }
    }

    // Category
    let resolvedCategoryId = categoryId || null;
    if (!resolvedCategoryId && (detail.category_id || item.category_id)) {
      try {
        const cid = detail.category_id || item.category_id;
        const catRes = await fetch(`https://api.mercadolibre.com/categories/${cid}`);
        if (catRes.ok) {
          const catData = await catRes.json();
          const catName = catData.name || "";
          if (catName) {
            const { data: existingCat } = await sb.from("categories").select("id").ilike("name", catName).maybeSingle();
            if (existingCat) {
              resolvedCategoryId = existingCat.id;
            } else {
              const slug = catName.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
              const { data: newCat } = await sb.from("categories").insert({ name: catName, slug }).select("id").single();
              if (newCat) resolvedCategoryId = newCat.id;
            }
          }
        }
      } catch (_) { /* ignore */ }
    }

    const imageUrl = detail.pictures?.[0]?.secure_url || detail.thumbnail?.replace("http://", "https://") || item.thumbnail;
    const galleryUrls = (detail.pictures || []).slice(1, 6).map((p: any) => p.secure_url || p.url);
    const price = detail.price || item.price || 0;
    const originalPrice = detail.original_price || item.original_price || null;

    const features = (detail.attributes || []).map((attr: any) => ({
      name: attr.name,
      value: attr.value_name
    })).filter((f: any) => f.value);

    // Upsert transaction-ish behavior via select + insert if not exists
    // (A real PostgREST UPSERT needs a unique constraint on some column other than ID, 
    // we use a generic insertion since we already checked ml_product_mappings)
    const { data: product, error: productErr } = await sb
      .from("products")
      .insert({
        title: detail.title || item.title || "Produto Mercado Livre",
        price: price > 0 ? price : 0.01,
        original_price: originalPrice && originalPrice > price ? originalPrice : null,
        store: detail.seller?.nickname || item.seller?.nickname || detail.seller_address?.city?.name || "Mercado Livre",
        affiliate_url: detail.permalink || item.permalink || "",
        image_url: imageUrl || "",
        gallery_urls: galleryUrls.length > 0 ? galleryUrls : null,
        description: description || item.description || null,
        category_id: resolvedCategoryId,
        platform_id: resolvedPlatformId,
        is_active: detail.status === "active" || true, // fallback if detailed api fails
        rating: detail.reviews?.rating_average || item.rating || 0,
        registered_by: userId || null,
        sales_count: detail.sold_quantity || item.sold_quantity || 0,
        available_quantity: detail.available_quantity || item.available_quantity || null,
        features: features.length > 0 ? features : null,
        badge: (detail.condition || item.condition) === "new" ? "Novo" : (detail.condition || item.condition) === "used" ? "Usado" : null,
      })
      .select()
      .single();

    if (productErr) throw productErr;

    // Insert Mapping (unique constraint on ml_item_id)
    const { error: mappingErr } = await sb
      .from("ml_product_mappings")
      .upsert({
        product_id: product.id,
        ml_item_id: item.id,
        ml_permalink: detail.permalink || item.permalink,
        ml_category_id: detail.category_id || item.category_id,
        ml_seller_id: String(detail.seller_id || item.seller?.id || ""),
        ml_condition: detail.condition || item.condition,
        ml_sold_quantity: detail.sold_quantity || item.sold_quantity || 0,
        ml_available_quantity: detail.available_quantity || item.available_quantity,
        ml_status: detail.status || "active",
        ml_original_price: originalPrice,
        ml_current_price: price,
        ml_thumbnail: imageUrl,
        sync_status: "active",
      }, { onConflict: 'ml_item_id' }); // Use Upsert to prevent race conditions

    if (mappingErr) {
      // rollback if mapping fails (though theoretically mappings table should have unique ml_item_id)
      console.warn("Error inserting mapping:", mappingErr.message);
    }

    await sb.from("ml_sync_logs").insert({
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
    console.error("ml-import-product error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
