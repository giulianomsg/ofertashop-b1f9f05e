const fs = require('fs');
const data = fs.readFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_dp.html', 'utf8');

// Breadcrumb
const breadcrumbMatch = data.match(/<ul class="a-unordered-list a-horizontal a-size-small">([\s\S]*?)<\/ul>/) || data.match(/wayfinding-breadcrumbs_container[\s\S]*?<\/ul>/);
const breadcrumbText = breadcrumbMatch ? breadcrumbMatch[0].replace(/<[^>]+>/g, '').replace(/\s+/g, ' ').trim() : "Not found";
console.log("Breadcrumb:", breadcrumbText);

// Brand
const brandMatch = data.match(/<a id="bylineInfo"[^>]*>([\s\S]*?)<\/a>/) || data.match(/Pacote da marca:\s*(?:<[^>]*>)*([^<]*)/);
const brandText = brandMatch ? brandMatch[1].replace(/<[^>]+>/g, '').trim() : "Not found";
console.log("Brand:", brandText);

// Price Area
const priceBlockMatch = data.match(/corePriceDisplay_desktop_feature_div([\s\S]*?)<\/div>/);
const priceText = priceBlockMatch ? priceBlockMatch[1].replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim() : "Not found";
console.log("Price Area string for Regex:", priceText);

// Ratings and Sales
const ratingMatch = data.match(/<span data-hook="rating-out-of-text"[^>]*>([\s\S]*?)<\/span>/);
console.log("Rating:", ratingMatch ? ratingMatch[1].trim() : "Not found");

const salesMatch = data.match(/social-proofing-faceout-title-tk_bought[^>]*>([\s\S]*?)<\/span>/);
console.log("Recent Sales:", salesMatch ? salesMatch[1].trim() : "Not found");
