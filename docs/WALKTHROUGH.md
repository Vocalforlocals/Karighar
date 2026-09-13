# Karighar (कारीघर) — Complete Full-Stack & HTTPS System Walkthrough

> **Project**: Karighar — AI-Driven Market Linkage & Smart Cataloging for Marginalized Artisans  
> **Problem Statement**: SIH 2026 #26090 — Ministry of Social Justice & Empowerment (MoSJE)  
> **Current Milestone**: 🔒 **Secure Full-Stack HTTPS & TLS 1.3 Framework (100% Live & Verified)**  
> **Primary Secure Endpoint**: `https://localhost:8443` (Desktop) | `https://10.246.49.42:8443` (Mobile PWA)  
> **HTTP Ingress Redirect**: `http://localhost:8080` (Automatically redirects with 301 to `https://localhost:8443`)

---

## 🎨 Artisan Dashboard & Studio Overhaul (Frontend, Backend & 100% Trilingual)

The **Artisan Studio / Dashboard** screen at `/artisan` has been completely upgraded across both frontend and backend layers with reactive 100% trilingual localization (**English**, **Hindi (हि)**, and **Tamil (த)**).

### 1. Backend REST Endpoints & Data Tier
- **Artisan Statistics**: `GET /api/v1/artisan/stats?artisanId=:id`
  - Calculates real-time GMV, active order count, loom preparation count, pending RFQ quotes, GI compliance percentage, and cluster metadata.
- **Institutional Buyer Quotes**: `GET /api/v1/artisan/quotes?artisanId=:id`
  - Provides pending & countered B2B institutional procurement quotes (e.g. FabIndia, Oberoi Hotels & Resorts) with target pricing and delivery requirements.
- **OpenAPI 3.0 & Swagger UI Documentation**: Fully documented in `/api/v1/openapi.json` and interactive at `/api/docs`.
- **Automated Integration Tests**: Added to `scripts/test_api.js`, achieving **33/33 tests passing (100%)**.

### 2. Frontend Visual & Structural Enhancements
- **Dynamic Profile Banner**:
  - Automatically derives the artisan's initials, full name, and guild cluster from `ApiClient.currentUser` (e.g. Master Ramdev Varma, Banarasi Silk Weavers Guild).
  - Enhanced avatar with golden double border ring (`AppColors.gold`) and `GI Master` verified badge.
- **Hero 4K AI Studio Wizard Banner**:
  - Deep dark slate gradient (`#1E293B` ➔ `#0F172A`) with vibrant terracotta saffron glowing icon badge and 4K AI indicator chip.
  - 1-tap navigation directly to `/artisan/add-product`.
- **Elevated Metric Cards**:
  - **Total GMV**: Live GMV currency format with positive growth delta tag (`+38.4% Uplift`).
  - **Active Orders**: Real-time units with loom prep count.
  - **Bulk Quotes**: Pending quotes count with buyer brand tags (FabIndia, Oberoi).
  - **GI Compliance**: 100% Certified with MoSJE verification badge.
- **Quick Action Row & Flexible Layout**:
  - `VKButton` upgraded with `Flexible` text truncation so longer translations in Hindi or Tamil gracefully scale across all mobile and desktop screen widths without RenderFlex overflow.
- **B2B Cluster Pooling & Karighar Credit Cards**:
  - Institutional loom pooling card (`/artisan/cluster-pooling`) with peacock teal accent.
  - PM-Vishwakarma Karighar Credit working capital card (`/artisan/credit`) with pre-approved ₹1,00,000 collateral-free limit tag.
- **Recent Loom Orders & Active Catalog**:
  - Real-time product cards with network image fallbacks, translated buyer and quantity labels, and localized status badges (`PENDING`, `IN PRODUCTION`, `DELIVERED`).
- **Setu Didi Voice Assistant FAB**:
  - Localized floating mic button (`'Setu Didi (Voice)'.tr`) reactively updating across languages:
    - **English**: `Setu Didi (Voice)`
    - **Hindi**: `सेतु दीदी (आवाज़)`
    - **Tamil**: `சேது தீதி (குரல்)`

### 3. 100% Trilingual Localization Matrix
Every text element on the Artisan Dashboard is wired to `LocaleManager.currentLanguage` via `ValueListenableBuilder`. When the user toggles the language switcher in the app bar, every element re-renders instantaneously without page reload:

