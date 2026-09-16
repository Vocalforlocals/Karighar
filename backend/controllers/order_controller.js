// ==============================================================================
// Karighar (कारीघर) — Order Domain Controller
// Manages Escrow Lifecycle, DBT Settlements & Status Milestones
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { orderRepository } = require('../repositories');
const validator = require('../middleware/validator');

class OrderController {
  async getAll(req, res, { parsedUrl, sendJson }) {
    try {
      const buyerEmail = parsedUrl.searchParams.get('buyerEmail');
      const artisanId = parsedUrl.searchParams.get('artisanId');
      const orders = orderRepository.getAll({ buyerEmail, artisanId });
      return sendJson(res, 200, { success: true, count: orders.length, orders });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getById(req, res, { params, sendJson }) {
    try {
      const order = orderRepository.getById ? orderRepository.getById(params.id) : null;
      if (!order) {
        return sendJson(res, 404, { success: false, error: 'Order not found' });
      }
      return sendJson(res, 200, { success: true, order });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async create(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const validated = validator.validateOrderCreate(body);
      const newOrder = orderRepository.create({
        ...body,
        ...validated
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('ORDER_CREATED', newOrder);
      }
      return sendJson(res, 201, { success: true, order: newOrder });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async updateStatus(req, res, { params, body, broadcastEvent, sendJson }) {
    try {
      const orderId = params.id;
      const status = body.status;
      if (!status) {
        return sendJson(res, 400, { success: false, error: 'Missing status field' });
      }

      const updated = orderRepository.updateStatus(orderId, status);
      if (!updated) {
        return sendJson(res, 404, { success: false, error: 'Order not found' });
      }

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('ORDER_UPDATED', { orderId, status });
      }
      return sendJson(res, 200, { success: true, order: updated });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const orderController = new OrderController();
module.exports = orderController;
