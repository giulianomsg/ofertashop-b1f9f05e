const fs = require('fs');
const data = fs.readFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_test.html', 'utf8');
const blocks = data.split('data-component-type="s-search-result"');
if (blocks.length > 1) {
    const chunk = blocks[1].substring(0, 5000);
    // Format to make it somewhat readable with line breaks
    const formatted = chunk.replace(/>/g, '>\n').replace(/</g, '\n<');
    fs.writeFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_dump.txt', formatted, 'utf8');
}
