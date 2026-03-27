// supabase/functions/send-newsletter/index.ts
// Processador da Fila de E-mails — uses Lovable AI Gateway if no RESEND_API_KEY
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const BATCH_SIZE = 50;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
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

    // Allow manual trigger with specific action
    let body: any = {};
    try { body = await req.json(); } catch { /* empty body ok */ }

    // If action is "queue_newsletter", queue emails for a specific newsletter
    if (body.action === "queue_newsletter" && body.newsletterId) {
      const { data: newsletter } = await supabase
        .from("newsletters")
        .select("*")
        .eq("id", body.newsletterId)
        .single();

      if (!newsletter) throw new Error("Newsletter não encontrada");

      // Get subscribers
      const { data: subs } = await supabase
        .from("profiles")
        .select("user_id")
        .eq("newsletter_opt_in", true);

      if (!subs || subs.length === 0) {
        return new Response(JSON.stringify({ success: true, message: "Nenhum assinante", queued: 0 }), {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // Get associated products
      const { data: pivotData } = await supabase
        .from("newsletter_products")
        .select("product_id")
        .eq("newsletter_id", body.newsletterId);

      let productsHTML = "";
      if (pivotData && pivotData.length > 0) {
        const productIds = pivotData.map((p: any) => p.product_id);
        const { data: products } = await supabase
          .from("products")
          .select("*")
          .in("id", productIds);

        if (products && products.length > 0) {
          productsHTML = `
            <table style="width:100%;max-width:600px;margin:20px auto;border-collapse:collapse;font-family:sans-serif;">
              <tbody>
                ${products.map((p: any) => `
                  <tr>
                    <td style="padding:15px;border-bottom:1px solid #eee;text-align:left;vertical-align:top;">
                      <img src="${p.image_url || 'https://via.placeholder.com/120'}" alt="${p.title}" style="width:120px;border-radius:8px;">
                    </td>
                    <td style="padding:15px;border-bottom:1px solid #eee;text-align:left;vertical-align:top;">
                      <h3 style="margin:0 0 10px;font-size:16px;color:#333;">${p.title}</h3>
                      <p style="margin:0 0 10px;font-size:18px;font-weight:bold;color:#e11d48;">R$ ${Number(p.price).toFixed(2).replace('.', ',')}</p>
                      <a href="${p.affiliate_url}" style="display:inline-block;padding:10px 20px;background:#3b82f6;color:#fff;text-decoration:none;border-radius:5px;font-weight:bold;">Ver Oferta</a>
                    </td>
                  </tr>
                `).join('')}
              </tbody>
            </table>
          `;
        }
      }

      const fullHtml = (newsletter.html_content || "") + productsHTML;
      const queueData = subs.map((sub: any) => ({
        user_id: sub.user_id,
        subject: newsletter.subject,
        html_content: fullHtml,
        status: "pending",
      }));

      const { error: queueError } = await supabase.from("email_queue").insert(queueData);
      if (queueError) throw queueError;

      await supabase.from("newsletters").update({ status: "sent" }).eq("id", body.newsletterId);

      return new Response(JSON.stringify({ success: true, queued: subs.length }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Default action: process pending emails in queue
    const { data: pendingEmails, error: fetchErr } = await supabase
      .from("email_queue")
      .select("id, user_id, subject, html_content")
      .eq("status", "pending")
      .order("created_at", { ascending: true })
      .limit(BATCH_SIZE);

    if (fetchErr) throw fetchErr;

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
        const { data: userData, error: userErr } = await supabase.auth.admin.getUserById(email.user_id);

        if (userErr || !userData?.user?.email) {
          console.warn(`[send] Cannot resolve email for user ${email.user_id}`);
          await supabase.from("email_queue").update({ status: "failed" }).eq("id", email.id);
          failed++;
          continue;
        }

        const recipientEmail = userData.user.email;

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
            await supabase.from("email_queue").update({ status: "failed" }).eq("id", email.id);
            failed++;
            continue;
          }
        } else {
          console.log(`[send] [NO_PROVIDER] Would send to: ${recipientEmail} | Subject: ${email.subject}`);
        }

        await supabase.from("email_queue").update({ status: "sent" }).eq("id", email.id);
        sent++;
      } catch (err) {
        console.error(`[send] Error processing email ${email.id}:`, err);
        await supabase.from("email_queue").update({ status: "failed" }).eq("id", email.id);
        failed++;
      }
    }

    return new Response(JSON.stringify({ success: true, processed: pendingEmails.length, sent, failed }), {
      status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("[send] Unexpected error:", err);
    return new Response(
      JSON.stringify({ error: err.message || "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
