const fs = require('fs');
const path = require('path');

function copyDir(src, dest) {
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
  const entries = fs.readdirSync(src, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.name.endsWith('.apk')) continue;
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

if (fs.existsSync('build/web')) {
  copyDir('build/web', 'public');
  console.log('✅ Synchronized build/web into public/ for Vercel deployment');
} else if (fs.existsSync('public')) {
  console.log('✅ public/ directory already present');
} else {
  console.warn('⚠️ Neither build/web nor public found');
}

if (fs.existsSync('public/index.html')) {
  fs.copyFileSync('public/index.html', 'index.html');
  console.log('✅ Synchronized root index.html');
}
