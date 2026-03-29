// Edge Function: shopee-import-product (standalone)
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function bufferToHex(buffer: ArrayBuffer): string {
  return [...new Uint8Array(buffer)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function sha256Hex(message: string): Promise<string> {
  const data = new TextEncoder().encode(message);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return bufferToHex(hash);
}

async function shopeeGraphQL<T = any>(query: string, variables: Record<string, any> = {}): Promise<T> {
  const appId = Deno.env.get("SHOPEE_APP_ID");
  const appSecret = Deno.env.get("SHOPEE_APP_SECRET");
  if (!appId || !appSecret) throw new Error("SHOPEE_APP_ID e SHOPEE_APP_SECRET devem estar definidas.");

  const payloadStr = JSON.stringify({ query, variables });
  const timestamp = Math.floor(Date.now() / 1000);
  const factor = `${appId}${timestamp}${payloadStr}${appSecret}`;
  const sign = await sha256Hex(factor);

  const shopeeHost = Deno.env.get("SHOPEE_API_BASE_URL") ?? "https://open-api.affiliate.shopee.com.br";
  const url = `${shopeeHost}/graphql`;
  const payloadBytes = new TextEncoder().encode(payloadStr);

  const res = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `SHA256 Credential=${appId},Timestamp=${timestamp},Signature=${sign}`,
      "Content-Type": "application/json",
    },
    body: payloadBytes,
  });

  const json = await res.json();
  if (json.errors && json.errors.length > 0) {
    throw new Error(`Shopee GraphQL error: ${json.errors.map((e: any) => e.message).join(", ")}`);
  }
  return json.data as T;
}

// --- MULTI-SCRAPER ABSTRACTION ---
interface ScraperConfig {
  provider: 'scrapingbee' | 'scrape.do' | 'scrapingant' | 'scraperapi';
  apiKey: string;
}

function buildScraperUrl(config: ScraperConfig, targetUrl: string): string {
  const { provider, apiKey } = config;
  if (provider === 'scrapingbee') {
    const api = new URL("https://app.scrapingbee.com/api/v1");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("render_js", "false");
    api.searchParams.append("premium_proxy", "true");
    api.searchParams.append("country_code", "br");
    return api.toString();
  }
  if (provider === 'scrape.do') {
    const api = new URL("https://api.scrape.do");
    api.searchParams.append("token", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("geoCode", "br");
    return api.toString();
  }
  if (provider === 'scrapingant') {
    const api = new URL("https://api.scrapingant.com/v2/general");
    api.searchParams.append("x-api-key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("proxy_country", "BR");
    api.searchParams.append("browser", "false");
    api.searchParams.append("proxy_type", "residential");
    return api.toString();
  }
  if (provider === 'scraperapi') {
    const api = new URL("https://api.scraperapi.com/");
    api.searchParams.append("api_key", apiKey);
    api.searchParams.append("url", targetUrl);
    api.searchParams.append("country_code", "br");
    api.searchParams.append("premium", "true");
    return api.toString();
  }
  throw new Error(`Scraper provider desconhecido: ${provider}`);
}

async function getActiveScraperConfig(sb: any): Promise<ScraperConfig> {
  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle();
    if (data?.value?.activeProvider && data?.value?.keys) {
      const provider = data.value.activeProvider;
      const apiKey = data.value.keys[provider];
      if (apiKey) return { provider, apiKey };
    }
  } catch (e) { /* ignore */ }

  const defaultKey = Deno.env.get("SCRAPINGBEE_API_KEY");
  if (defaultKey) return { provider: "scrapingbee", apiKey: defaultKey };
  throw new Error("Nenhum serviço de Web Scraper configurado.");
}

async function fetchWithRetry(url: string, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const res = await fetch(url);
      if (res.ok) {
        let finalHtml = await res.text();
        try {
          const json = JSON.parse(finalHtml);
          if (json && typeof json.content === 'string') finalHtml = json.content;
        } catch (e) { /* raw html */ }
        return finalHtml;
      }
    } catch (err: any) {
      if (i === maxRetries - 1) throw err;
    }
    await new Promise((resolve) => setTimeout(resolve, 1000 * Math.pow(2, i)));
  }
  throw new Error("Falha ao buscar página.");
}

// --- OPENROUTER AI SEMANTIC EXTRACTION ---
interface OpenRouterConfig {
  apiKey: string;
  model: string;
}

