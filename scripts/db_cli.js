// ==============================================================================
// Karighar (कारीघर) — Database Administration & Migrations CLI
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// Usage: node scripts/db_cli.js [status | seed | backup | restore <file> | export-sql | query <sql>]
// ==============================================================================

const fs = require('fs');
const path = require('path');
const { dbAdapter, DB_FILE } = require('../backend/database/db_adapter');
const { exportSeedSqlFile } = require('../backend/database/db_seeder');
const { sqliteEngine } = require('../backend/database/sqlite_engine');

const BACKUP_DIR = path.join(__dirname, '..', 'backend', 'data', 'backups');

function ensureBackupDir() {
  if (!fs.existsSync(BACKUP_DIR)) {
    fs.mkdirSync(BACKUP_DIR, { recursive: true });
  }
}

function printHelp() {
  console.log('Karighar Database CLI:');
  console.log('  node scripts/db_cli.js status              Show database statistics and engine health');
  console.log('  node scripts/db_cli.js seed                Regenerate seed.sql and sync relational tables');
  console.log('  node scripts/db_cli.js backup              Create timestamped snapshot in backend/backups/');
  console.log('  node scripts/db_cli.js restore <file>      Restore database from snapshot');
  console.log('  node scripts/db_cli.js export-sql          Export live state to backend/seed.sql');
  console.log('  node scripts/db_cli.js query "<SQL>"       Execute ad-hoc SQL query on relational engine\n');
}

async function handleCommand() {
  const args = process.argv.slice(2);
  const cmd = args[0] ? args[0].toLowerCase() : 'status';

  switch (cmd) {
    case 'status': {
      await dbAdapter.waitForConnection();
      console.log('================================================================');
      console.log(' 📊 Karighar Database Architecture Status');
      console.log('================================================================');
      const status = dbAdapter.getStatus();
      const db = dbAdapter.read();
      const stat = fs.existsSync(DB_FILE) ? fs.statSync(DB_FILE) : { size: 0 };

      console.log(` • Active Engine:       ${status.activeEngine.toUpperCase()}`);
      console.log(` • Configured Engine:   ${status.configuredEngine}`);
      console.log(` • PostgreSQL Connected:${status.postgresConnected ? ' YES (Connected to Cluster)' : ' NO'}`);
      if (status.configuredEngine === 'postgres' && !status.postgresConnected && status.postgresError) {
        console.log(`   └─ Connection Error: ${status.postgresError}`);
      }
      console.log(` • Atomic File-Swap:    ${status.atomicSwapEnabled ? 'ENABLED (ACID safe)' : 'DISABLED'}`);
      console.log(` • JSON File Path:      ${status.databaseFilePath} (${Math.round(stat.size / 1024)} KB)`);
      console.log(` • Products Count:      ${(db.products || []).length}`);
      console.log(` • Orders Count:        ${(db.orders || []).length}`);
      console.log(` • Tenders Count:       ${(db.tenders || []).length}`);
      console.log(` • GIS Clusters Count:  ${(db.gisClusters || []).length}`);
      console.log(` • Blockchain Blocks:   ${(db.blockchainBlocks || []).length}`);

      if (status.activeEngine === 'postgres') {
        try {
          const pgArtisans = await dbAdapter.query('SELECT COUNT(*) FROM artisans');
          const pgProducts = await dbAdapter.query('SELECT COUNT(*) FROM craft_products');
          const pgOrders = await dbAdapter.query('SELECT COUNT(*) FROM orders');
          const pgTenders = await dbAdapter.query('SELECT COUNT(*) FROM tenders');
          console.log('\n 🐘 PostgreSQL Live Cluster Counts:');
          console.log(`   - Artisans:          ${pgArtisans.rows[0].count}`);
          console.log(`   - Craft Products:    ${pgProducts.rows[0].count}`);
          console.log(`   - Orders:            ${pgOrders.rows[0].count}`);
          console.log(`   - Tenders:           ${pgTenders.rows[0].count}`);
        } catch (pgErr) {
          console.warn('   [PG NOTICE] Could not query live counts:', pgErr.message);
        }
      }

      const sqliteStatus = sqliteEngine.getStatus();
      console.log(` • Native SQLite:       ${sqliteStatus.active ? 'OPERATIONAL' : 'OFFLINE'}`);
      if (sqliteStatus.active) {
        console.log(`   - Tables:            ${sqliteStatus.tables.join(', ')}`);
        console.log(`   - Relational Counts: ${JSON.stringify(sqliteStatus.rowCounts)}`);
      }
      console.log('================================================================\n');
      break;
    }

    case 'seed':
    case 'export-sql': {
      console.log('[CLI] Generating idempotent SQL DML seed...');
      const sqlFile = exportSeedSqlFile();
      console.log(`[CLI] Export complete: ${sqlFile}`);
      break;
    }

    case 'backup': {
      ensureBackupDir();
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const backupFile = path.join(BACKUP_DIR, `database_backup_${timestamp}.json`);
      fs.copyFileSync(DB_FILE, backupFile);
      console.log(`[CLI] ✅ Database snapshot created: ${backupFile}`);
      break;
    }

    case 'restore': {
      const target = args[1];
      if (!target) {
        console.error('[CLI ERROR] Please specify backup file to restore.');
        process.exit(1);
      }
      const fullPath = path.isAbsolute(target) ? target : path.join(BACKUP_DIR, target);
      if (!fs.existsSync(fullPath)) {
        console.error(`[CLI ERROR] Backup file does not exist: ${fullPath}`);
        process.exit(1);
      }
      const backupData = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
      dbAdapter.write(backupData);
      console.log(`[CLI] ✅ Database restored successfully from: ${fullPath}`);
      break;
    }

    case 'query': {
      const sql = args.slice(1).join(' ');
      if (!sql) {
        console.error('[CLI ERROR] Please provide a SQL query string.');
        process.exit(1);
      }
      try {
        console.log(`[SQL EXEC] ${sql}`);
        const result = sqliteEngine.query(sql);
        console.table(result);
      } catch (err) {
        console.error('[SQL ERROR]', err.message);
        process.exit(1);
      }
      break;
    }

    default:
      printHelp();
  }
}

handleCommand().catch(err => {
  console.error('[CLI FATAL]', err);
  process.exit(1);
});
