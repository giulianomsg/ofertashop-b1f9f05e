// supabase/functions/_shared/shopee-auth.ts
// Utilitário de autenticação para a Shopee Open API (Affiliate / Open Platform)
//
// Gera o timestamp e a assinatura HMAC-SHA256 exigidos pela API.
// Utiliza as variáveis de ambiente SHOPEE_APP_ID e SHOPEE_APP_SECRET.
//
// Referência: https://open.shopee.com/documents/v2/OpenAPI%202.0%20Overview

// ─── Tipos ──────────────────────────────────────────────────────────────────

export interface ShopeeAuthParams {
  /** Caminho completo do endpoint (ex.: "/api/v2/product/get_item_list") */
  apiPath: string;
  /** Payload do request (body) — usado apenas em POST; para GET, passar string vazia ou omitir */
  payload?: string;
}

export interface ShopeeAuthHeaders {
  Authorization: string;
  "Content-Type": string;
  /** Timestamp em segundos (epoch) */
  timestamp: string;
  /** ID da app para cabeçalhos que o exijam */
  partner_id: string;
}

export interface ShopeeSignResult {
  /** URL final (base + path + query params de auth) */
  url: string;
  /** Cabeçalhos prontos para fetch */
  headers: ShopeeAuthHeaders;
  /** Timestamp usado na assinatura (epoch seconds) */
  timestamp: number;
  /** Assinatura HMAC-SHA256 hex */
  sign: string;
}

// ─── Funções internas ───────────────────────────────────────────────────────

/**
 * Converte um ArrayBuffer para string hexadecimal.
 */
function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * Gera uma assinatura HMAC-SHA256 usando a Web Crypto API (disponível no Deno).
 *
 * @param secret  - Chave secreta (SHOPEE_APP_SECRET)
 * @param message - A string base usada para gerar o sign
 * @returns Hex string da assinatura
 */
async function hmacSha256(secret: string, message: string): Promise<string> {
  const encoder = new TextEncoder();
  const keyData = encoder.encode(secret);
  const msgData = encoder.encode(message);

  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    keyData,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signature = await crypto.subtle.sign("HMAC", cryptoKey, msgData);
  return bufferToHex(signature);
}

// ─── Função principal ───────────────────────────────────────────────────────

/**
 * Gera a assinatura e os cabeçalhos de autenticação para um request à Shopee Open API.
 *
 * A base string para o HMAC é, por convenção da Shopee:
 *   `{partner_id}{api_path}{timestamp}`
 *
 * Para endpoints que exigem access_token ou shop_id, concatena-se adicionalmente
 * esses valores à base string. Consulte a documentação oficial para detalhes.
 *
 * @example
 * ```ts
 * import { generateShopeeAuth } from "./_shared/shopee-auth.ts";
 *
 * const { url, headers } = await generateShopeeAuth({
 *   apiPath: "/api/v2/product/get_item_list",
 * });
 *
 * const res = await fetch(url, { method: "GET", headers });
 * ```
 */
export async function generateShopeeAuth(
  params: ShopeeAuthParams,
): Promise<ShopeeSignResult> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");

  if (!appId || !appSecret) {
    throw new Error(
      "As variáveis de ambiente SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.",
    );
  }

  const { apiPath, payload: _payload } = params;

  // Timestamp em segundos (epoch)
  const timestamp = Math.floor(Date.now() / 1000);

  // ── Base string ──
  // Formato padrão da Shopee Open API v2:
  //   partner_id + api_path + timestamp
  const baseString = `${appId}${apiPath}${timestamp}`;

  // ── Assinatura HMAC-SHA256 ──
  const sign = await hmacSha256(appSecret, baseString);

  // ── URL final com query params de autenticação ──
  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://partner.shopeemobile.com";
  const separator = apiPath.includes("?") ? "&" : "?";
  const url = `${shopeeHost}${apiPath}${separator}partner_id=${appId}&timestamp=${timestamp}&sign=${sign}`;

  // ── Cabeçalhos prontos para fetch ──
  const headers: ShopeeAuthHeaders = {
    Authorization: sign,
    "Content-Type": "application/json",
    timestamp: String(timestamp),
    partner_id: appId,
  };

  return { url, headers, timestamp, sign };
}

/**
 * Variante que inclui access_token e shop_id na base string.
 * Necessária para endpoints autenticados em nome de uma loja.
 *
 * Base string: `{partner_id}{api_path}{timestamp}{access_token}{shop_id}`
 */
export async function generateShopeeAuthWithShop(
  params: ShopeeAuthParams & { accessToken: string; shopId: number },
): Promise<ShopeeSignResult> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");

  if (!appId || !appSecret) {
    throw new Error(
      "As variáveis de ambiente SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.",
    );
  }

  const { apiPath, accessToken, shopId } = params;

  const timestamp = Math.floor(Date.now() / 1000);

  // Base string com access_token e shop_id
  const baseString = `${appId}${apiPath}${timestamp}${accessToken}${shopId}`;

  const sign = await hmacSha256(appSecret, baseString);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://partner.shopeemobile.com";
  const separator = apiPath.includes("?") ? "&" : "?";
  const url =
    `${shopeeHost}${apiPath}${separator}partner_id=${appId}&timestamp=${timestamp}&sign=${sign}&access_token=${accessToken}&shop_id=${shopId}`;

  const headers: ShopeeAuthHeaders = {
    Authorization: sign,
    "Content-Type": "application/json",
    timestamp: String(timestamp),
    partner_id: appId,
  };

  return { url, headers, timestamp, sign };
}