async function getOpenRouterConfig(sb: any): Promise<OpenRouterConfig | null> {
  try {
    const { data } = await sb.from("admin_settings").select("value").eq("key", "openrouter_config").maybeSingle();
    if (data?.value?.apiKey && data?.value?.model) {
      return { apiKey: data.value.apiKey, model: data.value.model };
    }
  } catch (e) { }
  
  const envKey = Deno.env.get("OPENROUTER_API_KEY");
  if (envKey) return { apiKey: envKey, model: "google/gemini-2.0-flash-lite-preview-02-05:free" };
  
  return null;
}

async function extractPricesFromHTML(config: OpenRouterConfig, rawHtml: string): Promise<{ price: number, original_price: number | null } | null> {
  try {
    const htmlObj = cheerio.load(rawHtml);
    let ssrJson = '';
    htmlObj('script').each((_: any, el: any) => {
       const htmlC = htmlObj(el).html() || '';
       if (htmlC.includes('window.__DEHYDRATED_STATE__') || htmlC.includes('"price_before_discount"')) {
          const matchP = htmlC.match(/"price":\s*(\d{4,12})/);
          const matchOP = htmlC.match(/"price_before_discount":\s*(\d{4,12})/);
          ssrJson = `Valores brutos da API na página (provável micro-unidades):\nPrice atual: ${matchP?.[1] || 'n/a'}, Original Price Antigo: ${matchOP?.[1] || 'n/a'}.`;
       }
    });

    htmlObj('script, style, link, meta, noscript, svg, img').remove();
    const cleanText = htmlObj('body').text().replace(/\s+/g, ' ').substring(0, 8000).trim();

    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${config.apiKey}`,
        "Content-Type": "application/json",
        "HTTP-Referer": "https://ofertashop.com",
        "X-Title": "OfertaShop",
      },
      body: JSON.stringify({
        model: config.model,
        messages: [
          {
             role: "system", 
             content: "Você é um bot extrator de dados ultra-preciso para links de afiliados da Shopee do Brasil. Seu trabalho é dizer extamente qual o PREÇO COM DESCONTO (Ex: por causa do PIX, moedas, ou promoção) que o cliente vai desembolsar para comprar a unidade padrão, e o PREÇO ORIGINAL (riscado). Retorne ESTRITAMENTE um objeto JSON com: {\"price\": <float>, \"original_price\": <float>}. Utilize ponto (.) para as casas decimais. Se não houver price, omita." 
          },
          { 
             role: "user", 
             content: `O conteúdo da página visível foi removido de tags HTML. Siga as pistas:\n\n${ssrJson}\n\nTexto Visível Desorganizado:\n${cleanText}` 
          }
        ]
      })
    });

    if (!response.ok) return null;

    const aiResponse = await response.json();
    const resultText = aiResponse.choices?.[0]?.message?.content || "";
    
    const jsonMatch = resultText.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      const parsed = JSON.parse(jsonMatch[0]);
      if (parsed.price && typeof parsed.price === 'number') {
        return {
           price: parsed.price,
           original_price: parsed.original_price || null
        };
      }
    }
  } catch (e) {
    console.warn("AI Semantic Extraction failed:", e);
  }
  return null;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { offer, forceAI, categoryId, platformId, userId } = await req.json();

    if (!offer || !offer.itemId) {
      return new Response(JSON.stringify({ error: "offer com itemId é obrigatório" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    console.log("[Shopee Import] Raw Offer Data from API:", JSON.stringify(offer, null, 2));

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const sb = createClient(supabaseUrl, supabaseKey);

    // Check if already imported
    const { data: existing } = await sb
      .from("shopee_product_mappings")
      .select("id, product_id")
      .eq("shopee_item_id", String(offer.itemId))
      .maybeSingle();

    if (existing) {
      return new Response(
        JSON.stringify({ error: "Produto já importado", product_id: existing.product_id }),
        { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Generate short link
    let shortLink = offer.shopeeShortLink || offer.offerLink || offer.productLink;
    try {
      if (offer.productLink || offer.offerLink) {
        const linkQuery = `
          query {
            generateShortLink(
              originUrl: "${(offer.offerLink || offer.productLink).replace(/"/g, '\\"')}"
              subId: "ofertashop"
            ) {
              shortLink
            }
          }
        `;
        const linkData = await shopeeGraphQL(linkQuery);
        if (linkData?.generateShortLink?.shortLink) {
          shortLink = linkData.generateShortLink.shortLink;
        }
      }
    } catch (e) {
      console.warn("Failed to generate short link, using original:", e);
    }

    // Get or find Shopee platform
    let resolvedPlatformId = platformId;
    if (!resolvedPlatformId) {
      const { data: shopeePlatform } = await sb
        .from("platforms")
        .select("id")
        .ilike("name", "%shopee%")
        .maybeSingle();
      resolvedPlatformId = shopeePlatform?.id || null;
    }

    // Resolve category_id: use provided or search existing only (NO auto-create)
    let resolvedCategoryId = categoryId || null;
    if (!resolvedCategoryId && offer.categoryName) {
      const { data: existingCat } = await sb
        .from("categories")
        .select("id")
        .ilike("name", offer.categoryName)
        .maybeSingle();
      if (existingCat) {
        resolvedCategoryId = existingCat.id;
      }
      // If not found, leave null for admin to set manually
    }

    // === PRICING: Normalize Shopee micro-units (if > 100000) ===
    const rawMax = parseFloat(offer.priceMax) || parseFloat(offer.price) || 0;
    const rawMin = parseFloat(offer.priceMin) || 0;
    
    // Convert from micro-units to standard BRL
    const priceMax = rawMax > 100000 ? rawMax / 100000 : rawMax;
    const priceMin = rawMin > 100000 ? rawMin / 100000 : rawMin;
    const discountRate = parseFloat(offer.priceDiscountRate) || 0;

    let finalPrice: number;
    let finalOriginalPrice: number | null = null;

    if (priceMin > 0 && priceMax > priceMin) {
      // priceMin is the discounted/cash price, priceMax is the original
      finalPrice = priceMin;
      finalOriginalPrice = priceMax;
    } else {
      finalPrice = priceMax > 0 ? priceMax : (priceMin > 0 ? priceMin : 0.01);
      finalOriginalPrice = null;
    }

    // Compute commission percentage properly
    const rate = Number(offer.commissionRate) || 0;
    const commissionPct = rate < 1 && rate > 0 ? rate * 100 : rate;

    // === 3. DYNAMIC DATA ENRICHMENT (SCRAPING) ===
    let scrapedDescription: string | null = null;
    let scrapedGalleryUrls: string[] = [];
    let scrapedImageUrl = offer.imageUrl || null;
    let scrapedFinalPrice: number | null = null;
    let scrapedRating: number | null = null;
    let scrapedSales: number | null = null;
    let priceSource = 'API_DEFAULT';

    try {
      const productUrl = offer.productLink || offer.offerLink;
      if (productUrl) {
        const scraperConfig = await getActiveScraperConfig(sb);
        const proxyUrl = buildScraperUrl(scraperConfig, productUrl);
        console.log(`[Shopee Scraping] Hybrid enrichment via ${scraperConfig.provider} at ${productUrl}`);
        const html = await fetchWithRetry(proxyUrl);
        const $ = cheerio.load(html);

        // 1. Explicit AI Forcing
        if (forceAI) {
           const aiConfig = await getOpenRouterConfig(sb);
           if (aiConfig) {
               console.log(`[Shopee Scraping] FORCING AI Semantic Fallback via OpenRouter Model ${aiConfig.model}`);
               const aiPrices = await extractPricesFromHTML(aiConfig, html);
               if (aiPrices && aiPrices.price > 0) {
                   scrapedFinalPrice = aiPrices.price;
                   if (aiPrices.original_price && aiPrices.original_price > aiPrices.price) {
                       // We update the apiMax if the AI definitively knows the old price was higher than the buggy API
                       if (aiPrices.original_price > priceMax) priceMax = aiPrices.original_price;
                   }
                   priceSource = 'OPENROUTER_AI';
                   console.log(`[Shopee Scraping - FORCED AI] Price: ${aiPrices.price}, Original: ${aiPrices.original_price}`);
               }
           }
        }

        // 3.1 Extract Promotional Price explicitly from DOM FIRST (Visual Source of Truth)
        if (!scrapedFinalPrice) {
          const domPriceText = $(".IZPeQz.B67UQ0, .pq5ilO, .pm1p0z, ._045P6p, .G27FPf, .Ou5R\\+P, .price, [class*='price']").first().text().trim();
          if (domPriceText) {
             const pricesMatched = [...domPriceText.replace(/\./g,'').replace(',','.').matchAll(/(\d+\.\d+)/g)];
             if (pricesMatched.length > 0) {
                scrapedFinalPrice = parseFloat(pricesMatched[0][0]);
                priceSource = 'DOM_CLASS';
             }
          }
        }

        // 3.2 Try to extract deep JSON states (Next.js/Shopee SSR) ONLY IF DOM FAILS
        if (!scrapedFinalPrice) {
          try {
            $('script').each((_: any, el: any) => {
               const scriptContent = $(el).html() || '';
               if (!scrapedFinalPrice) {
                 const priceMatch = scriptContent.match(/"price":\s*(\d{4,12})/);
                 if (priceMatch) {
                    const rawP = parseInt(priceMatch[1], 10);
                    // Handle micro-units robustly
                    if (rawP > 1000000000) scrapedFinalPrice = rawP / 10000000; // 10^7 format
                    else if (rawP > 100000) scrapedFinalPrice = rawP / 100000;  // 10^5 format
                    if (scrapedFinalPrice) priceSource = 'SSR_JSON';
                 }
               }
            });
          } catch (e) { /* ignore */ }
        }

        // 3.3 Try Semantic AI Parsing ONLY IF BOTH FAILED
        if (!scrapedFinalPrice && !forceAI) {
          const aiConfig = await getOpenRouterConfig(sb);
          if (aiConfig) {
             console.log(`[Shopee Scraping] Activating AI Semantic Fallback via OpenRouter Model ${aiConfig.model}`);
             const aiPrices = await extractPricesFromHTML(aiConfig, html);
             if (aiPrices && aiPrices.price > 0) {
                 scrapedFinalPrice = aiPrices.price;
                 // If the AI found the real original price but it's different from the API, we will just prioritize the API's priceMax in step 4
                 if (aiPrices.original_price && aiPrices.original_price > aiPrices.price) {
                     // We update the apiMax if the AI definitively knows the old price was higher than the buggy API
                     if (aiPrices.original_price > priceMax) priceMax = aiPrices.original_price;
                 }
                 priceSource = 'OPENROUTER_AI_FALLBACK';
                 console.log(`[Shopee Scraping] AI returned Price: ${aiPrices.price}, Original: ${aiPrices.original_price}`);
             }
          }
        }

        // 3.4 Extract Images (Gallery)
        const images: string[] = [];
        $("img[src*='cf.shopee'], img[src*='down-id.img.susercontent'], img[data-src*='cf.shopee']").each((_: any, el: any) => {
          const src = $(el).attr("data-src") || $(el).attr("src") || "";
          if (src && src.startsWith("http") && !src.includes("data:image") && !src.includes("badge")) {
            const hiRes = src.replace(/_tn$/, "").replace(/\?.*$/, "");
            images.push(hiRes);
          }
        });
        $('meta[property="og:image"]').each((_: any, el: any) => {
          const content = $(el).attr("content");
          if (content && content.startsWith("http")) images.push(content);
        });

        if (images.length > 0) {
          const uniqueImages = [...new Set(images)].slice(0, 8);
          scrapedGalleryUrls = uniqueImages;
          scrapedImageUrl = uniqueImages[0] || scrapedImageUrl;
        }

        // 3.4 Extract Rating and Sales
        const ratingText = $(".OitTbl, ._1k47d8, .rating, [class*='rating']").first().text().trim();
        const ratingMatch = ratingText.match(/(\d[\.,]\d)/);
        if (ratingMatch) scrapedRating = parseFloat(ratingMatch[1].replace(',', '.'));

        const salesDOM = $(".p1\\+k1E, ._1k47d8, .sales, [class*='sold']").first().text().trim();
        if (salesDOM) {
           let mult = 1;
           if (salesDOM.toLowerCase().includes("mil")) mult = 1000;
           const sMatch = salesDOM.replace(',', '.').match(/(\d+[\.,]?\d*)/);
           if (sMatch) scrapedSales = Math.floor(parseFloat(sMatch[1]) * mult);
        }

        // 3.5 Extract description
        const descEl = $(".product-detail, [class*='product-detail'], [class*='description'], .QN2lPu").text().trim();
        if (descEl && descEl.length > 20) {
          scrapedDescription = descEl.substring(0, 2000);
        }
        if (!scrapedDescription) {
          const ogDesc = $('meta[property="og:description"]').attr("content");
          if (ogDesc && ogDesc.length > 20) scrapedDescription = ogDesc;
        }
      }
    } catch (scrapeErr) {
      console.warn("[Shopee Scraping] Hybrid enrichment failed (fallback to API data):", scrapeErr);
    }

    // === 4. MERGE DATA ===
    if (scrapedFinalPrice && scrapedFinalPrice > 0) {
      // Force API logic to be original_price, and scraped to be final selling price
      const apiPrice = finalPrice > 0 ? finalPrice : (priceMax > 0 ? priceMax : 0);
      
      if (apiPrice > scrapedFinalPrice) {
        finalOriginalPrice = apiPrice;
      } else if (priceMax > scrapedFinalPrice) {
        finalOriginalPrice = priceMax; 
      }
      
      finalPrice = scrapedFinalPrice;
      console.log(`[Shopee Merged] Price forced by Web Scraper: ${finalPrice} (Old API was ${apiPrice})`);
    }

    const mergedRating = scrapedRating !== null && scrapedRating > 0 ? scrapedRating : (Number(offer.ratingStar) || 0);
    const mergedSales = scrapedSales !== null && scrapedSales > 0 ? scrapedSales : (Number(offer.sales) || 0);

    // Insert product
    const { data: product, error: productErr } = await sb
      .from("products")
      .insert({
        title: offer.productName || "Produto Shopee",
        price: finalPrice > 0 ? finalPrice : 0.01,
        original_price: finalOriginalPrice,
        description: scrapedDescription || null,
        store: offer.shopName || "Shopee",
        affiliate_url: shortLink || offer.productLink || "",
        image_url: scrapedImageUrl,
        gallery_urls: scrapedGalleryUrls.length > 0 ? scrapedGalleryUrls : null,
        category_id: resolvedCategoryId,
        platform_id: resolvedPlatformId,
        is_active: true,
        rating: Number(offer.ratingStar) || 0,
        registered_by: userId || null,
        sales_count: Number(offer.sales) || 0,
        commission_rate: commissionPct > 0 ? Number(commissionPct.toFixed(2)) : null,
        badge: null,
        extra_metadata: offer,
      })
      .select()
      .single();

    if (productErr) throw productErr;

    // price_history is automatically populated by the track_price_history trigger

    const shopee_extra_data = {
      appExistRate: offer.appExistRate,
      appNewRate: offer.appNewRate,
      webExistRate: offer.webExistRate,
      webNewRate: offer.webNewRate,
      commission: offer.commission,
      productCatIds: offer.productCatIds,
      priceDiscountRate: offer.priceDiscountRate,
      shopType: offer.shopType,
      sellerCommissionRate: offer.sellerCommissionRate,
      shopeeCommissionRate: offer.shopeeCommissionRate
    };

    const validFrom = offer.periodStartTime ? new Date(offer.periodStartTime * 1000).toISOString() : null;
    const validTo = offer.periodEndTime ? new Date(offer.periodEndTime * 1000).toISOString() : null;

    // Create mapping
    const { error: mappingErr } = await sb
      .from("shopee_product_mappings")
      .insert({
        product_id: product.id,
        shopee_item_id: String(offer.itemId),
        shopee_shop_id: String(offer.shopId || ""),
        shopee_offer_id: String(offer.offerId || ""),
        shopee_commission_rate: Number(offer.commissionRate) || null,
        shopee_image_url: offer.imageUrl || null,
        shopee_product_url: offer.productLink || null,
        shopee_short_link: shortLink || null,
        sync_status: "active",
        offer_valid_from: validFrom,
        offer_valid_to: validTo,
        shopee_extra_data: shopee_extra_data
      });

    if (mappingErr) console.error("Mapping insert error:", mappingErr);

    // Log sync
    await sb.from("shopee_sync_logs").insert({
      sync_type: "import",
      status: "success",
      items_processed: 1,
      items_updated: 1,
      triggered_by: userId || null,
      completed_at: new Date().toISOString(),
    });

    return new Response(JSON.stringify({ success: true, product }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: any) {
    console.error("shopee-import-product error:", err);
    return new Response(JSON.stringify({ error: err.message || "Erro interno" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
