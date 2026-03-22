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
      throw new Error("ML_APP_ID ou ML_CLIENT_SECRET ausentes no .env");
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    if (req.method === "GET") {
      const url = new URL(req.url);
      const action = url.searchParams.get("action");
      const redirectUri = url.searchParams.get("redirect_uri");
      
      if (action === "auth_url" && redirectUri) {
        const authUrl = `https://auth.mercadolivre.com.br/authorization?response_type=code&client_id=${ML_APP_ID}&redirect_uri=${encodeURIComponent(redirectUri)}`;
        return new Response(JSON.stringify({ url: authUrl }), {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      throw new Error("Ação não reconhecida ou redirect_uri ausente.");
    }

    if (req.method === "POST") {
      const body = await req.json();
      const code = body.code;
      const redirectUri = body.redirect_uri;

      if (!code || !redirectUri) {
         throw new Error(`Parâmetros code ou redirect_uri ausentes. Recebido: ${JSON.stringify(body)}`);
      }

      const tokenRes = await fetch("https://api.mercadolibre.com/oauth/token", {
        method: "POST",
        headers: { "Content-Type": "application/json", Accept: "application/json" },
        body: JSON.stringify({
          grant_type: "authorization_code",
          client_id: ML_APP_ID,
          client_secret: ML_CLIENT_SECRET,
          code: code,
          redirect_uri: redirectUri,
        }),
      });

      const tokenData = await tokenRes.json();
      if (!tokenRes.ok || !tokenData.access_token) {
        throw new Error(`Falha OAuth: ${tokenData.message || JSON.stringify(tokenData)}`);
      }

      const newExpiresAt = new Date(Date.now() + tokenData.expires_in * 1000).toISOString();
      const payload = {
        access_token: tokenData.access_token,
        refresh_token: tokenData.refresh_token,
        expires_at: newExpiresAt,
        updated_at: new Date().toISOString()
      };

      const { data: latest } = await sb.from("ml_tokens").select("id").order("updated_at", { ascending: false }).limit(1).maybeSingle();

      if (latest) {
        await sb.from("ml_tokens").update(payload).eq("id", latest.id);
      } else {
        await sb.from("ml_tokens").insert([payload]);
      }

      return new Response(JSON.stringify({ success: true, message: "Autorização concluída!" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: corsHeaders });
  } catch (err: any) {
    console.error("ml-auth error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
