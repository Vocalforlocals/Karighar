# Karighar Buyer App: Architectural & UI/UX Benchmark Report
**Comparative Industry Analysis (Flipkart, Amazon India, Etsy, Myntra) & Blueprint for Building the Karighar Buyer App from Scratch**

*Document Status: Pending User Review & Approval*  
*Author: Senior Principal Mobile & Full-Stack Architect*  
*Target System: Karighar (कारीघर) — National Handicrafts & Handloom Platform*  
*Reference File: `flipkart.md`*

---

## Executive Summary & Strategic Context

The **Karighar Buyer App** is designed to connect conscious consumers, cultural connoisseurs, and institutional buyers directly with India's master artisans, weavers, and craft cooperatives. Unlike generic mass-market e-commerce platforms (Flipkart, Amazon) that prioritize speed, massive SKUs, and heavy discounting, or Western craft marketplaces (Etsy) that cater primarily to hobbyists, **Karighar occupies a unique niche**:

1. **Authenticity & Provenance**: Every listing is backed by Geographical Indication (GI) tags, Ministry of Textiles / Craft Mark certifications, and tamper-evident SHA-256 digital provenance twins.
2. **Vernacular & Voice-First Inclusivity**: Powered by the Government of India's Bhashini NLTM engine, supporting 22 constitutional languages and 4 Bihari dialects (Bhojpuri, Maithili, Magahi, Angika), making craft discovery accessible through spoken natural language.
3. **Ethical & Fair Wage Transparency**: Buyers see an itemized wage transparency breakdown (Raw materials, Artisan labor, Packaging, Logistics, Fair margin) ensuring master artisans receive fair remuneration.
4. **Smart Escrow Financial Security**: Buyer funds are held in RBI-compliant nodal escrow and only disbursed to artisans upon successful delivery and a 7-day buyer satisfaction window, integrated with PFMS (Public Financial Management System) for DBT.

This document presents a **forensic benchmark** of India's leading e-commerce platforms—**Flipkart** (India's domestic retail leader), **Amazon India** (logistics & faceted discovery standard), and **Etsy / Myntra** (storytelling, curation, and visual presentation)—and translates these battle-tested patterns into a **production-ready blueprint for Karighar's Buyer App built from scratch**.

> [!IMPORTANT]
> **No implementation code will be written without your explicit review and permission.** This document serves as the foundational architectural blueprint for your evaluation.

---

## 1. Comparative Platform Matrix: Flipkart vs. Amazon vs. Etsy vs. Myntra

