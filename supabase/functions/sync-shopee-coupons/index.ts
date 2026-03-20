// Supabase Edge Function — Sincronização de Cupons/Ofertas da Shopee
// Proteção estrita contra Error 10020 (Invalid Signature)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Utilitário de Autenticação Shopee (GraphQL) Embutido ──────────────

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

async function generateShopeeAuth(payload: string) {
  // O .trim() é vital aqui para erradicar caracteres invisíveis de copy-paste (\r ou \n)
  const appId = Deno.env.get("SHOPEE_APP_ID")?.trim();
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET")?.trim();
  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL")?.trim() || "https://open-api.affiliate.shopee.com.br";

  if (!appId || !appSecret) {
    throw new Error("As variáveis de ambiente SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");
  }

  const timestamp = Math.floor(Date.now() / 1000);

  // Base string estrita: appId + timestamp + payload bruto
  const baseString = `${appId}${timestamp}${payload}`;
  const sign = await hmacSha256(appSecret, baseString);

  const url = `${shopeeHost}/graphql`;

  const headers = {
    "Authorization": `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
    "Content-Type": "application/json; charset=utf-8",
  };

  return { url, headers };
}

// ─── CORS e GraphQL Query ──────────────────────────────────────────────────

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// A Query foi intencionalmente convertida para uma linha única sem espaços extras 
// para evitar divergências de escape JSON (\n) que causam falhas de hash (Error 10020)
const SHOPEE_OFFERS_QUERY = `query ShopeeOfferList($page: Int!, $limit: Int!) { shopeeOfferV2(page: $page, limit: $limit) { nodes { offerName offerLink originalLink offerType commissionRate imageUrl categoryId collectionId periodStartTime periodEndTime } pageInfo { page limit hasNextPage } } }`;

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
  const allOffers: ShopeeOffer[] = [];
  let page = 1;
  const limit = 50; // Limite padrão seguro para a Shopee

  while (true) {
    // 1. Cria o payload JSON de forma estrita
    const body = JSON.stringify({
      query: SHOPEE_OFFERS_QUERY,
      variables: { page, limit },
    });

    // 2. Assina o exato mesmo texto que será enviado na rede
    const { url, headers } = await generateShopeeAuth(body);

    console.log(`[shopee] Fetching page ${page}...`);
    const res = await fetch(url, { method: "POST", headers, body });

    if (!res.ok) {
      const text = await res.text();
      console.error(`[shopee] API HTTP error ${res.status}: ${text}`);
      throw new Error(`Shopee API returned ${res.status}: ${text}`);
    }

    const json = await res.json();

    if (json.errors && json.errors.length > 0) {
      console.error("[shopee] GraphQL errors:", JSON.stringify(json.errors));
      throw new Error(`Shopee GraphQL error: ${json.errors[0]?.message || "unknown"}`);
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
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey, { auth: { persistSession: false } });

    const { data: platform, error: platformErr } = await supabase
      .from("platforms")
      .select("id")
      .ilike("name", "%shopee%")
      .single();

    if (platformErr || !platform) {
      return new Response(JSON.stringify({ error: 'Plataforma "Shopee" não encontrada.' }), { status: 404, headers: corsHeaders });
    }

    const platformId = platform.id;
    const syncStartTime = new Date().toISOString();

    const offers = await fetchAllOffers();
    let upsertedCount = 0;
    let deactivatedCount = 0;

    if (offers.length > 0) {
      const rows = offers.map((o) => mapOfferToCoupon(o, platformId, syncStartTime));
      const { error: upsertErr } = await supabase.from("coupons").upsert(rows, { onConflict: "platform_id,code" });

      if (upsertErr) throw upsertErr;
      upsertedCount = rows.length;

      const { count } = await supabase
        .from("coupons")
        .update({ active: false })
        .eq("platform_id", platformId)
        .eq("active", true)
        .lt("updated_at", syncStartTime);

      deactivatedCount = count ?? 0;
    }

    return new Response(JSON.stringify({ success: true, fetched: offers.length, upserted: upsertedCount, deactivated: deactivatedCount }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: "Internal server error", detail: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});