// ==============================================================================
// Karighar (कारीघर) — Blockchain Ledger & Government Webhooks Controller
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { blockchainRepository, tenderRepository, orderRepository } = require('../repositories');
const { verifyWebhookSignature } = require('../middleware/webhook_security');
const { logAuditEvent, getRecentAuditLogs } = require('../middleware/audit_logger');
const { dbAdapter } = require('../database/db_adapter');
const { sqliteEngine } = require('../database/sqlite_engine');

class BlockchainController {
  async getBlocks(req, res, { sendJson }) {
    try {
      const data = blockchainRepository.getBlocks();
      return sendJson(res, 200, {
        success: true,
        ...data
      });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getTransaction(req, res, { params, sendJson }) {
    try {
      const hash = params.hash;
      const result = blockchainRepository.getTransaction(hash);
      if (result) {
        return sendJson(res, 200, {
          success: true,
          blockNumber: result.blockNumber,
          transaction: result.transaction
        });
      }
      return sendJson(res, 404, { success: false, error: 'Transaction not found on ledger' });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getAuditLogs(req, res, { parsedUrl, sendJson }) {
    try {
      const limit = parseInt(parsedUrl.searchParams.get('limit') || '50', 10);
      const logs = getRecentAuditLogs(limit);
      return sendJson(res, 200, {
        success: true,
        count: logs.length,
        logs,
        sentryNotice: 'Immutable append-only audit trail active.'
      });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getDbStats(req, res, { sendJson }) {
    try {
      const status = dbAdapter.getStatus();
      const db = dbAdapter.read();
      return sendJson(res, 200, {
        success: true,
        activeEngine: status.engine,
        sqliteAvailable: sqliteEngine.isAvailable,
        totalArtisans: (db.artisans || []).length,
        totalProducts: (db.products || []).length,
        totalOrders: (db.orders || []).length,
        totalTenders: (db.tenders || []).length,
        chatThreads: (db.chatThreads || []).length,
        postgresPoolConfigured: status.postgresPoolConfigured,
        timestamp: new Date().toISOString()
      });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async handleGemWebhook(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const signatureHeader = req.headers['x-gov-signature'] || req.headers['x-signature-sha256'];
      const clientIp = req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1';

      if (signatureHeader) {
        const verifyResult = verifyWebhookSignature('GEM', req.rawBody || body, signatureHeader);
        if (!verifyResult.valid) {
          logAuditEvent({
            action: 'WEBHOOK_SIGNATURE_FAILED',
            actor: 'GEM_WEBHOOK_INGRESS',
            role: 'EXTERNAL_GOV_GATEWAY',
            ip: clientIp,
            status: 'SECURITY_ALERT',
            details: { portal: 'GEM', error: verifyResult.error }
          });
          return sendJson(res, 401, {
            success: false,
            error: `Cryptographic Webhook Verification Failed: ${verifyResult.error}`
          });
        }
      }

      const newTender = tenderRepository.create(body);

      logAuditEvent({
        action: 'GEM_TENDER_INGESTED',
        actor: 'GEM_PORTAL',
        role: 'EXTERNAL_GOV_GATEWAY',
        ip: clientIp,
        status: 'SUCCESS',
        details: { tenderId: newTender.id, reference: newTender.gemPortalReference, signed: !!signatureHeader }
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('TENDER_RECEIVED', newTender);
      }

      return sendJson(res, 201, {
        success: true,
        tenderId: newTender.id,
        gemPortalReference: newTender.gemPortalReference,
        status: 'INGESTED_TO_KARIGHAR',
        tender: newTender
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async handlePfmsWebhook(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const signatureHeader = req.headers['x-gov-signature'] || req.headers['x-signature-sha256'];
      const clientIp = req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1';

      if (signatureHeader) {
        const verifyResult = verifyWebhookSignature('PFMS', req.rawBody || body, signatureHeader);
        if (!verifyResult.valid) {
          logAuditEvent({
            action: 'WEBHOOK_SIGNATURE_FAILED',
            actor: 'PFMS_WEBHOOK_INGRESS',
            role: 'EXTERNAL_GOV_GATEWAY',
            ip: clientIp,
            status: 'SECURITY_ALERT',
            details: { portal: 'PFMS', error: verifyResult.error }
          });
          return sendJson(res, 401, {
            success: false,
            error: `Cryptographic Webhook Verification Failed: ${verifyResult.error}`
          });
        }
      }

      const orderId = body.orderId || 'ORD-2026-9041';
      const utr = body.utrNumber || `SBIN${Date.now()}`;
      const ackNo = body.pfmsAckNo || `PFMS-ACK-2026-${Math.floor(10000 + Math.random() * 90000)}`;

      const settlement = orderRepository.settleViaPfmsCallback(orderId, utr, ackNo);

      logAuditEvent({
        action: 'PFMS_SETTLEMENT_CALLBACK',
        actor: 'PFMS_CORE_BANKING',
        role: 'EXTERNAL_GOV_GATEWAY',
        ip: clientIp,
        status: 'SUCCESS',
        details: { orderId, utr, ackNo, signed: !!signatureHeader }
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('PFMS_SETTLED', settlement);
      }
      return sendJson(res, 200, settlement);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async handleIcegateWebhook(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const signatureHeader = req.headers['x-gov-signature'] || req.headers['x-signature-sha256'];
      const clientIp = req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1';

      if (signatureHeader) {
        const verifyResult = verifyWebhookSignature('ICEGATE', req.rawBody || body, signatureHeader);
        if (!verifyResult.valid) {
          logAuditEvent({
            action: 'WEBHOOK_SIGNATURE_FAILED',
            actor: 'ICEGATE_WEBHOOK_INGRESS',
            role: 'EXTERNAL_GOV_GATEWAY',
            ip: clientIp,
            status: 'SECURITY_ALERT',
            details: { portal: 'ICEGATE', error: verifyResult.error }
          });
          return sendJson(res, 401, {
            success: false,
            error: `Cryptographic Webhook Verification Failed: ${verifyResult.error}`
          });
        }
      }

      const trackingRef = body.shippingBillNumber || `SB-${Date.now()}`;
      const customClearance = {
        success: true,
        icegateStatus: 'CUSTOMS_CLEARED',
        portOfExport: body.portOfExport || 'INNSA1 (Nhava Sheva, Mumbai)',
        hsnCode: body.hsnCode || '5007',
        shippingBillNumber: trackingRef,
        dutyDrawbackStatus: 'APPROVED_PFMS_DIRECT_CREDIT',
        clearedAt: new Date().toISOString()
      };

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('CUSTOMS_CLEARED', customClearance);
      }
      return sendJson(res, 200, customClearance);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const blockchainController = new BlockchainController();
module.exports = blockchainController;
