// supabase/functions/_shared/shopee-auth.ts
// Utilitário de autenticação para a Shopee Affiliate Open API (GraphQL)
//
// Na API de Afiliados, a base string para o HMAC-SHA256 é:
//   {app_id}{timestamp}{payload}
// onde payload é o body JSON da requisição GraphQL em formato string.
//
// Variáveis de ambiente: SHOPEE_APP_ID, SHOPEE_APP_SECRET
// Referência: https://affiliate.shopee.com.br/open_api/api-doc

// ─── Tipos ──────────────────────────────────────────────────────────────────

export interface ShopeeAuthParams {
  /** Payload do request (body JSON stringificado da query GraphQL) */
  payload: string;
}

export interface ShopeeAuthHeaders {
  Authorization: string;
  "Content-Type": string;
}

export interface ShopeeSignResult {
  /** URL do endpoint GraphQL */
  url: string;
  /** Cabeçalhos prontos para fetch (Authorization + Content-Type) */
  headers: ShopeeAuthHeaders;
  /** Timestamp usado na assinatura (epoch seconds) */
  timestamp: number;
  /** Assinatura HMAC-SHA256 hex */
  sign: string;
}

// ─── Funções internas ───────────────────────────────────────────────────────

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

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
 * Gera a assinatura e os cabeçalhos de autenticação para a Shopee Affiliate API (GraphQL).
 *
 * A base string para o HMAC-SHA256 segue o padrão da API de Afiliados:
 *   `{app_id}{timestamp}{payload}`
 *
 * @example
 * ```ts
 * import { generateShopeeAuth } from "../_shared/shopee-auth.ts";
 *
 * const body = JSON.stringify({ query: "...", variables: { ... } });
 * const { url, headers } = await generateShopeeAuth({ payload: body });
 *
 * const res = await fetch(url, { method: "POST", headers, body });
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

  const { payload } = params;

  // Timestamp em segundos (epoch)
  const timestamp = Math.floor(Date.now() / 1000);

  // ── Base string (padrão Affiliate GraphQL) ──
  //   app_id + timestamp + payload
  const baseString = `${appId}${timestamp}${payload}`;

  // ── Assinatura HMAC-SHA256 ──
  const sign = await hmacSha256(appSecret, baseString);

  // ── URL do endpoint GraphQL ──
  const shopeeHost =
    Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://affiliate.shopee.com.br";
  const url = `${shopeeHost}/graphql`;

  // ── Cabeçalhos prontos para fetch ──
  const headers: ShopeeAuthHeaders = {
    Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
    "Content-Type": "application/json",
  };

  return { url, headers, timestamp, sign };
}
