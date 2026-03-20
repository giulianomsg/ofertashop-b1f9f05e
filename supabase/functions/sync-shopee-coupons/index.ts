// Supabase Edge Function — Sincronização de Cupons/Ofertas da Shopee
// Versão Final: SHA-256 Digest (Affiliate API) com Paginação Dinâmica

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Utilitário de Autenticação Shopee (GraphQL) ──────────────────────────

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// Shopee Affiliate usa um digest SHA-256 simples, não HMAC
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

// ─── Tipos e Helpers ───────────────────────────────────────────────────────

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

function formatDate(isoOrTimestamp: string): string {
  try {
    const d = new Date(isNaN(Number(isoOrTimestamp)) ? isoOrTimestamp : Number(isoOrTimestamp) * 1000);
    return d.toLocaleDateString("pt-BR", { day: "2-digit", month: "2-digit", year: "numeric" });
  } catch {
    return isoOrTimestamp;
  }
}

function mapOfferToCoupon(offer: ShopeeOffer, platformId: string, syncTime: string) {
  const code = offer.collectionId
    ? `shopee-offer-${offer.collectionId}`
    : `shopee-offer-${offer.offerName.replace(/\s+/g, "-").toLowerCase().slice(0, 40)}`;

  const discountValue = offer.commissionRate ? `${offer.commissionRate}% comissão` : null;
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

// ─── Fetch Principal (Com Paginação) ───────────────────────────────────────

async function fetchAllOffers(): Promise<ShopeeOffer[]> {
  const appId = Deno.env.get("SHOPEE_APP_ID")?.trim();
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET")?.trim();
  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL")?.trim() || "https://open-api.affiliate.shopee.com.br";

  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID ou SHOPEE_APP_SECRET em falta.");

  const allOffers: ShopeeOffer[] = [];
  let page = 1;
  const limit = 50;

  // Query com suporte a variáveis do GraphQL (em uma linha para evitar problemas de parsing)
  const queryStr = `query ShopeeOfferList($page: Int!, $limit: Int!) { shopeeOfferV2(page: $page, limit: $limit) { nodes { offerName offerLink originalLink offerType commissionRate imageUrl categoryId collectionId periodStartTime periodEndTime } pageInfo { page limit hasNextPage } } }`;

  while (true) {
    const timestamp = Math.floor(Date.now() / 1000);

    // Constrói o payload de forma dinâmica e segura para cada página
    const payloadStr = JSON.stringify({
      query: queryStr,
      variables: { page, limit }
    });
    const payloadBytes = new TextEncoder().encode(payloadStr);

    // Regra estrita da API Affiliate: appId + timestamp + payload + appSecret
    const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
    const sign = await sha256Hex(factor);

    const url = `${shopeeHost}/graphql`;

    console.log(`[shopee] Requesting page ${page} (limit: ${limit})...`);

    const res = await fetch(url, {
      method: "POST",
      headers: {
        "Authorization": `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
        "Content-Type": "application/json",
      },
      body: payloadBytes,
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`Shopee API returned ${res.status}: ${text}`);
    }

    const json = await res.json();

    if (json.errors && json.errors.length > 0) {
      const errMsg = json.errors[0]?.message || JSON.stringify(json.errors);
      throw new Error(`Shopee GraphQL error: ${errMsg}`);
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
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, { auth: { persistSession: false } });

    const { data: platform } = await supabase.from("platforms").select("id").ilike("name", "%shopee%").single();
    if (!platform) throw new Error('Plataforma "Shopee" não encontrada.');

    const platformId = platform.id;
    const syncStartTime = new Date().toISOString();

    const offers = await fetchAllOffers();

    if (offers.length > 0) {
      const rows = offers.map((o) => mapOfferToCoupon(o, platformId, syncStartTime));
      await supabase.from("coupons").upsert(rows, { onConflict: "platform_id,code" });
      await supabase.from("coupons").update({ active: false }).eq("platform_id", platformId).eq("active", true).lt("updated_at", syncStartTime);
    }

    return new Response(JSON.stringify({ success: true, fetched: offers.length }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (err) {
    console.error("[sync] Execution error:", err);
    return new Response(JSON.stringify({ error: "Internal server error", detail: String(err) }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});