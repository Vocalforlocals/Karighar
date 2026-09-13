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
  const lines = content.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line.includes('await ') && !line.includes('// ignore:')) {
      let hasMounted = false;
      for (let j = i + 1; j < Math.min(i + 10, lines.length); j++) {
        const next = lines[j];
        if (next.includes('if (!mounted') || next.includes('if (mounted')) {
          hasMounted = true;
          break;
        }
        if ((next.includes('context.') || next.includes('Navigator.of(context)') || next.includes('ScaffoldMessenger.of(context)')) && !hasMounted) {
          issues.push({ file, line: j + 1, code: next.trim() });
          break;
        }
      }
    }
  }
}

console.log('Unsafe context after await:', issues.length);
console.log(JSON.stringify(issues, null, 2));
