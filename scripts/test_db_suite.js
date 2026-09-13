// ==============================================================================
// Karighar (कारीघर) — End-to-End Database Architecture Test Suite
// Verifies Domain Repositories, Embedded Relational SQLite, & Admin Telemetry
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const https = require('https');
const {
  productRepository,
  orderRepository,
  tenderRepository,
  creditRepository,
  blockchainRepository
} = require('../backend/repositories');
const { sqliteEngine } = require('../backend/sqlite_engine');
const { dbAdapter } = require('../backend/db_adapter');

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

function fetchSecure(path) {
  return new Promise((resolve, reject) => {
    const req = https.get(`https://localhost:8443${path}`, { rejectUnauthorized: false }, res => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(data) });
        } catch {
          resolve({ status: res.statusCode, data });
        }
      });
    });
    req.on('error', reject);
  });
}

async function runSuite() {
  console.log('================================================================');
  console.log(' 🏛️  Running Karighar Multi-Phase Database Architecture Test Suite');
  console.log('================================================================\n');

  // 1. Product Repository
  await test('ProductRepository.getAll returns seeded products with category filter', async () => {
    const textiles = productRepository.getAll({ category: 'Textiles & Weaves' });
    if (!Array.isArray(textiles) || textiles.length === 0) {
      throw new Error('Expected textiles array');
    }
  });

  await test('ProductRepository.create mints valid SHA-256 provenance hash', async () => {
    const p = productRepository.create({
      title: 'Tanjore 24K Gold Foil Art Frame',
      category: 'Paintings & Art',
      craftForm: 'Tanjore Art',
      price: 18000
    });
    if (!p.id || !p.sha256Hash || p.sha256Hash.length !== 64) {
      throw new Error('Product creation failed or SHA-256 invalid');
    }
  });

  await test('ProductRepository.updateStock adjusts stock quantity atomically', async () => {
    const all = productRepository.getAll();
    const target = all[0];
    const originalStock = target.stockQuantity;
    const updated = productRepository.updateStock(target.id, 5);
    if (updated.stockQuantity !== originalStock + 5) {
      throw new Error(`Stock mismatch: expected ${originalStock + 5}, got ${updated.stockQuantity}`);
    }
  });

  // 2. Order Repository
  await test('OrderRepository manages escrow status and PFMS settlement', async () => {
    const o = orderRepository.create({ amount: 9500, buyerName: 'Corporate Gifting Client' });
    if (!o.id || o.escrowStatus !== 'HELD_IN_ESCROW') {
      throw new Error('Order creation failed');
    }
    const release = orderRepository.releaseEscrow(o.id);
    if (release.escrowStatus !== 'RELEASED_TO_ARTISAN' || !release.pfmsTransactionId) {
      throw new Error('Escrow release failed');
    }
  });

  // 3. Tender Repository
  await test('TenderRepository tracks institutional RFQs and loom capacity commitments', async () => {
    const t = tenderRepository.create({
      title: 'MoSJE National Gifting 300 Shawls',
      quantity: 300,
      budgetPerUnit: 2200
    });
    if (!t.id || t.status !== 'open_for_pooling') {
      throw new Error('Tender creation failed');
    }
    const updatedTender = tenderRepository.commitCapacity(t.id, {
      artisanId: 'art_ramdev_01',
      artisanName: 'Master Ramdev',
      committedUnits: 60,
      committedLooms: 2
    });
    if (updatedTender.pooledQuantity !== 60 || updatedTender.contributors.length === 0) {
      throw new Error('Loom capacity commitment failed');
    }
  });

  // 4. Credit Repository
  await test('CreditRepository returns PM-Vishwakarma profile and records loan DBT', async () => {
    const profile = creditRepository.getProfile('art_ramdev_01');
    if (profile.creditScore !== 842 || profile.ratingTier !== 'Tier-1 AAA (Prime Trust)') {
      throw new Error('Credit profile score invalid');
    }
    const disburse = creditRepository.disburseLoan('art_ramdev_01', 100000);
    if (!disburse.success || !disburse.loanReference.startsWith('PM-VISHWAKARMA-LOAN')) {
      throw new Error('Loan disbursement failed');
    }
  });

  // 5. Blockchain Repository
  await test('BlockchainRepository queries blocks and transaction Merkle proofs', async () => {
    const blocksData = blockchainRepository.getBlocks();
    if (blocksData.count === 0 || blocksData.chainId !== 13702) {
      throw new Error('Blockchain blocks query failed');
    }
    const txInfo = blockchainRepository.getTransaction('9e12b7');
    if (!txInfo || !txInfo.merkleRoot) {
      throw new Error('Transaction lookup by hash failed');
    }
  });

  // 6. Native SQLite Relational Engine
  await test('Embedded Relational SQLite executes multi-table SQL JOIN queries', async () => {
    const rows = sqliteEngine.query(`
      SELECT p.id, p.title, p.price, a.full_name, a.cluster_name
      FROM craft_products p
      LEFT JOIN artisans a ON p.artisan_id = a.id
      LIMIT 3
    `);
    if (!Array.isArray(rows) || rows.length === 0 || !rows[0].title) {
      throw new Error('SQLite multi-table query failed');
    }
  });

  // 7. Live Server Admin Database Telemetry
  await test('HTTPS GET /api/v1/admin/db/stats returns live storage & relational metrics', async () => {
    const res = await fetchSecure('/api/v1/admin/db/stats');
    if (res.status !== 200 || !res.data.success) {
      throw new Error(`Expected 200, got ${res.status}`);
    }
    if (!res.data.activeEngine || !res.data.entities || res.data.entities.products === 0) {
      throw new Error('Invalid database telemetry payload');
    }
    if (!res.data.relationalSqlite || !res.data.relationalSqlite.active) {
      throw new Error('Expected native relational SQLite to be reported active');
    }
  });

  console.log('\n================================================================');
  console.log(` 🏁 Database Architecture Suite: ${passed} Passed, ${failed} Failed`);
  console.log('================================================================\n');

  if (failed > 0) {
    process.exit(1);
  }
}

runSuite().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
