// supabase/functions/sync-shopee-offers/index.ts
// Supabase Edge Function — Sincronização de Ofertas da Shopee → tabela products
//
// Utiliza a API Oficial da Shopee Affiliates (shopeeOfferV2 — GraphQL)
// SHA-256 Digest para autenticação.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Utilitário de Autenticação Shopee (SHA-256 Digest) ────────────────────

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hashBuffer);
}

// ─── CORS ──────────────────────────────────────────────────────────────────

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// ─── Tipos ─────────────────────────────────────────────────────────────────

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

// ─── Mapeamento Oferta → Product ───────────────────────────────────────────

function mapOfferToProduct(offer: ShopeeOffer, syncTime: string) {
  const externalId = offer.collectionId
    ? `shopee-${offer.collectionId}`
    : `shopee-${offer.offerName.replace(/\s+/g, "-").toLowerCase().slice(0, 50)}`;

  return {
    external_id: externalId,
    title: offer.offerName || "Oferta Shopee",
    image_url: offer.imageUrl || null,
    affiliate_url: offer.offerLink || offer.originalLink || "https://shopee.com.br",
    store: "Shopee",
    category: offer.offerType || "Ofertas",
    description: offer.commissionRate
      ? `Comissão: ${offer.commissionRate}%. ${offer.offerType || "Oferta Shopee"}.`
      : `${offer.offerType || "Oferta Shopee"}.`,
    price: 0,
    is_active: true,
    updated_at: syncTime,
  };
}

// ─── Fetch paginado ────────────────────────────────────────────────────────

async function fetchAllOffers(): Promise<ShopeeOffer[]> {
  const appId = Deno.env.get("SHOPEE_APP_ID")?.trim();
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET")?.trim();
  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL")?.trim() || "https://open-api.affiliate.shopee.com.br";

  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID ou SHOPEE_APP_SECRET em falta.");

  const allOffers: ShopeeOffer[] = [];
  let page = 1;
  const limit = 50;

  const queryStr = `query ShopeeOfferList($page: Int!, $limit: Int!) { shopeeOfferV2(page: $page, limit: $limit) { nodes { offerName offerLink originalLink offerType commissionRate imageUrl categoryId collectionId periodStartTime periodEndTime } pageInfo { page limit hasNextPage } } }`;

  while (true) {
    const timestamp = Math.floor(Date.now() / 1000);
    const payloadStr = JSON.stringify({ query: queryStr, variables: { page, limit } });
    const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
    const sign = await sha256Hex(factor);

    console.log(`[offers] Fetching page ${page}...`);

    const res = await fetch(`${shopeeHost}/graphql`, {
      method: "POST",
      headers: {
        "Authorization": `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
        "Content-Type": "application/json",
      },
      body: new TextEncoder().encode(payloadStr),
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`Shopee API ${res.status}: ${text}`);
    }

    const json = await res.json();
    if (json.errors?.length > 0) {
      throw new Error(`Shopee GraphQL: ${json.errors[0]?.message || JSON.stringify(json.errors)}`);
    }

    const data = json.data?.shopeeOfferV2;
    if (!data) break;

    const nodes: ShopeeOffer[] = data.nodes || [];
    allOffers.push(...nodes);

    if (!data.pageInfo?.hasNextPage || nodes.length === 0) break;
    page++;
  }

  return allOffers;
}

// ─── Handler ───────────────────────────────────────────────────────────────

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
      { auth: { persistSession: false } },
    );

    const syncStartTime = new Date().toISOString();

    // ── Buscar ofertas ──
    const offers = await fetchAllOffers();
    console.log(`[offers] Total: ${offers.length}`);

    let upsertedCount = 0;
    let deactivatedCount = 0;

    if (offers.length > 0) {
      const rows = offers.map((o) => mapOfferToProduct(o, syncStartTime));

      // UPSERT na tabela products usando external_id como conflict target
      const { error: upsertErr } = await supabase
        .from("products")
        .upsert(rows, { onConflict: "external_id", ignoreDuplicates: false });

      if (upsertErr) {
        console.error("[offers] Upsert error:", upsertErr);
        return new Response(
          JSON.stringify({ error: "Upsert failed", detail: upsertErr.message }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        );
      }

      upsertedCount = rows.length;

      // Desativar ofertas antigas que não vieram neste lote
      const { error: deactivateErr, count } = await supabase
        .from("products")
        .update({ is_active: false })
        .like("external_id", "shopee-%")
        .eq("is_active", true)
        .lt("updated_at", syncStartTime);

      if (deactivateErr) {
        console.error("[offers] Deactivation error:", deactivateErr);
      }
      deactivatedCount = count ?? 0;
    }

    const result = {
      success: true,
      syncStartTime,
      source: "shopee_affiliate_api",
      fetched: offers.length,
      upserted: upsertedCount,
      deactivated: deactivatedCount,
    };

    console.log("[offers] Complete:", JSON.stringify(result));
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[offers] Error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error", detail: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
