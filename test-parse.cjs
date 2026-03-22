const fs = require('fs');
const html = fs.readFileSync('ml-test.html', 'utf8');

// The HTML might be a React SSR page, let's search for some product names
const search = "Iphone";
const index = html.indexOf(search);
console.log("Found 'Iphone' at index", index);
if (index !== -1) {
  console.log("Context:", html.substring(Math.max(0, index - 200), index + 200));
}

// Let's also check if it's a captcha page
const captchaIndex = html.toLowerCase().indexOf("captcha");
console.log("Captcha found?", captchaIndex !== -1);
if (captchaIndex !== -1) {
  console.log("Captcha context:", html.substring(Math.max(0, captchaIndex - 100), captchaIndex + 100));
}

// Check other standard ML classes
const classes = ["ui-search-result__wrapper", "ui-search-layout__item", "andes-card", "poly-component__title"];
for (const cls of classes) {
  console.log(`Class ${cls} count:`, (html.match(new RegExp(cls, 'g')) || []).length);
}
