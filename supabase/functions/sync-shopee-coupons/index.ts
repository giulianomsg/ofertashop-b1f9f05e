// supabase/functions/sync-shopee-coupons/index.ts
// Supabase Edge Function — Sincronização de Cupons da Shopee
//
// ARQUITETURA:
//   A Shopee não oferece API pública para cupons sem CNPJ/registro de parceiro.
//   A página https://shopee.com.br/m/cupom-de-desconto é um SPA que carrega
//   cupons via endpoints internos:
//
//   1. GET  /api/v4/pagebuilder/get_csr_page — retorna metadata da página
//      incluindo collection_ids de cada seção de cupons.
//   2. POST /api/v1/microsite/get_vouchers_by_collections — retorna os vouchers
//      de cada collection. Este endpoint é protegido por headers anti-bot
//      (af-ac-enc-dat, x-sap-sec, x-csrftoken) mas funciona com cookies
//      mínimos de sessão.
//
//   ESTRATÉGIA EM 2 FASES:
//     Fase 1 (get_csr_page): Endpoint público, sem auth.
//     Fase 2 (get_vouchers_by_collections): Necessita cabeçalhos de sessão.
//       → Tentamos fazer a chamada com headers mínimos.
//       → Se falhar, fazemos fallback para o HTML renderizado via parsing.
//
//   A sincronização segue 3 passos lógicos:
//     A) Registra syncStartTime.
//     B) UPSERT dos cupons coletados.
//     C) Desativa cupons não atualizados neste lote (updated_at < syncStartTime).
//
// CONFIGURAÇÃO (Supabase Secrets):
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
//
// CRON (pg_cron ou externo):
//   Chamar a cada 6 horas:
//   SELECT cron.schedule('sync-shopee-coupons', '0 */6 * * *',
//     $$SELECT extensions.http_post(
//       'https://<project>.supabase.co/functions/v1/sync-shopee-coupons',
//       '{}', 'application/json',
//       ARRAY[extensions.http_header('Authorization', 'Bearer <SERVICE_ROLE_KEY>')]
//     )$$
//   );

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── Types ─────────────────────────────────────────────────────────────────

interface ParsedCoupon {
  code: string;
  title: string;
  description: string;
  discount_value: string | null;
  discount_amount: string | null;
  subtitle: string | null;
  conditions: string | null;
  link_url: string;
  is_link_only: boolean;
}

// ─── Shopee Page Fetcher ───────────────────────────────────────────────────

const SHOPEE_BASE = "https://shopee.com.br";
const COUPON_PAGE_URL = `${SHOPEE_BASE}/m/cupom-de-desconto`;

const BROWSER_HEADERS: Record<string, string> = {
  "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
  "Accept":
    "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
  "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
  "Sec-Fetch-Dest": "document",
  "Sec-Fetch-Mode": "navigate",
  "Sec-Fetch-Site": "none",
  "Sec-Fetch-User": "?1",
  "Upgrade-Insecure-Requests": "1",
};

const JSON_HEADERS: Record<string, string> = {
  "User-Agent": BROWSER_HEADERS["User-Agent"],
  "Accept": "application/json",
  "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
  "Content-Type": "application/json",
  "Referer": COUPON_PAGE_URL,
  "X-Requested-With": "XMLHttpRequest",
};

/**
 * Fase 1: Busca metadata da página via get_csr_page (endpoint público).
 * Retorna os collection_ids presentes na página de cupons.
 */
async function fetchPageCollections(): Promise<string[]> {
  try {
    const url = `${SHOPEE_BASE}/api/v4/pagebuilder/get_csr_page?page_url=cupom-de-desconto&platform=4&timestamp=0`;
    const res = await fetch(url, { headers: JSON_HEADERS });

    if (!res.ok) {
      console.warn(`get_csr_page returned ${res.status}`);
      return [];
    }

    const json = await res.json();
    const collectionIds: string[] = [];

    // Extrai collection_ids recursivamente dos componentes da página
    const extractCollections = (obj: any) => {
      if (!obj) return;
      if (typeof obj === "object") {
        if (obj.collection_id) collectionIds.push(String(obj.collection_id));
        if (obj.collectionID) collectionIds.push(String(obj.collectionID));
        for (const val of Object.values(obj)) {
          extractCollections(val);
        }
      }
      if (Array.isArray(obj)) {
        obj.forEach(extractCollections);
      }
    };

    extractCollections(json);
    return [...new Set(collectionIds)];
  } catch (err) {
    console.error("Error fetching page collections:", err);
    return [];
  }
}

