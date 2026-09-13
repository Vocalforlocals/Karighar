// ==============================================================================
// Karighar (कारीघर) — Database Seeding & SQL DML Migration Engine
// Ingests master JSON entities & generates idempotent PostgreSQL 16 seed script
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const fs = require('fs');
const path = require('path');

const DB_FILE = path.join(__dirname, '..', 'data', 'database.json');
const OUTPUT_SQL_FILE = path.join(__dirname, 'seed.sql');

function escapeSql(val) {
  if (val === null || val === undefined) return 'NULL';
  if (typeof val === 'number') return val;
  if (typeof val === 'boolean') return val ? 'TRUE' : 'FALSE';
  return `'${String(val).replace(/'/g, "''")}'`;
}

function escapeArray(arr) {
  if (!Array.isArray(arr) || arr.length === 0) return "'{}'";
  const escapedElements = arr.map(e => `"${String(e).replace(/"/g, '\\"')}"`).join(',');
  return `'{${escapedElements}}'`;
}

function generateSqlSeed() {
  if (!fs.existsSync(DB_FILE)) {
    throw new Error(`Seed database file not found at: ${DB_FILE}`);
  }

  const data = JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
  const sqlLines = [];

  sqlLines.push('-- ==============================================================================');
  sqlLines.push('-- Karighar (कारीघर) — Automated Seed Data Migration Script');
  sqlLines.push('-- Auto-generated on: ' + new Date().toISOString());
  sqlLines.push('-- ==============================================================================\n');

  // 1. SEED ARTISANS
  sqlLines.push('-- 1. ARTISANS REGISTRY');
  const artisans = [
    {
      id: 'art_ramdev_01',
      aadhaar_vault_token: 'vault_uid_5489_8412_varanasi',
      full_name: 'Master Ramdev Varma',
      phone_number: '+91-9876543210',
      state: 'Uttar Pradesh',
      district: 'Varanasi',
      cluster_name: 'Varanasi Silk Weavers Guild #04',
      craft_category: 'Textiles & Weaves',
      pm_vishwakarma_id: 'PM-VISHWAKARMA-UP-VAR-9041',
      trust_score: 842,
      is_dbt_linked: true
    },
    {
      id: 'art_lakshmi_02',
      aadhaar_vault_token: 'vault_uid_6712_9821_kutch',
      full_name: 'Lakshmi Ben',
      phone_number: '+91-9876543211',
      state: 'Gujarat',
      district: 'Kutch',
      cluster_name: 'Ajrakhpur Natural Dye Cooperative',
      craft_category: 'Block Printing & Ajrakh',
      pm_vishwakarma_id: 'PM-VISHWAKARMA-GJ-KUT-4412',
      trust_score: 875,
      is_dbt_linked: true
    },
    {
      id: 'art_somnath_03',
      aadhaar_vault_token: 'vault_uid_8941_1204_bastar',
      full_name: 'Somnath Baghel',
      phone_number: '+91-9876543212',
      state: 'Chhattisgarh',
      district: 'Bastar',
      cluster_name: 'Bastar Lost-Wax Bell Metal Guild',
      craft_category: 'Metal Crafts',
      pm_vishwakarma_id: 'PM-VISHWAKARMA-CG-BAS-7819',
      trust_score: 810,
      is_dbt_linked: true
    }
  ];

  for (const a of artisans) {
    sqlLines.push(`INSERT INTO artisans (id, aadhaar_vault_token, full_name, phone_number, state, district, cluster_name, craft_category, pm_vishwakarma_id, trust_score, is_dbt_linked)
VALUES (${escapeSql(a.id)}, ${escapeSql(a.aadhaar_vault_token)}, ${escapeSql(a.full_name)}, ${escapeSql(a.phone_number)}, ${escapeSql(a.state)}, ${escapeSql(a.district)}, ${escapeSql(a.cluster_name)}, ${escapeSql(a.craft_category)}, ${escapeSql(a.pm_vishwakarma_id)}, ${a.trust_score}, ${escapeSql(a.is_dbt_linked)})
ON CONFLICT (id) DO NOTHING;`);
  }
  sqlLines.push('');

  // 2. SEED CRAFT PRODUCTS
  sqlLines.push('-- 2. CRAFT PRODUCTS');
  const products = data.products || [];
  const seenHashes = new Set();

  for (const p of products) {
    let hash = p.sha256Hash || p.id;
    if (hash.startsWith('0x')) hash = hash.slice(2);
    if (hash.length !== 64) {
      hash = require('crypto').createHash('sha256').update(p.id + p.title).digest('hex');
    }
    if (seenHashes.has(hash)) continue;
    seenHashes.add(hash);

    const artisanId = p.artisanId || 'art_ramdev_01';
    const tags = Array.isArray(p.tags) ? p.tags : ['GI Certified'];
    const imageUrl = (p.images && p.images[0]) || p.rawImage || 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800';

    sqlLines.push(`INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES (${escapeSql(p.id)}, ${escapeSql(artisanId)}, ${escapeSql(p.title)}, ${escapeSql(p.category || 'Textiles & Weaves')}, ${escapeSql(p.craftForm || 'Handicraft')}, ${escapeSql(p.description || '')}, ${Number(p.price) || 5000}, ${Number(p.stockQuantity) || 1}, ${Number(p.estimatedHours) || 48}, ${escapeSql(hash)}, ${escapeSql(p.isGICertified !== false)}, ${escapeArray(tags)}, ${escapeSql(imageUrl)})
ON CONFLICT (id) DO NOTHING;`);
  }
  sqlLines.push('');

  // 3. SEED ORDERS
  sqlLines.push('-- 3. ORDERS & ESCROW SETTLEMENTS');
  const orders = data.orders || [];
  for (const o of orders) {
    const prodId = o.productId || (products[0] ? products[0].id : 'prod_01');
    sqlLines.push(`INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES (${escapeSql(o.id)}, ${escapeSql(prodId)}, ${escapeSql(o.buyerName || 'Ananya Sen')}, ${escapeSql(o.buyerEmail || 'buyer@delhi.gov.in')}, ${Number(o.amount) || 8500}, 'INR', ${escapeSql(o.status || 'delivered')}, ${escapeSql(o.escrowStatus || 'SETTLED_TO_BENEFICIARY')}, ${escapeSql(o.pfmsRef || 'PFMS-DBT-80085643')}, ${escapeSql(o.polygonTx || '0xac76f496f2a8b6dd335acaa012ef4a16')}, ${escapeSql(o.shippingAddress || 'New Delhi, India')})
ON CONFLICT (id) DO NOTHING;`);
  }
  sqlLines.push('');

  // 4. SEED TENDERS
  sqlLines.push('-- 4. INSTITUTIONAL PROCUREMENT TENDERS');
  const tenders = data.tenders || [];
  const seenGemRefs = new Set();

  for (const t of tenders) {
    let gemRef = t.gemPortalReference || `GEM/2026/B/${Math.floor(100000 + Math.random() * 900000)}`;
    if (seenGemRefs.has(gemRef)) {
      gemRef = `${gemRef}-${t.id}`;
    }
    seenGemRefs.add(gemRef);

    sqlLines.push(`INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES (${escapeSql(t.id)}, ${escapeSql(gemRef)}, ${escapeSql(t.issuingEntity || 'Ministry of Social Justice & Empowerment')}, ${escapeSql(t.title)}, ${escapeSql(t.category || 'Handloom Textiles')}, ${Number(t.totalQuantity) || 500}, ${Number(t.pooledQuantity) || 0}, ${Number(t.maxBudgetPerUnit) || 2500}, ${Number(t.totalBudgetValue) || 1250000}, ${escapeSql(t.deadline || '2026-11-30')}, ${escapeSql(t.hsnCode || '5007')}, ${escapeSql(t.status || 'open_for_pooling')}, ${escapeSql(t.description || '')})
ON CONFLICT (id) DO NOTHING;`);
  }
  sqlLines.push('');

  // 5. SEED CREDIT PROFILES
  sqlLines.push('-- 5. PM-VISHWAKARMA CREDIT PROFILES');
  const creditProfiles = data.creditProfiles || {};
  for (const [artisanId, cp] of Object.entries(creditProfiles)) {
    sqlLines.push(`INSERT INTO credit_profiles (artisan_id, credit_score, rating_tier, on_time_delivery_rate, average_weave_quality, verified_dbt_turnover, pre_approved_loan_amount, interest_rate_per_annum, tenure_months, linked_bank_account)
VALUES (${escapeSql(artisanId)}, ${Number(cp.creditScore) || 842}, ${escapeSql(cp.ratingTier || 'Tier-1 AAA (Prime Trust)')}, ${Number(cp.onTimeDeliveryRate) || 97.8}, ${Number(cp.averageWeaveQuality) || 98.6}, ${Number(cp.verifiedDbtTurnover) || 182000}, ${Number(cp.preApprovedLoanAmount) || 100000}, ${Number(cp.interestRatePerAnnum) || 5.0}, ${Number(cp.tenureMonths) || 18}, ${escapeSql(cp.linkedBankAccount || 'State Bank of India')})
ON CONFLICT (artisan_id) DO NOTHING;`);
  }
  sqlLines.push('');

  // 6. SEED BLOCKCHAIN BLOCKS
  sqlLines.push('-- 6. SOVEREIGN BLOCKCHAIN LEDGER BLOCKS');
  const blocks = data.blockchainBlocks || [];
  for (const b of blocks) {
    let blockHash = b.blockHash || '';
    if (blockHash.startsWith('0x')) blockHash = blockHash.slice(2);
    if (blockHash.length !== 64) blockHash = blockHash.padEnd(64, '0').slice(0, 64);

    let prevHash = b.previousHash || '';
    if (prevHash.startsWith('0x')) prevHash = prevHash.slice(2);
    if (prevHash.length !== 64) prevHash = prevHash.padEnd(64, '0').slice(0, 64);

    const merkleRoot = b.merkleRoot || '0xfe492a819b4c2e6d8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f';

    sqlLines.push(`INSERT INTO blockchain_blocks (block_number, block_hash, previous_block_hash, merkle_root, validator_node, transactions_count, gas_used, block_data)
VALUES (${Number(b.blockNumber)}, ${escapeSql(blockHash)}, ${escapeSql(prevHash)}, ${escapeSql(merkleRoot)}, ${escapeSql(b.validator || 'MoSJE Node')}, ${(b.transactions || []).length}, ${Number(b.gasUsed) || 42000}, ${escapeSql(JSON.stringify(b))})
ON CONFLICT (block_number) DO NOTHING;`);
  }
  sqlLines.push('');

  return sqlLines.join('\n');
}

function exportSeedSqlFile(destPath = OUTPUT_SQL_FILE) {
  const sql = generateSqlSeed();
  fs.writeFileSync(destPath, sql, 'utf8');
  const rootSeedPath = path.join(__dirname, '..', 'seed.sql');
  try { fs.writeFileSync(rootSeedPath, sql, 'utf8'); } catch (_) {}
  console.log(`[SEEDER] Successfully generated SQL seed script: ${destPath} (${Buffer.byteLength(sql)} bytes)`);
  return destPath;
}

if (require.main === module) {
  try {
    exportSeedSqlFile();
  } catch (err) {
    console.error('[SEEDER ERROR]', err.message);
    process.exit(1);
  }
}

module.exports = {
  generateSqlSeed,
  exportSeedSqlFile
};
