// ==============================================================================
// Karighar (कारीघर) — Automated Backend API & HTTPS Test Suite
// Verifies All 26 Endpoints, HSTS, SSE, Webhooks, AI & Ledger Proofs
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const https = require('https');
const http = require('http');
const { signWebhookPayload } = require('../backend/middleware/webhook_security');

const HTTPS_PORT = 8443;
const HTTP_PORT = 8080;
const HOST = 'localhost';
const SECURE_BASE_URL = `https://${HOST}:${HTTPS_PORT}`;
const HTTP_BASE_URL = `http://${HOST}:${HTTP_PORT}`;

function secureRequest(method, path, body = null, customHeaders = {}) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, SECURE_BASE_URL);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method: method,
      rejectUnauthorized: false, // Accept self-signed local cert for testing
      headers: {
        'Content-Type': 'application/json',
        ...customHeaders
      }
    };

    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          resolve({ status: res.statusCode, headers: res.headers, data: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, headers: res.headers, data });
        }
      });
    });

    req.on('error', reject);

    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

function httpRequest(method, path) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, HTTP_BASE_URL);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      method: method
    };

    const req = http.request(options, res => {
      resolve({ status: res.statusCode, headers: res.headers });
    });

    req.on('error', reject);
    req.end();
  });
}

async function runTests() {
  console.log('================================================================');
  console.log(' 🔒 Running Karighar Secure Full-Stack HTTPS Verification Suite');
  console.log('================================================================\n');

  let passed = 0;
  let failed = 0;

  async function test(name, fn) {
    try {
      await fn();
      console.log(` ✅ PASS: ${name}`);
      passed++;
    } catch (err) {
      console.error(` ❌ FAIL: ${name} -> ${err.message}`);
      failed++;
    }
  }

  // 1. HTTP to HTTPS Redirect Test
  await test('HTTP Ingress (8080) automatically redirects to HTTPS (8443) with 301', async () => {
    const res = await httpRequest('GET', '/api/v1/health');
    if (res.status !== 301 || !res.headers.location || !res.headers.location.startsWith('https://')) {
      throw new Error(`Expected 301 Redirect to https, got status ${res.status}, location: ${res.headers.location}`);
    }
  });

  // 2. HTTPS Health & HSTS Security Header
  await test('HTTPS GET /api/v1/health returns healthy status with HSTS header', async () => {
    const res = await secureRequest('GET', '/api/v1/health');
    if (res.status !== 200 || res.data.status !== 'ok') {
      throw new Error(`Expected status 200, got ${res.status}`);
    }
    if (!res.headers['strict-transport-security']) {
      throw new Error('Missing Strict-Transport-Security (HSTS) header');
    }
  });

  // 3. Products List over HTTPS
  await test('HTTPS GET /api/v1/products returns seeded artisan crafts', async () => {
    const res = await secureRequest('GET', '/api/v1/products');
    if (res.status !== 200 || !Array.isArray(res.data.products) || res.data.products.length < 4) {
      throw new Error(`Expected at least 4 products, got ${res.data?.products?.length}`);
    }
  });

  // 4. Product Details & SHA-256 Provenance over HTTPS
  await test('HTTPS GET /api/v1/products/prod_01 returns product with SHA-256 hash', async () => {
    const res = await secureRequest('GET', '/api/v1/products/prod_01');
    if (res.status !== 200 || !res.data.product?.sha256Hash) {
      throw new Error('Expected product with valid SHA-256 provenance hash');
    }
  });

  // 5. Create Product over HTTPS
  await test('HTTPS POST /api/v1/products auto-mints SHA-256 hash securely', async () => {
    const res = await secureRequest('POST', '/api/v1/products', {
      title: 'Kashmir Pashmina Handspun Shawl',
      category: 'Textiles & Weaves',
      craftForm: 'Pashmina Weaving',
      price: 14500,
      stockQuantity: 3
    });
    if (res.status !== 201 || !res.data.product?.sha256Hash) {
      throw new Error('Product creation failed or SHA-256 missing');
    }
  });

  // 6. Orders List over HTTPS
  await test('HTTPS GET /api/v1/orders returns active orders', async () => {
    const res = await secureRequest('GET', '/api/v1/orders');
    if (res.status !== 200 || !Array.isArray(res.data.orders)) {
      throw new Error('Expected orders array');
    }
  });

  // 7. Tenders & Cluster Pooling over HTTPS
  await test('HTTPS POST /api/v1/tenders/tender_taj_500/pool commits loom capacity', async () => {
    const res = await secureRequest('POST', '/api/v1/tenders/tender_taj_500/pool', {
      artisanId: 'art_ramdev_01',
      artisanName: 'Master Ramdev',
      committedUnits: 50
    });
    if (res.status !== 200 || res.data.tender.pooledQuantity < 400) {
      throw new Error(`Expected pooled capacity >= 400, got ${res.data?.tender?.pooledQuantity}`);
    }
  });

  // 8. Varta-AI Wage-Defense Sentry over HTTPS
  await test('HTTPS POST /api/v1/negotiate/evaluate detects lowball offer under MoSJE rules', async () => {
    const res = await secureRequest('POST', '/api/v1/negotiate/evaluate', {
      offeredPrice: 5200,
      daysOfCraft: 14,
      rawMaterialCost: 2800
    });
    if (res.status !== 200 || !res.data.isLowball || res.data.nonNegotiableFloor !== 14700) {
      throw new Error(`Expected lowball flag and floor 14700, got ${JSON.stringify(res.data)}`);
    }
  });

  // 9. Smart Escrow Delivery Verification & PFMS Release over HTTPS
  await test('HTTPS POST /api/v1/escrow/verify releases smart contract escrow to artisan bank', async () => {
    const res = await secureRequest('POST', '/api/v1/escrow/verify', {
      orderId: 'ORD-2026-9041',
      amount: 8500
    });
    if (res.status !== 200 || res.data.escrowStatus !== 'RELEASED_TO_ARTISAN' || !res.data.pfmsTransactionId) {
      throw new Error('Escrow release failed');
    }
  });

  // 10. PM-Vishwakarma Credit Hub over HTTPS
  await test('HTTPS GET /api/v1/credit/profile/art_ramdev_01 returns 842 credit score', async () => {
    const res = await secureRequest('GET', '/api/v1/credit/profile/art_ramdev_01');
    if (res.status !== 200 || res.data.profile?.creditScore !== 842) {
      throw new Error(`Expected score 842, got ${res.data?.profile?.creditScore}`);
    }
  });

  await test('HTTPS POST /api/v1/credit/disburse simulates 1-tap ₹1L subsidized loan', async () => {
    const res = await secureRequest('POST', '/api/v1/credit/disburse', { amount: 100000 });
    if (res.status !== 200 || !res.data.loanReference) {
      throw new Error('Disbursement simulation failed');
    }
  });

  // 10b. Artisan Studio Real-Time Metrics & Quotes Telemetry
  await test('HTTPS GET /api/v1/artisan/stats returns live GMV and cluster metrics', async () => {
    const res = await secureRequest('GET', '/api/v1/artisan/stats?artisanId=art_ramdev_01');
    if (res.status !== 200 || !res.data.success || !res.data.totalGmv || !res.data.cluster) {
      throw new Error('Artisan stats API failed to return expected metrics');
    }
  });

  await test('HTTPS GET /api/v1/artisan/quotes returns institutional buyer quotes', async () => {
    const res = await secureRequest('GET', '/api/v1/artisan/quotes?artisanId=art_ramdev_01');
    if (res.status !== 200 || !res.data.success || !Array.isArray(res.data.quotes)) {
      throw new Error('Artisan quotes API failed to return quotes array');
    }
  });

  // 11. MoSJE National GIS Cluster Telemetry over HTTPS
  await test('HTTPS GET /api/v1/gis/clusters returns national handicraft clusters', async () => {
    const res = await secureRequest('GET', '/api/v1/gis/clusters');
    if (res.status !== 200 || !Array.isArray(res.data.clusters) || res.data.clusters.length < 5) {
      throw new Error('Expected 5 national clusters');
    }
  });

  // 12. AI Weave Inspection over HTTPS
  await test('HTTPS POST /api/v1/ai/weave-inspect returns Grade A+ GI certification', async () => {
    const res = await secureRequest('POST', '/api/v1/ai/weave-inspect', {});
    if (res.status !== 200 || res.data.analysis?.certificationGrade !== 'Grade A+ GI Handloom') {
      throw new Error('Weave inspection simulation failed');
    }
  });

  // 13. Bhashini Speech-to-Listing over HTTPS
  await test('HTTPS POST /api/v1/ai/voice-catalog extracts bilingual metadata', async () => {
    const res = await secureRequest('POST', '/api/v1/ai/voice-catalog', { language: 'Hindi', transcript: 'शुद्ध रेशम की साड़ी' });
    if (res.status !== 200 || !res.data.extractedCatalog?.titleHindi || !res.data.extractedCatalog?.materialsUsed || !res.data.extractedCatalog?.suggestedPricing) {
      throw new Error('Voice catalog extraction failed');
    }
  });

  // 13b. Multi-Angle Camera Computer Vision & 4K Synthesis
  await test('HTTPS POST /api/v1/ai/camera/process-angle processes multi-angle computer vision metrics', async () => {
    const res = await secureRequest('POST', '/api/v1/ai/camera/process-angle', {
      angleKey: 'texture',
      angleIndex: 1,
      angleLabel: 'Weave Texture',
      enhancementOptions: { superResolution: true, studioLighting: true, colorCalibration: true, backgroundDeClutter: true }
    });
    if (res.status !== 200 || !res.data.success || !res.data.angle || res.data.angle.qualityMetrics?.endsPerInch !== 128 || !res.data.angle.hash) {
      throw new Error('Multi-angle camera processing failed');
    }
  });

  // 13c. Multi-Angle 360° Composite GI Inspection
  await test('HTTPS POST /api/v1/ai/camera/multi-angle-inspect synthesizes 360° GI provenance certificate', async () => {
    const res = await secureRequest('POST', '/api/v1/ai/camera/multi-angle-inspect', {
      angles: [
        { angleKey: 'overview', hasImage: true },
        { angleKey: 'texture', hasImage: true },
        { angleKey: 'motif', hasImage: true },
        { angleKey: 'loom', hasImage: true }
      ]
    });
    if (res.status !== 200 || !res.data.success || !res.data.multiAngleInspection?.provenanceHash || res.data.multiAngleInspection.coverageScore !== 100) {
      throw new Error('Composite 360° multi-angle inspection failed');
    }
  });

  // 13d. Camera Image Asset Registration
  await test('HTTPS POST /api/v1/ai/camera/upload ingests and registers camera capture asset', async () => {
    const res = await secureRequest('POST', '/api/v1/ai/camera/upload', {
      fileName: 'angle_texture.jpg',
      angle: 'texture',
      imageBase64: 'data:image/jpeg;base64,sample_craft_image_data'
    });
    if (res.status !== 200 || !res.data.success || !res.data.asset?.url || !res.data.asset?.sha256) {
      throw new Error('Camera image asset registration failed');
    }
  });

  // 14. OpenAPI 3.0 Specification
  await test('HTTPS GET /api/v1/openapi.json returns valid OpenAPI 3.0 specification', async () => {
    const res = await secureRequest('GET', '/api/v1/openapi.json');
    if (res.status !== 200 || res.data.openapi !== '3.0.3' || !res.data.paths) {
      throw new Error('Invalid OpenAPI 3.0 specification');
    }
  });

  // 15. Swagger / Developer Docs HTML Portal
  await test('HTTPS GET /api/docs returns interactive Swagger documentation portal', async () => {
    const res = await secureRequest('GET', '/api/docs');
    if (res.status !== 200 || typeof res.data !== 'string' || (!res.data.includes('KARIGHAR API GATEWAY') && !res.data.includes('SHILPSETU API GATEWAY'))) {
      throw new Error('Documentation portal did not return expected HTML');
    }
  });

  // 16. JWT Authentication & Registration
  let jwtToken = null;
  await test('HTTPS POST /api/v1/auth/login issues valid HMAC-SHA256 JWT token', async () => {
    const res = await secureRequest('POST', '/api/v1/auth/login', {
      email: 'ramdev@karighar.gov.in',
      role: 'ARTISAN'
    });
    if (res.status !== 200 || !res.data.token || res.data.role !== 'ARTISAN') {
      throw new Error('JWT token authentication failed');
    }
    jwtToken = res.data.token;
  });

  await test('HTTPS POST /api/v1/auth/register creates new artisan account and returns token', async () => {
    const testPhone = `+91 98${Math.floor(10000000 + Math.random() * 90000000)}`;
    const res = await secureRequest('POST', '/api/v1/auth/register', {
      fullName: 'Sita Devi Weaving Guild',
      phone: testPhone,
      email: `sita_${Date.now()}@karighar.gov.in`,
      role: 'ARTISAN',
      craftCategory: 'Textiles & Weaves',
      state: 'Bihar',
      district: 'Madhubani'
    });
    if (res.status !== 201 || !res.data.token || res.data.user?.fullName !== 'Sita Devi Weaving Guild') {
      throw new Error(`Registration failed: ${JSON.stringify(res.data)}`);
    }
  });

  await test('HTTPS POST /api/v1/auth/send-otp generates valid mobile OTP with TTL', async () => {
    const res = await secureRequest('POST', '/api/v1/auth/send-otp', {
      phone: '+91 98765 43210'
    });
    if (res.status !== 200 || !res.data.success || !res.data.expiresInSeconds) {
      throw new Error('Send OTP failed');
    }
  });

  await test('HTTPS POST /api/v1/auth/verify-otp validates code and returns user session', async () => {
    const res = await secureRequest('POST', '/api/v1/auth/verify-otp', {
      phone: '+91 98765 43210',
      otp: '7829'
    });
    if (res.status !== 200 || !res.data.token || !res.data.user) {
      throw new Error('Verify OTP failed');
    }
  });

  await test('HTTPS GET /api/v1/auth/me returns authenticated user identity with Bearer token', async () => {
    const res = await secureRequest('GET', '/api/v1/auth/me', null, {
      'Authorization': `Bearer ${jwtToken}`
    });
    if (res.status !== 200 || !res.data.user || (res.data.user.email !== 'ramdev@karighar.gov.in' && res.data.user.email !== 'ramdev@shilpsetudo.gov.in')) {
      throw new Error('GET /api/v1/auth/me failed');
    }
  });

  // 17. PM-Vishwakarma Aadhaar e-KYC
  await test('HTTPS POST /api/v1/auth/verify-artisan verifies Aadhaar biometric e-KYC', async () => {
    const res = await secureRequest('POST', '/api/v1/auth/verify-artisan', {
      aadhaarNumber: '5489-1234-8412',
      artisanId: 'art_ramdev_01',
      craftCategory: 'Banarasi Brocade Silk'
    });
    if (res.status !== 200 || !res.data.kyc?.verified || res.data.kyc?.profile?.trustScore !== 842) {
      throw new Error('Aadhaar e-KYC verification failed');
    }
  });

  // 18. GeM Procurement Webhook
  await test('HTTPS POST /api/v1/webhooks/gem ingests Ministry procurement tender', async () => {
    const res = await secureRequest('POST', '/api/v1/webhooks/gem', {
      tenderRef: 'GEM/2026/B/992410',
      issuingMinistry: 'Ministry of Social Justice & Empowerment',
      title: 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas',
      category: 'Textiles & Weaves',
      quantity: 200,
      budgetPerUnit: 2500
    });
    if (res.status !== 201 || (!['INGESTED_TO_KARIGHAR', 'INGESTED_TO_SHILPSETU'].includes(res.data.status)) || !res.data.tenderId) {
      throw new Error('GeM webhook ingestion failed');
    }
  });

  // 19. PFMS SBI Bank Settlement Webhook
  await test('HTTPS POST /api/v1/webhooks/pfms settles smart contract escrow via SBI callback', async () => {
    const res = await secureRequest('POST', '/api/v1/webhooks/pfms', {
      orderId: 'ORD-2026-9041',
      amount: 8500,
      utrNumber: 'SBIN9841209124',
      pfmsAckNo: 'PFMS-ACK-2026-98124'
    });
    if (res.status !== 200 || res.data.escrowStatus !== 'SETTLED_TO_BENEFICIARY') {
      throw new Error('PFMS settlement callback failed');
    }
  });

  // 20. ICEGATE DGFT Customs Clearance Webhook
  await test('HTTPS POST /api/v1/webhooks/icegate issues customs export shipping clearance', async () => {
    const res = await secureRequest('POST', '/api/v1/webhooks/icegate', {
      shippingBillNumber: 'SB-IN-DEL-2026-9041',
      orderId: 'ORD-2026-9041',
      destinationCountry: 'United States'
    });
    if (res.status !== 200 || res.data.customsStatus !== 'CLEARED_FOR_INTERNATIONAL_AIR_DISPATCH') {
      throw new Error('ICEGATE customs webhook failed');
    }
  });

  // 21. Blockchain Sovereign Ledger Blocks
  await test('HTTPS GET /api/v1/blockchain/blocks returns immutable ledger blocks', async () => {
    const res = await secureRequest('GET', '/api/v1/blockchain/blocks');
    if (res.status !== 200 || !res.data.success || !Array.isArray(res.data.blocks) || res.data.blocks.length === 0) {
      throw new Error('Blockchain blocks retrieval failed');
    }
    const genesis = res.data.blocks.find(b => b.blockNumber === 1042);
    if (!genesis || !genesis.merkleRoot) {
      throw new Error('Genesis block Merkle root missing');
    }
  });

  // 22. Blockchain Specific Transaction Lookup
  await test('HTTPS GET /api/v1/blockchain/tx/:hash inspects transaction on ledger', async () => {
    const res = await secureRequest('GET', '/api/v1/blockchain/tx/9e12b7');
    if (res.status !== 200 || !res.data.success || !res.data.transaction || !res.data.transaction.txHash) {
      throw new Error('Blockchain tx lookup failed');
    }
  });

  // 23. In-Memory Token Bucket Rate Limiter & DoS Shield
  await test('Rate Limiting & DoS Shield returns X-RateLimit headers', async () => {
    const res = await secureRequest('GET', '/api/v1/health');
    if (res.status !== 200) {
      throw new Error(`Expected 200, got ${res.status}`);
    }
    if (!res.headers['x-ratelimit-limit'] || !res.headers['x-ratelimit-remaining']) {
      throw new Error('Missing X-RateLimit-Limit or X-RateLimit-Remaining headers');
    }
  });

  // 24. Cryptographic HMAC Webhook Security: Spoofed/Tampered Rejection
  await test('Cryptographic Webhook Sentry rejects spoofed/tampered HMAC signature (401)', async () => {
    const fakePayload = { tenderRef: 'GEM/FAKE/001', title: 'Spoofed Tender' };
    const res = await secureRequest('POST', '/api/v1/webhooks/gem', fakePayload, {
      'X-Gov-Signature': 'sha256=deadbeef0000111122223333444455556666777788889999aaaabbbbccccdddd'
    });
    if (res.status !== 401 || res.data.success !== false) {
      throw new Error(`Expected HTTP 401 Unauthorized for forged signature, got ${res.status}`);
    }
  });

  // 25. Cryptographic HMAC Webhook Security: Valid Signature Ingestion
  await test('Cryptographic Webhook Sentry verifies and ingests authentic HMAC-SHA256 signed tender', async () => {
    const validTenderPayload = {
      tenderRef: `GEM/2026/SECURE/${Date.now()}`,
      issuingMinistry: 'Ministry of Social Justice & Empowerment',
      title: 'Authenticated GeM Silk Shawl Procurement',
      category: 'Textiles & Weaves',
      quantity: 150,
      budgetPerUnit: 3000
    };
    const validSignature = signWebhookPayload('gem', validTenderPayload);
    const res = await secureRequest('POST', '/api/v1/webhooks/gem', validTenderPayload, {
      'X-Gov-Signature': validSignature
    });
    if (res.status !== 201 || !res.data.tenderId || (!['INGESTED_TO_KARIGHAR', 'INGESTED_TO_SHILPSETU'].includes(res.data.status))) {
      throw new Error(`Signed webhook ingestion failed: status ${res.status}`);
    }
  });

  // 26. CERT-In Compliant Tamper-Evident Audit Trail
  await test('CERT-In Audit Telemetry returns immutable SHA-256 hash-chained records', async () => {
    const res = await secureRequest('GET', '/api/v1/admin/audit-logs?limit=10');
    if (res.status !== 200 || !res.data.success || !Array.isArray(res.data.auditLogs)) {
      throw new Error('Audit logs retrieval failed');
    }
    if (res.data.auditLogs.length === 0) {
      throw new Error('Expected at least one audit log entry');
    }
    const sample = res.data.auditLogs[0];
    if (!sample.id || !sample.action || !sample.integrityHash || !sample.previousHash) {
      throw new Error('Audit log record missing required CERT-In hash-chaining fields');
    }
  });

  console.log('\n================================================================');
  console.log(` 🏁 HTTPS Suite Completed: ${passed} Passed, ${failed} Failed`);
  console.log('================================================================');

  if (failed > 0) {
    process.exit(1);
  }
}

runTests().catch(err => {
  console.error('Fatal test error:', err);
  process.exit(1);
});
