// supabase/functions/sync-shopee-coupons/index.ts
// Supabase Edge Function — Sincronização de Cupons da Shopee
//
// ESTRATÉGIA MULTI-CAMADA:
//   1. API interna get_csr_page → get_vouchers_by_collections
//   2. API v4 de promoções (promotions/get)
//   3. Microsite voucher list
//   4. Fetch HTML + parse __NEXT_DATA__ / __INITIAL_STATE__
//   5. Fallback: regex no HTML bruto
//
// SYNC: UPSERT (cria se não existe, atualiza se existe)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ─── CORS ──────────────────────────────────────────────────────────────────

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

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

// ─── Constants ─────────────────────────────────────────────────────────────

const SHOPEE_BASE = "https://shopee.com.br";
const COUPON_PAGE_URL = `${SHOPEE_BASE}/m/cupom-de-desconto`;

const BROWSER_UA =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

const BROWSER_HEADERS: Record<string, string> = {
  "User-Agent": BROWSER_UA,
  "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
  "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
  "Sec-Fetch-Dest": "document",
  "Sec-Fetch-Mode": "navigate",
  "Sec-Fetch-Site": "none",
  "Sec-Fetch-User": "?1",
  "Upgrade-Insecure-Requests": "1",
};

const JSON_HEADERS: Record<string, string> = {
  "User-Agent": BROWSER_UA,
  "Accept": "application/json",
  "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
  "Content-Type": "application/json",
  "Referer": COUPON_PAGE_URL,
  "X-Requested-With": "XMLHttpRequest",
};

// ─── Strategy 1: get_csr_page → get_vouchers_by_collections ────────────────

async function strategy1_CollectionAPI(): Promise<ParsedCoupon[]> {
  console.log("[s1] Trying collection API...");
  try {
    // Phase 1: get collection IDs
    const pageUrl = `${SHOPEE_BASE}/api/v4/pagebuilder/get_csr_page?page_url=cupom-de-desconto&platform=4&timestamp=0`;
    const pageRes = await fetch(pageUrl, { headers: JSON_HEADERS });

    if (!pageRes.ok) {
      console.warn(`[s1] get_csr_page: ${pageRes.status}`);
      return [];
    }

    const pageJson = await pageRes.json();
    const collectionIds: string[] = [];

    const extract = (obj: any) => {
      if (!obj) return;
      if (typeof obj === "object") {
        if (obj.collection_id) collectionIds.push(String(obj.collection_id));
        if (obj.collectionID) collectionIds.push(String(obj.collectionID));
        for (const val of Object.values(obj)) extract(val);
      }
    };
    extract(pageJson);

    const uniqueIds = [...new Set(collectionIds)];
    console.log(`[s1] Found ${uniqueIds.length} collection(s)`);
    if (uniqueIds.length === 0) return [];

    // Phase 2: get vouchers
    const voucherUrl = `${SHOPEE_BASE}/api/v1/microsite/get_vouchers_by_collections`;
    const voucherRes = await fetch(voucherUrl, {
      method: "POST",
      headers: JSON_HEADERS,
      body: JSON.stringify({
        collection_ids: uniqueIds.map(Number),
        with_voucher_info: true,
      }),
    });

    if (!voucherRes.ok) {
      console.warn(`[s1] get_vouchers: ${voucherRes.status}`);
      return [];
    }

    const vJson = await voucherRes.json();
    if (vJson.error || !vJson.data) {
      console.warn("[s1] API error:", vJson.error || vJson.msg);
      return [];
    }

    return parseVoucherData(vJson.data);
  } catch (err) {
    console.error("[s1] Error:", err);
    return [];
  }
}

// ─── Strategy 2: Shopee voucher wallet / promotions endpoints ──────────────

