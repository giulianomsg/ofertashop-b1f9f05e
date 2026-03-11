# SEO & Open Graph Setup Guide

Este documento detalha como configurar o seu provedor de alojamento (Hosting) para garantir que as redes sociais (Facebook, WhatsApp, Twitter) e motores de pesquisa consigam ler corretamente as tags Open Graph da aplicação.

Como o OfertaShop é uma aplicação *Single Page Application* (SPA) com React (Vite) via Client-Side Rendering (CSR), os bots destas plataformas não executam o Javascript para ler o `react-helmet-async`. 

Para resolver este problema, criamos a Edge Function `og-proxy`. 
Foi criada uma solução que usa um **Rewrite Rule**. Vamos detetar quando o visitante é um bot e redirecioná-lo para a nossa Edge Function do Supabase, que vai retornar o HTML estático correto pré-preenchido com as tags.

## Proxy URL
O URL da sua Edge Function será algo como:  
`https://<YOUR_SUPABASE_REF>.supabase.co/functions/v1/og-proxy`

A Edge Function aceita dois parâmetros na *query string*:
- `productId` (Obrigatório): O ID do produto requisitado.
- `url` (Opcional): O URL de origem que a Edge Function fará o download para injetar as tags metas. Se omitido, usará um skeleton básico que funciona perfeitamente para os bots de qualquer forma.

## Exemplos de Configuração por Provedor

### 1. Vercel (`vercel.json`)
Se estiver a hospedar a aplicação na Vercel, crie ou atualize o seu ficheiro `vercel.json` na raiz do projeto:

```json
{
  "rewrites": [
    {
      "source": "/produto/:id",
      "has": [
        {
          "type": "header",
          "key": "user-agent",
          "value": ".*(bot|facebookexternalhit|whatsapp|twitterbot|linkedinbot|pinterest).*\\s?"
        }
      ],
      "destination": "https://<YOUR_SUPABASE_REF>.supabase.co/functions/v1/og-proxy?productId=:id&url=https://seu-dominio.com/produto/:id"
    },
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### 2. Netlify (`_redirects` ou `netlify.toml`)
Na Netlify, a deteção de User-Agent é uma funcionalidade a nível de Edge (como o Netlify Edge Functions). Dito isto, pode criar uma função rudimentar no Netlify que simplesmente faça esse reencaminhamento.
Alternativamente, ative o **Prerendering** nativo da Netlify nas definições do seu site (Site Settings > Build & deploy > Prerendering). A Netlify deteta os bots por defeito e entrega-lhes uma página pre-renderizada com os valores injetados pelo React Helmet! Isto poupa o facto de usar a função proxy do Supabase.

### 3. Cloudflare Pages
No Cloudflare, usando `_routes.json` ou Cloudflare Functions (`functions/produto/[id].js`), pode redirecionar bots:

```javascript
// functions/produto/[id].js
export async function onRequest(context) {
  const { request, env, params } = context;
  const userAgent = request.headers.get("User-Agent") || "";
  
  const isBot = /bot|facebookexternalhit|whatsapp|twitterbot|linkedin/i.test(userAgent);
  if (isBot) {
    const supabaseRef = env.SUPABASE_REF;
    return fetch(`https://${supabaseRef}.supabase.co/functions/v1/og-proxy?productId=${params.id}&url=${request.url}`);
  }
  
  return env.ASSETS.fetch(request);
}
```

## Como Testar?

Para testar se a configuração está a funcionar:

1. Garanta que fez *Deploy* da Edge Function no Supabase (se ainda não o fez):
   ```bash
   npx supabase functions deploy og-proxy
   ```
2. Após o deploy do seu frontend, use a ferramenta [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/) ou o [Twitter Card Validator](https://cards-dev.twitter.com/validator).
3. Insira o URL final publicamente acessível de um dos seus produtos (ex: `https://seu-dominio.com/produto/123`).
4. Verifique se o título, descrição e imagem estão a ser carregados corretamente do Supabase! Se não estiverem, atestem os logs da Edge Function na dashboard do Supabase.
