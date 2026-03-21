// Edge Function: ml-refresh-token (standalone)
// Refreshes ML access token using refresh_token
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

    if (!ML_APP_ID || !ML_CLIENT_SECRET) {
      throw new Error("ML_APP_ID e ML_CLIENT_SECRET devem estar configurados.");
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Get the most recent token
    const { data: token, error: fetchErr } = await sb
      .from("ml_tokens")
      .select("*")
      .order("updated_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (fetchErr || !token) {
      return new Response(JSON.stringify({ error: "Nenhum token encontrado. Faça a autorização OAuth primeiro." }), {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Check if token is still valid (with 5 min buffer)
    const expiresAt = new Date(token.expires_at).getTime();
    if (Date.now() < expiresAt - 5 * 60 * 1000) {
      return new Response(JSON.stringify({ success: true, access_token: token.access_token, already_valid: true }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Refresh the token
    const tokenRes = await fetch("https://api.mercadolibre.com/oauth/token", {
      method: "POST",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify({
        grant_type: "refresh_token",
        client_id: ML_APP_ID,
        client_secret: ML_CLIENT_SECRET,
        refresh_token: token.refresh_token,
      }),
    });

    const tokenData = await tokenRes.json();

    if (!tokenRes.ok || !tokenData.access_token) {
      console.error("ML token refresh failed:", tokenData);
      return new Response(JSON.stringify({ error: "Falha ao renovar token", details: tokenData }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const newExpiresAt = new Date(Date.now() + tokenData.expires_in * 1000).toISOString();

    await sb.from("ml_tokens").update({
      access_token: tokenData.access_token,
      refresh_token: tokenData.refresh_token,
      expires_at: newExpiresAt,
      updated_at: new Date().toISOString(),
    }).eq("id", token.id);

    return new Response(JSON.stringify({ success: true, access_token: tokenData.access_token }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("ml-refresh-token error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
