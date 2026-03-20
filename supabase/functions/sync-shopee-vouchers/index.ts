// supabase/functions/sync-shopee-vouchers/index.ts
// Supabase Edge Function — Sincronização de Vouchers/Cupons da Shopee → tabela coupons
//
// Utiliza a API Oficial da Shopee Affiliates (shopeeOfferV2 — GraphQL)
// filtrando ofertas do tipo voucher/cupom.
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

// Palavras-chave para identificar ofertas que são vouchers/cupons
const VOUCHER_KEYWORDS = [
  "voucher", "cupom", "cupão", "código", "codigo", "promo",
  "desconto", "off", "frete", "grátis", "gratis", "cashback",
];

function isVoucherOffer(offer: ShopeeOffer): boolean {
  const text = `${offer.offerName} ${offer.offerType}`.toLowerCase();
  return VOUCHER_KEYWORDS.some((kw) => text.includes(kw));
}

// ─── Helpers ───────────────────────────────────────────────────────────────

function formatDate(isoOrTimestamp: string): string {
  try {
    const d = new Date(
      isNaN(Number(isoOrTimestamp)) ? isoOrTimestamp : Number(isoOrTimestamp) * 1000,
    );
    return d.toLocaleDateString("pt-BR", { day: "2-digit", month: "2-digit", year: "numeric" });
  } catch {
    return isoOrTimestamp;
  }
}

function mapOfferToCoupon(offer: ShopeeOffer, platformId: string, syncTime: string) {
  // Usar collectionId como base do código, ou gerar a partir do nome
  const code = offer.collectionId
    ? `shopee-voucher-${offer.collectionId}`
    : `shopee-voucher-${offer.offerName.replace(/\s+/g, "-").toLowerCase().slice(0, 40)}`;

  // Extrair valor de desconto do nome da oferta
  let discountValue: string | null = null;
  let discountAmount: string | null = null;

  const name = offer.offerName || "";
  const pctMatch = name.match(/(\d{1,3})%/);
  const amtMatch = name.match(/R\$\s*(\d+(?:[.,]\d{2})?)/i);
  const freteMatch = /frete\s*gr[áa]tis/i.test(name);

  if (pctMatch) {
    discountValue = `${pctMatch[1]}%`;
  } else if (amtMatch) {
    discountAmount = `R$${amtMatch[1]}`;
  } else if (freteMatch) {
    discountValue = "Frete Grátis";
  } else if (offer.commissionRate) {
    discountValue = `${offer.commissionRate}% comissão`;
  }

  let conditions: string | null = null;
  if (offer.periodStartTime && offer.periodEndTime) {
    conditions = `Válido de ${formatDate(offer.periodStartTime)} até ${formatDate(offer.periodEndTime)}`;
  }

  return {
    platform_id: platformId,
    code,
    title: offer.offerName || "Cupom Shopee",
    description: `Cupom ${offer.offerType || "Shopee"}: ${offer.offerName || ""}`.trim(),
    discount_value: discountValue,
    discount_amount: discountAmount,
    subtitle: offer.offerType || null,
    conditions,
    link_url: offer.offerLink || offer.originalLink || "https://shopee.com.br",
    is_link_only: true,
    active: true,
    updated_at: syncTime,
  };
}

// ─── Fetch paginado (todas as ofertas, depois filtra vouchers) ─────────────

async function fetchVoucherOffers(): Promise<ShopeeOffer[]> {
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

    console.log(`[vouchers] Fetching page ${page}...`);

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
    // Filtrar apenas ofertas que parecem ser vouchers/cupons
    const vouchers = nodes.filter(isVoucherOffer);
    allOffers.push(...vouchers);

    console.log(`[vouchers] Page ${page}: ${nodes.length} total, ${vouchers.length} voucher(s)`);

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

    // ── Identificar platform_id da Shopee ──
    const { data: platform } = await supabase
      .from("platforms")
      .select("id")
      .ilike("name", "%shopee%")
      .single();

    if (!platform) throw new Error('Plataforma "Shopee" não encontrada.');

    const platformId = platform.id;
    const syncStartTime = new Date().toISOString();
    console.log(`[vouchers] Start: ${syncStartTime}, Platform: ${platformId}`);

    // ── Buscar vouchers ──
    const vouchers = await fetchVoucherOffers();
    console.log(`[vouchers] Total vouchers: ${vouchers.length}`);

    let upsertedCount = 0;
    let deactivatedCount = 0;

    if (vouchers.length > 0) {
      const rows = vouchers.map((v) => mapOfferToCoupon(v, platformId, syncStartTime));

      // UPSERT na tabela coupons usando (platform_id, code) como conflict target
      const { error: upsertErr } = await supabase
        .from("coupons")
        .upsert(rows, { onConflict: "platform_id,code", ignoreDuplicates: false });

      if (upsertErr) {
        console.error("[vouchers] Upsert error:", upsertErr);
        return new Response(
          JSON.stringify({ error: "Upsert failed", detail: upsertErr.message }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        );
      }

      upsertedCount = rows.length;

      // Desativar cupons antigos da Shopee que não vieram neste lote
      const { error: deactivateErr, count } = await supabase
        .from("coupons")
        .update({ active: false })
        .eq("platform_id", platformId)
        .eq("active", true)
        .lt("updated_at", syncStartTime);

      if (deactivateErr) {
        console.error("[vouchers] Deactivation error:", deactivateErr);
      }
      deactivatedCount = count ?? 0;
    }

    const result = {
      success: true,
      syncStartTime,
      platformId,
      source: "shopee_affiliate_api_vouchers",
      fetched: vouchers.length,
      upserted: upsertedCount,
      deactivated: deactivatedCount,
    };

    console.log("[vouchers] Complete:", JSON.stringify(result));
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[vouchers] Error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error", detail: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
