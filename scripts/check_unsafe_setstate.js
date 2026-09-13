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
  if (!content.includes('State<')) continue;
  
  const lines = content.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line.includes('await ') && !line.includes('// ignore:')) {
      // Look ahead up to 10 lines for setState without mounted check
      let hasMounted = false;
      for (let j = i + 1; j < Math.min(i + 15, lines.length); j++) {
        const next = lines[j];
        if (next.includes('if (!mounted') || next.includes('if (mounted')) {
          hasMounted = true;
          break;
        }
        if (next.includes('setState(') && !hasMounted) {
          issues.push({ file, line: j + 1, code: next.trim() });
          break;
        }
      }
    }
  }
}

console.log('Unsafe setState after await:', issues.length);
console.log(JSON.stringify(issues, null, 2));
