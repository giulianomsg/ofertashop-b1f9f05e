const fs = require('fs');
const cheerio = require('cheerio'); // Node might not have cheerio installed locally. I'll just check regexes manually or use a simple parsing.
const html = fs.readFileSync('ml-test.html', 'utf8');

// The new ML structure
const titles = html.match(/poly-component__title[^>]*>([^<]+)<\/h2>/g);
console.log("Titles found via h2:", titles ? titles.length : 0);

if (titles && titles.length > 0) {
  console.log("Sample title:", titles[0].replace(/<[^>]+>/g, ''));
}

const prices = html.match(/andes-money-amount__fraction[^>]*>([^<]+)<\/span>/g);
console.log("Prices found:", prices ? prices.length : 0);
if (prices && prices.length > 0) {
  console.log("Sample price:", prices[0].replace(/<[^>]+>/g, ''));
}

const links = html.match(/href="([^"]+)"[^>]*poly-component__title/g);
console.log("Links found:", links ? links.length : 0);
if (links && links.length > 0) {
  console.log("Sample link:", links[0].match(/href="([^"]+)"/)[1]);
}
