const fs = require('fs');
const data = fs.readFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_test.html', 'utf8');
const blocks = data.split('data-component-type="s-search-result"');
if (blocks.length > 1) {
    const chunk = blocks[1].substring(0, 1500);
    console.log("DUMP DO BLOCO:");
    console.log(chunk.replace(/\s+/g, ' '));
}
