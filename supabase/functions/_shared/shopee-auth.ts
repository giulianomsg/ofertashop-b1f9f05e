// supabase/functions/_shared/shopee-auth.ts
// Autenticação para a Shopee Affiliate Open API (GraphQL)
//
// ⚠️ A API de Afiliados da Shopee NÃO usa HMAC.
// A assinatura é um SHA-256 digest simples da concatenação:
//   appId + timestamp + payload + appSecret
//
// Variáveis de ambiente: SHOPEE_APP_ID, SHOPEE_APP_SECRET, SHOPEE_API_BASE_URL

export interface ShopeeAuthHeaders {
  Authorization: string;
  "Content-Type": string;
}

export interface ShopeeSignResult {
  url: string;
  headers: ShopeeAuthHeaders;
  timestamp: number;
  sign: string;
}

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hash);
}

/**
 * Gera assinatura SHA-256 e headers para a Shopee Affiliate API.
 * 
 * Base string: `${appId}${timestamp}${payload}${appSecret}`
 * Header: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`
 */
export async function generateShopeeAuth(payload: string): Promise<ShopeeSignResult> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");

  if (!appId || !appSecret) {
    throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");
  }

  const timestamp = Math.floor(Date.now() / 1000);
  const factor = `${appId}${timestamp}${payload}${appSecret}`;
  const sign = await sha256Hex(factor);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://open-api.affiliate.shopee.com.br";
  const url = `${shopeeHost}/graphql`;

  const headers: ShopeeAuthHeaders = {
    Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
    "Content-Type": "application/json",
  };

  return { url, headers, timestamp, sign };
}

/**
 * Helper: executa uma query GraphQL na Shopee com assinatura automática.
 * Retorna o JSON da resposta ou lança erro.
 */
export async function shopeeGraphQL<T = any>(query: string, variables: Record<string, any> = {}): Promise<T> {
  const payloadStr = JSON.stringify({ query, variables });
  const { url, headers } = await generateShopeeAuth(payloadStr);
  const payloadBytes = new TextEncoder().encode(payloadStr);

  const res = await fetch(url, {
    method: "POST",
    headers,
    body: payloadBytes,
  });

  const json = await res.json();

  if (json.errors && json.errors.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors.map((e: any) => e.message).join(", ")}`);
  }

  return json.data as T;
}
