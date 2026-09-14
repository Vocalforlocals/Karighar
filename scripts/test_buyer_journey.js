// ==============================================================================
// Karighar - Automated Buyer Journey End-to-End Test Suite
// Executes live API calls against local HTTPS or Vercel Gateway
// ==============================================================================

const https = require('https');

const BASE_URL = process.env.BASE_URL || 'https://karighar.vercel.app';

function request(method, path, body = null, headers = {}) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const options = {
      method,
      hostname: url.hostname,
      port: url.port || 443,
      path: url.pathname + url.search,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Karighar-Buyer-E2E-Tester/1.0',
        ...headers
      },
      rejectUnauthorized: false
    };

    if (body) {
      options.headers['Content-Type'] = 'application/json';
    }

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          resolve({ status: res.statusCode, body: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, raw: data });
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

async function runBuyerJourney() {
  console.log(`\n======================================================`);
  console.log(`🚀 RUNNING KARIGHAR BUYER JOURNEY E2E INTEGRATION TEST`);
  console.log(`Target Host: ${BASE_URL}`);
  console.log(`======================================================\n`);

  let passed = 0;
  let failed = 0;

  async function test(name, fn) {
    try {
      process.stdout.write(`⏳ Testing: ${name}... `);
      await fn();
      console.log(`✅ PASSED`);
      passed++;
    } catch (err) {
      console.log(`❌ FAILED: ${err.message}`);
      failed++;
    }
  }

  let authToken = null;
  let firstProductId = null;
  let newOrderId = null;

  // 1. Health check
  await test('1. System Health & Telemetry (/api/v1/health)', async () => {
    const res = await request('GET', '/api/v1/health');
    if (res.status !== 200 || res.body.status !== 'ok') throw new Error(`Status ${res.status}`);
  });

  // 2. Buyer Authentication
  await test('2. Buyer Login Authentication (/api/v1/auth/login)', async () => {
    const res = await request('POST', '/api/v1/auth/login', {
      email: 'procurement@fabindia.com',
      password: 'buyer2026'
    });
    if (res.status !== 200 || !res.body.token) throw new Error(`Token missing, status ${res.status}`);
    authToken = res.body.token;
  });

  // 3. Current User Profile
  await test('3. Authenticated Profile Inspection (/api/v1/auth/me)', async () => {
    const res = await request('GET', '/api/v1/auth/me', null, {
      'Authorization': `Bearer ${authToken}`
    });
    if (res.status !== 200 || !res.body.success) throw new Error(`Auth me failed`);
  });

  // 4. Product Catalog Discovery
  await test('4. Browse Handcrafted GI Catalog (/api/v1/products)', async () => {
    const res = await request('GET', '/api/v1/products?category=Textiles');
    if (res.status !== 200 || !res.body.products || res.body.products.length === 0) {
      throw new Error(`Failed to load catalog products`);
    }
    firstProductId = res.body.products[0].id;
  });

  // 5. Single Product & SHA-256 Provenance
  await test(`5. View Craft Detail & Provenance Hash (/api/v1/products/${firstProductId})`, async () => {
    const res = await request('GET', `/api/v1/products/${firstProductId}`);
    if (res.status !== 200 || !res.body.product) throw new Error(`Product lookup failed`);
  });

  // 6. AI Computer Vision Weave Quality Inspection
  await test('6. AI CV Weave Quality & Anti-Powerloom Check (/api/v1/ai/weave-inspect)', async () => {
    const res = await request('POST', '/api/v1/ai/weave-inspect', {
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c'
    });
    if (res.status !== 200 || !res.body.analysis) throw new Error(`Inspection failed`);
  });

  // 7. Varta-AI Living-Wage Defense Evaluation
  await test('7. Varta-AI Wage Defense Negotiation (/api/v1/negotiate/evaluate)', async () => {
    const res = await request('POST', '/api/v1/negotiate/evaluate', {
      offeredPrice: 4800,
      daysOfCraft: 14,
      rawMaterialCost: 2800
    });
    if (res.status !== 200 || !res.body.nonNegotiableFloor) throw new Error(`Evaluation failed`);
  });

  // 8. Create Purchase Order in Smart Escrow
  await test('8. Create Order Locked in Escrow (/api/v1/orders)', async () => {
    const res = await request('POST', '/api/v1/orders', {
      buyerName: 'FabIndia Overseas',
      productId: firstProductId,
      quantity: 1,
      totalAmount: 8500
    });
    if (res.status !== 201 || !res.body.order) throw new Error(`Order placement failed`);
    newOrderId = res.body.order.id;
  });

  // 9. Verify Escrow Release via QR Scan & PFMS
  await test('9. Release Escrow via QR Scan & PFMS (/api/v1/escrow/verify)', async () => {
    const res = await request('POST', '/api/v1/escrow/verify', {
      orderId: newOrderId,
      amount: 8500
    });
    if (res.status !== 200 || !res.body.pfmsTransactionId) throw new Error(`Escrow release failed`);
  });

  // 10. Blockchain Sovereign Ledger Inspection
  await test('10. MoSJE Blockchain Ledger Audit (/api/v1/blockchain/blocks)', async () => {
    const res = await request('GET', '/api/v1/blockchain/blocks');
    if (res.status !== 200 || !res.body.blocks) throw new Error(`Blockchain inspection failed`);
  });

  console.log(`\n======================================================`);
  console.log(`🏁 TEST EXECUTION SUMMARY: ${passed} PASSED, ${failed} FAILED`);
  console.log(`======================================================\n`);
}

runBuyerJourney().catch(err => {
  console.error('[FATAL]', err);
});
