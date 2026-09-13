// ==============================================================================
// Karighar (कारीघर) — Zero-Dependency Embedded Relational SQLite Engine
// Leverages native node:sqlite for local relational SQL execution & queries
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const path = require('path');
const fs = require('fs');

const SQLITE_FILE = path.join(__dirname, '..', 'data', 'karighar.sqlite');
const DB_JSON_FILE = path.join(__dirname, '..', 'data', 'database.json');

class SqliteEngine {
  constructor() {
    this.db = null;
    this.isAvailable = false;
    this._init();
  }

  _init() {
    try {
      const { DatabaseSync } = require('node:sqlite');
      this.db = new DatabaseSync(SQLITE_FILE);
      this.isAvailable = true;
      this._createTables();
      this._syncFromMasterJson();
      console.log('[SQLITE] Native Embedded Relational SQLite Engine active:', SQLITE_FILE);
    } catch (err) {
      console.warn('[SQLITE WARN] node:sqlite initialization notice:', err.message);
      this.isAvailable = false;
    }
  }

  _createTables() {
    if (!this.isAvailable || !this.db) return;

    this.db.exec(`
      CREATE TABLE IF NOT EXISTS artisans (
        id TEXT PRIMARY KEY,
        aadhaar_vault_token TEXT NOT NULL,
        full_name TEXT NOT NULL,
        phone_number TEXT,
        state TEXT NOT NULL,
        district TEXT NOT NULL,
        cluster_name TEXT NOT NULL,
        craft_category TEXT NOT NULL,
        pm_vishwakarma_id TEXT,
        trust_score INTEGER DEFAULT 800,
        is_dbt_linked INTEGER DEFAULT 1
      );

      CREATE TABLE IF NOT EXISTS craft_products (
        id TEXT PRIMARY KEY,
        artisan_id TEXT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        craft_form TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        stock_quantity INTEGER DEFAULT 1,
        estimated_craft_hours INTEGER DEFAULT 48,
        sha256_hash TEXT NOT NULL,
        gi_tag_certified INTEGER DEFAULT 1,
        tags TEXT DEFAULT '[]',
        image_url TEXT
      );

      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        product_id TEXT,
        buyer_name TEXT NOT NULL,
        buyer_email TEXT,
        amount REAL NOT NULL,
        currency TEXT DEFAULT 'INR',
        status TEXT DEFAULT 'pending',
        escrow_status TEXT DEFAULT 'HELD_IN_ESCROW',
        pfms_ref TEXT,
        polygon_tx TEXT
      );

      CREATE TABLE IF NOT EXISTS tenders (
        id TEXT PRIMARY KEY,
        gem_portal_reference TEXT NOT NULL,
        issuing_ministry TEXT NOT NULL,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        total_quantity INTEGER NOT NULL,
        pooled_quantity INTEGER DEFAULT 0,
        max_budget_per_unit REAL NOT NULL,
        total_budget_value REAL NOT NULL,
        deadline TEXT NOT NULL,
        hsn_code TEXT DEFAULT '5007',
        status TEXT DEFAULT 'open_for_pooling',
        description TEXT
      );
    `);
  }

