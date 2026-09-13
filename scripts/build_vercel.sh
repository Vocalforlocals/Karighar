#!/bin/bash
# ==============================================================================
# Karighar (कारीघर) — Vercel Cloud Build Runner
# Smart India Hackathon 2026 | MoSJE Problem Statement #26090
# ==============================================================================
set -e

echo "=== Karighar Vercel Build Phase ==="

if [ -f "build/web/index.html" ] && [ -f "build/web/main.dart.js" ]; then
  echo "✅ Pre-compiled release bundle present in build/web. Proceeding directly."
else
  echo "📥 Pre-compiled bundle not detected. Installing Flutter stable SDK..."
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /tmp/flutter
  export PATH="$PATH:/tmp/flutter/bin"
  flutter config --no-analytics
  echo "🔨 Compiling Flutter Web release..."
  flutter build web --release
fi

echo "🚀 Bundle verified. Ready for Vercel edge deployment."
