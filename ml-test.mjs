import fs from 'fs';

async function testML() {
  const keyword = "Iphone 15";
  const url = `https://lista.mercadolivre.com.br/${keyword.replace(/\s+/g, '-')}`;
  console.log("Fetching", url);
  try {
    const res = await fetch(url, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
      }
    });
    console.log("Status:", res.status);
    console.log("Redirected:", res.redirected, res.url);
    const html = await res.text();
    fs.writeFileSync("ml-test.html", html);
    console.log("HTML length:", html.length);
    
    // Test alternative URL
    const url2 = `https://lista.mercadolivre.com.br/search?q=${encodeURIComponent(keyword)}`;
    console.log("Fetching", url2);
    const res2 = await fetch(url2, { headers: { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" } });
    console.log("Status 2:", res2.status);
    console.log("Redirected 2:", res2.redirected, res2.url);
  } catch (e) {
    console.error(e);
  }
}
testML();
