// ==============================================================================
// Karighar (कारीघर) — Backend Automated Test Suite
// Verifies all modular controllers, routing, SSE, and database operations
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const http = require('http');
const { handleSecureRequest } = require('../../serve_flutter');

const TEST_PORT = 9999;
let server;

function request(method, path, body = null, headers = {}) {
  return new Promise((resolve, reject) => {
    const payload = body ? JSON.stringify(body) : null;
    const reqHeaders = {
      'Content-Type': 'application/json',
      ...headers
    };
    if (payload) {
      reqHeaders['Content-Length'] = Buffer.byteLength(payload);
    }

    const req = http.request({
      hostname: '127.0.0.1',
      port: TEST_PORT,
      path,
      method,
      headers: reqHeaders
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        let json = null;
        try {
          json = JSON.parse(data);
        } catch (e) {
          json = data;
        }
        resolve({ statusCode: res.statusCode, headers: res.headers, body: json });
      });
    });

    req.on('error', reject);
    if (payload) req.write(payload);
    req.end();
  });
}

async function runTests() {
  console.log('================================================================');
  console.log('🧪 Starting Karighar Enterprise Backend Automated Test Suite');
  console.log('================================================================');

  server = http.createServer(handleSecureRequest);
  await new Promise(resolve => server.listen(TEST_PORT, '127.0.0.1', resolve));

  let passed = 0;
  let failed = 0;

  async function test(name, fn) {
    try {
      await fn();
      console.log(` ✅ PASS: ${name}`);
      passed++;
    } catch (err) {
      console.error(` ❌ FAIL: ${name}`);
      console.error(`    Error: ${err.message}`);
      failed++;
    }
  }

  // 1. Health Check
  await test('GET /api/v1/health returns 200 and system metadata', async () => {
    const res = await request('GET', '/api/v1/health');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.status !== 'ok') throw new Error(`Expected status ok, got ${res.body.status}`);
    if (res.body.version !== '2.0.0') throw new Error(`Expected version 2.0.0, got ${res.body.version}`);
  });

  // 2. OpenAPI Spec
  await test('GET /api/v1/openapi.json returns valid spec', async () => {
    const res = await request('GET', '/api/v1/openapi.json');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.openapi || !res.body.paths) throw new Error('Malformed OpenAPI specification');
  });

  // 3. Products
  let testProductId = null;
  await test('GET /api/v1/products returns catalog list', async () => {
    const res = await request('GET', '/api/v1/products');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.success || !Array.isArray(res.body.products)) throw new Error('Invalid products payload');
    if (res.body.products.length > 0) {
      testProductId = res.body.products[0].id;
    }
  });

  await test('GET /api/v1/products/:id returns single product', async () => {
    if (!testProductId) return;
    const res = await request('GET', `/api/v1/products/${testProductId}`);
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.product.id !== testProductId) throw new Error('Product ID mismatch');
  });

  await test('POST /api/v1/products creates new craft with SHA-256 provenance', async () => {
    const res = await request('POST', '/api/v1/products', {
      title: 'Kashi Tested Handloom Stole',
      category: 'Textiles & Weaves',
      price: 3200,
      description: 'Automated test woven craft'
    });
    if (res.statusCode !== 201) throw new Error(`Status ${res.statusCode}, body: ${JSON.stringify(res.body)}`);
    if (!res.body.product || !res.body.product.sha256Hash) throw new Error('Missing product or sha256 hash');
  });

  // 4. Buyer Commerce
  await test('GET /api/v1/buyer/feed returns banners, reels, and categories', async () => {
    const res = await request('GET', '/api/v1/buyer/feed');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.banners || !res.body.categories) throw new Error('Missing feed components');
  });

  await test('POST /api/v1/buyer/semantic-search performs query intent mapping', async () => {
    const res = await request('POST', '/api/v1/buyer/semantic-search', {
      query: 'silk sarees under 15000'
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.results) throw new Error('Missing search results');
  });

  await test('POST /api/v1/buyer/reserve-stock reserves loom capacity for 15 mins', async () => {
    const res = await request('POST', '/api/v1/buyer/reserve-stock', {
      items: [{ productId: testProductId, quantity: 1 }]
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.reservationId || res.body.ttlSeconds !== 900) throw new Error('Invalid reservation payload');
  });

  // 5. Real-Time Chat & Negotiation
  let createdThreadId = null;
  await test('GET /api/v1/chat/threads returns active threads', async () => {
    const res = await request('GET', '/api/v1/chat/threads');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.success || !Array.isArray(res.body.threads)) throw new Error('Invalid chat threads response');
    if (res.body.threads.length > 0) {
      createdThreadId = res.body.threads[0].id;
    }
  });

  await test('POST /api/v1/chat/threads creates a new inquiry negotiation thread', async () => {
    const res = await request('POST', '/api/v1/chat/threads', {
      buyerName: 'Anita Roy',
      buyerOrg: 'Tata CliQ Luxury',
      productTitle: 'Handcrafted Varanasi Silk Stoles',
      requestedQuantity: 30,
      targetPricePerUnit: 5200,
      initialMessage: 'We would like to procure 30 units for corporate gifting.'
    });
    if (res.statusCode !== 201) throw new Error(`Status ${res.statusCode}, body: ${JSON.stringify(res.body)}`);
    if (!res.body.thread || res.body.thread.requestedQuantity !== 30) throw new Error('Thread creation failed');
    createdThreadId = res.body.thread.id;
  });

  await test('POST /api/v1/chat/threads/:id/messages adds a negotiation message', async () => {
    const res = await request('POST', `/api/v1/chat/threads/${createdThreadId}/messages`, {
      senderRole: 'buyer',
      senderName: 'Anita Roy',
      text: 'Can you deliver within 21 days?'
    });
    if (res.statusCode !== 201) throw new Error(`Status ${res.statusCode}`);
    if (res.body.message.text !== 'Can you deliver within 21 days?') throw new Error('Message text mismatch');
  });

  await test('POST /api/v1/chat/threads/:id/counter submits an artisan counter-offer', async () => {
    const res = await request('POST', `/api/v1/chat/threads/${createdThreadId}/counter`, {
      counterPrice: 5600,
      note: 'Counter-Offer: ₹5,600/unit with pure Mulberry Silk Mark tags.'
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.thread.status !== 'countered' || res.body.thread.artisanCounterPrice !== '5600') {
      throw new Error('Counter offer failed to update thread state');
    }
  });

  await test('POST /api/v1/chat/threads/:id/accept locks in escrow deal', async () => {
    const res = await request('POST', `/api/v1/chat/threads/${createdThreadId}/accept`, {});
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.thread.status !== 'accepted') throw new Error('Deal acceptance state not reflected');
  });

  // 6. Orders
  await test('GET /api/v1/orders returns order items', async () => {
    const res = await request('GET', '/api/v1/orders');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.success || !Array.isArray(res.body.orders)) throw new Error('Invalid orders response');
  });

  // 7. Bhashini & AI
  await test('GET /api/v1/bhashini/languages returns 22 scheduled + regional dialects', async () => {
    const res = await request('GET', '/api/v1/bhashini/languages');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.totalCount < 20) throw new Error(`Expected at least 20 languages, got ${res.body.totalCount}`);
  });

  await test('POST /api/v1/bhashini/translate translates text', async () => {
    const res = await request('POST', '/api/v1/bhashini/translate', {
      text: 'नमस्ते कारीगर',
      sourceLang: 'hi',
      targetLang: 'en'
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.translatedText) throw new Error('Missing translatedText');
  });

  await test('POST /api/v1/ai/weave-inspect evaluates quality', async () => {
    const res = await request('POST', '/api/v1/ai/weave-inspect', {
      craftPreset: 'Banarasi Brocade'
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    const metrics = res.body.analysis || res.body;
    if (!metrics.endsPerInch || !metrics.certificationGrade) throw new Error('Missing weave metrics');
  });

  // 8. Tenders & Credit
  await test('GET /api/v1/tenders returns GeM bulk tenders', async () => {
    const res = await request('GET', '/api/v1/tenders');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.success || !Array.isArray(res.body.tenders)) throw new Error('Invalid tenders list');
  });

  await test('GET /api/v1/credit/profile/art_ramdev_01 returns credit score & trust rating', async () => {
    const res = await request('GET', '/api/v1/credit/profile/art_ramdev_01');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.profile || !res.body.profile.creditScore) throw new Error('Missing credit score');
  });

  // 9. Blockchain Explorer
  await test('GET /api/v1/blockchain/blocks returns verified blocks', async () => {
    const res = await request('GET', '/api/v1/blockchain/blocks');
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (!res.body.blocks) throw new Error('Missing blockchain blocks');
  });

  // 10. Karighar AI Assistant 4-Step Creator-to-Market Workflow
  await test('POST /api/v1/ai-assistant/step Step 01 (Artisan Input) returns structured JSON and voice prompt', async () => {
    const res = await request('POST', '/api/v1/ai-assistant/step', {
      step: '01_artisan',
      language: 'hi',
      currency: 'INR',
      data: {
        photo_url: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c',
        transcript: 'वाराणसी शुद्ध रेशम हथकरघा साड़ी'
      }
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.step !== '01_artisan') throw new Error(`Expected step 01_artisan, got ${res.body.step}`);
    if (!res.body.message_to_artisan || !res.body.voice_text) throw new Error('Missing message_to_artisan or voice_text');
    if (!res.body.data || !res.body.next_action) throw new Error('Missing data or next_action');
  });

  await test('POST /api/v1/ai-assistant/step Step 02 (AI Assist) calculates living wage & 16-language translations', async () => {
    const res = await request('POST', '/api/v1/ai-assistant/step', {
      step: '02_ai_assist',
      language: 'hi',
      currency: 'INR',
      data: {
        title: 'Banarasi Brocade Saree',
        raw_material_cost: 1800,
        labor_hours: 32,
        hourly_rate: 120
      }
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.step !== '02_ai_assist') throw new Error(`Expected step 02_ai_assist, got ${res.body.step}`);
    const { price_range, translations, total_cost } = res.body.data;
    if (!price_range || !price_range.low || !price_range.suggested || !price_range.premium) {
      throw new Error('Missing valid price_range (low, suggested, premium)');
    }
    if (total_cost !== (1800 + 32 * 120)) throw new Error(`Incorrect total cost: ${total_cost}`);
    // Check 16 languages in translations
    const langCodes = ['en', 'hi', 'bn', 'mr', 'te', 'ta', 'gu', 'ur', 'kn', 'or', 'ml', 'pa', 'as', 'mai', 'sat', 'ks'];
    for (const code of langCodes) {
      if (!translations[code]) throw new Error(`Missing translation for language code: ${code}`);
    }
  });

  await test('POST /api/v1/ai-assistant/step Step 03 (Creator Review) checks authenticity & allows edits', async () => {
    const res = await request('POST', '/api/v1/ai-assistant/step', {
      step: '03_creator_review',
      language: 'en',
      currency: 'INR',
      data: {
        title: 'Master Banarasi Handloom Saree',
        final_price: 7200,
        authenticity_declaration: true
      }
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.data.authenticity_status !== 'verified') throw new Error('Authenticity should be verified');
    if (res.body.data.final_price !== 7200) throw new Error('Final price mismatch');
  });

  await test('POST /api/v1/ai-assistant/step Step 04 (Publish) publishes to marketplace & connects buyer chat', async () => {
    const res = await request('POST', '/api/v1/ai-assistant/step', {
      step: '04_publish',
      language: 'en',
      currency: 'INR',
      data: {
        title: 'Master Banarasi Handloom Saree',
        final_price: 7200,
        artisanId: 'art_ramdev_01'
      }
    });
    if (res.statusCode !== 200) throw new Error(`Status ${res.statusCode}`);
    if (res.body.status !== 'completed') throw new Error('Status should be completed');
    if (!res.body.data.live_listing_url || !res.body.data.chat_thread_id) {
      throw new Error('Missing live_listing_url or chat_thread_id');
    }
    if (!Array.isArray(res.body.data.channels) || res.body.data.channels.length < 3) {
      throw new Error('Channels should include B2C, B2B, and GeM');
    }
  });

  console.log('================================================================');
  console.log(`🏁 Test Summary: ${passed} passed, ${failed} failed`);
  console.log('================================================================');

  server.close();
  process.exit(failed > 0 ? 1 : 0);
}

runTests().catch(err => {
  console.error('Fatal test runner error:', err);
  if (server) server.close();
  process.exit(1);
});