| Feature Dimension | Flipkart (India) | Amazon India | Etsy (Global / India) | Myntra (Fashion/Lifestyle) | **Karighar Buyer Target** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Primary Value Proposition** | Value for money, electronics & fashion, high gamification (SuperCoins). | Speed (Prime 1-2 day), vast catalog, subscription lock-in. | Unique handcrafted items, artisan identity, vintage goods. | Visual-first fashion discovery, trends, studio try-on. | **Certified GI Authentic Crafts, Direct Artisan Connection, Fair Price, Cultural Heritage.** |
| **Discovery & Search** | Sticky header, Voice search (Hindi/English), Flipkart Camera (lens search). | Deep faceted search (A9 algorithm), multi-attribute filter drawers. | Semantic search, craft style, occasion-based gift discovery. | Visual stream, influencer closets, high-density lookbooks. | **Bhashini 26-Lang Voice Search, Visual Craft Lens, Region/GI Cluster Explorer.** |
| **Product Detail Page (PDP)** | Price slash, Bank offer accordions, Pin-code delivery date, split CTA. | Extensive technical bullet points, A+ rich brand content, Q&A section. | Artisan story card, shop policies, custom personalization text field. | Size/fit guide, styling recommendations, 4K zoom video reels. | **Studio 4K Zoom, 360 Spin, Artisan Story Video, Fair Wage Breakdown, GI Seal.** |
| **Cart & Bag** | Auto-coupons, price summary, frequently bought together, save for later. | 1-Click Buy Now vs Add to Cart, quantity pickers, Prime badge. | Multi-shop cart separation, note to seller, gift wrap option. | Dynamic shipping threshold progress bar, coupon bag drawer. | **Single Artisan / Multi-Cluster Bag, Customization Notes, GI Certificate inclusion.** |
| **Checkout Flow** | 4-Step Accordion (Login -> Address -> Summary -> Payment). | 1-Page Accordion with saved 1-click address & default payment. | 2-Page Clean Checkout (Guest checkout supported). | Clean 3-Step Breadcrumb (Bag -> Address -> Payment). | **Step-Wise Transparent Flow with Address Auto-GPS, GST Invoice option, Escrow Notice.** |
| **Payment Ecosystem** | UPI Intent, Flipkart Pay Later, SuperCoins + Cash, CoD, Cards. | Amazon Pay UPI, Amazon Pay Later, CoD, Netbanking, Cards. | Credit Cards, PayPal, UPI (India localized via Razorpay). | UPI Intent, EMI, Wallets, Pay on Delivery, Myntra Credit. | **UPI Intent (GPay/PhonePe/Paytm/BHIM), Dynamic QR, Razorpay/Cashfree, Escrow-Protected CoD.** |
| **Post-Purchase & OMS** | Live step-by-step graphical tracking, OTP on delivery, Flipkart Help. | Real-time map courier tracking, driver contact, automated returns. | Direct messaging with artisan, handmade production updates. | Real-time tracking timeline, instant exchange pick-up. | **Live Courier Tracking, Digital Provenance Passport, Artisan WhatsApp Video thank-you.** |

---

## 2. In-Depth Customer Journey & Functional Analysis

```
                      +-------------------------------------------------------------+
                      |                 KARIGHAR BUYER JOURNEY                     |
                      +-------------------------------------------------------------+
                                                     |
         +-------------------------------------------+-------------------------------------------+
         |                                           |                                           |
         v                                           v                                           v
[ 1. DISCOVERY & SEARCH ]               [ 2. PRODUCT EXPERIENCE ]               [ 3. TRUST & PROVENANCE ]
* Voice Search in 26 Langs              * 4K Ultra-Zoom Studio View             * GI Registry Tag Verification
* Visual Craft Lens (Gemini)            * 360-Degree Handcraft Spin             * SHA-256 Digital Twin
* Regional Cluster Interactive Map      * Video of Artisan at Loom/Wheel        * Transparent Wage Breakdown
* Filter by Craft / State / Price       * Variant (Size, Color, Material)       * Artisan Profile & Awards
         |                                           |                                           |
         +-------------------------------------------+-------------------------------------------+
                                                     |
                                                     v
                                      [ 4. CART & INVENTORY HOLD ]
                                      * Soft-Lock Inventory (15 Min TTL)
                                      * Pincode Delivery & SLA Estimator
                                      * Customization & Engraving Notes
                                      * Transparent Price Breakdown
                                                     |
                                                     v
                                        [ 5. FRICTIONLESS CHECKOUT ]
                                        * GPS Pincode Auto-Resolution
                                        * Saved Multi-Address Drawer
                                        * GST & Tax Invoice for B2B/Gift
                                                     |
                                                     v
                                      [ 6. PAYMENT & ESCROW HOLD ]
                                      * UPI Intent (GPay / PhonePe / Paytm)
                                      * Dynamic UPI QR for Desktop Shoppers
                                      * Escrow Protection Notice
                                      * Webhook Confirmation & Stock Hard-Lock
                                                     |
                                                     v
                                       [ 7. POST-PURCHASE & OMS ]
                                       * Live Courier Timeline & Map
                                       * Downloadable Provenance Passport
                                       * 7-Day Inspection Window
                                       * Escrow Release to Artisan via PFMS
```

