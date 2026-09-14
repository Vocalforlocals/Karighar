// ==============================================================================
// Karighar — Automated Buyer Feed & Gemini AI API Test Suite
// ==============================================================================

const https = require('https');

const BASE_URL = 'https://localhost:8443';

function makeRequest(path, method = 'GET', postData = null) {
  return new Promise((resolve, reject) => {
    const parsedUrl = new URL(path, BASE_URL);
    const bodyStr = postData ? JSON.stringify(postData) : null;

    const options = {
      hostname: parsedUrl.hostname,
      port: parsedUrl.port,
      path: parsedUrl.pathname + parsedUrl.search,
      method: method,
      rejectUnauthorized: false,
      headers: {
        'Content-Type': 'application/json',
        ...(bodyStr ? { 'Content-Length': Buffer.byteLength(bodyStr) } : {})
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve({ status: res.statusCode, data: json });
        } catch (e) {
          resolve({ status: res.statusCode, raw: data });
        }
      });
    });

    req.on('error', reject);
    if (bodyStr) req.write(bodyStr);
    req.end();
  });
}

async function runTests() {
  console.log('🧪 Starting Karighar Buyer Feed & Gemini AI Test Suite...\n');
  let passed = 0;
  let total = 4;

  // 1. Test GET /api/v1/buyer/feed
  try {
    const res = await makeRequest('/api/v1/buyer/feed');
    if (res.status === 200 && res.data.success && res.data.banners?.length > 0 && res.data.storyReels?.length > 0) {
      console.log('✅ [1/4] GET /api/v1/buyer/feed passed');
      console.log(`       - Banners: ${res.data.banners.length}, Story Reels: ${res.data.storyReels.length}, Featured: ${res.data.featuredCrafts.length}`);
      passed++;
    } else {
      console.error('❌ [1/4] GET /api/v1/buyer/feed failed:', res);
    }
  } catch (err) {
    console.error('❌ [1/4] Error:', err.message);
  }

  // 2. Test GET /api/v1/buyer/categories
  try {
    const res = await makeRequest('/api/v1/buyer/categories');
    if (res.status === 200 && res.data.success && res.data.categories?.length >= 5) {
      console.log('✅ [2/4] GET /api/v1/buyer/categories passed');
      console.log(`       - Total Categories: ${res.data.categories.length}`);
      passed++;
    } else {
      console.error('❌ [2/4] GET /api/v1/buyer/categories failed:', res);
    }
  } catch (err) {
    console.error('❌ [2/4] Error:', err.message);
  }

  // 3. Test POST /api/v1/buyer/ai-curate
  try {
    const res = await makeRequest('/api/v1/buyer/ai-curate', 'POST', {
      preferences: ['Pure Silk', 'Madhubani Art'],
      occasion: 'Royal Wedding Gift',
      maxBudget: 20000
    });
    if (res.status === 200 && res.data.success && res.data.curation?.curatedTheme) {
      console.log('✅ [3/4] POST /api/v1/buyer/ai-curate passed');
      console.log(`       - Curated Theme: "${res.data.curation.curatedTheme}"`);
      console.log(`       - Model: ${res.data.model}, Matched Products: ${res.data.matchedProducts?.length}`);
      passed++;
    } else {
      console.error('❌ [3/4] POST /api/v1/buyer/ai-curate failed:', res);
    }
  } catch (err) {
    console.error('❌ [3/4] Error:', err.message);
  }

  // 4. Test POST /api/v1/buyer/semantic-search
  try {
    const res = await makeRequest('/api/v1/buyer/semantic-search', 'POST', {
      query: 'authentic silk saree with zari under 10000',
      language: 'English'
    });
    if (res.status === 200 && res.data.success && res.data.parsedIntent) {
      console.log('✅ [4/4] POST /api/v1/buyer/semantic-search passed');
      console.log(`       - Parsed Category: ${res.data.parsedIntent.craftCategory}, Matches: ${res.data.matchCount}`);
      passed++;
    } else {
      console.error('❌ [4/4] POST /api/v1/buyer/semantic-search failed:', res);
    }
  } catch (err) {
    console.error('❌ [4/4] Error:', err.message);
  }

  console.log(`\n📊 Summary: ${passed}/${total} tests passed.`);
  process.exit(passed === total ? 0 : 1);
}

runTests();
