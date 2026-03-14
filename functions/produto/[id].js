// Cloudflare Pages Function para proxy de OG tags
const BOT_REGEX = /bot|facebookexternalhit|whatsapp|twitterbot|linkedinbot|pinterest|slackbot|telegrambot|discordbot|googlebot|bingbot|yandex|crawler|spider|preview/i;

export async function onRequest(context) {
  const { request, params, env } = context;
  const userAgent = request.headers.get("User-Agent") || "";

  if (!BOT_REGEX.test(userAgent)) {
    // Utilizador humano — servir a SPA normalmente
    return env.ASSETS.fetch(request);
  }

  // Bot — proxy para a Edge Function do Supabase
  const productId = params.id;
  const proxyUrl = `https://smfndfyuscgfjedeqysu.supabase.co/functions/v1/og-proxy?productId=${productId}`;

  return fetch(proxyUrl, {
    headers: { "User-Agent": userAgent },
  });
}
