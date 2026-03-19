// supabase/functions/sync-shopee-coupons/index.ts
// Supabase Edge Function — Sincronização de Cupons/Ofertas da Shopee
//
// Utiliza a API Oficial da Shopee Affiliates (shopeeOfferV2 — GraphQL)
// para buscar ofertas disponíveis e fazer UPSERT na tabela `coupons`.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Shopee Auth (inlined from _shared/shopee-auth.ts) ─────────────────────

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

async function hmacSha256(secret: string, message: string): Promise<string> {
  const encoder = new TextEncoder();
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    encoder.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign("HMAC", cryptoKey, encoder.encode(message));
  return bufferToHex(signature);
}

async function generateShopeeAuth(params: { apiPath: string }) {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");
  if (!appId || !appSecret) {
    throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");
  }
  const { apiPath } = params;
  const timestamp = Math.floor(Date.now() / 1000);
  const baseString = `${appId}${apiPath}${timestamp}`;
  const sign = await hmacSha256(appSecret, baseString);
  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://affiliate.shopee.com.br";
  const separator = apiPath.includes("?") ? "&" : "?";
  const url = `${shopeeHost}${apiPath}${separator}partner_id=${appId}&timestamp=${timestamp}&sign=${sign}`;
  const headers = {
    Authorization: sign,
    "Content-Type": "application/json",
    timestamp: String(timestamp),
    partner_id: appId,
  };
  return { url, headers, timestamp, sign };
}

// ─── CORS ──────────────────────────────────────────────────────────────────

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// ─── GraphQL Query ─────────────────────────────────────────────────────────

const SHOPEE_OFFERS_QUERY = `
  query ShopeeOfferList($page: Int!, $limit: Int!) {
    shopeeOfferV2(page: $page, limit: $limit) {
      nodes {
        offerName
        offerLink
        originalLink
        offerType
        commissionRate
        imageUrl
        categoryId
        collectionId
        periodStartTime
        periodEndTime
      }
      pageInfo {
        page
        limit
        hasNextPage
      }
    }
  }
`;

// ─── Types ─────────────────────────────────────────────────────────────────

interface ShopeeOffer {
  offerName: string;
  offerLink: string;
  originalLink: string;
  offerType: string;
  commissionRate: number;
  imageUrl: string;
  categoryId: string;
  collectionId: string;
  periodStartTime: string;
  periodEndTime: string;
}

interface CouponRow {
  platform_id: string;
  code: string;
  title: string;
  description: string;
  discount_value: string | null;
  discount_amount: string | null;
  subtitle: string | null;
  conditions: string | null;
  link_url: string;
  is_link_only: boolean;
  active: boolean;
  updated_at: string;
}

// ─── Helpers ───────────────────────────────────────────────────────────────

