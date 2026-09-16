// ==============================================================================
// Karighar (कारीघर) — PM-Vishwakarma Credit Hub & Telemetry Controller
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { creditRepository, artisanRepository } = require('../repositories');
const { logAuditEvent } = require('../middleware/audit_logger');

class CreditController {
  async getProfile(req, res, { params, sendJson }) {
    try {
      const artisanId = params.id || 'art_ramdev_01';
      const profile = creditRepository.getProfile(artisanId);
      return sendJson(res, 200, { success: true, profile });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async disburseLoan(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const loanAmount = Number(body.amount) || 100000.0;
      const artisanId = body.artisanId || 'art_ramdev_01';
      const disbursement = creditRepository.disburseLoan(artisanId, loanAmount);

      logAuditEvent({
        action: 'PM_VISHWAKARMA_CREDIT_DISBURSED',
        actor: 'SBI_DBT_PORTAL',
        role: 'CREDIT_HUB',
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { loanReference: disbursement.loanReference, amountDisbursed: loanAmount }
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('CREDIT_DISBURSED', disbursement);
      }
      return sendJson(res, 200, disbursement);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async getArtisanStats(req, res, { parsedUrl, sendJson }) {
    try {
      const artisanId = parsedUrl.searchParams.get('artisanId') || 'art_ramdev_01';
      const stats = artisanRepository.getStats(artisanId);
      return sendJson(res, 200, stats);
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getArtisanQuotes(req, res, { parsedUrl, sendJson }) {
    try {
      const artisanId = parsedUrl.searchParams.get('artisanId') || 'art_ramdev_01';
      const quotes = artisanRepository.getQuotes(artisanId);
      return sendJson(res, 200, { success: true, count: quotes.length, quotes });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getGisClusters(req, res, { sendJson }) {
    try {
      const clusters = artisanRepository.getClusters();
      return sendJson(res, 200, { success: true, count: clusters.length, clusters });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }
}

const creditController = new CreditController();
module.exports = creditController;
