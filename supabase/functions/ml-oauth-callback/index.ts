// Edge Function: ml-oauth-callback (standalone)
// Handles OAuth callback from Mercado Livre and stores tokens
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const ML_APP_ID = Deno.env.get("ML_APP_ID");
    const ML_CLIENT_SECRET = Deno.env.get("ML_CLIENT_SECRET");
    const ML_REDIRECT_URI = Deno.env.get("ML_REDIRECT_URI");

    if (!ML_APP_ID || !ML_CLIENT_SECRET || !ML_REDIRECT_URI) {
      throw new Error("ML_APP_ID, ML_CLIENT_SECRET e ML_REDIRECT_URI devem estar configurados.");
    }

    const { code, userId, redirect_uri } = await req.json();
    // Allow frontend to pass the redirect_uri used in the initial authorization
    const finalRedirectUri = redirect_uri || ML_REDIRECT_URI;

    if (!code) {
      return new Response(JSON.stringify({ error: "Código de autorização é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Exchange code for token
    const tokenRes = await fetch("https://api.mercadolibre.com/oauth/token", {
      method: "POST",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify({
        grant_type: "authorization_code",
        client_id: ML_APP_ID,
        client_secret: ML_CLIENT_SECRET,
        code,
        redirect_uri: ML_REDIRECT_URI,
      }),
    });

    const tokenData = await tokenRes.json();

    if (!tokenRes.ok || !tokenData.access_token) {
      console.error("ML token exchange failed:", tokenData);
      return new Response(JSON.stringify({ error: "Falha ao obter token", details: tokenData }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    const expiresAt = new Date(Date.now() + tokenData.expires_in * 1000).toISOString();

    // Upsert token (one per user)
    const { error: upsertErr } = await sb
      .from("ml_tokens")
      .upsert(
        {
          user_id: userId || "00000000-0000-0000-0000-000000000000",
          access_token: tokenData.access_token,
          refresh_token: tokenData.refresh_token,
          expires_at: expiresAt,
          ml_user_id: String(tokenData.user_id || ""),
          updated_at: new Date().toISOString(),
        },
        { onConflict: "user_id" }
      );

    if (upsertErr) {
      // If upsert fails (no unique constraint on user_id), try delete+insert
      await sb.from("ml_tokens").delete().eq("user_id", userId || "00000000-0000-0000-0000-000000000000");
      await sb.from("ml_tokens").insert({
        user_id: userId || "00000000-0000-0000-0000-000000000000",
        access_token: tokenData.access_token,
        refresh_token: tokenData.refresh_token,
        expires_at: expiresAt,
        ml_user_id: String(tokenData.user_id || ""),
      });
    }

    return new Response(JSON.stringify({ success: true, ml_user_id: tokenData.user_id }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("ml-oauth-callback error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
