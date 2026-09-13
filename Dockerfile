# ==============================================================================
# Karighar (कारीघर) — Production Multi-Stage Dockerfile
# Smart India Hackathon 2026 | MoSJE Problem Statement #26090
# ==============================================================================

# Stage 1: Build Flutter Web Release
FROM debian:bookworm-slim AS build-env

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

# Cache dependencies
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code and build optimized web bundle
COPY . .
RUN flutter build web --release

# Stage 2: Ultra-Lightweight Production Runtime (Nginx Alpine)
FROM nginx:alpine-slim

# Copy custom Nginx configuration & SSL Certificates
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /etc/nginx/certs
COPY certs/ /etc/nginx/certs/

# Copy compiled artifacts from build stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -q --spider --no-check-certificate https://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
