// ==============================================================================
// Karighar (कारीघर) — Enterprise Multi-Engine Storage Adapter Layer
// Seamlessly routes queries to JSON Atomic Store, SQLite, or PostgreSQL 16
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const fs = require('fs');
const path = require('path');

// Lightweight Native .env loader (loads root .env if present)
const envPath = path.join(__dirname, '..', '..', '.env');
if (fs.existsSync(envPath)) {
  try {
    const envContent = fs.readFileSync(envPath, 'utf8');
    for (const line of envContent.split('\n')) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const idx = trimmed.indexOf('=');
      if (idx > 0) {
        const key = trimmed.substring(0, idx).trim();
        const val = trimmed.substring(idx + 1).trim().replace(/^['"]|['"]$/g, '');
        if (!process.env[key]) {
          process.env[key] = val;
        }
      }
    }
  } catch (e) {
    console.warn('[ENV] Notice loading .env in db_adapter:', e.message);
  }
}

const { sqliteEngine } = require('./sqlite_engine');

const DB_FILE = path.join(__dirname, '..', 'data', 'database.json');
const ENGINE = (process.env.DB_ENGINE || 'json').toLowerCase();

let pgPool = null;
let pgConnected = false;
let pgInitPromise = null;
let pgError = null;

// Attempt PostgreSQL initialization if configured
if (ENGINE === 'postgres' && process.env.DATABASE_URL) {
  try {
    const { Pool } = require('pg');
    pgPool = new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
      max: parseInt(process.env.DB_POOL_MAX || '20', 10),
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 5000
    });
    pgInitPromise = pgPool.query('SELECT NOW()')
      .then(() => {
        console.log('[STORAGE] Connected to PostgreSQL 16 Enterprise Cluster');
        pgConnected = true;
        pgError = null;
      })
      .catch((err) => {
        pgError = err.message;
        console.warn('[STORAGE WARN] PostgreSQL connection failed, falling back to Atomic JSON:', err.message);
        pgConnected = false;
      });
  } catch (err) {
    pgError = err.message;
    console.warn('[STORAGE WARN] "pg" module not installed or invalid configuration. Using Atomic JSON engine.');
    pgConnected = false;
  }
}

/**
 * Embedded Atomic JSON Engine (Zero-Dependency Default)
 */
const jsonEngine = {
  read() {
    try {
      if (!fs.existsSync(DB_FILE)) return {};
      return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
    } catch (err) {
      console.error('[STORAGE ERROR] Error reading JSON database:', err.message);
      return {};
    }
  },

  write(data) {
    const tmpFile = `${DB_FILE}.${Date.now()}.${Math.random().toString(36).slice(2, 6)}.tmp`;
    try {
      const jsonStr = JSON.stringify(data, null, 2);
      fs.writeFileSync(tmpFile, jsonStr, 'utf8');
      fs.renameSync(tmpFile, DB_FILE);
      return true;
    } catch (err) {
      console.error('[STORAGE ERROR] Atomic write failed, using direct write fallback:', err.message);
      try {
        fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2), 'utf8');
        return true;
      } catch (directErr) {
        console.error('[STORAGE CRITICAL] Direct write failed:', directErr.message);
        return false;
      }
    } finally {
      if (fs.existsSync(tmpFile)) {
        try { fs.unlinkSync(tmpFile); } catch (_) {}
      }
    }
  }
};

/**
 * Unified Public API
 */
const dbAdapter = {
  getEngine() {
    if (ENGINE === 'postgres' && pgConnected) return 'postgres';
    if (ENGINE === 'sqlite' && sqliteEngine.isAvailable) return 'sqlite';
    return 'json';
  },

  isPostgresActive() {
    return ENGINE === 'postgres' && pgConnected;
  },

  isSqliteActive() {
    return sqliteEngine.isAvailable;
  },

  getDb() {
    return jsonEngine.read();
  },

  saveDb(data) {
    return jsonEngine.write(data);
  },

  // Direct backwards-compatible methods
  read() {
    return jsonEngine.read();
  },

  write(data) {
    return jsonEngine.write(data);
  },

  async query(sql, params = []) {
    if (this.isPostgresActive() && pgPool) {
      return await pgPool.query(sql, params);
    }
    if (sqliteEngine.isAvailable) {
      return sqliteEngine.query(sql, params);
    }
    throw new Error('No relational SQL driver (PostgreSQL or SQLite) is currently active.');
  },

  async waitForConnection() {
    if (pgInitPromise) {
      await pgInitPromise;
    }
    return this.getStatus();
  },

  getStatus() {
    return {
      activeEngine: this.getEngine(),
      configuredEngine: ENGINE,
      atomicSwapEnabled: true,
      postgresPoolConfigured: !!pgPool,
      postgresConnected: pgConnected,
      postgresError: pgError,
      sqliteAvailable: sqliteEngine.isAvailable,
      sqliteFile: sqliteEngine.isAvailable ? sqliteEngine.getStatus().file : null,
      databaseFilePath: DB_FILE
    };
  }
};

module.exports = {
  dbAdapter,
  DB_FILE
};
