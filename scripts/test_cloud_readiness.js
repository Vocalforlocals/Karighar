// ==============================================================================
// Karighar (कारीघर) — National Enterprise Cloud Readiness Test Suite
// Verifies DDL Schema, Pluggable DB Adapter, Distributed Cache, & Docker Stack
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const fs = require('fs');
const path = require('path');
const https = require('https');

const { dbAdapter } = require('../backend/database/db_adapter');
const { cacheAdapter } = require('../backend/middleware/cache_adapter');

const SECURE_URL = 'https://localhost:8443/api/v1/health';

function check(title, condition, detail = '') {
  if (condition) {
    console.log(` ✅ PASS: ${title}`);
  } else {
    console.error(` ❌ FAIL: ${title} ${detail ? `(${detail})` : ''}`);
    process.exit(1);
  }
}

function fetchHealth() {
  return new Promise((resolve, reject) => {
    const req = https.get(SECURE_URL, { rejectUnauthorized: false }, (res) => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(e);
        }
      });
    });
    req.on('error', reject);
  });
}

async function runCloudReadinessSuite() {
  console.log('================================================================');
  console.log(' ☁️  Running Karighar National Cloud Enterprise Readiness Suite');
  console.log('================================================================\n');

  // 1. PostgreSQL 16 DDL Schema Validation
  const schemaPath = path.join(__dirname, '..', 'backend', 'schema.sql');
  check('PostgreSQL schema.sql exists', fs.existsSync(schemaPath));
  const schemaContent = fs.readFileSync(schemaPath, 'utf8');
  check('Schema contains artisans registry table', schemaContent.includes('CREATE TABLE IF NOT EXISTS artisans'));
  check('Schema contains craft_products table', schemaContent.includes('CREATE TABLE IF NOT EXISTS craft_products'));
  check('Schema contains institutional tenders table', schemaContent.includes('CREATE TABLE IF NOT EXISTS tenders'));
  check('Schema contains cluster commitments table', schemaContent.includes('CREATE TABLE IF NOT EXISTS tender_commitments'));
  check('Schema contains PM-Vishwakarma credit table', schemaContent.includes('CREATE TABLE IF NOT EXISTS credit_profiles'));
  check('Schema contains blockchain ledger table', schemaContent.includes('CREATE TABLE IF NOT EXISTS blockchain_blocks'));
  check('Schema contains CERT-In audit events table', schemaContent.includes('CREATE TABLE IF NOT EXISTS cert_in_audit_events'));
  check('Schema defines GIN/B-Tree performance indexes', schemaContent.includes('USING GIN(tags)') && schemaContent.includes('idx_products_category'));

  // 2. Pluggable Storage Adapter Layer
  const dbStatus = dbAdapter.getStatus();
  check('Storage adapter defaults to atomic JSON engine', dbStatus.activeEngine === 'json');
  check('Atomic file-swap rename capability active', dbStatus.atomicSwapEnabled === true);
  const testDb = dbAdapter.read();
  check('Database adapter successfully reads seed entities', Array.isArray(testDb.products) && testDb.products.length > 0);

  // 3. Distributed Cache & State Bus Layer
  const cacheStatus = cacheAdapter.getStatus();
  check('Cache adapter defaults to high-speed In-Memory bus', cacheStatus.activeEngine === 'memory');
  let eventCaught = false;
  const listener = (evt) => {
    if (evt.type === 'TEST_EVENT' && evt.payload.msg === 'CloudReady') {
      eventCaught = true;
    }
  };
  cacheAdapter.on('event', listener);
  const pubResult = cacheAdapter.publishEvent('TEST_EVENT', { msg: 'CloudReady' });
  check('Event broker formats standardized cluster payload', pubResult.type === 'TEST_EVENT' && pubResult.nodeId !== undefined);
  check('Cache adapter dispatches event to subscribers', eventCaught === true);
  cacheAdapter.removeListener('event', listener);

  await cacheAdapter.set('test_key', { status: 'operational' }, 60);
  const cachedVal = await cacheAdapter.get('test_key');
  check('Cache adapter key-value storage and retrieval works', cachedVal && cachedVal.status === 'operational');

  // 4. Docker Compose Enterprise Orchestration
  const composePath = path.join(__dirname, '..', 'docker-compose.yml');
  check('docker-compose.yml exists in workspace root', fs.existsSync(composePath));
  const composeContent = fs.readFileSync(composePath, 'utf8');
  check('Compose defines app service with HTTPS', (composeContent.includes('karighar_app') || composeContent.includes('shilpsetudo_app')) && composeContent.includes('8443:8443'));
  check('Compose defines PostgreSQL 16 Alpine service', composeContent.includes('postgres:16-alpine') && composeContent.includes('5432:5432'));
  check('Compose mounts schema.sql for automated DB seeding', composeContent.includes('01_init_schema.sql'));
  check('Compose defines Redis 7 Alpine cache service', composeContent.includes('redis:7-alpine') && composeContent.includes('6379:6379'));
  check('Compose defines persistent volumes for PG & Redis', composeContent.includes('pg_data:') && composeContent.includes('redis_data:'));

  // 5. Production Environment Configuration Template (.env.example)
  const envPath = path.join(__dirname, '..', '.env.example');
  check('.env.example exists in workspace root', fs.existsSync(envPath));
  const envContent = fs.readFileSync(envPath, 'utf8');
  check('.env.example defines DB_ENGINE switch', envContent.includes('DB_ENGINE=json'));
  check('.env.example defines DATABASE_URL connection string', envContent.includes('DATABASE_URL=postgresql://'));
  check('.env.example defines CACHE_ENGINE switch', envContent.includes('CACHE_ENGINE=memory'));
  check('.env.example defines REDIS_URL', envContent.includes('REDIS_URL=redis://'));
  check('.env.example defines CERT-In audit retention days', envContent.includes('AUDIT_RETENTION_DAYS=180'));

  // 6. Live HTTPS Server Health Telemetry
  try {
    const health = await fetchHealth();
    check('Live server reports status: ok over TLS', health.status === 'ok');
    check('Live server reports active storage engine metadata', health.storage && health.storage.activeEngine === 'json');
    check('Live server reports active cache engine metadata', health.cache && health.cache.activeEngine === 'memory');
    check('Live server reports cluster node identifier', !!health.cluster && !!health.cluster.nodeId);
  } catch (err) {
    check('Live server telemetry accessible', false, err.message);
  }

  console.log('\n================================================================');
  console.log(' 🏁 National Cloud Enterprise Readiness: 100% Verified');
  console.log('================================================================\n');
}

runCloudReadinessSuite().catch(err => {
  console.error('Fatal test error:', err);
  process.exit(1);
});