### 2.1 Discovery & Search Ergonomics (Flipkart & Amazon Benchmark)

#### Flipkart Benchmark:
* **High-Density Search Bar**: Prominently sits at the top of every screen with a fixed height (48-52dp), curved corners, search icon on the left, and dual action buttons on the right (Microphone for Voice Search, Camera for Visual Lens).
* **Predictive Autocomplete & Query Suggestions**: As the user types 2-3 characters, an instant dropdown displays recent searches with a "clock" icon, category-scoped queries ("madhubani in paintings", "madhubani in sarees"), and trending badges.
* **Vernacular Voice Search**: Flipkart’s voice search converts Hindi/regional phrases (e.g., *"sasti suti saree dikhao"*) into normalized product queries with instant fallback transliteration.

#### Karighar Buyer App Implementation Specification:
* **Unified Discovery Bar**:
  * Voice microphone triggering **Bhashini NLTM** supporting 22 Indian languages and Bihari dialects (Bhojpuri, Maithili, Magahi, Angika) with real-time waveform animation.
  * Visual Search ("Craft Lens") powered by **Google Gemini 2.5 Flash Multimodal**, allowing buyers to snap a photo of any textile, pottery, or painting and match it against authentic artisan catalogs.
* **Regional Craft Explorer**:
  * An interactive visual map of India allowing buyers to browse by GI cluster (e.g., *Mithila Paintings - Madhubani*, *Bhagalpuri Silk - Bhagalpur*, *Channapatna Toys - Karnataka*, *Blue Pottery - Jaipur*).
* **Faceted Smart Filters**:
  * Craft Technique (Hand-painted, Hand-woven, Lost-wax brass cast, Wood-carved).
  * Artisan Certification (National Awardee, Shilp Guru, State Awardee, Co-op Society).
  * Delivery Speed (Ready to Dispatch in 24h vs. Made-to-Order Custom Craft).
  * Price Range with live histogram slider.

---

### 2.2 Product Detail Page (PDP) Architecture

The PDP is the critical conversion engine. On Amazon and Flipkart, 65% of buyer drop-offs occur on the PDP due to unclear delivery timelines or lack of product trust. For handcrafted items, the trust deficit is even higher.

```
+------------------------------------------------------------+
|  <- [Back]            KARIGHAR PDP              [Share] [❤️] |
+------------------------------------------------------------+
|                                                            |
|              [ 4K INTERACTIVE IMAGE CAROUSEL ]             |
|              (Pinch-to-zoom / 360 Spin / Video)            |
|                                                            |
|   (•) 1/6  [Play Reel]  [View in Room AR]  [GI Certified]  |
+------------------------------------------------------------+
| MADHUBANI HAND-PAINTED TUSSAR SILK SAREE                   |
| By Master Artisan: Smt. Sita Devi | Madhubani, Bihar      |
| ⭐ 4.9 (128 verified reviews) | 🛡️ GI Tag #GI-370          |
+------------------------------------------------------------+
| ₹6,450  M.R.P.: ₹8,500  (24% OFF)                          |
| Inclusive of all taxes | Free Shipping                     |
+------------------------------------------------------------+
| [💰 FAIR WAGE BREAKDOWN ACCORDION]                         |
| Raw Silk: ₹2,200 | Artisan Labor (14 days): ₹3,500        |
| Natural Dyes: ₹350 | Packaging & Logistics: ₹400           |
+------------------------------------------------------------+
| [📍 DELIVERY & PINCODE CHECK]                              |
| [ Enter Pincode (e.g. 110001) ] -> [ Check ]               |
| 🚚 Fastest delivery by Thursday, Sep 18 | COD Available    |
+------------------------------------------------------------+
| [🎨 ARTISAN STORY & WORKSHOP]                              |
| "Meet the Weaver" video card with workshop photo & bio     |
+------------------------------------------------------------+
| [🛡️ BLOCKCHAIN PROVENANCE DIGITAL PASSPORT]               |
| SHA-256 Hash: 8f7e2a... [Verify Certificate]               |
+------------------------------------------------------------+
|                                                            |
|  [ ADD TO CART (₹6,450) ]  |  [ BUY NOW (INSTANT UPI) ]   |
+------------------------------------------------------------+
```

