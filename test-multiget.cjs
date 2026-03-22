const https = require('https');
https.get('https://api.mercadolibre.com/items?ids=MLB3437596041', {
    headers: { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' }
}, (res) => {
    let data = '';
    res.on('data', (c) => data += c);
    res.on('end', () => console.log(data));
});