async function strategy2_PromotionAPI(): Promise<ParsedCoupon[]> {
  console.log("[s2] Trying promotion endpoints...");
  try {
    // Try multiple possible API paths
    const endpoints = [
      `${SHOPEE_BASE}/api/v2/voucher_wallet/get_shop_vouchers?shopid=0&limit=50&need_user_voucher=0`,
      `${SHOPEE_BASE}/api/v2/voucher/get_store_voucher_list?shop_id=0&voucher_status=0&offset=0&limit=50`,
      `${SHOPEE_BASE}/api/v4/homepage/get_vouchers?limit=50`,
    ];

    for (const url of endpoints) {
      try {
        const res = await fetch(url, { headers: JSON_HEADERS });
        if (!res.ok) continue;

        const json = await res.json();
        const vouchers =
          json.data?.vouchers ||
          json.data?.voucher_list ||
          json.vouchers ||
          json.data?.shop_vouchers || [];

        if (vouchers.length > 0) {
          console.log(`[s2] Found ${vouchers.length} voucher(s) from ${url}`);
          return vouchers.map(parseShopeeVoucher).filter(Boolean) as ParsedCoupon[];
        }
      } catch {
        continue;
      }
    }
    return [];
  } catch (err) {
    console.error("[s2] Error:", err);
    return [];
  }
}

// ─── Strategy 3: Fetch HTML, parse embedded JSON data ──────────────────────

async function strategy3_HTMLParsing(): Promise<ParsedCoupon[]> {
  console.log("[s3] Trying HTML parsing...");
  try {
    const res = await fetch(COUPON_PAGE_URL, {
      headers: BROWSER_HEADERS,
      redirect: "follow",
    });
    if (!res.ok) {
      console.warn(`[s3] Page fetch: ${res.status}`);
      return [];
    }

    const html = await res.text();
    console.log(`[s3] HTML length: ${html.length} chars`);
    const coupons: ParsedCoupon[] = [];

    // Try __NEXT_DATA__
    const nextDataMatch = html.match(/<script id="__NEXT_DATA__"[^>]*>([\s\S]*?)<\/script>/);
    if (nextDataMatch) {
      try {
        const nextData = JSON.parse(nextDataMatch[1]);
        const found = deepFindVouchers(nextData);
        console.log(`[s3] __NEXT_DATA__ vouchers: ${found.length}`);
        coupons.push(...found);
      } catch { console.warn("[s3] Failed to parse __NEXT_DATA__"); }
    }

    // Try __INITIAL_STATE__
    if (coupons.length === 0) {
      const stateMatch = html.match(/window\.__INITIAL_STATE__\s*=\s*({[\s\S]*?});?\s*<\/script>/);
      if (stateMatch) {
        try {
          const state = JSON.parse(stateMatch[1]);
          const found = deepFindVouchers(state);
          console.log(`[s3] __INITIAL_STATE__ vouchers: ${found.length}`);
          coupons.push(...found);
        } catch { console.warn("[s3] Failed to parse __INITIAL_STATE__"); }
      }
    }

    // Try any inline JSON that contains voucher-like objects
    if (coupons.length === 0) {
      const jsonBlocks = html.match(/\{[^{}]*"voucher_code"[^{}]*\}/g) || [];
      for (const block of jsonBlocks.slice(0, 50)) {
        try {
          const obj = JSON.parse(block);
          const parsed = parseShopeeVoucher(obj);
          if (parsed) coupons.push(parsed);
        } catch { /* skip */ }
      }
      if (coupons.length > 0) console.log(`[s3] Inline JSON vouchers: ${coupons.length}`);
    }

    // Regex fallback: extract discount patterns from the HTML
    if (coupons.length === 0) {
      console.log("[s3] Falling back to regex extraction...");
      const seen = new Set<string>();

      // Pattern: "R$XX OFF"
      const amountPattern = /R\$\s*(\d+(?:[.,]\d{2})?)\s*(?:OFF|off|de desconto)/gi;
      let match: RegExpExecArray | null;
      while ((match = amountPattern.exec(html)) !== null && coupons.length < 50) {
        const val = match[1];
        const key = `amount-${val}`;
        if (seen.has(key)) continue;
        seen.add(key);
        coupons.push({
          code: `shopee-rs${val.replace(/[.,]/g, "")}-${coupons.length}`,
          title: `R$${val} OFF Shopee`,
          description: "Cupom de desconto Shopee",
          discount_value: null,
          discount_amount: `R$${val}`,
          subtitle: null,
          conditions: null,
          link_url: COUPON_PAGE_URL,
          is_link_only: true,
        });
      }

      // Pattern: "XX% OFF"
      const pctPattern = /(\d{1,3})%\s*(?:OFF|off|de desconto)/gi;
      while ((match = pctPattern.exec(html)) !== null && coupons.length < 50) {
        const val = match[1];
        const key = `pct-${val}`;
        if (seen.has(key)) continue;
        seen.add(key);
        coupons.push({
          code: `shopee-pct${val}-${coupons.length}`,
          title: `${val}% OFF Shopee`,
          description: "Cupom de desconto Shopee",
          discount_value: `${val}%`,
          discount_amount: null,
          subtitle: null,
          conditions: null,
          link_url: COUPON_PAGE_URL,
          is_link_only: true,
        });
      }

      // Pattern: "Frete Grátis" or "Frete gratis"
      const fretePattern = /frete\s*gr[áa]tis/gi;
      if (fretePattern.test(html) && !seen.has("frete")) {
        seen.add("frete");
        coupons.push({
          code: `shopee-fretegratis-0`,
          title: "Frete Grátis Shopee",
          description: "Cupom de frete grátis Shopee",
          discount_value: "Frete Grátis",
          discount_amount: null,
          subtitle: null,
          conditions: null,
          link_url: COUPON_PAGE_URL,
          is_link_only: true,
        });
      }

      console.log(`[s3] Regex extracted ${coupons.length} coupon(s)`);
    }

    return coupons;
  } catch (err) {
    console.error("[s3] Error:", err);
    return [];
  }
}