function formatDate(isoOrTimestamp: string): string {
  try {
    const d = new Date(
      isNaN(Number(isoOrTimestamp))
        ? isoOrTimestamp
        : Number(isoOrTimestamp) * 1000,
    );
    return d.toLocaleDateString("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    });
  } catch {
    return isoOrTimestamp;
  }
}

function mapOfferToCoupon(
  offer: ShopeeOffer,
  platformId: string,
  syncTime: string,
): CouponRow {
  const code = offer.collectionId
    ? `shopee-offer-${offer.collectionId}`
    : `shopee-offer-${offer.offerName.replace(/\s+/g, "-").toLowerCase().slice(0, 40)}`;

  const discountValue = offer.commissionRate
    ? `${offer.commissionRate}% comissão`
    : null;

  let conditions: string | null = null;
  if (offer.periodStartTime && offer.periodEndTime) {
    conditions = `Válido de ${formatDate(offer.periodStartTime)} até ${formatDate(offer.periodEndTime)}`;
  }

  return {
    platform_id: platformId,
    code,
    title: offer.offerName || "Oferta Shopee",
    description: `Oferta ${offer.offerType || "Shopee"}: ${offer.offerName || ""}`.trim(),
    discount_value: discountValue,
    discount_amount: null,
    subtitle: offer.offerType || null,
    conditions,
    link_url: offer.offerLink || offer.originalLink || "https://shopee.com.br",
    is_link_only: true,
    active: true,
    updated_at: syncTime,
  };
}

// ─── Fetch all offers (paginated) ──────────────────────────────────────────

async function fetchAllOffers(): Promise<ShopeeOffer[]> {
  const allOffers: ShopeeOffer[] = [];
  let page = 1;
  const limit = 50;
  const apiPath = "/graphql";

  while (true) {
    const { url, headers } = await generateShopeeAuth({ apiPath });

    const body = JSON.stringify({
      query: SHOPEE_OFFERS_QUERY,
      variables: { page, limit },
    });

    console.log(`[shopee] Fetching page ${page} (limit ${limit})...`);
    const res = await fetch(url, {
      method: "POST",
      headers: {
        ...headers,
        "Content-Type": "application/json",
      },
      body,
    });

    if (!res.ok) {
      const text = await res.text();
      console.error(`[shopee] API error ${res.status}: ${text}`);
      throw new Error(`Shopee API returned ${res.status}: ${text}`);
    }

    const json = await res.json();

    if (json.errors && json.errors.length > 0) {
      console.error("[shopee] GraphQL errors:", JSON.stringify(json.errors));
      throw new Error(
        `Shopee GraphQL error: ${json.errors[0]?.message || "unknown"}`,
      );
    }

    const data = json.data?.shopeeOfferV2;
    if (!data) {
      console.warn("[shopee] No shopeeOfferV2 in response");
      break;
    }

    const nodes: ShopeeOffer[] = data.nodes || [];
    console.log(`[shopee] Page ${page}: ${nodes.length} offer(s)`);
    allOffers.push(...nodes);

    if (!data.pageInfo?.hasNextPage || nodes.length === 0) break;
    page++;
  }

  return allOffers;
}

// ─── Main Handler ──────────────────────────────────────────────────────────

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey, {
      auth: { persistSession: false },
    });

    // ── Identificar platform_id da Shopee ──
    const { data: platform, error: platformErr } = await supabase
      .from("platforms")
      .select("id")
      .ilike("name", "%shopee%")
      .single();

    if (platformErr || !platform) {
      return new Response(
        JSON.stringify({
          error: 'Plataforma "Shopee" não encontrada na tabela platforms.',
          detail: platformErr?.message,
        }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    const platformId = platform.id;
    const syncStartTime = new Date().toISOString();
    console.log(`[sync] Start: ${syncStartTime}, Platform: ${platformId}`);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // BUSCAR OFERTAS via API Oficial da Shopee
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const offers = await fetchAllOffers();
    console.log(`[sync] Total offers fetched: ${offers.length}`);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // UPSERT — cria novos ou atualiza existentes
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    let upsertedCount = 0;

    if (offers.length > 0) {
      const rows = offers.map((o) =>
        mapOfferToCoupon(o, platformId, syncStartTime),
      );

      const { error: upsertErr } = await supabase
        .from("coupons")
        .upsert(rows, {
          onConflict: "platform_id,code",
          ignoreDuplicates: false,
        });

      if (upsertErr) {
        console.error("[sync] Upsert error:", upsertErr);
        return new Response(
          JSON.stringify({
            error: "Upsert failed",
            detail: upsertErr.message,
          }),
          {
            status: 500,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          },
        );
      }

      upsertedCount = rows.length;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // DESATIVAR cupons que NÃO vieram neste lote
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    let deactivatedCount = 0;

    if (offers.length > 0) {
      const { error: deactivateErr, count } = await supabase
        .from("coupons")
        .update({ active: false })
        .eq("platform_id", platformId)
        .eq("active", true)
        .lt("updated_at", syncStartTime);

      if (deactivateErr) {
        console.error("[sync] Deactivation error:", deactivateErr);
      }
      deactivatedCount = count ?? 0;
    }

    const result = {
      success: true,
      syncStartTime,
      platformId,
      source: "shopee_affiliate_api",
      fetched: offers.length,
      upserted: upsertedCount,
      deactivated: deactivatedCount,
    };

    console.log("[sync] Complete:", JSON.stringify(result));
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[sync] Unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error", detail: String(err) }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
});