| Component / Label | English (`en`) | Hindi (`hi` - हि) | Tamil (`ta` - த) |
| :--- | :--- | :--- | :--- |
| **App Bar Title** | Artisan Studio | कारीगर स्टूडियो | கைவினைஞர் அரங்கம் |
| **Hero Title** | Launch AI Studio Wizard | एआई स्टूडियो विज़ार्ड शुरू करें | AI கலைக்கூட வழிகாட்டியைத் தொடங்குக |
| **Hero Description** | Photograph loom craft, speak description in Hindi, get 4K enhancement & MoSJE pricing. | हथकरघा शिल्प की फोटो लें, हिंदी में विवरण बोलें, 4के गुणवत्ता और सरकारी मूल्य प्राप्त करें। | நெசவுப் பொருளைப் படம் பிடியுங்கள், விவரத்தைப் பேசுங்கள், 4K மெருகேற்றலும் அரசு விலையும் பெறுங்கள். |
| **Total GMV Metric** | Total GMV | कुल सकल बिक्री | மொத்த விற்பனை |
| **GMV Delta** | +38.4% Uplift | +38.4% वृद्धि | +38.4% உயர்வு |
| **Active Orders Metric** | Active Orders | सक्रिय ऑर्डर | செயலில் உள்ள ஆர்டர்கள் |
| **Loom Prep Delta** | 2 in Loom Prep | 2 करघे की तैयारी में | 2 தறி தயாரிப்பில் |
| **Bulk Quotes Metric** | Bulk Quotes | थोक मूल्य प्रस्ताव | மொத்த விலை கோரிக்கைகள் |
| **GI Compliance** | GI Compliance | जीआई अनुपालन | புவிசார் குறியீடு |
| **Certified Tag** | 100% Certified | 100% प्रमाणित | 100% சான்றளிக்கப்பட்டது |
| **Verified Tag** | MoSJE Verified | मंत्रालय द्वारा सत्यापित | அரசு சரிபார்க்கப்பட்டது |
| **Add Product Button** | Add Product (AI) | नया उत्पाद जोड़ें (एआई) | பொருள் சேர்க்க (AI) |
| **View Quotes Button** | View Quotes | प्रस्ताव देखें | விலை கோரிக்கைகள் |
| **Cluster Pooling** | Institutional B2B Cluster Pooling | संस्थागत बी2बी क्लस्टर पूलिंग | நிறுவன B2B தொகுப்பு |
| **Karighar Credit Hub** | PM-Vishwakarma Karighar Credit Hub | पीएम-विश्वकर्मा कारीघर क्रेडिट हब | பிஎம்-விஸ்வகர்மா காரிகர் கிரெடிட் மையம் |
| **Recent Orders** | Recent Loom Orders | हाल के करघा ऑर्डर | சமீபத்திய தறி ஆர்டர்கள் |
| **Active Catalog** | My Active Catalog | मेरा सक्रिय कैटलॉग | எனது நேரடிப் பட்டியல் |
| **New Craft Button** | New Craft | नया शिल्प | புதிய கைவினை |
| **Market Status** | LIVE ON MARKET | बाज़ार में लाइव | சந்தையில் நேரலை |
| **Voice Assistant FAB** | Setu Didi (Voice) | सेतु दीदी (आवाज़) | சேது தீதி (குரல்) |

---

## 🔒 2. HTTPS Security Architecture

The Karighar application and backend have been upgraded to an end-to-end encrypted TLS framework:

1. **Cryptographic Certificate Tier (`certs/`)**:
   - 2048-bit RSA Private Key (`key.pem`) and X.509 Certificate (`cert.pem`) generated via OpenSSL.
   - Built with **Subject Alternative Names (SAN)** for `localhost`, `127.0.0.1`, `*.localhost`, and mobile LAN IP `10.63.63.42`.
2. **Dual-Engine Node Server (`serve_flutter.js`)**:
   - **Primary HTTPS Server (Port 8443)**: Serves Flutter PWA, 15 REST API endpoints, and real-time SSE over TLS 1.3 / 1.2 with HSTS (`Strict-Transport-Security: max-age=31536000; includeSubDomains`).
   - **HTTP Ingress Listener (Port 8080)**: Automatically intercepts unencrypted HTTP traffic and returns an HTTP 301 redirect upgrading the connection to HTTPS.
3. **Nginx & Cloud Containerization (`nginx.conf` + `Dockerfile`)**:
   - Port 443 SSL VirtualHost with modern ciphers (`ECDHE-ECDSA-AES128-GCM-SHA256`, `ECDHE-RSA-AES256-GCM-SHA384`) and HTTP/2 support.
   - Port 80 permanent redirect to `https://$host$request_uri`.
   - `Dockerfile` updated to expose ports 80 and 443 with certificate mount.
