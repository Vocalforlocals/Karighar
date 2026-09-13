<<<<<<< HEAD
# Karighar (कारीघर)
### AI-Driven Market Linkage & Smart Cataloging Mobile Application for Marginalized Artisans
**Smart India Hackathon 2026 | Problem Statement #26090**  
**Ministry of Social Justice and Empowerment (MoSJE)**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.3-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.0-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-BLoC%209.x%20%2B%20Clean-FF6F00)](https://bloclibrary.dev)
[![PWA Ready](https://img.shields.io/badge/PWA-Installable-2E7D32?logo=pwa)](https://web.dev/progressive-web-apps/)
[![SIH Status](https://img.shields.io/badge/SIH%202026-Jury%20Ready-E8833A)](SIH_2026_DOSSIER.md)

---

## 🌟 Quick Links
- 📑 **[SIH 2026 Executive Jury Dossier](SIH_2026_DOSSIER.md)**: Full problem-statement mapping, economic analysis, and scheme alignment.
- 🚀 **Interactive Evaluator Tour**: Launch the app and tap the **"★ Tour"** button in the app bar for an automated 60-second feature walkthrough.

---

## 📱 Complete System Overview

Karighar bridges the divide between illiterate rural craftspeople and global/institutional markets through an accessible, voice-first mobile platform built on 6 core pillars:

### 1. 🎨 Artisan Studio & Edge AI (`/artisan`)
- **Namaste Home Dashboard**: Real-time sales telemetry, DBT bank settlement status, and pending order tracking.
- **📸 4K Neural Studio Filters**: Real-time image enhancements (Warm Sunlight, Studio Softbox, Heritage Silk Glow) with background elimination.
- **🎙️ Bhashini Voice-to-Catalog**: Tap-to-speak in Hindi, Tamil, Bengali, or Indian English; extracts title, craft dimensions, story, and creates dual-language SEO listings.
- **🔍 Edge Weave Quality Inspector**: Computer vision thread density analyzer ($120\text{ EPI} \times 110\text{ PPI}$) providing instant Grade A+ GI certification.
- **💰 Smart Margin Calculator**: Computes fair-trade suggested prices with transparent profit margins.

### 2. 🛍️ Buyer Discovery & Trust Engine (`/buyer`)
- **Authentic GI Marketplace**: Varanasi Silk, Jaipur Blue Pottery, Madhubani Art, Chanderi Textiles, and Dhokra Brass.
- **📜 Cryptographic GI Craft Passport (`/buyer/passport/:id`)**: Tamper-proof SHA-256 provenance hash, artisan UID, WSC batch verification, and dynamic QR generation.
- **🥽 AR 3D Craft Room Viewer (`/buyer/ar/:id`)**: Interactive 3D preview with real-time ambient lighting simulation for living rooms and offices.
- **🤝 Institutional B2B Tenders (`/buyer/tenders`)**: Government and corporate bulk quote inquiries with MOQ, wholesale tier pricing, and automated GeM/GST invoices (`HSN 5007`).

### 3. 🛡️ Autonomous Trade & Protection
- **🤖 Varta-AI Wage-Defense Sentry (`/buyer/chat`)**: Autonomous AI agent that analyzes buyer offers against rural minimum wage benchmarks ($MVAR \ge ₹850/\text{day}$) and issues polite counter-offers.
- **🌍 Cross-Border Global Export Gateway**: Instant conversion into USD (\$), EUR (€), GBP (£), and AED (د.إ) with automated DGFT Certificate of Origin generation.
- **🤝 Cluster Order Pooling (`/artisan/cluster-pooling`)**: Enables multiple artisans in a village cluster to collaboratively fulfill large institutional orders.
- **🔒 Smart Delivery Escrow**: Zero-leakage milestone-based escrow releasing funds directly to artisan bank accounts via PFMS / UPI on delivery.
- **💳 PM-Vishwakarma Karighar Credit Hub**: 300–900 alternative credit scoring system qualifying artisans for 1-tap ₹1,00,000 collateral-free subsidized micro-loans.

### 4. 🗺️ MoSJE Administration & Telemetry (`/admin/gis-map`)
- **National Artisan Cluster GIS Radar**: Live interactive telemetry mapping craft clusters, artisan density, active orders, and distress alerts across India.

---

## ⚡ Quick Start: Running Karighar

### 1. Instant Web & Mobile Testing (Recommended)
Launch the lightweight zero-dependency streaming server:
```bash
node serve_flutter.js
```
- **Desktop Browser**: Open [http://localhost:8080](http://localhost:8080)
- **Mobile Device**: Connect to the same Wi-Fi and open `http://<YOUR_LAN_IP>:8080` (e.g. `http://10.63.63.42:8080`).
- **PWA Installation**: Tap the browser install prompt or "Add to Home Screen" to install Karighar as an offline-capable native app.

### 2. Run via Flutter Toolchain
```bash
# Run on Chrome
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows

# Run on Connected Android Device
flutter run
```

### 3. Build Production Artifacts
```bash
# Production Web Build
flutter build web --release

# Standalone Android APK
powershell -ExecutionPolicy Bypass -File scripts/build_apk.ps1
```

---

## 🏛️ Technology Stack

| Layer | Technologies |
|---|---|
| **Framework** | Flutter 3.47.3 (Dart 3.7.0) |
| **State Architecture** | BLoC 9.0.0, Hydrated BLoC, Cubit |
| **Navigation** | GoRouter 14.8.1 (Dual Persistent StatefulShellRoute) |
| **Design System** | VK Component Library, Saffron & Teal Tokens, Google Fonts Plus Jakarta Sans |
| **Real-Time Sync** | Server-Sent Events (SSE) Broker (`serve_flutter.js`) |
| **Computer Vision** | 2D Canvas Matrix Shaders, Edge Thread Density Inspector |
| **Cryptography** | `crypto` package (SHA-256 Digital Provenance Hashing) |
| **Localization** | `intl`, custom dynamic `LocaleManager` (EN, HI, TA, BN) |

---

## 📋 Clean Architecture Directory Structure

```
vishawakala/
├── 📱 lib/                           # Flutter Frontend (Clean Feature-Driven Architecture)
│   ├── main.dart                     # App bootstrap
│   ├── app/                          # App-level routing & top-level aliases (/studio, /login, etc.)
│   ├── core/
│   │   ├── l10n/                     # Trilingual localization engine (English, Hindi, Tamil)
│   │   ├── models/                   # Domain entities (Product, Artisan, Order, User, Blockchain)
│   │   ├── services/                 # API client, Speech-to-Text, Audio recorder, Escrow service
│   │   ├── theme/                    # Indian handicraft design tokens & typography
│   │   └── widgets/                  # Atomic reusable widgets (VKAppBar, VKButton, VKCard, VKBadge)
│   └── features/                     # Modular Domain Features
│       ├── admin/presentation/       # MoSJE Admin panel & national GIS cluster telemetry
│       ├── artisan/presentation/     # Studio Wizard (Camera, Voice, Pricing), orders & credit
│       │   └── bloc/                 # Artisan BLoC state management
│       ├── auth/presentation/        # Login, Register, Mobile OTP & 1-tap persona selector
│       │   └── data/                 # Auth repository & session client
│       ├── buyer/presentation/       # Marketplace, GI craft showcase, tender RFQs, AR viewer
│       │   └── bloc/                 # Buyer BLoC state management
│       ├── chat/presentation/        # Real-time multi-lingual negotiation & AI assistant
│       ├── error/presentation/       # Dedicated 404 destination hub (NotFoundScreen)
│       └── trust/presentation/       # Sovereign blockchain explorer & GI verification
│
├── ⚙️ backend/                       # Node.js Full-Stack Backend (Layered Clean Architecture)
│   ├── data/                         # 🔒 Runtime Persistence (Isolated from code)
│   │   ├── database.json             # Atomic ACID file-swap JSON store
│   │   ├── karighar.sqlite        # Embedded relational SQLite database
│   │   ├── audit_trail.jsonl         # CERT-In compliant SHA-256 tamper-evident log
│   │   └── backups/                  # Automated timestamped database snapshots
│   ├── database/                     # Storage Engine & Relational Adapters
│   │   ├── db_adapter.js             # Pluggable adapter (JSON / SQLite / PostgreSQL)
│   │   ├── sqlite_engine.js          # Native node:sqlite query engine
│   │   ├── db_seeder.js              # Data normalizer & SQL seed generator
│   │   ├── schema.sql                # PostgreSQL 16 DDL relational schema
│   │   └── seed.sql                  # Seed data DML
│   ├── middleware/                   # Security, Auth & Logging Middleware
│   │   ├── auth_service.js           # JWT signing & Aadhaar biometric e-KYC
│   │   ├── webhook_security.js       # HMAC-SHA256 Sentry (GeM, PFMS, ICEGATE)
│   │   ├── rate_limiter.js           # Sliding-window DoS protection
│   │   ├── audit_logger.js           # Tamper-evident hash-chained audit logger
│   │   └── cache_adapter.js          # Distributed Redis & In-Memory message bus
│   ├── repositories/                 # Domain Repositories (Data Access Layer)
│   │   ├── product_repository.js     # Products & SHA-256 digital provenance minting
│   │   ├── order_repository.js       # Orders & smart escrow settlement
│   │   ├── tender_repository.js      # Ministry RFQs & loom capacity pooling
│   │   ├── credit_repository.js      # PM-Vishwakarma 842 credit scoring & loans
│   │   ├── blockchain_repository.js  # Sovereign ledger blocks & Merkle roots
│   │   ├── artisan_repository.js     # Artisan profiles & cluster stats
│   │   └── auth_repository.js        # User credentials & OTP store
│   └── docs/                         # OpenAPI 3.0 & Swagger UI
│       └── api_docs.js               # Interactive Swagger portal generator
│
├── 📚 docs/                          # Enterprise Project Documentation
│   ├── SIH_2026_DOSSIER.md           # Executive SIH 2026 MoSJE Dossier
│   ├── SYSTEM_AUDIT_REPORT.md        # Security, Architecture & Resilience Audit
│   └── WALKTHROUGH.md                # Multi-Phase System & Database Walkthrough
│
├── 🛠️ scripts/                       # CLI Automation & Verification Suites
│   ├── test_api.js                   # 36/36 HTTPS API Verification Suite
│   ├── db_cli.js                     # Database Administration CLI
│   ├── generate_certs.js             # Auto-detect LAN IP & TLS Certificate Generator
│   ├── demo_autopilot.js             # Automated Evaluation Simulator
│   └── build_apk.ps1                 # Android APK Builder
│
├── 🔒 certs/                         # SSL/TLS Certificates for HTTPS & Mobile LAN
│   ├── cert.pem                      # Self-signed X.509 TLS certificate
│   ├── key.pem                       # RSA 2048-bit private key
│   └── openssl.cnf                   # SAN configuration with auto-detected LAN IPs
│
├── 🧪 test/                          # Automated Frontend Tests (12/12 passing)
│   └── widget_test.dart              # Complete widget, screen & routing test suite
│
├── 🌐 web/                           # Web entrypoint (index.html & PWA manifest)
├── 📦 build/web/                     # Compiled production web bundle
│
├── 🚀 serve_flutter.js               # Master Unified HTTPS Server (Ports 8443 & 8080)
├── 🐳 docker-compose.yml             # PostgreSQL 16, Redis 7 & Web Orchestration
├── 📄 Dockerfile                     # Multi-stage production container build
├── 📄 nginx.conf                     # Reverse proxy & static caching configuration
└── 📄 pubspec.yaml                   # Flutter dependencies & assets manifest
```

---

## 👥 Smart India Hackathon 2026 Team
- **Problem Statement**: #26090 — AI-Driven Market Linkage & Smart Cataloging for Marginalized Artisans
- **Organization**: Ministry of Social Justice and Empowerment (MoSJE)
- **Status**: Production-Ready, Zero Static Warnings, 100% Verified.
=======
# Karighar
A technology-driven platform for empowering artisans, preserving traditional craftsmanship, and creating sustainable market opportunities.
>>>>>>> 4ea293724e2b60324052467ebd4b14a2f1fa90d4