#### Key Ergonomic Components:
1. **Pinch-to-Zoom 4K Gallery**:
   * Multi-angle high-resolution photography capturing natural weave textures, dye bleed, and hand-chiseled imperfections that prove authenticity.
   * "In-the-Making" short video reel showing the artisan actively crafting the specific piece.
2. **Interactive AR "View in Room"**:
   * For home decor (brass statues, Dhokra figurines, Madhubani wall canvases, Blue Pottery vases), buyers can preview the item to scale in their living room using web/mobile AR.
3. **Pincode Delivery Estimator**:
   * Instant lookup against courier serviceability APIs (Delhivery / Shiprocket / India Post).
   * Displays clear promise: "Free delivery by Friday, Sep 19" or "Made-to-Order: Dispatches in 4 days".
4. **Fair Wage Transparency Drawer**:
   * Shows buyers exactly where their money goes, eliminating exploitative middleman markups.
5. **Persistent Split Sticky Action Bar**:
   * Fixed at the bottom of the viewport with zero scroll interference.
   * Left: `Add to Cart` (Outlined, secondary accent).
   * Right: `Buy Now` (Solid emerald green / deep terracotta, high visual weight).

---

### 2.3 Cart & Inventory Reservation (The 15-Minute Soft Lock)

In mass retail (Amazon/Flipkart), inventory consists of thousands of identical factory units. In handicrafts, **each piece is often unique (1-of-1) or available in strictly limited quantities (e.g., 2 pieces hand-loomed per month)**.

If two buyers click "Buy Now" at the same moment, standard e-commerce architectures suffer from **race-condition double-selling**.

#### Karighar Two-Phase Inventory Lock Architecture:

```
[Buyer Clicks 'Proceed to Checkout']
                 |
                 v
[Check Available Stock in Redis/DB]
       |
       +---> Stock == 0 ---> Return HTTP 409 "Artisan Craft Sold Out"
       |
       +---> Stock >= 1 ---> [Acquire Atomic Soft-Lock]
                                  |
                                  +--> Decrement available inventory in Cache
                                  +--> Set Redis Key: `lock:inventory:{productId}` (TTL: 900s / 15 min)
                                  +--> Store `reservation_id` in Buyer Session
                                  |
                                  v
                       [Buyer Proceeds to Payment Gate]
                                  |
            +---------------------+---------------------+
            |                                           |
            v                                           v
[Payment Captured Successfully]          [Payment Fails or 15-Min TTL Expires]
            |                                           |
            +--> Commit Hard-Lock in DB                 +--> Background Cron / TTL Key Expiry
            +--> Mark Order "CONFIRMED"                 +--> Re-increment available inventory
            +--> Notify Artisan                         +--> Broadcast Stock Restoration via SSE
```

---

## 3. Indian FinTech & Payment Ecosystem Benchmark

India leads the world in real-time digital payments via the Unified Payments Interface (UPI). In tier-1 e-commerce apps:
* **UPI accounts for 68% - 74%** of all consumer e-commerce transactions.
* **Cards (Credit/Debit with COFT)** account for 14% - 18%.
* **Cash on Delivery (COD)** accounts for 8% - 14% (down from 60% in 2016, but still essential for tier-2/tier-3 buyers).
* **Netbanking & Wallets** account for the remainder.

