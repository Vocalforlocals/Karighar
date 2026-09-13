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
const report = [];

for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  if (!content.includes('State<')) continue;
  
  const disposableTypes = ['TextEditingController', 'AnimationController', 'ScrollController', 'TabController', 'PageController', 'FocusNode', 'Timer', 'StreamSubscription'];
  const created = [];
  for (const type of disposableTypes) {
    const regex = new RegExp('(?:' + type + '\\s+)?([_a-zA-Z0-9]+)\\s*=\\s*(?:new\\s+)?' + type + '\\(', 'g');
    let m;
    while ((m = regex.exec(content)) !== null) {
      created.push({ type, varName: m[1] });
    }
  }

  if (created.length > 0) {
    const hasDispose = content.includes('void dispose()');
    for (const c of created) {
      const isDisposed = content.includes(c.varName + '.dispose()') || 
                         content.includes(c.varName + '?.dispose()') || 
                         content.includes(c.varName + '.cancel()') || 
                         content.includes(c.varName + '?.cancel()');
      if (!hasDispose || !isDisposed) {
        report.push({ file, type: c.type, varName: c.varName, hasDispose, isDisposed });
      }
    }
  }
}

console.log('Undisposed fields found:', report.length);
console.log(JSON.stringify(report, null, 2));
