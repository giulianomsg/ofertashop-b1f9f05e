// supabase/functions/send-newsletter/index.ts
// Supabase Edge Function — Processador da Fila de E-mails
//
// Busca emails pendentes na tabela email_queue (status = 'pending'),
// envia via serviço de transporte configurável (Resend por padrão),
// e marca cada registro como 'sent' ou 'failed'.
//
// CONFIGURAÇÃO (Supabase Secrets):
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
//   RESEND_API_KEY  — Chave da API do Resend (https://resend.com)
//   EMAIL_FROM      — Remetente (ex: "OfertaShop <noreply@ofertashop.com.br>")
//
// CRON (pg_cron — a cada 5 minutos):
//   SELECT cron.schedule('send-newsletter-queue', '*/5 * * * *',
//     $$SELECT extensions.http_post(
//       'https://<project>.supabase.co/functions/v1/send-newsletter',
//       '{}', 'application/json',
//       ARRAY[extensions.http_header('Authorization', 'Bearer <SERVICE_ROLE_KEY>')]
//     )$$
//   );

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const BATCH_SIZE = 50;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const resendApiKey = Deno.env.get("RESEND_API_KEY") || "";
    const emailFrom = Deno.env.get("EMAIL_FROM") || "OfertaShop <noreply@ofertashop.com.br>";

    const supabase = createClient(supabaseUrl, supabaseKey, {
      auth: { persistSession: false },
    });

    // ── Buscar emails pendentes ──
    const { data: pendingEmails, error: fetchErr } = await (supabase as any)
      .from("email_queue")
      .select("id, user_id, subject, html_content")
      .eq("status", "pending")
      .order("created_at", { ascending: true })
      .limit(BATCH_SIZE);

    if (fetchErr) {
      console.error("[send] Fetch error:", fetchErr);
      return new Response(JSON.stringify({ error: fetchErr.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    if (!pendingEmails || pendingEmails.length === 0) {
      return new Response(
        JSON.stringify({ success: true, message: "Nenhum e-mail pendente.", processed: 0 }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    console.log(`[send] Processing ${pendingEmails.length} email(s)...`);

    let sent = 0;
    let failed = 0;

    for (const email of pendingEmails) {
      try {
        // Resolve user email via admin API
        const { data: userData, error: userErr } = await supabase.auth.admin.getUserById(email.user_id);

        if (userErr || !userData?.user?.email) {
          console.warn(`[send] Cannot resolve email for user ${email.user_id}:`, userErr?.message);
          await updateStatus(supabase, email.id, "failed");
          failed++;
          continue;
        }

        const recipientEmail = userData.user.email;

        // ── Send via Resend ──
        if (resendApiKey) {
          const resendRes = await fetch("https://api.resend.com/emails", {
            method: "POST",
            headers: {
              "Authorization": `Bearer ${resendApiKey}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              from: emailFrom,
              to: [recipientEmail],
              subject: email.subject,
              html: email.html_content,
            }),
          });

          if (!resendRes.ok) {
            const errBody = await resendRes.text();
            console.error(`[send] Resend error for ${recipientEmail}:`, errBody);
            await updateStatus(supabase, email.id, "failed");
            failed++;
            continue;
          }
        } else {
          // ── Modo placeholder: sem serviço de e-mail configurado ──
          // Apenas marca como enviado para teste.
          // Configure RESEND_API_KEY para envio real.
          console.log(`[send] [PLACEHOLDER] Would send to: ${recipientEmail} | Subject: ${email.subject}`);
        }

        await updateStatus(supabase, email.id, "sent");
        sent++;
      } catch (err) {
        console.error(`[send] Error processing email ${email.id}:`, err);
        await updateStatus(supabase, email.id, "failed");
        failed++;
      }
    }

    const result = {
      success: true,
      processed: pendingEmails.length,
      sent,
      failed,
    };

    console.log("[send] Complete:", JSON.stringify(result));
    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[send] Unexpected error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error", detail: String(err) }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

async function updateStatus(supabase: any, id: string, status: string) {
  const updates: any = { status };
  if (status === "sent") updates.sent_at = new Date().toISOString();
  const { error } = await supabase.from("email_queue").update(updates).eq("id", id);
  if (error) console.error(`[send] Failed to update status for ${id}:`, error);
}
