const url = 'https://app.scrapingbee.com/api/v1?api_key=VWYXU3Y0GC4ITXPIGHK3BNIF66W14S1C6NDMSF85FE7TEOSD0WPFGQ6S6OOX0LVR7JPI6DP774VWJMVH&url=' + encodeURIComponent('https://www.minhaloja.natura.com/s/produtos?busca=creme+merengue+para+o+corpo&consultoria=ofertashop&marca=natura') + '&render_js=true&premium_proxy=true&country_code=br';
const r = await fetch(url);
const html = await r.text();
Deno.writeTextFileSync('natura_dump.html', html);
console.log("HTML guardado em natura_dump.html.");
