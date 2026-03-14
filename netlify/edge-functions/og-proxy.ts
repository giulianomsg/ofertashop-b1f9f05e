const BOT_REGEX = /bot|facebookexternalhit|whatsapp|twitterbot|linkedinbot|pinterest|slackbot|telegrambot|discordbot|googlebot|bingbot|yandex|crawler|spider|preview/i;

export default async (request: Request) => {
  const url = new URL(request.url);
  const match = url.pathname.match(/^\/produto\/([a-zA-Z0-9-]+)/);

  if (!match) return;

  const userAgent = request.headers.get("user-agent") || "";
  if (!BOT_REGEX.test(userAgent)) return;

  const productId = match[1];
  const proxyUrl = `https://smfndfyuscgfjedeqysu.supabase.co/functions/v1/og-proxy?productId=${productId}`;

  return fetch(proxyUrl, {
    headers: { "User-Agent": userAgent },
  });
};

export const config = { path: "/produto/*" };
