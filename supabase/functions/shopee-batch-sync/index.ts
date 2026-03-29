// Edge Function: shopee-batch-sync — Scraping real + fallback GraphQL para preços
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// --- Shopee Affiliate GraphQL ---
function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hash);
}

async function shopeeGraphQL<T = unknown>(query: string, variables: Record<string, unknown> = {}): Promise<T> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");
  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");

  const payloadStr = JSON.stringify({ query, variables });
  const timestamp = Math.floor(Date.now() / 1000);
  const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
  const sign = await sha256Hex(factor);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://open-api.affiliate.shopee.com.br";

  const res = await fetch(`${shopeeHost}/graphql`, {
    method: "POST",
    headers: {
      Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
      "Content-Type": "application/json",
    },
    body: new TextEncoder().encode(payloadStr),
  });

  const json = await res.json();
  if (json.errors?.length > 0) {
    throw new Error(`Shopee GraphQL: ${json.errors.map((e: { message: string }) => e.message).join(", ")}`);
  }
  return json.data as T;
}

// --- Multi-Scraper Proxy ---
interface ScraperConfig {
  provider: 'scrapingbee' | 'scrape.do' | 'scrapingant' | 'scraperapi';
  apiKey: string;
}

function buildScraperUrl(config: ScraperConfig, targetUrl: string): string {
  const { provider, apiKey } = config;
  if (provider === 'scrapingbee') {
    const api = new URL("https://app.scrapingbee.com/api/v1");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("render_js", "true");
    api.searchParams.append("premium_proxy", "true");
    api.searchParams.append("country_code", "br");
    api.searchParams.append("wait", "3000");
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    api.searchParams.append("render", "true");
    return api.toString();
  }
  if (provider === 'scrapingant') {
    const api = new URL("https://api.scrapingant.com/v2/general");
    api.searchParams.append("x-api-key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("proxy_country", "BR");
    api.searchParams.append("browser", "true");
    api.searchParams.append("proxy_type", "residential");
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    api.searchParams.append("premium", "true");
    api.searchParams.append("render", "true");
    return api.toString();
  }
  throw new Error(`Scraper provider desconhecido: ${provider}`);
}

async function getShopeeScraperConfig(sb: ReturnType<typeof createClient>): Promise<ScraperConfig | null> {
  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "shopee_scraper_config").maybeSingle();
    if (data?.value?.activeProvider && data?.value?.keys) {
      const provider = data.value.activeProvider;
      const apiKey = data.value.keys[provider];
      if (apiKey) return { provider, apiKey };
    }
  } catch (_e) { /* ignore */ }

  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle();
    if (data?.value?.activeProvider && data?.value?.keys) {
      const provider = data.value.activeProvider;
      const apiKey = data.value.keys[provider];
      if (apiKey) return { provider, apiKey };
    }
  } catch (_e) { /* ignore */ }

  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  return null;
}

async function fetchHtmlViaScraper(config: ScraperConfig, targetUrl: string): Promise<string | null> {
  try {
    const proxyUrl = buildScraperUrl(config, targetUrl);
    const res = await fetch(proxyUrl);
    if (res.ok) {
      let html = await res.text();
      try {
        const wrapper = JSON.parse(html);
        if (wrapper && typeof wrapper.content === 'string') html = wrapper.content;
      } catch (_e) { /* raw */ }
      return html;
    }
  } catch (err) {
    console.warn(`[Shopee Sync] Scraping error:`, err instanceof Error ? err.message : err);
  }
  return null;
}

