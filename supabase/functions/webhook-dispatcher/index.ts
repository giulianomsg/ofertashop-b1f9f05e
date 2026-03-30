import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ----------------------------------------------------------
// Types
// ----------------------------------------------------------
interface WebhookPayload {
  type: "UPDATE" | "INSERT" | "DELETE";
  table: string;
  schema: string;
  record: Record<string, unknown>;
  old_record: Record<string, unknown>;
}

interface ApiClientRow {
  id: string;
  client_name: string;
  api_key: string;
  webhook_url: string;
  webhook_events: string[];
  is_active: boolean;
}

interface GerashopWebhookPayload {
  event: string;
  timestamp: string;
  data: {
    id: string;
    external_id: string;
    name: string;
    promotional_price: number;
    is_active: boolean;
    changes: Record<string, { old: unknown; new: unknown }>;
  };
}

// ----------------------------------------------------------
// HMAC SHA256 Signature
// ----------------------------------------------------------
async function generateHmacSignature(
  payload: string,
  secret: string,
): Promise<string> {
  const encoder = new TextEncoder();
  const keyData = encoder.encode(secret);
  const msgData = encoder.encode(payload);

  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    keyData,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signature = await crypto.subtle.sign("HMAC", cryptoKey, msgData);

  // Convert ArrayBuffer to hex string
  return Array.from(new Uint8Array(signature))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// ----------------------------------------------------------
// Helpers
// ----------------------------------------------------------
const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

// ----------------------------------------------------------
// Main Server
// ----------------------------------------------------------
Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      return jsonResponse({ error: "Configuração de servidor incompleta." }, 500);
    }

    const sb = createClient(supabaseUrl, serviceRoleKey);

    // Parse the incoming Supabase Database Webhook payload
    const webhookPayload: WebhookPayload = await req.json();
    const { type, record, old_record } = webhookPayload;

    // Only process UPDATE events on the products table
    if (type !== "UPDATE") {
      return jsonResponse({ message: "Evento ignorado (não é UPDATE)." }, 200);
    }

    // Check whether `price` or `is_active` have actually changed
    const priceChanged = record.price !== old_record.price;
    const isActiveChanged = record.is_active !== old_record.is_active;

    if (!priceChanged && !isActiveChanged) {
      return jsonResponse({
        message: "Nenhuma alteração relevante detectada (price / is_active inalterados).",
      }, 200);
    }

    // Fetch all active API clients that have a webhook_url configured
    const { data: clients, error: clientsError } = await sb
      .from("api_clients")
      .select("id, client_name, api_key, webhook_url, webhook_events, is_active")
      .eq("is_active", true)
      .not("webhook_url", "is", null)
      .neq("webhook_url", "");

    if (clientsError) {
      console.error("Erro ao buscar api_clients:", clientsError);
      return jsonResponse({ error: "Erro ao buscar clientes." }, 500);
    }

    if (!clients || clients.length === 0) {
      return jsonResponse({ message: "Nenhum cliente com webhook configurado." }, 200);
    }

    // Build the changes object
    const changes: Record<string, { old: unknown; new: unknown }> = {};
    if (priceChanged) {
      changes.promotional_price = {
        old: old_record.price,
        new: record.price,
      };
    }
    if (isActiveChanged) {
      changes.is_active = {
        old: old_record.is_active,
        new: record.is_active,
      };
    }

    // Build the Gerashop webhook payload
    const gerashopPayload: GerashopWebhookPayload = {
      event: "offer.updated",
      timestamp: new Date().toISOString(),
      data: {
        id: record.id as string,
        external_id: record.id as string,
        name: record.title as string,
        promotional_price: record.price as number,
        is_active: record.is_active as boolean,
        changes,
      },
    };

    const payloadString = JSON.stringify(gerashopPayload);

    // Dispatch webhooks to all eligible clients
    const dispatchResults = await Promise.allSettled(
      (clients as ApiClientRow[]).map(async (client) => {
        // Check if the client is subscribed to offer.updated events
        if (
          !client.webhook_events ||
          !client.webhook_events.includes("offer.updated")
        ) {
          return { clientId: client.id, skipped: true };
        }

        try {
          // Generate HMAC SHA256 signature using the client's api_key
          const signature = await generateHmacSignature(
            payloadString,
            client.api_key,
          );

          // Dispatch the webhook
          const response = await fetch(client.webhook_url, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-Webhook-Signature": signature,
              "X-Webhook-Event": "offer.updated",
            },
            body: payloadString,
            signal: AbortSignal.timeout(10_000), // 10s timeout
          });

          const statusCode = response.status;
          let responseBody = "";
          try {
            responseBody = await response.text();
          } catch {
            responseBody = "Não foi possível ler a resposta.";
          }

          // Log the result
          await sb.from("webhook_logs").insert({
            api_client_id: client.id,
            endpoint_url: client.webhook_url,
            payload: gerashopPayload,
            status_code: statusCode,
            response_body: responseBody.substring(0, 1000), // Limit stored response
          });

          console.log(
            `Webhook enviado para ${client.client_name} (${client.webhook_url}): ${statusCode}`,
          );

          return { clientId: client.id, statusCode };
        } catch (fetchError: unknown) {
          const errorMessage =
            fetchError instanceof Error
              ? fetchError.message
              : "Erro desconhecido";

          console.error(
            `Falha ao enviar webhook para ${client.client_name}:`,
            errorMessage,
          );

          // Log the failure
          await sb.from("webhook_logs").insert({
            api_client_id: client.id,
            endpoint_url: client.webhook_url,
            payload: gerashopPayload,
            status_code: 0,
            response_body: `Erro: ${errorMessage}`.substring(0, 1000),
          });

          return { clientId: client.id, error: errorMessage };
        }
      }),
    );

    return jsonResponse({
      message: "Webhooks processados.",
      results: dispatchResults.map((r) =>
        r.status === "fulfilled" ? r.value : { error: r.reason },
      ),
    }, 200);
  } catch (err: unknown) {
    const message =
      err instanceof Error ? err.message : "Erro interno desconhecido.";
    console.error("webhook-dispatcher error:", err);
    return jsonResponse({ error: message }, 500);
  }
});