```
+-----------------------------------------------------------------------------+
|                      KARIGHAR PAYMENT ORCHESTRATOR                          |
+-----------------------------------------------------------------------------+
|                                                                             |
|  1. UPI INTENT (Mobile Native)                                              |
|     [ Google Pay ]     [ PhonePe ]     [ Paytm ]     [ CRED UPI / BHIM ]    |
|     * Direct App-to-App handoff via Android/iOS deep-link `upi://pay`       |
|                                                                             |
|  2. DYNAMIC UPI QR (Desktop / Web Shoppers)                                 |
|     * Renders instantaneous dynamic QR code with exact order amount         |
|     * Live SSE/Polling listener detects payment in < 1.5 seconds            |
|                                                                             |
|  3. CREDIT / DEBIT CARDS (RBI Tokenized COFT)                               |
|     * RuPay, Visa, MasterCard with 2-Factor OTP verification                |
|                                                                             |
|  4. ESCROW-PROTECTED CASH ON DELIVERY (COD)                                 |
|     * Available for verified pincodes                                       |
|     * OTP-protected delivery to eliminate Return-To-Origin (RTO) fraud       |
|                                                                             |
|  5. NODAL ESCROW HOLD & PFMS SETTLEMENT                                     |
|     * 100% buyer funds held in RBI Section 25 Nodal Escrow                  |
|     * Disbursed directly to artisan bank account via PFMS upon delivery     |
+-----------------------------------------------------------------------------+
```

### 3.1 UPI Intent vs. UPI Collect vs. Dynamic QR

1. **UPI Intent (Recommended for Mobile App)**:
   * When the buyer taps "Pay with Google Pay" or "PhonePe", the Karighar app invokes the native OS intent via `upi://pay?pa=karighar.escrow@icici&pn=KarigharEscrow&am=6450.00&tr=ORD-2026-9041&tn=Madhubani%20Saree`.
   * **Zero manual VPA entry required**. Buyer authenticates with UPI PIN inside their trusted banking app and is instantly redirected back to Karighar.
   * **Success rate: 94-96%** (compared to only 78% for UPI Collect where users must wait for an SMS or external app notification).

2. **Dynamic UPI QR (For Web & Desktop Shoppers)**:
   * The backend generates a signed UPI payload encoded as a QR code rendered in real-time.
   * The buyer points any UPI app scanner at their laptop screen and authorizes payment.
   * The web page listens to server-sent events (`/api/sync/events`) and automatically transitions to the "Order Confirmed" screen the instant the bank webhook fires.

3. **Payment Gateway Fallback Engine**:
   * Primary: **Razorpay** / **Cashfree Payments** (best-in-class Indian UPI & card conversion rates).
   * Webhook Signature Verification: Every payment callback is verified using `HMAC-SHA256` with mutual TLS encryption before marking orders as paid.

### 3.2 Karighar Smart Escrow Architecture (The Core Differentiator)

In standard Flipkart/Amazon models, platforms hold seller money for 7 to 15 days to manage return reserves, often delaying payments to vulnerable artisans.

**The Karighar Escrow Framework**:
1. **Nodal Holding**: Buyer payment enters an RBI-regulated Nodal Account.
2. **Real-Time Artisan Notification**: Artisan receives an instant SMS & WhatsApp alert: *"Funds of ₹6,450 are locked in Escrow for Order #ORD-2026-9041. You can safely dispatch the parcel."*
3. **Delivery Milestone**: India Post / Courier API delivers parcel -> System triggers an automated 7-day buyer inspection period.
4. **Automated Disbursement**:
   * After 7 days (or upon buyer manual approval), the Escrow release engine invokes the **PFMS Direct Benefit Transfer (DBT)** gateway.
   * 100% of fair artisan earnings are wired straight to the artisan’s Aadhaar-linked bank account without platform cuts.

---

## 4. UI/UX Design System & Ergonomics Benchmark

### 4.1 Typography, Colors, & Aesthetic Direction

