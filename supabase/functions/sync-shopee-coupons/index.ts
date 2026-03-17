// supabase/functions/sync-shopee-coupons/index.ts
// Supabase Edge Function — Sincronização de Cupons da Shopee
//
// Arquitetura:
//   Esta Edge Function é projetada para ser chamada via Cron (pg_cron ou cron externo).
//   Ela executa 3 etapas lógicas:
//     A) Registra o timestamp de início da sincronização.
//     B) Busca cupons da Shopee Open API e faz UPSERT na tabela `coupons`.
//     C) Desativa cupons que NÃO foram atualizados nesta sincronização
//        (ou seja, não vieram no lote atual da API).
//
// Configuração necessária (secrets do Supabase):
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
//   SHOPEE_PARTNER_ID, SHOPEE_PARTNER_KEY, SHOPEE_SHOP_ID
//
// Cron exemplo (pg_cron):
//   SELECT cron.schedule('sync-shopee-coupons', '0 */6 * * *',
//     $$SELECT extensions.http_post(
//       'https://<project>.supabase.co/functions/v1/sync-shopee-coupons',
//       '{}', 'application/json',
//       ARRAY[extensions.http_header('Authorization', 'Bearer <SERVICE_ROLE_KEY>')]
//     )$$
//   );

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Shopee HMAC-SHA256 Auth ───────────────────────────────────────────────

const SHOPEE_HOST = "https://partner.shopeemobile.com";

/**
 * Gera a assinatura HMAC-SHA256 exigida pela Shopee Open API.
 * A base string é: partner_id + api_path + timestamp + shop_id
 */
