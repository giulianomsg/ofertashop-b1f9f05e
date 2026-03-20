// Supabase Edge Function — Sincronização de Cupons/Ofertas da Shopee
// Versão Bare-Metal: Proteção contra injeção de charset e espaços

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Utilitário de Autenticação Shopee (GraphQL) ──────────────────────────

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

// ─── CORS e Headers ────────────────────────────────────────────────────────

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// Query estática em linha única (sem variáveis dinâmicas) para evitar escaping
const PAYLOAD_STR = `{"query":"query{shopeeOfferV2(page:1,limit:50){nodes{offerName offerLink originalLink offerType commissionRate imageUrl categoryId collectionId periodStartTime periodEndTime}pageInfo{page limit hasNextPage}}}"}`;

// Transformamos a string em bytes puros para o fetch não injetar charset
const PAYLOAD_BYTES = new TextEncoder().encode(PAYLOAD_STR);

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

// ─── Fetch Principal ───────────────────────────────────────────────────────

async function fetchAllOffers(): Promise<ShopeeOffer[]> {
  const appId = Deno.env.get("SHOPEE_APP_ID")?.trim();
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET")?.trim();
  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL")?.trim() || "https://open-api.affiliate.shopee.com.br";

  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID ou SHOPEE_APP_SECRET em falta.");

  const timestamp = Math.floor(Date.now() / 1000);
  const baseString = `${appId}${timestamp}${PAYLOAD_STR}`;
  const sign = await hmacSha256(appSecret, baseString);

  const url = `${shopeeHost}/graphql`;

  // Headers sem espaços extras
  const headers = {
    "Authorization": `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
    "Content-Type": "application/json",
  };

  console.log(`[shopee] Requesting URL: ${url}`);
  const res = await fetch(url, { method: "POST", headers, body: PAYLOAD_BYTES });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Shopee API returned ${res.status}: ${text}`);
  }

  const json = await res.json();

  if (json.errors && json.errors.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors[0]?.message || JSON.stringify(json.errors)}`);
  }

  return json.data?.shopeeOfferV2?.nodes || [];
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
    return new Response(JSON.stringify({ error: "Internal server error", detail: String(err) }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});