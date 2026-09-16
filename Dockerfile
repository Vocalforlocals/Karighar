# ==============================================================================
# Karighar (कारीघर) — Production Unified Dockerfile
# Node.js Backend API + Flutter Web Static Assets
# Smart India Hackathon 2026 | MoSJE Problem Statement #26090
# ==============================================================================

# Stage 1: Build Flutter Web Release
FROM debian:bookworm-slim AS flutter-build

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Install core build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone stable Flutter SDK
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git ${FLUTTER_HOME}
RUN flutter config --no-analytics --enable-web

WORKDIR /app

# Cache Flutter dependencies
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code and build optimized web bundle
COPY . .
RUN flutter build web --release

# ==============================================================================
# Stage 2: Node.js Production Runtime (Backend API + Flutter Web)
# ==============================================================================
FROM node:20-alpine

WORKDIR /app

# Copy package files and install Node.js dependencies
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev 2>/dev/null || npm install --omit=dev

# Copy backend source code
COPY serve_flutter.js ./
COPY backend/ ./backend/
COPY scripts/ ./scripts/

# Copy compiled Flutter web assets from build stage
COPY --from=flutter-build /app/build/web ./build/web

# Create certs directory (TLS handled by Railway's edge proxy)
RUN mkdir -p certs

# Railway injects PORT env var automatically
ENV NODE_ENV=production
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -q --spider http://localhost:${PORT:-8080}/api/v1/health || exit 1

CMD ["node", "serve_flutter.js"]
