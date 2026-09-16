# ==============================================================================
# Karighar (कारीघर) — Production Dockerfile
# Node.js Backend API + Pre-built Flutter Web Assets
# Smart India Hackathon 2026 | MoSJE Problem Statement #26090
# ==============================================================================

FROM node:20-alpine

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev 2>/dev/null || npm install --omit=dev

# Copy backend source code
COPY serve_flutter.js ./
COPY backend/ ./backend/
COPY scripts/ ./scripts/

# Copy pre-built Flutter web assets
COPY build/web ./build/web

# Create empty certs directory (Railway handles TLS at edge)
RUN mkdir -p certs

ENV NODE_ENV=production
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -q --spider http://localhost:${PORT:-8080}/api/v1/health || exit 1

CMD ["node", "serve_flutter.js"]