4. **Flutter Client (`lib/core/services/api_client.dart`)**:
   - Upgraded to secure HTTPS networking on mobile and Web origins.

---

## ⚡ 3. Verified HTTPS API Matrix

| Test Case | Protocol & URL | Result |
| :--- | :--- | :---: |
| **HTTP Auto-Redirect** | `GET http://localhost:8080/api/v1/health` | **`301 Moved Permanently` ➔ `https://localhost:8443/api/v1/health`** |
| **HSTS Security Header** | `GET https://localhost:8443/api/v1/health` | **`200 OK` (HSTS: `max-age=31536000`)** |
| **Artisan Live Stats** | `GET https://localhost:8443/api/v1/artisan/stats` | **`200 OK` (Live GMV & loom counts)** |
| **Artisan Bulk Quotes** | `GET https://localhost:8443/api/v1/artisan/quotes` | **`200 OK` (Institutional quotes)** |
| **Products Catalog** | `GET https://localhost:8443/api/v1/products` | **`200 OK` (4+ crafts verified)** |
| **SHA-256 Provenance** | `GET https://localhost:8443/api/v1/products/prod_01` | **`200 OK` (SHA-256 hash returned)** |
| **Publish Craft** | `POST https://localhost:8443/api/v1/products` | **`201 Created` (Encrypted minting)** |
| **Active Orders** | `GET https://localhost:8443/api/v1/orders` | **`200 OK`** |
| **Cluster Pooling** | `POST https://localhost:8443/api/v1/tenders/tender_taj_500/pool` | **`200 OK` (Capacity updated)** |
| **Varta-AI Sentry** | `POST https://localhost:8443/api/v1/negotiate/evaluate` | **`200 OK` (Lowball defense active)** |
| **Smart Escrow Release** | `POST https://localhost:8443/api/v1/escrow/verify` | **`200 OK` (PFMS Ack minted)** |
| **PM-Vishwakarma Credit**| `GET https://localhost:8443/api/v1/credit/profile/art_ramdev_01` | **`200 OK` (842 AAA Prime)** |
| **1-Tap Loan Claim** | `POST https://localhost:8443/api/v1/credit/disburse` | **`200 OK` (Loan ref generated)** |
| **MoSJE GIS Telemetry** | `GET https://localhost:8443/api/v1/gis/clusters` | **`200 OK` (5 national clusters)** |
| **AI Weave Inspection** | `POST https://localhost:8443/api/v1/ai/weave-inspect` | **`200 OK` (Grade A+ GI Handloom)** |
| **Bhashini Voice AI** | `POST https://localhost:8443/api/v1/ai/voice-catalog` | **`200 OK` (Bilingual extraction)** |
| **OpenAPI 3.0 Specs** | `GET https://localhost:8443/api/v1/openapi.json` | **`200 OK` (Valid JSON specification)** |
| **Swagger UI Portal** | `GET https://localhost:8443/api/docs` | **`200 OK` (Interactive documentation)** |

---

## 🧪 4. Complete Verification Results

```bash
# 1. Automated HTTPS API Test Suite
node scripts/test_api.js
# Output: 33 Passed, 0 Failed (100% clean)

# 2. Dart Static Analysis
flutter analyze --no-fatal-infos
# Output: No issues found! (0 warnings, 0 errors across 61 files)

# 3. Flutter Unit & Widget Tests
flutter test
# Output: 00:04 +10: All tests passed! (10/10 passing)

# 4. Production Release Web Bundle
flutter build web --release
# Output: √ Built build\web (91.6s)
```

---

## 🚀 5. How to Test the Updated Platform

1. **On your Browser**:
   - Navigate to **`https://localhost:8443/artisan`**.
   - Review the improved profile banner, hero AI studio card, metric uplift chips, and active catalog.
   - Click the language selector pill in the top right (`EN` / `हि` / `த`) and switch between **English**, **हिंदी**, and **தமிழ்**.
   - Notice that every label, metric delta, button, badge, and helper card translates dynamically.
2. **Interactive Voice Assistant**:
   - Tap the **Setu Didi (Voice)** FAB in the bottom right corner to interact via voice or text in your chosen language.
3. **Swagger API Docs**:
   - Navigate to **`https://localhost:8443/api/docs`** to test the new `/api/v1/artisan/stats` and `/api/v1/artisan/quotes` endpoints live.
