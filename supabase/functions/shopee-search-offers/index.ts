// Edge Function: shopee-search-offers — Refatorado: API Interna JSON + API Oficial para comissão
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// --- Shopee Affiliate GraphQL (apenas para comissão e link) ---
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
  const url = `${shopeeHost}/graphql`;

  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
      "Content-Type": "application/json",
    },
    body: new TextEncoder().encode(payloadStr),
  });

  const json = await res.json();
  if (json.errors?.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors.map((e: { message: string }) => e.message).join(", ")}`);
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
  throw new Error(`Scraper provider desconhecido: ${provider}`);
}

async function getActiveScraperConfig(sb: ReturnType<typeof createClient>): Promise<ScraperConfig> {
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
  throw new Error("Nenhum serviço de Web Scraper configurado.");
}

async function fetchJsonViaScraper(scraperConfig: ScraperConfig, targetUrl: string, maxRetries = 2): Promise<unknown> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const proxyUrl = buildScraperUrl(scraperConfig, targetUrl);
      const res = await fetch(proxyUrl);
      if (res.ok) {
        let text = await res.text();
        // Some scrapers wrap the response in { content: "..." }
        try {
          const wrapper = JSON.parse(text);
          if (wrapper && typeof wrapper.content === 'string') text = wrapper.content;
        } catch (_e) { /* raw response */ }
        return JSON.parse(text);
      }
    } catch (err) {
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000 * Math.pow(2, i)));
  }
  throw new Error("Falha ao buscar dados da Shopee.");
}

// --- Normalizar preço Shopee (vem em micro-unidades: valor * 100000) ---
function normalizeShopeePrice(raw: number): number {
  if (!raw || raw <= 0) return 0;
  if (raw > 100000) return raw / 100000;
  return raw;
}

// --- Handler Principal ---
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: corsHeaders });

  try {
    const { keyword, page = 1, limit = 20, sortType = 2 } = await req.json();
    if (!keyword || typeof keyword !== "string") {
      return new Response(JSON.stringify({ error: "keyword é obrigatório" }), {
        status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    // 1. Detectar se é URL direta de produto
    const urlMatch = keyword.match(/i\.(\d+)\.(\d+)/) || keyword.match(/product\/(\d+)\/(\d+)/);

    if (urlMatch) {
      // Busca direta via API Oficial (já retorna comissão)
      const itemId = urlMatch[2];
      const query = `
        query {
          productOfferV2(itemId: ${itemId}) {
            nodes {
              itemId shopId productName price priceMin priceMax imageUrl productLink
              commission commissionRate sales ratingStar shopName offerLink
              periodStartTime periodEndTime appExistRate appNewRate webExistRate webNewRate
              productCatIds priceDiscountRate shopType sellerCommissionRate shopeeCommissionRate
            }
          }
        }
      `;
      const data = await shopeeGraphQL<{ productOfferV2: { nodes: unknown[] } }>(query);
      const offers = data?.productOfferV2?.nodes || [];

      const itemIds = offers.map((o: Record<string, unknown>) => String(o.itemId));
      const { data: existing } = await sb.from("shopee_product_mappings").select("shopee_item_id").in("shopee_item_id", itemIds);
      const importedSet = new Set((existing || []).map((m: { shopee_item_id: string }) => m.shopee_item_id));

      const enriched = offers.map((o: Record<string, unknown>) => ({ ...o, already_imported: importedSet.has(String(o.itemId)) }));

      return new Response(JSON.stringify({ offers: enriched, pageInfo: { page: 1, limit: 1, hasNextPage: false } }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 2. Busca por keyword via API Interna da Shopee
    const scraperConfig = await getActiveScraperConfig(sb);
    const offset = (page - 1) * limit;

    // Mapear sortType para o parâmetro da API interna
    const sortByMap: Record<number, string> = { 1: "relevancy", 2: "ctime", 3: "sales", 4: "price", 5: "price", 6: "relevancy" };
    const orderMap: Record<number, string> = { 1: "desc", 2: "desc", 3: "desc", 4: "asc", 5: "desc", 6: "desc" };
    const by = sortByMap[sortType] || "relevancy";
    const order = orderMap[sortType] || "desc";

    const searchUrl = `https://shopee.com.br/api/v4/search/search_items?by=${by}&keyword=${encodeURIComponent(keyword)}&limit=${limit}&newest=${offset}&order=${order}&page_type=search&scenario=PAGE_GLOBAL_SEARCH&version=2`;

    console.log(`[Shopee Search] Buscando via API interna: ${searchUrl}`);

    interface ShopeeSearchItem {
      itemid: number;
      shopid: number;
      name: string;
      price: number;
      price_min: number;
      price_max: number;
      price_before_discount: number;
      price_min_before_discount: number;
      price_max_before_discount: number;
      image: string;
      images: string[];
      item_rating: { rating_star: number; rating_count: number[] };
      sold: number;
      historical_sold: number;
      shop_name: string;
      liked_count: number;
      discount: string;
    }

    const searchData = await fetchJsonViaScraper(scraperConfig, searchUrl) as { items?: { item_basic: ShopeeSearchItem }[] };
    const items: ShopeeSearchItem[] = (searchData?.items || []).map((i: { item_basic: ShopeeSearchItem }) => i.item_basic);

    if (items.length === 0) {
      return new Response(JSON.stringify({ offers: [], pageInfo: { page, limit, hasNextPage: false } }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 3. Enriquecer com dados de comissão via API Oficial (batch)
    const commissionMap = new Map<string, Record<string, unknown>>();
    try {
      const batchIds = items.map((i) => String(i.itemid));
      const aliasQueries = batchIds.map((id) => `
        item_${id}: productOfferV2(itemId: ${id}) {
          nodes { itemId commissionRate commission offerLink shopName appExistRate appNewRate webExistRate webNewRate priceDiscountRate shopType sellerCommissionRate shopeeCommissionRate periodStartTime periodEndTime }
        }
      `).join("\n");

      const commData = await shopeeGraphQL<Record<string, { nodes: Record<string, unknown>[] }>>(`query { ${aliasQueries} }`);
      for (const [, val] of Object.entries(commData || {})) {
        const nodes = val?.nodes || [];
        for (const node of nodes) {
          commissionMap.set(String(node.itemId), node);
        }
      }
    } catch (e) {
      console.warn("[Shopee Search] Falha ao buscar comissões via API Oficial (continuando sem):", e);
    }

    // 4. Montar resultados
    const offers = items.map((item) => {
      const comm = commissionMap.get(String(item.itemid)) || {};
      const price = normalizeShopeePrice(item.price);
      const priceMin = normalizeShopeePrice(item.price_min);
      const priceMax = normalizeShopeePrice(item.price_max);
      const priceBeforeDiscount = normalizeShopeePrice(item.price_before_discount || item.price_max_before_discount || 0);
      const imageUrl = item.image ? `https://down-br.img.susercontent.com/file/${item.image}` : "";
      const productLink = `https://shopee.com.br/product/${item.shopid}/${item.itemid}`;

      return {
        itemId: String(item.itemid),
        shopId: String(item.shopid),
        productName: item.name,
        price: priceBeforeDiscount > 0 ? priceBeforeDiscount : (priceMax > 0 ? priceMax : price),
        priceMin: priceMin > 0 ? priceMin : price,
        priceMax: priceBeforeDiscount > 0 ? priceBeforeDiscount : priceMax,
        pricePromotional: price > 0 ? price : priceMin,
        imageUrl,
        productLink,
        commission: Number(comm.commission) || 0,
        commissionRate: Number(comm.commissionRate) || 0,
        sales: item.historical_sold || item.sold || 0,
        ratingStar: item.item_rating?.rating_star || 0,
        shopName: item.shop_name || String(comm.shopName) || "Shopee",
        offerLink: String(comm.offerLink || ""),
        discount: item.discount || null,
        // Dados extras de comissão
        appExistRate: Number(comm.appExistRate) || 0,
        appNewRate: Number(comm.appNewRate) || 0,
        webExistRate: Number(comm.webExistRate) || 0,
        webNewRate: Number(comm.webNewRate) || 0,
        priceDiscountRate: Number(comm.priceDiscountRate) || 0,
        shopType: Number(comm.shopType) || 0,
        sellerCommissionRate: Number(comm.sellerCommissionRate) || 0,
        shopeeCommissionRate: Number(comm.shopeeCommissionRate) || 0,
        periodStartTime: Number(comm.periodStartTime) || 0,
        periodEndTime: Number(comm.periodEndTime) || 0,
      };
    });

    // 5. Marcar já importados
    const itemIds = offers.map((o) => o.itemId);
    const { data: existingMappings } = await sb.from("shopee_product_mappings").select("shopee_item_id").in("shopee_item_id", itemIds);
    const importedSet = new Set((existingMappings || []).map((m: { shopee_item_id: string }) => m.shopee_item_id));

    const enriched = offers.map((o) => ({ ...o, already_imported: importedSet.has(o.itemId) }));

    return new Response(JSON.stringify({
      offers: enriched,
      pageInfo: { page, limit, hasNextPage: items.length >= limit },
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : "Erro interno";
    console.error("shopee-search-offers error:", err);
    return new Response(JSON.stringify({ error: message }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