  _syncFromMasterJson() {
    if (!this.isAvailable || !this.db || !fs.existsSync(DB_JSON_FILE)) return;

    try {
      const data = JSON.parse(fs.readFileSync(DB_JSON_FILE, 'utf8'));

      // Seed Default Artisans
      const insertArtisan = this.db.prepare(`
        INSERT OR IGNORE INTO artisans (id, aadhaar_vault_token, full_name, phone_number, state, district, cluster_name, craft_category, pm_vishwakarma_id, trust_score, is_dbt_linked)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `);
      insertArtisan.run('art_ramdev_01', 'vault_uid_5489_8412_varanasi', 'Master Ramdev Varma', '+91-9876543210', 'Uttar Pradesh', 'Varanasi', 'Varanasi Silk Guild #04', 'Textiles & Weaves', 'PM-VISHWAKARMA-UP-VAR-9041', 842, 1);
      insertArtisan.run('art_lakshmi_02', 'vault_uid_6712_9821_kutch', 'Lakshmi Ben', '+91-9876543211', 'Gujarat', 'Kutch', 'Ajrakhpur Dye Cooperative', 'Block Printing', 'PM-VISHWAKARMA-GJ-KUT-4412', 875, 1);

      // Seed Products
      const insertProd = this.db.prepare(`
        INSERT OR REPLACE INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `);
      for (const p of (data.products || [])) {
        insertProd.run(
          p.id,
          p.artisanId || 'art_ramdev_01',
          p.title,
          p.category || 'Textiles & Weaves',
          p.craftForm || 'Handloom',
          p.description || '',
          Number(p.price) || 8500,
          Number(p.stockQuantity) || 1,
          Number(p.estimatedHours) || 48,
          p.sha256Hash || p.id,
          p.isGICertified !== false ? 1 : 0,
          JSON.stringify(p.tags || []),
          (p.images && p.images[0]) || p.rawImage || ''
        );
      }

      // Seed Tenders
      const insertTender = this.db.prepare(`
        INSERT OR REPLACE INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `);
      for (const t of (data.tenders || [])) {
        insertTender.run(
          t.id,
          t.gemPortalReference || `GEM/2026/B/${Math.floor(100000 + Math.random() * 900000)}`,
          t.issuingEntity || 'Ministry of Social Justice & Empowerment',
          t.title,
          t.category || 'Handloom Textiles',
          Number(t.totalQuantity) || 500,
          Number(t.pooledQuantity) || 0,
          Number(t.maxBudgetPerUnit) || 2500,
          Number(t.totalBudgetValue) || 1250000,
          t.deadline || '2026-11-30',
          t.hsnCode || '5007',
          t.status || 'open_for_pooling',
          t.description || ''
        );
      }

      // Seed Orders
      const insertOrder = this.db.prepare(`
        INSERT OR REPLACE INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `);
      for (const o of (data.orders || [])) {
        insertOrder.run(
          o.id,
          o.productId || 'prod_01',
          o.buyerName || 'Client Buyer',
          o.buyerEmail || 'buyer@delhi.gov.in',
          Number(o.amount) || 8500,
          'INR',
          o.status || 'delivered',
          o.escrowStatus || 'SETTLED_TO_BENEFICIARY',
          o.pfmsRef || 'PFMS-DBT-80085643',
          o.polygonTx || '0xac76f496f2a8b6dd335acaa012ef4a16'
        );
      }
    } catch (err) {
      console.error('[SQLITE ERROR] Sync failed:', err.message);
    }
  }

  query(sql, params = []) {
    if (!this.isAvailable || !this.db) {
      throw new Error('SQLite engine is not initialized.');
    }
    const stmt = this.db.prepare(sql);
    return stmt.all(...params);
  }

  execute(sql, params = []) {
    if (!this.isAvailable || !this.db) {
      throw new Error('SQLite engine is not initialized.');
    }
    const stmt = this.db.prepare(sql);
    return stmt.run(...params);
  }

  getStatus() {
    if (!this.isAvailable || !this.db) {
      return { active: false, file: null, tables: [] };
    }

    try {
      const tablesStmt = this.db.prepare("SELECT name FROM sqlite_master WHERE type='table'");
      const tables = tablesStmt.all().map(t => t.name);

      const countStmt = (tbl) => {
        try {
          return this.db.prepare(`SELECT COUNT(*) as count FROM ${tbl}`).get().count;
        } catch { return 0; }
      };

      const counts = {};
      for (const t of tables) {
        counts[t] = countStmt(t);
      }

      return {
        active: true,
        driver: 'node:sqlite (native)',
        file: SQLITE_FILE,
        tables,
        rowCounts: counts
      };
    } catch (err) {
      return { active: false, error: err.message };
    }
  }
}

const sqliteEngine = new SqliteEngine();

module.exports = {
  sqliteEngine,
  SQLITE_FILE
};
