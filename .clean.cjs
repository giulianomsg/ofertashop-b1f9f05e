const fs = require('fs');
const data = fs.readFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_test.html', 'utf8');
const blocks = data.split('data-component-type="s-search-result"');
if (blocks.length > 1) {
    let chunk = blocks[1].substring(0, 15000);
    
    // Simplifica tags para leitura humana
    chunk = chunk.replace(/<svg[\s\S]*?<\/svg>/g, '');
    chunk = chunk.replace(/<script[\s\S]*?<\/script>/g, '');
    chunk = chunk.replace(/\s(class|data-[a-zA-Z0-9-]+|aria-[a-zA-Z0-9-]+|cel_widget_id|tabindex|role|src|srcset|href|alt|target|rel|id)="[^"]*"/g, '');
    chunk = chunk.replace(/<div\s*>\s*<\/div>/g, '');
    chunk = chunk.replace(/>\s+</g, '>\n<');
    
    fs.writeFileSync('e:/OfertaShop/ofertashop-b1f9f05e/amazon_clean.txt', chunk, 'utf8');
}