// ─── Strategy 4: Try the mobile API (sometimes less protected) ─────────────

async function strategy4_MobileAPI(): Promise<ParsedCoupon[]> {
  console.log("[s4] Trying mobile API...");
  try {
    const mobileHeaders: Record<string, string> = {
      "User-Agent": "ShopeeApp/3.20 (Android; Mobile)",
      "Accept": "application/json",
      "Accept-Language": "pt-BR",
      "Content-Type": "application/json",
    };

    const endpoints = [
      `${SHOPEE_BASE}/api/v4/pages/get_homepage_category_list`,
      `${SHOPEE_BASE}/api/v4/microsite/get_microsite_data?page_url=cupom-de-desconto`,
    ];

    for (const url of endpoints) {
      try {
        const res = await fetch(url, { headers: mobileHeaders });
        if (!res.ok) continue;
        const json = await res.json();
        const found = deepFindVouchers(json);
        if (found.length > 0) {
          console.log(`[s4] Found ${found.length} voucher(s) from ${url}`);
          return found;
        }
      } catch { continue; }
    }
    return [];
  } catch (err) {
    console.error("[s4] Error:", err);
    return [];
  }
}

// ─── Parsing Helpers ───────────────────────────────────────────────────────

function parseVoucherData(data: any): ParsedCoupon[] {
  const coupons: ParsedCoupon[] = [];
  const collections = data?.collections || data || [];

  for (const collection of Object.values(collections) as any[]) {
    const vouchers = collection?.vouchers || collection?.voucher_list || [];
    for (const v of vouchers) {
      const parsed = parseShopeeVoucher(v);
      if (parsed) coupons.push(parsed);
    }
  }
  return coupons;
}

function parseShopeeVoucher(v: any): ParsedCoupon | null {
  if (!v) return null;

  const code =
    v.voucher_code || v.code || v.voucher_id?.toString() || v.promotionid?.toString() ||
    `shopee-v${Date.now()}-${Math.random().toString(36).slice(2, 6)}`;

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
    const rawValue = v.discount_value || v.discount_amount || 0;
    if (rawValue > 0) {
      const formatted = rawValue > 1000 ? (rawValue / 100000).toFixed(0) : rawValue;
      discountAmount = `R$${formatted}`;
    }
  }

  // If no discount identified, try to extract from title
  if (!discountValue && !discountAmount) {
    const title = v.voucher_name || v.title || "";
    const amtMatch = title.match(/R\$\s*(\d+)/i);
    const pctMatch = title.match(/(\d+)%/);
    if (amtMatch) discountAmount = `R$${amtMatch[1]}`;
    else if (pctMatch) discountValue = `${pctMatch[1]}%`;
  }

  const minSpend = v.min_spend || v.min_spend_amount;
  let conditions: string | null = null;
  if (minSpend) {
    const minFormatted = minSpend > 1000 ? (minSpend / 100000).toFixed(0) : minSpend;
    conditions = `Compra mínima: R$${minFormatted}`;
  }

  const promotionId = v.promotionid || v.promotion_id || "";
  const signature = v.signature || "";
  const linkUrl = promotionId
    ? `${SHOPEE_BASE}/m/cupom-de-desconto?promotionId=${promotionId}${signature ? `&signature=${signature}` : ""}`
    : COUPON_PAGE_URL;

  const title =
    v.voucher_name || v.title ||
    (discountAmount ? `${discountAmount} OFF` : discountValue ? `${discountValue} OFF` : "Cupom Shopee");

  return {
    code,
    title,
    description: v.description || v.voucher_description || "",
    discount_value: discountValue,
    discount_amount: discountAmount,
    subtitle: v.usage_tips || v.subtitle || null,
    conditions,
    link_url: linkUrl,
    is_link_only: true,
  };
}