/**
 * Fase 2: Busca vouchers de uma lista de collection_ids via API interna.
 * Este endpoint pode exigir headers de sessão. Se falhar, retorna vazio.
 */
async function fetchVouchersByCollections(
  collectionIds: string[]
): Promise<ParsedCoupon[]> {
  if (collectionIds.length === 0) return [];

  try {
    const url = `${SHOPEE_BASE}/api/v1/microsite/get_vouchers_by_collections`;
    const body = JSON.stringify({
      collection_ids: collectionIds.map(Number),
      with_voucher_info: true,
    });

    const res = await fetch(url, {
      method: "POST",
      headers: JSON_HEADERS,
      body,
    });

    if (!res.ok) {
      console.warn(`get_vouchers_by_collections returned ${res.status}`);
      return [];
    }

    const json = await res.json();

    if (json.error || !json.data) {
      console.warn("Voucher API error:", json.error, json.msg);
      return [];
    }

    const coupons: ParsedCoupon[] = [];

    // A resposta agrupa vouchers por collection
    const collections = json.data?.collections || json.data || [];
    for (const collection of Object.values(collections) as any[]) {
      const vouchers = collection?.vouchers || collection?.voucher_list || [];
      for (const v of vouchers) {
        const voucherCode =
          v.voucher_code || v.code || v.voucher_id?.toString() || `shopee-${v.promotionid || Date.now()}`;
        const discountType = v.discount_type || v.reward_type;
        const isPercentage = discountType === "percentage" || discountType === 1;
        const isCoin = discountType === "coin" || discountType === 3;

        let discountValue: string | null = null;
        let discountAmount: string | null = null;

        if (isPercentage) {
          discountValue = `${v.discount_value || v.discount_percentage || v.percentage}%`;
        } else if (isCoin) {
          discountValue = `${v.coin_percentage || v.discount_value}% em moedas`;
        } else {
          // fix_amount
          const rawValue = v.discount_value || v.discount_amount || 0;
          const formatted =
            rawValue > 1000
              ? (rawValue / 100000).toFixed(0) // Shopee uses micro-currency
              : rawValue;
          discountAmount = `R$${formatted}`;
        }

        const minSpend = v.min_spend || v.min_spend_amount;
        let conditions: string | null = null;
        if (minSpend) {
          const minFormatted =
            minSpend > 1000 ? (minSpend / 100000).toFixed(0) : minSpend;
          conditions = `Compra mínima: R$${minFormatted}`;
        }

        const promotionId = v.promotionid || v.promotion_id || "";
        const signature = v.signature || "";
        const linkUrl = promotionId
          ? `${SHOPEE_BASE}/m/cupom-de-desconto?promotionId=${promotionId}${signature ? `&signature=${signature}` : ""}`
          : COUPON_PAGE_URL;

        coupons.push({
          code: voucherCode,
          title:
            v.voucher_name || v.title || (discountAmount ? `${discountAmount} OFF` : `${discountValue} OFF`),
          description: v.description || v.voucher_description || "",
          discount_value: discountValue,
          discount_amount: discountAmount,
          subtitle: v.usage_tips || v.subtitle || null,
          conditions,
          link_url: linkUrl,
          is_link_only: true, // Shopee usa sistema de "coletar", não código público
        });
      }
    }

    return coupons;
  } catch (err) {
    console.error("Error fetching vouchers by collections:", err);
    return [];
  }
}

/**
 * Fallback: Se a API interna falhar, busca o HTML da página e extrai
 * informações básicas dos cupons via parsing de texto do DOM.
 */