async function generateShopeeSignature(
  partnerKey: string,
  partnerId: number,
  apiPath: string,
  timestamp: number,
  shopId?: number
): Promise<string> {
  const baseString = shopId
    ? `${partnerId}${apiPath}${timestamp}${shopId}`
    : `${partnerId}${apiPath}${timestamp}`;

  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    "raw",
    encoder.encode(partnerKey),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signatureBuffer = await crypto.subtle.sign(
    "HMAC",
    key,
    encoder.encode(baseString)
  );

  return Array.from(new Uint8Array(signatureBuffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * Constrói a URL autenticada para a Shopee Open API.
 */
async function buildShopeeUrl(
  partnerKey: string,
  partnerId: number,
  apiPath: string,
  shopId?: number,
  extraParams?: Record<string, string>
): Promise<string> {
  const timestamp = Math.floor(Date.now() / 1000);
  const sign = await generateShopeeSignature(
    partnerKey,
    partnerId,
    apiPath,
    timestamp,
    shopId
  );

  const params = new URLSearchParams({
    partner_id: String(partnerId),
    timestamp: String(timestamp),
    sign,
    ...(shopId ? { shop_id: String(shopId) } : {}),
    ...(extraParams || {}),
  });

  return `${SHOPEE_HOST}${apiPath}?${params.toString()}`;
}

// ─── Shopee Coupon Fetcher ─────────────────────────────────────────────────

interface ShopeeCoupon {
  code: string;
  title: string;
  description: string;
  discount_value: string | null;
  discount_amount: string | null;
  conditions: string | null;
  end_time: number; // unix timestamp
}

/**
 * Busca cupons da Shopee Open API.
 * NOTA: Este é o ponto de integração real. Se a API de cupons da Shopee
 * não estiver disponível para o tier de parceiro, substituir por lib de
 * extração estruturada (scraping) ou alimentação manual.
 */
async function fetchShopeeCoupons(
  partnerKey: string,
  partnerId: number,
  shopId: number
): Promise<ShopeeCoupon[]> {
  const apiPath = "/api/v2/voucher/get_voucher_list";

  try {
    const url = await buildShopeeUrl(partnerKey, partnerId, apiPath, shopId, {
      page_no: "1",
      page_size: "100",
      status: "ongoing",
    });

    const response = await fetch(url, {
      method: "GET",
      headers: { "Content-Type": "application/json" },
    });

    if (!response.ok) {
      console.warn(
        `Shopee API returned ${response.status}. Falling back to empty list.`
      );
      return [];
    }

    const json = await response.json();

    if (json.error) {
      console.warn(`Shopee API error: ${json.error} — ${json.message}`);
      return [];
    }

    // Mapeia a resposta da Shopee para o formato interno
    const vouchers = json.response?.voucher_list || [];
    return vouchers.map((v: any) => ({
      code: v.voucher_code || v.voucher_id?.toString() || "",
      title: v.voucher_name || "Cupom Shopee",
      description: v.voucher_description || "",
      discount_value:
        v.discount_type === "percentage"
          ? `${v.discount_value}%`
          : null,
      discount_amount:
        v.discount_type === "fix_amount"
          ? `R$${(v.discount_value / 100000).toFixed(2)}`
          : null,
      conditions: v.min_spend
        ? `Compra mínima: R$${(v.min_spend / 100000).toFixed(2)}`
        : null,
      end_time: v.end_time || 0,
    }));
  } catch (err) {
    console.error("Error fetching Shopee coupons:", err);
    return [];
  }
}

// ─── Main Handler ──────────────────────────────────────────────────────────

serve(async (req) => {
  try {
    // ── Env vars ──
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const partnerIdStr = Deno.env.get("SHOPEE_PARTNER_ID");
    const partnerKey = Deno.env.get("SHOPEE_PARTNER_KEY");
    const shopIdStr = Deno.env.get("SHOPEE_SHOP_ID");

    if (!partnerIdStr || !partnerKey || !shopIdStr) {
      return new Response(
        JSON.stringify({
          error: "Missing Shopee credentials in environment secrets.",
        }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    const partnerId = Number(partnerIdStr);
    const shopId = Number(shopIdStr);

    const supabase = createClient(supabaseUrl, supabaseKey, {
      auth: { persistSession: false },
    });

    // ── Passo 0: Identificar platform_id da Shopee ──
    const { data: platform, error: platformErr } = await supabase
      .from("platforms")
      .select("id")
      .ilike("name", "%shopee%")
      .single();

    if (platformErr || !platform) {
      return new Response(
        JSON.stringify({
          error: 'Platform "Shopee" not found in platforms table.',
          detail: platformErr?.message,
        }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    const platformId = platform.id;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PASSO A: Registrar timestamp de início da sincronização
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const syncStartTime = new Date().toISOString();

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PASSO B: Buscar cupons da API e executar UPSERT em lote
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const shopeeCoupons = await fetchShopeeCoupons(
      partnerKey,
      partnerId,
      shopId
    );

    let upsertedCount = 0;

    if (shopeeCoupons.length > 0) {
      const rows = shopeeCoupons.map((c) => ({
        platform_id: platformId,
        code: c.code,
        title: c.title,
        description: c.description,
        discount_value: c.discount_value,
        discount_amount: c.discount_amount,
        conditions: c.conditions,
        active: true,
        updated_at: syncStartTime,
      }));

      // UPSERT: insere novos ou atualiza existentes com base em (platform_id, code).
      // Requer UNIQUE constraint: ALTER TABLE coupons ADD CONSTRAINT uq_coupons_platform_code UNIQUE (platform_id, code);
      const { error: upsertErr, count } = await supabase
        .from("coupons")
        .upsert(rows, {
          onConflict: "platform_id,code",
          ignoreDuplicates: false,
        });

      if (upsertErr) {
        console.error("Upsert error:", upsertErr);
        return new Response(
          JSON.stringify({ error: "Upsert failed", detail: upsertErr.message }),
          { status: 500, headers: { "Content-Type": "application/json" } }
        );
      }

      upsertedCount = shopeeCoupons.length;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PASSO C: Desativar cupons que NÃO vieram neste lote
    // Cupons com updated_at < syncStartTime não foram atualizados,
    // logo não existem mais na API → devem ser desativados.
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const { error: deactivateErr, count: deactivatedCount } = await supabase
      .from("coupons")
      .update({ active: false })
      .eq("platform_id", platformId)
      .eq("active", true)
      .lt("updated_at", syncStartTime);

    if (deactivateErr) {
      console.error("Deactivation error:", deactivateErr);
    }

    return new Response(
      JSON.stringify({
        success: true,
        syncStartTime,
        platformId,
        fetched: shopeeCoupons.length,
        upserted: upsertedCount,
        deactivated: deactivatedCount ?? 0,
      }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error", detail: String(err) }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