// Build scraper URL WITHOUT render_js (cheaper, for JSON API calls)
function buildScraperUrlNoJs(config: ScraperConfig, targetUrl: string): string {
  const { provider, apiKey } = config;
  if (provider === 'scrapingbee') {
    const api = new URL("https://app.scrapingbee.com/api/v1");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("render_js", "false");
    api.searchParams.append("premium_proxy", "true");
    api.searchParams.append("country_code", "br");
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    return api.toString();
  }
  if (provider === 'scrapingant') {
    const api = new URL("https://api.scrapingant.com/v2/general");
    api.searchParams.append("x-api-key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("proxy_country", "BR");
    api.searchParams.append("browser", "false");
    api.searchParams.append("proxy_type", "residential");
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    api.searchParams.append("premium", "true");
    return api.toString();
  }
  throw new Error(`Provider desconhecido: ${provider}`);
}

function normalizeMicroPrice(raw: number | undefined | null): number {
  if (!raw || raw <= 0) return 0;
  if (raw > 10000000) return raw / 100000;
  if (raw > 10000) return raw / 100;
  return raw;
}

// --- Calcular preço PIX com subsídio da Shopee (Política 2026) ---
function calculateShopeePixPrice(price: number): { pixPrice: number; pixDiscount: number } {
  if (price < 80) return { pixPrice: price, pixDiscount: 0 };
  if (price < 500) {
    const pixPrice = Math.round(price * 0.95 * 100) / 100;
    return { pixPrice, pixDiscount: 5 };
  }
  const pixPrice = Math.round(price * 0.92 * 100) / 100;
  return { pixPrice, pixDiscount: 8 };
}

async function fetchShopeeInternalApiSync(config: ScraperConfig, shopId: string, itemId: string): Promise<{ price: number; originalPrice: number | null } | null> {
  const apiUrl = `https://shopee.com.br/api/v4/item/get?shopid=${shopId}&itemid=${itemId}`;
  try {
    const proxyUrl = buildScraperUrlNoJs(config, apiUrl);
    const res = await fetch(proxyUrl);
    if (!res.ok) return null;

    let text = await res.text();
    try {
      const wrapper = JSON.parse(text);
      if (wrapper && typeof wrapper.content === 'string') text = wrapper.content;
    } catch (_e) { /* */ }

    const json = JSON.parse(text);
    const item = json?.data?.item || json?.item || json?.data;
    if (!item) return null;

    const priceMinRaw = item.price_min || item.price || 0;
    const priceBeforeDiscountRaw = item.price_before_discount || item.price_max_before_discount || 0;
    const priceMinBeforeDiscountRaw = item.price_min_before_discount || 0;
    const priceMaxRaw = item.price_max || 0;

    const price = normalizeMicroPrice(priceMinRaw);
    const priceBeforeDiscount = normalizeMicroPrice(priceBeforeDiscountRaw);
    const priceMinBeforeDiscount = normalizeMicroPrice(priceMinBeforeDiscountRaw);
    const priceMax = normalizeMicroPrice(priceMaxRaw);

    let originalPrice: number | null = null;
    const candidates = [priceBeforeDiscount, priceMinBeforeDiscount, priceMax].filter(p => p > 0);
    if (candidates.length > 0) {
      const maxOrig = Math.max(...candidates);
      if (maxOrig > price * 1.01) originalPrice = maxOrig;
    }

    console.log(`[Shopee Sync API] item=${itemId} price=${price} original=${originalPrice}`);
    return { price, originalPrice };
  } catch (err) {
    console.warn(`[Shopee Sync API] Error for ${itemId}:`, err instanceof Error ? err.message : err);
    return null;
  }
}

// --- Extração de preços via Cheerio ---
function parseBRLPrice(text: string): number[] {
  const prices: number[] = [];
  const matches = text.match(/R\$\s?[\d.,]+/g);
  if (matches) {
    for (const m of matches) {
      const cleaned = m.replace("R$", "").replace(/\s/g, "").replace(/\./g, "").replace(",", ".").trim();
      const val = parseFloat(cleaned);
      if (val > 0 && val < 1000000) prices.push(val);
    }
  }
  return prices;
}

function extractPricesFromHtml(html: string, refPrice = 0): { price: number; originalPrice: number | null } {
  const $ = cheerio.load(html);
  const tier1: number[] = [];  // JSON-LD
  const tier2: number[] = [];  // Specific CSS
  const tier3: number[] = [];  // SSR micro-units
  const originalPrices: number[] = [];

  // TIER 1: JSON-LD (most reliable)
  $('script[type="application/ld+json"]').each((_: number, el: cheerio.Element) => {
    try {
      const json = JSON.parse($(el).html() || "");
      if (json?.offers?.price) tier1.push(Number(json.offers.price));
      if (json?.offers?.lowPrice) tier1.push(Number(json.offers.lowPrice));
      if (json?.offers?.highPrice) originalPrices.push(Number(json.offers.highPrice));
      if (Array.isArray(json?.offers)) {
        for (const off of json.offers) {
          if (off?.price) tier1.push(Number(off.price));
          if (off?.lowPrice) tier1.push(Number(off.lowPrice));
          if (off?.highPrice) originalPrices.push(Number(off.highPrice));
        }
      }
    } catch (_e) { /* ignore */ }
  });

  // TIER 2: Specific Shopee CSS selectors ONLY (no generic [class*='price'])
  const specificSelectors = [".pq96Uv", ".IZPeQz", "._44q_F", ".B67UQ0"];
  for (const sel of specificSelectors) {
    $(sel).each((_: number, el: cheerio.Element) => {
      const parentText = $(el).parents().slice(0, 5).text().toLowerCase();
      const isShipping = parentText.includes("frete") || parentText.includes("entrega") || parentText.includes("envio");
      if (!isShipping) {
        tier2.push(...parseBRLPrice($(el).text()));
      }
    });
  }

  const origSelectors = [".v97vId", ".G2799_", "del", "[style*='line-through']"];
  for (const sel of origSelectors) {
    $(sel).each((_: number, el: cheerio.Element) => { originalPrices.push(...parseBRLPrice($(el).text())); });
  }

  // TIER 3: SSR micro-unit prices
  $("script").each((_: number, el: cheerio.Element) => {
    const content = $(el).html() || "";
    if (content.length < 100) return;
    const microPatterns = [
      /"price"\s*:\s*(\d{7,15})/g,
      /"price_min"\s*:\s*(\d{7,15})/g,
      /"price_max"\s*:\s*(\d{7,15})/g,
      /"price_before_discount"\s*:\s*(\d{7,15})/g,
      /"price_min_before_discount"\s*:\s*(\d{7,15})/g,
      /"price_max_before_discount"\s*:\s*(\d{7,15})/g,
    ];
    for (const pattern of microPatterns) {
      let match;
      while ((match = pattern.exec(content)) !== null) {
        const raw = parseInt(match[1]);
        if (raw > 100000) {
          const normalized = raw / 100000;
          if (normalized > 0.5 && normalized < 1000000) {
            if (match[0].includes("before_discount") || match[0].includes("price_max")) {
              originalPrices.push(normalized);
            } else {
              tier3.push(normalized);
            }
          }
        }
      }
    }
  });

  // Pick from tiers with sanity filtering
  const filterValid = (arr: number[]) => arr.filter(p => p >= 1.0 && p < 1000000);
  const sanityFilter = (prices: number[]) => {
    if (refPrice <= 0) return prices;
    return prices.filter(p => p >= refPrice * 0.1);
  };

  const v1 = filterValid(tier1);
  const v2 = filterValid(tier2);
  const v3 = filterValid(tier3);

  let candidates: number[] = [];
  if (v1.length > 0) candidates = sanityFilter(v1);
  if (candidates.length === 0 && v2.length > 0) candidates = sanityFilter(v2);
  if (candidates.length === 0 && v3.length > 0) candidates = sanityFilter(v3);

  const price = candidates.length > 0 ? Math.min(...candidates) : 0;
  const vOrig = filterValid(originalPrices);
  const allForMax = [...candidates, ...vOrig];
  const maxCandidate = allForMax.length > 0 ? Math.max(...allForMax) : 0;
  const originalPrice = maxCandidate > price * 1.01 ? maxCandidate : null;

  return { price, originalPrice };
}

function normalizeShopeePrice(raw: number | string | undefined | null): number {
  const num = Number(raw);
  if (!num || num <= 0) return 0;
  if (num > 100000) return num / 100000;
  return num;
}

// --- Handler Principal ---
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let logId: string | null = null;

  try {
    const body = await req.json().catch(() => ({}));
    const userId = body?.userId || null;
    const productId = body?.productId || null;

    // Log de sync
    const { data: logEntry } = await sb.from("shopee_sync_logs")
      .insert({ sync_type: productId ? "single_sync" : "batch_sync", status: "running", triggered_by: userId })
      .select("id").single();
    logId = logEntry?.id || null;

    // Buscar mappings
    let mappingsQuery = sb.from("shopee_product_mappings")
      .select("*, products(id, title, price, original_price, is_active, sales_count, rating)")
      .eq("sync_status", "active");
    if (productId) mappingsQuery = mappingsQuery.eq("product_id", productId);

    const { data: mappings, error: fetchErr } = await mappingsQuery;
    if (fetchErr) throw fetchErr;

    if (!mappings || mappings.length === 0) {
      if (logId) await sb.from("shopee_sync_logs").update({ status: "success", items_processed: 0, completed_at: new Date().toISOString() }).eq("id", logId);
      return new Response(JSON.stringify({ updated: 0, deactivated: 0, total: 0, details: [] }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Tentar obter scraper config
    const scraperConfig = await getShopeeScraperConfig(sb);
    const CONCURRENCY = 3;
    let totalUpdated = 0;
    let totalDeactivated = 0;
    const details: { id: string; title: string; status: string; oldPrice?: number; newPrice?: number; source?: string }[] = [];
    const syncLogs: string[] = [];

    // Processar em batches
    for (let i = 0; i < mappings.length; i += CONCURRENCY) {
      const batch = mappings.slice(i, i + CONCURRENCY);

      await Promise.all(batch.map(async (mapping: Record<string, unknown>) => {
        const itemId = mapping.shopee_item_id as string;
        const shopId = (mapping.shopee_shop_id as string) || "0";
        const product = mapping.products as Record<string, unknown> | null;
        const productUrl = (mapping.shopee_product_url as string) || `https://shopee.com.br/product/${shopId}/${itemId}`;

        try {
          let basePrice = 0;
          let baseOriginalPrice: number | null = null;
          let source = "none";
          const currentPrice = Number((product as Record<string, unknown>)?.price || 0);

          if (scraperConfig) {
            // === TENTATIVA 1: API INTERNA VIA PROXY (sem JS, mais rápido/barato) ===
            try {
              const apiResult = await fetchShopeeInternalApiSync(scraperConfig, shopId, itemId);
              if (apiResult && apiResult.price > 0) {
                basePrice = apiResult.price;
                baseOriginalPrice = apiResult.originalPrice;
                source = "internal_api";
              }
            } catch (_e) { /* will try HTML next */ }

            // === TENTATIVA 2: HTML SCRAPING (render_js=true) ===
            if (basePrice <= 0) {
              const html = await fetchHtmlViaScraper(scraperConfig, productUrl);
              if (html && html.length > 1000) {
                const scraped = extractPricesFromHtml(html, currentPrice);
                if (scraped.price > 0) {
                  basePrice = scraped.price;
                  baseOriginalPrice = scraped.originalPrice;
                  source = "html_scraping";
                }
              }
            }
          }

          // === TENTATIVA 3: FALLBACK API GRAPHQL ===
          if (basePrice <= 0) {
            try {
              const gqlQuery = `query { productOfferV2(itemId: ${itemId}) { nodes { price priceMin priceMax sales ratingStar } } }`;
              const gqlData = await shopeeGraphQL<{ productOfferV2: { nodes: Record<string, unknown>[] } }>(gqlQuery);
              const node = gqlData?.productOfferV2?.nodes?.[0];
              if (node) {
                const rawMin = normalizeShopeePrice(node.priceMin as number);
                const rawMax = normalizeShopeePrice(node.priceMax as number);
                const rawPrice = normalizeShopeePrice(node.price as number);

                basePrice = rawMin > 0 ? rawMin : rawPrice;
                baseOriginalPrice = rawMax > basePrice ? rawMax : null;
                source = "graphql_api";
              }
            } catch (gqlErr) {
              console.warn(`[Shopee Sync] GraphQL fallback failed for ${itemId}:`, gqlErr);
            }
          }

          if (basePrice <= 0) {
            syncLogs.push(`[${itemId}] Sem preço (scraping + API falharam).`);
            return;
          }

          // === APLICAR SUBSÍDIO PIX ===
          const { pixPrice, pixDiscount } = calculateShopeePixPrice(basePrice);
          const newPrice = pixPrice;
          let newOriginalPrice: number | null = null;
          
          if (pixDiscount > 0 && basePrice > pixPrice) {
            newOriginalPrice = basePrice;
          } else if (baseOriginalPrice && baseOriginalPrice > pixPrice * 1.01) {
            newOriginalPrice = baseOriginalPrice;
          }

          // Comparar e atualizar
          const currentOriginalPrice = Number((product as Record<string, unknown>)?.original_price || 0);
          const updates: Record<string, unknown> = {};

          if (Math.abs(newPrice - currentPrice) > 0.01) {
            updates.price = newPrice;
          }

          if (newOriginalPrice !== null && Math.abs(newOriginalPrice - currentOriginalPrice) > 0.01) {
            updates.original_price = newOriginalPrice;
          } else if (newOriginalPrice === null && currentOriginalPrice > 0) {
            updates.original_price = null;
          }

          // Reativar se inativo
          if (!(product as Record<string, unknown>)?.is_active && newPrice > 0) {
            updates.is_active = true;
            await sb.from("shopee_product_mappings").update({ sync_status: "active" }).eq("id", mapping.id as string);
          }

          let resultStatus = "unchanged";
          if (Object.keys(updates).length > 0) {
            const { error: updateErr } = await sb.from("products").update(updates).eq("id", mapping.product_id as string);
            if (!updateErr) {
              totalUpdated++;
              resultStatus = updates.price !== undefined ? "price_changed" : "updated";

              if (updates.price !== undefined) {
                await sb.from("price_history").insert({
                  product_id: mapping.product_id,
                  old_price: currentPrice,
                  new_price: updates.price,
                  changed_by: userId,
                });
              }

              details.push({
                id: mapping.product_id as string,
                title: (product as Record<string, unknown>)?.title as string || "?",
                status: resultStatus,
                oldPrice: currentPrice,
                newPrice: (updates.price as number) || currentPrice,
                source,
              });
            }
          }

          await sb.from("shopee_product_mappings").update({ last_synced_at: new Date().toISOString() }).eq("id", mapping.id as string);
          syncLogs.push(`[${itemId}] ${resultStatus} (${source}) — R$${currentPrice.toFixed(2)} → R$${newPrice.toFixed(2)}`);
        } catch (e: unknown) {
          const msg = e instanceof Error ? e.message : String(e);
          syncLogs.push(`[${itemId}] Erro: ${msg}`);
        }
      }));
    }

    if (logId) {
      await sb.from("shopee_sync_logs").update({
        status: "success", items_processed: mappings.length, items_updated: totalUpdated,
        items_deactivated: totalDeactivated, completed_at: new Date().toISOString(),
      }).eq("id", logId);
    }

    return new Response(JSON.stringify({
      total: mappings.length, updated: totalUpdated, deactivated: totalDeactivated, details, debug_trace: syncLogs,
    }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Erro interno";
    console.error("shopee-batch-sync error:", err);
    if (logId) {
      await sb.from("shopee_sync_logs").update({ status: "error", error_message: message, completed_at: new Date().toISOString() }).eq("id", logId);
    }
    return new Response(JSON.stringify({ error: message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
