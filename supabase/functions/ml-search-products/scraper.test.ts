import { assertEquals } from "https://deno.land/std@0.208.0/assert/mod.ts";
import * as cheerio from "https://esm.sh/cheerio@1.0.0-rc.12";

// Simulando a extração do HTML do Mercado Livre
const MOCK_HTML = `
  <html>
    <body>
      <div class="ui-search-layout__item">
        <a class="ui-search-link" href="https://produto.mercadolivre.com.br/MLB-12345-iphone-15">Iphone</a>
        <h2 class="ui-search-item__title">iPhone 15 Pro Max 256gb Titânio</h2>
        <span class="price-tag-fraction">7.500</span><span class="price-tag-cents">99</span>
        <img class="ui-search-result-image__element" data-src="https://http2.mlstatic.com/D_NQ_123.jpg" />
        <div class="ui-search-item__shipping--free">Frete grátis</div>
        <p class="ui-search-official-store-label">por Apple</p>
      </div>
    </body>
  </html>
`;

Deno.test("ML Scraper - HTML Parsing Unit Test", () => {
  const $ = cheerio.load(MOCK_HTML);
  const results: any[] = [];

  $(".ui-search-layout__item").each((_, el) => {
    const title = $(el).find(".ui-search-item__title").text().trim();
    
    const priceText = $(el).find(".price-tag-fraction").first().text().replace(/\./g, "").replace(",", ".");
    const price = parseFloat(priceText) || 0;
    const centsText = $(el).find(".price-tag-cents").first().text();
    const cents = centsText ? parseFloat(centsText) / 100 : 0;
    const finalPrice = price + cents;

    const permalink = $(el).find(".ui-search-link").attr("href")?.split("#")[0] || "";
    const matchId = permalink.match(/MLB-?(\d+)/i);
    const id = matchId ? `MLB${matchId[1]}` : "mock_id";

    let thumbnail = $(el).find("img.ui-search-result-image__element").attr("data-src") || "";

    const shipping_free = $(el).find(".ui-search-item__shipping--free").length > 0;
    const sellerNickname = $(el).find(".ui-search-official-store-label").text().replace("por ", "").trim() || "Vendedor";

    if (title && finalPrice > 0 && permalink) {
      results.push({
        id,
        title,
        price: finalPrice,
        thumbnail,
        permalink,
        shipping_free,
        sellerNickname
      });
    }
  });

  assertEquals(results.length, 1);
  assertEquals(results[0].title, "iPhone 15 Pro Max 256gb Titânio");
  assertEquals(results[0].price, 7500.99);
  assertEquals(results[0].id, "MLB12345");
  assertEquals(results[0].thumbnail, "https://http2.mlstatic.com/D_NQ_123.jpg");
  assertEquals(results[0].shipping_free, true);
  assertEquals(results[0].sellerNickname, "Apple");
});
