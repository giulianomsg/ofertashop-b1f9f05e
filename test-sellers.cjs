const fs=require('fs');
const html=fs.readFileSync('ml-test.html','utf8');
const cheerio=require('cheerio'); // I'll use simple substrings

let sellers = [];
let idx = 0;
while ((idx = html.indexOf('poly-component__seller', idx + 1)) !== -1) {
  const start = html.lastIndexOf('<', idx);
  const end = html.indexOf('</', idx);
  if (start !== -1 && end !== -1 && end > start) {
    sellers.push(html.substring(start, end + 7).replace(/<[^>]+>/g, '').trim());
  }
}
console.log('Sellers (poly-component__seller):', sellers.slice(0, 10));

let sellerNames = [];
let idx2 = 0;
while ((idx2 = html.indexOf('poly-component__brand', idx2 + 1)) !== -1) {
  const start = html.lastIndexOf('<', idx2);
  const end = html.indexOf('</', idx2);
  if (start !== -1 && end !== -1 && end > start) {
    sellerNames.push(html.substring(start, end + 7).replace(/<[^>]+>/g, '').trim());
  }
}
console.log('Brand/SellerNames (poly-component__brand):', sellerNames.slice(0, 10));
