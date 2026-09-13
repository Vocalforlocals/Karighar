// ==============================================================================
// Karighar (कारीघर) — CERT-In Compliant Regulatory Audit Logging Engine
// Implements tamper-evident append-only structured JSONL audit trail with hash-chaining
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const AUDIT_FILE = path.join(__dirname, '..', 'data', 'audit_trail.jsonl');
let lastHash = '0000000000000000000000000000000000000000000000000000000000000000';

// Initialize last hash from existing log file if present
try {
  if (fs.existsSync(AUDIT_FILE)) {
    const lines = fs.readFileSync(AUDIT_FILE, 'utf8').trim().split('\n').filter(Boolean);
    if (lines.length > 0) {
      const lastEntry = JSON.parse(lines[lines.length - 1]);
      if (lastEntry.integrityHash) {
        lastHash = lastEntry.integrityHash;
      }
    }
  }
} catch (_) {}

/**
 * Log a regulatory compliance audit event
 */
function logAuditEvent({ action, actor = 'ANONYMOUS', role = 'GUEST', ip = '127.0.0.1', status = 'SUCCESS', details = {} }) {
  try {
    const id = `AUD-${Date.now()}-${crypto.randomBytes(4).toString('hex')}`;
    const timestamp = new Date().toISOString();

    const recordPayload = {
      id,
      timestamp,
      action,
      actor,
      role,
      ip,
      status,
      details,
      previousHash: lastHash
    };

    // Cryptographic hash-chaining (each audit entry signs the previous entry)
    const integrityHash = crypto
      .createHash('sha256')
      .update(JSON.stringify(recordPayload))
      .digest('hex');

    recordPayload.integrityHash = integrityHash;
    lastHash = integrityHash;

    const line = JSON.stringify(recordPayload) + '\n';
    fs.appendFileSync(AUDIT_FILE, line, 'utf8');

    return recordPayload;
  } catch (err) {
    console.error('[AUDIT ERROR]', err.message);
    return null;
  }
}

/**
 * Retrieve recent audit logs for MoSJE administrator dashboard
 */
function getRecentAuditLogs(limit = 50) {
  try {
    if (!fs.existsSync(AUDIT_FILE)) return [];
    const content = fs.readFileSync(AUDIT_FILE, 'utf8');
    const lines = content.trim().split('\n').filter(Boolean);
    return lines
      .slice(-limit)
      .map(line => {
        try {
          return JSON.parse(line);
        } catch {
          return null;
        }
      })
      .filter(Boolean)
      .reverse(); // Newest first
  } catch (err) {
    console.error('[AUDIT RETRIEVAL ERROR]', err.message);
    return [];
  }
}

module.exports = {
  logAuditEvent,
  getRecentAuditLogs
};
