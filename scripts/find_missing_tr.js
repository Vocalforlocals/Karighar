const fs = require('fs');
const path = require('path');

function getFiles(dir) {
  let results = [];
  const list = fs.readdirSync(dir, { withFileTypes: true });
  for (const item of list) {
    const full = path.join(dir, item.name);
    if (item.isDirectory()) results = results.concat(getFiles(full));
    else if (item.name.endsWith('.dart')) results.push(full);
  }
  return results;
}

const files = getFiles('lib');
const trRegex = /['"]([^'"\n]+)['"]\.tr\b/g;
const allKeys = new Set();

for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  let match;
  while ((match = trRegex.exec(content)) !== null) {
    allKeys.add(match[1]);
  }
}

const localeContent = fs.readFileSync('lib/core/l10n/locale_manager.dart', 'utf8');
const missing = [];
for (const key of allKeys) {
  if (!localeContent.includes("'" + key + "':") && !localeContent.includes('"' + key + '":')) {
    missing.push(key);
  }
}
console.log('Total .tr keys found in lib:', allKeys.size);
console.log('Missing in locale_manager:', missing.length);
console.log(JSON.stringify(missing, null, 2));