| Element | Generic Mass Retail (Flipkart/Amazon) | Karighar Artisanal Luxury & Provenance |
| :--- | :--- | :--- |
| **Primary Theme** | Electric Blue (`#2874F0`) or Amazon Orange (`#FF9900`) | **Terracotta Ochre (`#D9531E`), Deep Indigo (`#1A2B4C`), Warm Parchment (`#FAF7F2`)** |
| **Typography** | Roboto / Amazon Ember (Clean, corporate, sans-serif) | **Cinzel / Rozha One (Serif display for craft heritage) + Inter / Noto Sans (Body readability)** |
| **Visual Texture** | Flat solid surfaces, bright neon discount tags | **Handmade paper grain, subtle brass metallic accents, woven border patterns** |
| **Imagery** | Cutout white-background studio shots | **High-contrast warm editorial photography showing crafts in natural light and artisan workshops** |
| **Voice & Tone** | "Hurry! 70% Off Today Only!" | **"Preserving 500 years of Madhubani tradition. Handcrafted with reverence."** |

### 4.2 Mobile Bottom Navigation Hierarchy

```
+-------------------------------------------------------------+
|    [ 🏠 ]        [ 🔍 ]        [ 📜 ]       [ 🛍️ ]     [ 👤 ]   |
|     Home        Explore       Stories        Cart      Profile  |
+-------------------------------------------------------------+
```
* **Home (`/home`)**: Curated daily feeds, GI cluster spotlights, master artisan reels, vernacular quick-dial.
* **Explore (`/explore`)**: Faceted category browser, 26-language voice search, visual craft scanner, regional state craft map.
* **Stories (`/stories`)**: Immersive full-screen short video feed (*"Craft Reels"*) showcasing how master weavers spin raw silk, chisel brass, or paint with bamboo twigs.
* **Cart (`/cart`)**: Real-time bag counter with active 15-min reservation badge, transparent price breakdown, one-tap checkout.
* **Profile (`/profile`)**: Order history, live shipment tracking, digital provenance passports, language switcher (22 Constitutional + 4 Bihari).

---

## 5. Backend Architecture & REST API Contracts for Buyer App

The backend running in `serve_flutter.js` already features high-performance repositories for products, orders, escrow, Bhashini, and Gemini. Below are the targeted API endpoints to be linked directly with the Buyer App:

```
                                  KARIGHAR BUYER REST APIS
+-------------------------------------------------------------------------------------------------+
| Endpoint                           | Method | Purpose                                           |
+------------------------------------+--------+---------------------------------------------------+
| /api/v1/buyer/feed                 | GET    | Dynamic home feed, hero banners, curated clusters |
| /api/v1/products                   | GET    | Filterable catalog with search & GI tags          |
| /api/v1/products/:id               | GET    | Rich PDP with artisan bio, 360 images, wage split |
| /api/v1/buyer/pincode/:code        | GET    | Delivery SLA, courier route, and COD verification |
| /api/v1/buyer/cart/reserve         | POST   | Soft-lock inventory for 15 minutes                |
| /api/v1/buyer/checkout/initiate    | POST   | Calculate tax, discounts, shipping, create order  |
| /api/v1/buyer/payment/create-order | POST   | Generate UPI Intent string or Dynamic QR payload  |
| /api/v1/buyer/payment/webhook      | POST   | Idempotent HMAC-SHA256 verified payment callback  |
| /api/v1/buyer/orders/:id/track     | GET    | Live shipment milestone timeline & courier map    |
| /api/v1/buyer/passport/:orderId    | GET    | Cryptographic Digital Provenance Certificate      |
+-------------------------------------------------------------------------------------------------+
```

### 5.1 Sample Request / Response Contracts

#### 1. Inventory Soft-Reservation (`POST /api/v1/buyer/cart/reserve`):
```json
// Request
{
  "items": [
    { "productId": "prod_madhubani_01", "quantity": 1 }
  ],
  "buyerSessionId": "sess_9921_alpha"
}

// Response (200 OK)
{
  "success": true,
  "reservationId": "res_84920491",
  "expiresAt": "2026-09-14T19:15:00Z",
  "ttlSeconds": 900,
  "lockedItems": [
    { "productId": "prod_madhubani_01", "unitPrice": 6450, "status": "RESERVED" }
  ]
}
```

