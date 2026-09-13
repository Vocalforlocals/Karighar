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
const issues = [];

for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  // Check for Row children that might overflow
  // Also check if any Scaffold body is not scrollable when Column contains many children
  const lines = content.split('\n');
  lines.forEach((line, i) => {
    // Check for hardcoded large widths
    if (/width:\s*(?:[4-9]\d{2}|[1-9]\d{3})/i.test(line) && !line.includes('//') && !file.includes('web')) {
      issues.push({ file, line: i + 1, code: line.trim() });
    }
  });
}

console.log('Potential hardcoded width issues:', issues.length);
if (issues.length > 0) console.log(JSON.stringify(issues, null, 2));
