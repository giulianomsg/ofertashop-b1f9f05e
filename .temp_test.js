const fs = require('fs');
const data = fs.readFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_test.html', 'utf8');
const blocks = data.split('data-component-type="s-search-result"');
if (blocks.length > 1) {
    const chunk = blocks[1].substring(0, 2500);
    
    // Test title
    const h2Match = chunk.match(/<h2[^>]*>([\s\S]*?)<\/h2>/);
    console.log("h2 match:", h2Match ? h2Match[1] : "not found");
    
    // test span inside
    if (h2Match) {
       const spanMatch = h2Match[1].match(/<span[^>]*>([\s\S]*?)<\/span>/);
       console.log("span in h2:", spanMatch ? spanMatch[1] : "not found");
    }
    
    // test price
    const priceMatch = chunk.match(/a-price-whole[^>]*>([\s\S]*?)<\//);
    console.log("price-whole match:", priceMatch ? priceMatch[1] : "not found");
    
    const priceTextMatch = chunk.match(/a-offscreen[^>]*>([\s\S]*?)<\//);
    console.log("offscreen price:", priceTextMatch ? priceTextMatch[1] : "not found");
}