#### 2. UPI Intent Generation (`POST /api/v1/buyer/payment/create-order`):
```json
// Request
{
  "orderId": "ORD-2026-9041",
  "paymentMethod": "UPI_INTENT",
  "upiProvider": "GPAY"
}

// Response (200 OK)
{
  "success": true,
  "orderId": "ORD-2026-9041",
  "amount": 6450.00,
  "currency": "INR",
  "upiIntentUrl": "upi://pay?pa=karighar.escrow@icici&pn=Karighar%20Escrow&mc=5947&tid=TXN20260914001&tr=ORD-2026-9041&tn=Madhubani%20Silk%20Saree&am=6450.00&cu=INR",
  "qrPayload": "upi://pay?pa=karighar.escrow@icici&pn=Karighar%20Escrow&tr=ORD-2026-9041&am=6450.00",
  "escrowProtected": true
}
```

---

## 6. Phased Implementation Roadmap for Karighar Buyer App

Once approved, we will build the Buyer App from scratch following this phased, test-driven blueprint:

```
+---------------------------------------------------------------------------------------------+
|                                    PHASED EXECUTION PLAN                                    |
+---------------------------------------------------------------------------------------------+
| Phase 1: Buyer Design System & Home Experience                                              |
|   * Terracotta & Indigo artisanal UI theme, typography, and responsive scaffold.           |
|   * Dynamic Home Feed with GI spotlights, master artisan stories, and category chips.       |
|   * Floating Bhashini 26-language voice navigation widget.                                 |
+---------------------------------------------------------------------------------------------+
| Phase 2: Catalog Discovery, Faceted Search & Visual Lens                                    |
|   * High-performance searchable catalog with multi-attribute craft filters.                |
|   * Multimodal Gemini Craft Lens (image search against authentic artisan catalog).          |
|   * Interactive GI Craft Map of India.                                                     |
+---------------------------------------------------------------------------------------------+
| Phase 3: High-Conversion Product Detail Page (PDP)                                         |
|   * 4K pinch-to-zoom interactive image & video carousel.                                    |
|   * Fair Wage Transparency breakdown drawer.                                                |
|   * Pincode delivery SLA & COD eligibility estimator.                                       |
|   * Persistent split sticky action bar (`[Add to Cart]` / `[Buy Now]`).                     |
+---------------------------------------------------------------------------------------------+
| Phase 4: Cart, Pincode Engine & 15-Minute Soft-Lock                                         |
|   * Redis-backed atomic 15-minute stock reservation engine.                                 |
|   * Comprehensive address selector with GPS location assistance.                            |
|   * Itemized order review with GST invoice toggle for corporate/institutional gifting.       |
+---------------------------------------------------------------------------------------------+
| Phase 5: Payment Orchestration & Smart Escrow Hold                                          |
|   * Native UPI Intent deep-linking (Google Pay, PhonePe, Paytm, CRED).                      |
|   * Real-time dynamic QR code modal with live SSE webhook confirmation.                     |
|   * Nodal Escrow holding notice & automated PFMS disbursement trigger on delivery.          |
+---------------------------------------------------------------------------------------------+
| Phase 6: Post-Purchase Order Tracking & Provenance Passport                                 |
|   * Graphical step-by-step courier shipment tracking timeline.                              |
|   * Verifiable SHA-256 Digital Provenance Passport & GI certificate viewer.                 |
+---------------------------------------------------------------------------------------------+
```

---

## 7. Explicit Review & Permission Notice

> [!CAUTION]
> **AWAITING USER REVIEW & AUTHORIZATION**:
> In accordance with your explicit instructions, **no implementation code for the buyer app will be written without your review and permission**.
>
> Please review this document (`flipkart.md`). Once you are satisfied with this architectural benchmark and implementation plan, please grant your permission to begin Phase 1 execution.
