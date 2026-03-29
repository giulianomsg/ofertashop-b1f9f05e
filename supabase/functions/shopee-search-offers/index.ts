// Edge Function: shopee-search-offers — Usa API Oficial GraphQL (productOfferV2)
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

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

// --- Normalizar preço Shopee (API retorna micro-unidades: valor * 100000) ---
function normalizeShopeePrice(raw: number | string | undefined | null): number {
  const num = Number(raw);
  if (!num || num <= 0) return 0;
  // Preços da API Oficial vêm em micro-unidades (ex: 28491000000 = R$ 284.91)
  if (num > 100000) return num / 100000;
  return num;
}

// --- Mapear sortType numérico para o sortType da API GraphQL ---
function mapSortType(sortType: number): number {
  // API Shopee Affiliate: 1=relevância, 2=comissão, 3=vendas, 4=preço asc, 5=preço desc, 6=avaliação
  return sortType;
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

    let offers: Record<string, unknown>[] = [];
    let hasNextPage = false;

    if (urlMatch) {
      // Busca direta por itemId
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
      const data = await shopeeGraphQL<{ productOfferV2: { nodes: Record<string, unknown>[] } }>(query);
      offers = data?.productOfferV2?.nodes || [];
    } else {
      // Busca por keyword via API Oficial GraphQL (productOfferV2)
      const gqlSortType = mapSortType(sortType);
      const query = `
        query {
          productOfferV2(
            keyword: "${keyword.replace(/"/g, '\\"')}"
            sortType: ${gqlSortType}
            limit: ${limit}
            page: ${page}
          ) {
            nodes {
              itemId shopId productName price priceMin priceMax imageUrl productLink
              commission commissionRate sales ratingStar shopName offerLink
              periodStartTime periodEndTime appExistRate appNewRate webExistRate webNewRate
              productCatIds priceDiscountRate shopType sellerCommissionRate shopeeCommissionRate
            }
            pageInfo {
              page
              limit
              hasNextPage
            }
          }
        }
      `;

      console.log(`[Shopee Search] Buscando via GraphQL: keyword="${keyword}", sort=${gqlSortType}, page=${page}`);

      const data = await shopeeGraphQL<{
        productOfferV2: {
          nodes: Record<string, unknown>[];
          pageInfo?: { page?: number; limit?: number; hasNextPage?: boolean };
        };
      }>(query);

      offers = data?.productOfferV2?.nodes || [];
      hasNextPage = data?.productOfferV2?.pageInfo?.hasNextPage || false;
    }

    // 2. Normalizar os preços dos resultados
    const normalized = offers.map((o) => {
      const rawPrice = normalizeShopeePrice(o.price as number);
      const rawPriceMin = normalizeShopeePrice(o.priceMin as number);
      const rawPriceMax = normalizeShopeePrice(o.priceMax as number);

      // priceMin = preço promocional/atual, priceMax = preço original (sem desconto)
      const pricePromotional = rawPriceMin > 0 ? rawPriceMin : rawPrice;
      const priceOriginal = rawPriceMax > 0 ? rawPriceMax : rawPrice;

      return {
        ...o,
        // Preço exibido (atual/promocional)
        price: priceOriginal,
        priceMin: pricePromotional,
        priceMax: priceOriginal,
        pricePromotional: pricePromotional,
        // Calcular desconto
        discount: priceOriginal > pricePromotional && priceOriginal > 0
          ? Math.round(((priceOriginal - pricePromotional) / priceOriginal) * 100)
          : null,
      };
    });

    // 3. Marcar já importados
    const itemIds = normalized.map((o) => String(o.itemId));
    const { data: existingMappings } = await sb
      .from("shopee_product_mappings")
      .select("shopee_item_id")
      .in("shopee_item_id", itemIds);
    const importedSet = new Set((existingMappings || []).map((m: { shopee_item_id: string }) => m.shopee_item_id));

    const enriched = normalized.map((o) => ({
      ...o,
      already_imported: importedSet.has(String(o.itemId)),
    }));

    return new Response(JSON.stringify({
      offers: enriched,
      pageInfo: { page, limit, hasNextPage },
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
