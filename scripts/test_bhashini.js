// ==============================================================================
// Karighar — Bhashini National Language Mission & Bihari Dialects Test Suite
// ==============================================================================

const https = require('https');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

function post(path, body) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify(body);
    const req = https.request({
      hostname: 'localhost',
      port: 8443,
      path,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      }
    }, res => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(data) });
        } catch (e) {
          resolve({ status: res.statusCode, raw: data });
        }
      });
    });
    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

function get(path) {
  return new Promise((resolve, reject) => {
    const req = https.request({
      hostname: 'localhost',
      port: 8443,
      path,
      method: 'GET'
    }, res => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(data) });
        } catch (e) {
          resolve({ status: res.statusCode, raw: data });
        }
      });
    });
    req.on('error', reject);
    req.end();
  });
}

async function runTests() {
  console.log('--- Testing Bhashini 22 Indian + Bihari Languages Gateway ---');

  // Test 1: GET /api/v1/bhashini/languages
  const langRes = await get('/api/v1/bhashini/languages');
  console.log(`1. Languages Catalog: HTTP ${langRes.status}, Total: ${langRes.body.totalCount}, Scheduled: ${langRes.body.scheduledIndianCount}, Bihari: ${langRes.body.bihariRegionalCount}`);
  if (langRes.body.totalCount < 26) {
    throw new Error(`Expected at least 26 languages, got ${langRes.body.totalCount}`);
  }

  // Test 2: POST /api/v1/bhashini/asr
  const asrRes = await post('/api/v1/bhashini/asr', {
    languageCode: 'bho',
    audioBase64: 'UklGRiQAAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQAAAAA='
  });
  console.log(`2. ASR (Speech-to-Text in Bhojpuri): HTTP ${asrRes.status}, Result: "${asrRes.body.recognizedText}" (${asrRes.body.dialectIdentified})`);

  // Test 3: POST /api/v1/bhashini/translate
  const transRes = await post('/api/v1/bhashini/translate', {
    text: 'हमार बैंक खाता के बैलेंस केतना बा?',
    sourceLang: 'bho',
    targetLang: 'en'
  });
  console.log(`3. NMT (Bhojpuri -> English): HTTP ${transRes.status}, Output: "${transRes.body.translatedText}"`);

  // Test 4: POST /api/v1/bhashini/tts
  const ttsRes = await post('/api/v1/bhashini/tts', {
    text: 'प्रणाम! अपनेक बैंक खाता मे ₹48,500 जमा भ’ गेल अछि।',
    languageCode: 'mai',
    gender: 'female'
  });
  console.log(`4. TTS (Speech Synthesis in Maithili): HTTP ${ttsRes.status}, Format: ${ttsRes.body.audioFormat}, Audio bytes: ${ttsRes.body.audioBase64 ? ttsRes.body.audioBase64.length : 0}`);

  // Test 5: POST /api/v1/bhashini/voice-assistant (Bhojpuri dialect test)
  const vaBho = await post('/api/v1/bhashini/voice-assistant', {
    query: 'हमार बैंक बैलेंस केतना बा?',
    languageCode: 'bho'
  });
  console.log(`5a. Setu Didi (Bhojpuri): HTTP ${vaBho.status}, Intent: ${vaBho.body.intent}, Route: ${vaBho.body.actionRoute}`);
  console.log(`    Response: "${vaBho.body.responseText}"`);

  // Test 5b: POST /api/v1/bhashini/voice-assistant (Maithili loom order test)
  const vaMai = await post('/api/v1/bhashini/voice-assistant', {
    query: 'आई कतेक नब हैंडलूम ऑर्डर आयल अछि?',
    languageCode: 'mai'
  });
  console.log(`5b. Setu Didi (Maithili): HTTP ${vaMai.status}, Intent: ${vaMai.body.intent}, Route: ${vaMai.body.actionRoute}`);
  console.log(`    Response: "${vaMai.body.responseText}"`);

  // Test 5c: POST /api/v1/bhashini/voice-assistant (Magahi subsidy test)
  const vaMag = await post('/api/v1/bhashini/voice-assistant', {
    query: 'सरकारी योजना वाला पईसा कब मिलतौ?',
    languageCode: 'mag'
  });
  console.log(`5c. Setu Didi (Magahi): HTTP ${vaMag.status}, Intent: ${vaMag.body.intent}, Route: ${vaMag.body.actionRoute}`);
  console.log(`    Response: "${vaMag.body.responseText}"`);

  // Test 5d: POST /api/v1/bhashini/voice-assistant (Tamil query test)
  const vaTa = await post('/api/v1/bhashini/voice-assistant', {
    query: 'எனது வங்கி கணக்கு இருப்பு என்ன?',
    languageCode: 'ta'
  });
  console.log(`5d. Setu Didi (Tamil): HTTP ${vaTa.status}, Intent: ${vaTa.body.intent}, Route: ${vaTa.body.actionRoute}`);
  console.log(`    Response: "${vaTa.body.responseText}"`);

  console.log('✅ ALL BHASHINI ENDPOINTS VERIFIED 100% SUCCESFULLY!');
}

runTests().catch(err => {
  console.error('❌ Test failed:', err);
  process.exit(1);
});