function deepFindVouchers(obj: any, depth = 0): ParsedCoupon[] {
  if (depth > 10 || !obj) return [];
  const results: ParsedCoupon[] = [];

  if (Array.isArray(obj)) {
    for (const item of obj) {
      if (item?.voucher_code || item?.promotionid || item?.voucher_name || item?.voucher_id) {
        const parsed = parseShopeeVoucher(item);
        if (parsed) results.push(parsed);
      }
      results.push(...deepFindVouchers(item, depth + 1));
    }
  } else if (typeof obj === "object") {
    // Check if this object itself is a voucher
    if (obj.voucher_code || obj.promotionid || obj.voucher_name) {
      const parsed = parseShopeeVoucher(obj);
      if (parsed) results.push(parsed);
    }
    for (const val of Object.values(obj)) {
      results.push(...deepFindVouchers(val, depth + 1));
    }
  }

  // Deduplicate by code
  const seen = new Set<string>();
  return results.filter(c => {
    if (seen.has(c.code)) return false;
    seen.add(c.code);
    return true;
  });
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
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const platformId = platform.id;
    const syncStartTime = new Date().toISOString();
    console.log(`[sync] Start: ${syncStartTime}, Platform: ${platformId}`);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // BUSCAR CUPONS — tenta cada estratégia em sequência
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    let coupons: ParsedCoupon[] = [];
    let source = "none";
    const logs: string[] = [];

    // Strategy 1: Collection API
    coupons = await strategy1_CollectionAPI();
    if (coupons.length > 0) {
      source = "collection_api";
    }

    // Strategy 2: Promotion API
    if (coupons.length === 0) {
      coupons = await strategy2_PromotionAPI();
      if (coupons.length > 0) source = "promotion_api";
    }

    // Strategy 4: Mobile API
    if (coupons.length === 0) {
      coupons = await strategy4_MobileAPI();
      if (coupons.length > 0) source = "mobile_api";
    }

    // Strategy 3: HTML Parsing (always some results from regex)
    if (coupons.length === 0) {
      coupons = await strategy3_HTMLParsing();
      if (coupons.length > 0) source = "html_parsing";
    }

    logs.push(`Source: ${source}, Found: ${coupons.length}`);
    console.log(`[sync] Total: ${coupons.length} coupon(s) via ${source}`);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // UPSERT — cria novos ou atualiza existentes
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

      // UPSERT: onConflict = unique constraint (platform_id, code)
      // This will INSERT new coupons and UPDATE existing ones
      const { error: upsertErr } = await supabase
        .from("coupons")
        .upsert(rows, {
          onConflict: "platform_id,code",
          ignoreDuplicates: false,
        });

      if (upsertErr) {
        console.error("[sync] Upsert error:", upsertErr);
        logs.push(`Upsert error: ${upsertErr.message}`);
        return new Response(
          JSON.stringify({
            error: "Upsert failed",
            detail: upsertErr.message,
            logs,
          }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      upsertedCount = coupons.length;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // DESATIVAR cupons que NÃO vieram neste lote
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    let deactivatedCount = 0;

    if (coupons.length > 0) {
      const { error: deactivateErr, count } = await supabase
        .from("coupons")
        .update({ active: false })
        .eq("platform_id", platformId)
        .eq("active", true)
        .lt("updated_at", syncStartTime);

      if (deactivateErr) {
        console.error("[sync] Deactivation error:", deactivateErr);
        logs.push(`Deactivation error: ${deactivateErr.message}`);
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
      logs,
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
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
