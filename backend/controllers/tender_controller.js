// ==============================================================================
// Karighar (कारीघर) — GeM Tenders & Cluster Pooling Controller
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { tenderRepository } = require('../repositories');

class TenderController {
  async getAll(req, res, { sendJson }) {
    try {
      const tenders = tenderRepository.getAll();
      return sendJson(res, 200, { success: true, count: tenders.length, tenders });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async poolCapacity(req, res, { params, body, broadcastEvent, sendJson }) {
    try {
      const tenderId = params.id;
      const tender = tenderRepository.commitCapacity(tenderId, body);

      if (!tender) {
        return sendJson(res, 404, { success: false, error: 'Tender not found' });
      }

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('POOLING_UPDATED', tender);
      }
      return sendJson(res, 200, { success: true, tender });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const tenderController = new TenderController();
module.exports = tenderController;
