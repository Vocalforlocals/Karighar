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
console.log('Total Dart files to audit:', files.length);

// 1. Audit missing localization keys
const localeContent = fs.readFileSync('lib/core/l10n/locale_manager.dart', 'utf8');
const trRegex = /'([^'\\]*(?:\\.[^'\\]*)*)'\.tr/g;
let missingTr = [];
for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  let match;
  while ((match = trRegex.exec(content)) !== null) {
    const key = match[1];
    if (!localeContent.includes("'" + key + "':") && !localeContent.includes('"' + key + '":')) {
      missingTr.push({ file, key });
    }
  }
}
console.log('--- LOCALIZATION AUDIT ---');
console.log('Missing .tr keys in locale_manager:', missingTr.length);
if (missingTr.length > 0) console.log(JSON.stringify(missingTr, null, 2));

// 2. Audit routes used in context.go / push
const routerContent = fs.readFileSync('lib/app/router.dart', 'utf8');
const routeRegex = /context\.(?:go|push|pushNamed)\(\s*['"]([^'"]+)['"]/g;
let brokenRoutes = [];
for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  let match;
  while ((match = routeRegex.exec(content)) !== null) {
    const route = match[1];
    // check if route or prefix is in router.dart
    const baseRoute = route.split('?')[0];
    if (!routerContent.includes("path: '" + baseRoute + "'") &&
        !routerContent.includes('path: "' + baseRoute + '"') &&
        !routerContent.includes("path: '" + baseRoute.replace('/', '') + "'") &&
        !routerContent.includes('path: "' + baseRoute.replace('/', '') + '"')) {
      brokenRoutes.push({ file, route });
    }
  }
}
console.log('--- ROUTER AUDIT ---');
console.log('Potentially unmatched routes:', brokenRoutes.length);
if (brokenRoutes.length > 0) console.log(JSON.stringify(brokenRoutes, null, 2));

// 3. Audit unclosed controllers / leaks
console.log('--- CONTROLLER DISPOSAL AUDIT ---');
let controllerIssues = [];
for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  if (content.includes('State<') && (content.includes('TextEditingController') || content.includes('AnimationController') || content.includes('ScrollController') || content.includes('TabController'))) {
    const hasDispose = content.includes('void dispose()');
    if (!hasDispose) {
      controllerIssues.push({ file, reason: 'StatefulWidget creates controller but lacks dispose() method' });
    }
  }
}
console.log('Controller disposal issues found:', controllerIssues.length);
if (controllerIssues.length > 0) console.log(JSON.stringify(controllerIssues, null, 2));

// 4. Audit async gaps without mounted check
console.log('--- ASYNC GAP (MOUNTED) AUDIT ---');
let asyncGapIssues = [];
for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  if (content.includes('State<')) {
    const lines = content.split('\n');
    let inAsync = false;
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (line.includes('await ') && !line.includes('// ignore:')) {
        // Look ahead 5 lines for context usage without mounted check
        for (let j = i + 1; j < Math.min(i + 8, lines.length); j++) {
          const nextLine = lines[j];
          if (nextLine.includes('mounted') || nextLine.includes('return;')) break;
          if (nextLine.includes('context.') || nextLine.includes('Navigator.of(context)') || nextLine.includes('ScaffoldMessenger.of(context)')) {
            asyncGapIssues.push({ file, line: j + 1, code: nextLine.trim() });
            break;
          }
        }
      }
    }
  }
}
console.log('Async gap potential context issues:', asyncGapIssues.length);
if (asyncGapIssues.length > 0) console.log(JSON.stringify(asyncGapIssues, null, 2));