async function fetchCouponsFromHTML(): Promise<ParsedCoupon[]> {
  try {
    const res = await fetch(COUPON_PAGE_URL, { headers: BROWSER_HEADERS });
    if (!res.ok) return [];

    const html = await res.text();
    const coupons: ParsedCoupon[] = [];

    // Shopee injeta dados no script como __INITIAL_STATE__ ou dentro de JSON no HTML
    const stateMatch = html.match(
      /window\.__INITIAL_STATE__\s*=\s*({[\s\S]*?});?\s*<\/script>/
    );
    if (stateMatch) {
      try {
        const state = JSON.parse(stateMatch[1]);
        // Tenta extrair vouchers do estado inicial
        const findVouchers = (obj: any, depth = 0): any[] => {
          if (depth > 8 || !obj) return [];
          const results: any[] = [];
          if (Array.isArray(obj)) {
            for (const item of obj) {
              if (item?.voucher_code || item?.promotionid || item?.voucher_name) {
                results.push(item);
              }
              results.push(...findVouchers(item, depth + 1));
            }
          } else if (typeof obj === "object") {
            for (const val of Object.values(obj)) {
              results.push(...findVouchers(val, depth + 1));
            }
          }
          return results;
        };

        const vouchers = findVouchers(state);
        for (const v of vouchers) {
          coupons.push({
            code: v.voucher_code || v.promotionid?.toString() || `shopee-html-${Date.now()}`,
            title: v.voucher_name || "Cupom Shopee",
            description: v.description || "",
            discount_value: v.discount_percentage ? `${v.discount_percentage}%` : null,
            discount_amount: v.discount_value ? `R$${v.discount_value}` : null,
            subtitle: null,
            conditions: v.min_spend ? `Compra mínima: R$${v.min_spend}` : null,
            link_url: COUPON_PAGE_URL,
            is_link_only: true,
          });
        }
      } catch {
        console.warn("Failed to parse __INITIAL_STATE__");
      }
    }

    // Fallback adicional: extrai valores de desconto do HTML puro
    if (coupons.length === 0) {
      // Padrão: "R$XX OFF" ou "XX% OFF" no texto da página
      const discountPattern = /(?:R\$\s*(\d+)\s*OFF|(\d+)%\s*OFF)/gi;
      let match: RegExpExecArray | null;
      let idx = 0;

      while ((match = discountPattern.exec(html)) !== null && idx < 50) {
        const isAmount = !!match[1];
        coupons.push({
          code: `shopee-scraped-${idx++}`,
          title: isAmount ? `R$${match[1]} OFF` : `${match[2]}% OFF`,
          description: "Cupom de desconto Shopee",
          discount_value: isAmount ? null : `${match[2]}%`,
          discount_amount: isAmount ? `R$${match[1]}` : null,
          subtitle: null,
          conditions: null,
          link_url: COUPON_PAGE_URL,
          is_link_only: true,
        });
      }

      // De-duplicar por title
      const seen = new Set<string>();
      return coupons.filter((c) => {
        if (seen.has(c.title)) return false;
        seen.add(c.title);
        return true;
      });
    }

    return coupons;
  } catch (err) {
    console.error("Error scraping HTML:", err);
    return [];
  }
}

// ─── Main Handler ──────────────────────────────────────────────────────────

serve(async (_req) => {
  try {
    // ── Env vars ──
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
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    const platformId = platform.id;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PASSO A: Registrar timestamp de início da sincronização
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const syncStartTime = new Date().toISOString();
    console.log(`[sync] Start: ${syncStartTime}, Platform: ${platformId}`);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PASSO B: Buscar cupons — tenta API interna, fallback para HTML
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    let coupons: ParsedCoupon[] = [];
    let source = "none";

    // Tentativa 1: API interna via collection_ids
    console.log("[sync] Fetching page collections...");
    const collectionIds = await fetchPageCollections();
    console.log(`[sync] Found ${collectionIds.length} collection(s)`);

    if (collectionIds.length > 0) {
      coupons = await fetchVouchersByCollections(collectionIds);
      if (coupons.length > 0) source = "api";
    }

    // Tentativa 2: Fallback HTML scraping
    if (coupons.length === 0) {
      console.log("[sync] API failed or empty, trying HTML fallback...");
      coupons = await fetchCouponsFromHTML();
      if (coupons.length > 0) source = "html";
    }

    console.log(`[sync] Found ${coupons.length} coupon(s) via ${source}`);

    // ── UPSERT no banco ──
    let upsertedCount = 0;

    if (coupons.length > 0) {
      const rows = coupons.map((c) => ({
        platform_id: platformId,
        code: c.code,
        title: c.title,
        description: c.description,
        discount_value: c.discount_value,
        discount_amount: c.discount_amount,
        subtitle: c.subtitle,
        conditions: c.conditions,
        link_url: c.link_url,
        is_link_only: c.is_link_only,
        active: true,
        updated_at: syncStartTime,
      }));

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
          { status: 500, headers: { "Content-Type": "application/json" } }
        );
      }

      upsertedCount = coupons.length;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PASSO C: Desativar cupons que NÃO vieram neste lote
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    let deactivatedCount = 0;

    if (coupons.length > 0) {
      // Só desativa se tivemos resultados (evita desativar tudo se a API caiu)
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
      source,
      fetched: coupons.length,
      upserted: upsertedCount,
      deactivated: deactivatedCount,
    };

    console.log("[sync] Complete:", JSON.stringify(result));

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[sync] Unexpected error:", err);
    return new Response(
      JSON.stringify({
        error: "Internal server error",
        detail: String(err),
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
