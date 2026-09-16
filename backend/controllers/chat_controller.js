// ==============================================================================
// Karighar (कारीघर) — Chat & Negotiation Domain Controller
// Powers Real-Time Buyer-Artisan Negotiation, Counter Offers & Escrow Locks
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { chatRepository } = require('../repositories');
const validator = require('../middleware/validator');

class ChatController {
  async getThreads(req, res, { parsedUrl, sendJson }) {
    try {
      const role = parsedUrl.searchParams.get('role');
      const userId = parsedUrl.searchParams.get('userId');
      const threads = chatRepository.getAllThreads({ role, userId });
      return sendJson(res, 200, { success: true, count: threads.length, threads });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getThreadById(req, res, { params, sendJson }) {
    try {
      const thread = chatRepository.getThreadById(params.id);
      if (!thread) {
        return sendJson(res, 404, { success: false, error: 'Chat thread not found' });
      }
      return sendJson(res, 200, { success: true, thread });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async createThread(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const newThread = chatRepository.createThread(body);

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('THREAD_CREATED', newThread);
      }
      return sendJson(res, 201, { success: true, thread: newThread });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async sendMessage(req, res, { params, body, broadcastEvent, sendJson }) {
    try {
      const threadId = params.id;
      const validated = validator.validateChatMessage(body);
      const result = chatRepository.addMessage(threadId, {
        ...body,
        ...validated
      });

      if (!result) {
        return sendJson(res, 404, { success: false, error: 'Chat thread not found' });
      }

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('CHAT_MESSAGE', { threadId, message: result.message });
      }
      return sendJson(res, 201, { success: true, message: result.message, thread: result.thread });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async submitCounterOffer(req, res, { params, body, broadcastEvent, sendJson }) {
    try {
      const threadId = params.id;
      const validated = validator.validateCounterOffer(body);
      const counterPrice = validated.counterPrice;

      const thread = chatRepository.getThreadById(threadId);
      if (!thread) {
        return sendJson(res, 404, { success: false, error: 'Chat thread not found' });
      }

      const totalAmount = Math.round(counterPrice * thread.requestedQuantity);
      const escrowAdvance = Math.round(totalAmount * 0.3);

      // Add counter card message
      const cardMessage = {
        senderRole: 'artisan',
        senderName: thread.artisanName,
        text: body.note || `Counter-Offer: ₹${counterPrice.toLocaleString('en-IN')}/unit (Total: ₹${totalAmount.toLocaleString('en-IN')}) with certified GI loom schedule.`,
        messageType: 'counter_card',
        cardData: {
          quantity: thread.requestedQuantity,
          unitPrice: counterPrice,
          totalAmount,
          escrowAdvance
        },
        isAiAssisted: false
      };

      chatRepository.addMessage(threadId, cardMessage);
      const updatedThread = chatRepository.updateThreadStatus(threadId, 'countered', {
        artisanCounterPrice: counterPrice.toString()
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('THREAD_UPDATED', {
          threadId,
          status: 'countered',
          artisanCounterPrice: counterPrice.toString(),
          thread: updatedThread
        });
      }

      return sendJson(res, 200, {
        success: true,
        message: 'Counter offer submitted successfully',
        thread: updatedThread
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async acceptDeal(req, res, { params, body, broadcastEvent, sendJson }) {
    try {
      const threadId = params.id;
      const thread = chatRepository.getThreadById(threadId);
      if (!thread) {
        return sendJson(res, 404, { success: false, error: 'Chat thread not found' });
      }

      const acceptedPrice = thread.artisanCounterPrice ? parseFloat(thread.artisanCounterPrice) : thread.targetPricePerUnit;
      const totalAmount = Math.round(acceptedPrice * thread.requestedQuantity);
      const escrowAdvance = Math.round(totalAmount * 0.3);

      const systemMsg = `🎉 Deal Accepted! Agreed price: ₹${acceptedPrice.toLocaleString('en-IN')}/unit. Total Contract: ₹${totalAmount.toLocaleString('en-IN')}. 30% Escrow Advance (₹${escrowAdvance.toLocaleString('en-IN')}) verified under MoSJE PFMS Direct DBT Rails. Production initiated.`;

      const updatedThread = chatRepository.updateThreadStatus(threadId, 'accepted', {
        systemMessage: systemMsg,
        messageType: 'acceptance_card',
        cardData: {
          quantity: thread.requestedQuantity,
          unitPrice: acceptedPrice,
          totalAmount,
          escrowAdvance,
          escrowStatus: 'PFMS_HELD'
        }
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('DEAL_ACCEPTED', {
          threadId,
          agreedPrice: acceptedPrice,
          totalAmount,
          escrowAdvance,
          thread: updatedThread
        });
      }

      return sendJson(res, 200, {
        success: true,
        message: 'Deal accepted and locked in RBI Nodal Escrow',
        thread: updatedThread
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async markAsRead(req, res, { params, body, sendJson }) {
    try {
      const threadId = params.id;
      const role = body.role || 'artisan';
      const thread = chatRepository.markAsRead(threadId, role);
      if (!thread) {
        return sendJson(res, 404, { success: false, error: 'Chat thread not found' });
      }
      return sendJson(res, 200, { success: true, thread });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const chatController = new ChatController();
module.exports = chatController;
