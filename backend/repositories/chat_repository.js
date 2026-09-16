// ==============================================================================
// Karighar (कारीघर) — Chat & Negotiation Repository
// Manages Real-time Negotiation Threads, Quotes, Counter-offers & Escrow Deals
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const crypto = require('crypto');
const { dbAdapter } = require('../database/db_adapter');

class ChatRepository {
  constructor() {
    this.adapter = dbAdapter;
    this._ensureInitialData();
  }

  _getDb() {
    return this.adapter.read();
  }

  _saveDb(db) {
    return this.adapter.write(db);
  }

  _ensureInitialData() {
    const db = this._getDb();
    if (!Array.isArray(db.chatThreads) || db.chatThreads.length === 0) {
      db.chatThreads = [
        {
          id: 'thread_01',
          quoteId: 'QUO-2026-089',
          buyerId: 'buyer_fabindia',
          buyerName: 'Priya Sharma',
          buyerOrg: 'FabIndia Procurement',
          artisanId: 'art_ramdev_01',
          artisanName: 'Master Ramdev',
          artisanCraft: 'GI Varanasi Brocade',
          productTitle: 'Varanasi Pure Katan Silk Brocade Saree',
          requestedQuantity: 25,
          targetPricePerUnit: 14500,
          artisanCounterPrice: '15800',
          status: 'countered',
          unreadCountArtisan: 0,
          unreadCountBuyer: 1,
          lastUpdated: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
          messages: [
            {
              id: 'msg_01_1',
              senderRole: 'buyer',
              senderName: 'Priya Sharma (FabIndia)',
              text: 'Namaste Ramdev ji, we are curating an exclusive Festive Silk collection and would like 25 units of your GI Brocade Saree.',
              timestamp: new Date(Date.now() - 60 * 60 * 1000).toISOString(),
              messageType: 'text',
              isAiAssisted: false
            },
            {
              id: 'msg_01_2',
              senderRole: 'buyer',
              senderName: 'Priya Sharma (FabIndia)',
              text: 'Offer Details: 25 sarees @ ₹14,500/unit (Total: ₹3,62,500). Immediate 30% PFMS Escrow deposit on acceptance.',
              timestamp: new Date(Date.now() - 55 * 60 * 1000).toISOString(),
              messageType: 'quote_card',
              cardData: {
                quantity: 25,
                unitPrice: 14500,
                totalAmount: 362500,
                escrowAdvance: 108750
              },
              isAiAssisted: false
            },
            {
              id: 'msg_01_3',
              senderRole: 'artisan',
              senderName: 'Master Ramdev',
              text: 'Pranam Priya ji. Because each saree requires 48 hours of pure gold zari handloom weaving, my base artisan cost is ₹15,800. I can guarantee 100% pure Mulberry silk with Ministry GI tags and Silk Mark certifications.',
              timestamp: new Date(Date.now() - 25 * 60 * 1000).toISOString(),
              messageType: 'text',
              isAiAssisted: true
            },
            {
              id: 'msg_01_4',
              senderRole: 'artisan',
              senderName: 'Master Ramdev',
              text: 'Counter-Offer: ₹15,800/unit (Total: ₹3,95,000) with expedited 18-day loom schedule.',
              timestamp: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
              messageType: 'counter_card',
              cardData: {
                quantity: 25,
                unitPrice: 15800,
                totalAmount: 395000,
                escrowAdvance: 118500
              },
              isAiAssisted: false
            }
          ]
        },
        {
          id: 'thread_02',
          quoteId: 'QUO-2026-104',
          buyerId: 'buyer_oberoi',
          buyerName: 'Vikramaditya Mehta',
          buyerOrg: 'The Oberoi Group Luxury Heritage',
          artisanId: 'art_ramdev_01',
          artisanName: 'Master Ramdev',
          artisanCraft: 'GI Varanasi Brocade',
          productTitle: 'Handcrafted Varanasi Silk Brocade Stoles',
          requestedQuantity: 50,
          targetPricePerUnit: 4800,
          artisanCounterPrice: null,
          status: 'pending',
          unreadCountArtisan: 1,
          unreadCountBuyer: 0,
          lastUpdated: new Date(Date.now() - 40 * 60 * 1000).toISOString(),
          messages: [
            {
              id: 'msg_02_1',
              senderRole: 'buyer',
              senderName: 'Vikramaditya Mehta (Oberoi)',
              text: 'Greetings Master Ramdev. We require 50 bespoke GI silk stoles for our executive presidential suites.',
              timestamp: new Date(Date.now() - 45 * 60 * 1000).toISOString(),
              messageType: 'text',
              isAiAssisted: false
            },
            {
              id: 'msg_02_2',
              senderRole: 'buyer',
              senderName: 'Vikramaditya Mehta (Oberoi)',
              text: 'Official Bulk RFP Offer: 50 stoles @ ₹4,800/unit. Total contract ₹2,40,000.',
              timestamp: new Date(Date.now() - 40 * 60 * 1000).toISOString(),
              messageType: 'quote_card',
              cardData: {
                quantity: 50,
                unitPrice: 4800,
                totalAmount: 240000,
                escrowAdvance: 72000
              },
              isAiAssisted: false
            }
          ]
        }
      ];
      this._saveDb(db);
    }
  }

  getAllThreads({ role, userId } = {}) {
    const db = this._getDb();
    let threads = db.chatThreads || [];

    if (role === 'artisan' && userId) {
      threads = threads.filter(t => t.artisanId === userId || t.artisanId === 'art_ramdev_01');
    } else if (role === 'buyer' && userId) {
      threads = threads.filter(t => t.buyerId === userId || !t.buyerId);
    }

    // Sort by most recently updated
    return threads.sort((a, b) => new Date(b.lastUpdated) - new Date(a.lastUpdated));
  }

  getThreadById(id) {
    const db = this._getDb();
    const threads = db.chatThreads || [];
    return threads.find(t => t.id === id) || null;
  }

  createThread(data) {
    const db = this._getDb();
    if (!Array.isArray(db.chatThreads)) {
      db.chatThreads = [];
    }

    const threadId = data.id || `thread_${Date.now()}`;
    const newThread = {
      id: threadId,
      quoteId: data.quoteId || `QUO-${Date.now().toString().slice(-6)}`,
      buyerId: data.buyerId || 'buyer_guest',
      buyerName: data.buyerName || 'Buyer',
      buyerOrg: data.buyerOrg || 'Individual Buyer',
      artisanId: data.artisanId || 'art_ramdev_01',
      artisanName: data.artisanName || 'Master Ramdev',
      artisanCraft: data.artisanCraft || 'GI Handloom',
      productTitle: data.productTitle || 'GI Artisan Craft',
      requestedQuantity: parseInt(data.requestedQuantity, 10) || 1,
      targetPricePerUnit: parseFloat(data.targetPricePerUnit) || 0,
      artisanCounterPrice: data.artisanCounterPrice || null,
      status: data.status || 'pending',
      unreadCountArtisan: 1,
      unreadCountBuyer: 0,
      lastUpdated: new Date().toISOString(),
      messages: Array.isArray(data.messages) && data.messages.length > 0 ? data.messages : [
        {
          id: `msg_${Date.now()}`,
          senderRole: 'buyer',
          senderName: data.buyerName || 'Buyer',
          text: data.initialMessage || `Inquiry initiated for ${data.requestedQuantity || 1} units @ ₹${data.targetPricePerUnit || 0}`,
          timestamp: new Date().toISOString(),
          messageType: 'quote_card',
          cardData: {
            quantity: parseInt(data.requestedQuantity, 10) || 1,
            unitPrice: parseFloat(data.targetPricePerUnit) || 0,
            totalAmount: (parseInt(data.requestedQuantity, 10) || 1) * (parseFloat(data.targetPricePerUnit) || 0),
            escrowAdvance: Math.round(((parseInt(data.requestedQuantity, 10) || 1) * (parseFloat(data.targetPricePerUnit) || 0)) * 0.3)
          },
          isAiAssisted: false
        }
      ]
    };

    db.chatThreads.unshift(newThread);
    this._saveDb(db);
    return newThread;
  }

  addMessage(threadId, messageData) {
    const db = this._getDb();
    if (!Array.isArray(db.chatThreads)) return null;

    const threadIndex = db.chatThreads.findIndex(t => t.id === threadId);
    if (threadIndex === -1) return null;

    const thread = db.chatThreads[threadIndex];
    const msgId = messageData.id || `msg_${Date.now()}_${Math.random().toString(36).slice(2, 6)}`;
    const newMsg = {
      id: msgId,
      senderRole: messageData.senderRole || 'buyer',
      senderName: messageData.senderName || (messageData.senderRole === 'artisan' ? thread.artisanName : thread.buyerName),
      text: messageData.text || '',
      timestamp: new Date().toISOString(),
      messageType: messageData.messageType || 'text',
      cardData: messageData.cardData || null,
      isAiAssisted: !!messageData.isAiAssisted
    };

    if (!Array.isArray(thread.messages)) {
      thread.messages = [];
    }
    thread.messages.push(newMsg);
    thread.lastUpdated = new Date().toISOString();

    if (newMsg.senderRole === 'artisan') {
      thread.unreadCountBuyer = (thread.unreadCountBuyer || 0) + 1;
    } else {
      thread.unreadCountArtisan = (thread.unreadCountArtisan || 0) + 1;
    }

    db.chatThreads[threadIndex] = thread;
    this._saveDb(db);
    return { thread, message: newMsg };
  }

  updateThreadStatus(threadId, status, extraData = {}) {
    const db = this._getDb();
    if (!Array.isArray(db.chatThreads)) return null;

    const threadIndex = db.chatThreads.findIndex(t => t.id === threadId);
    if (threadIndex === -1) return null;

    const thread = db.chatThreads[threadIndex];
    thread.status = status;
    thread.lastUpdated = new Date().toISOString();

    if (extraData.artisanCounterPrice !== undefined) {
      thread.artisanCounterPrice = extraData.artisanCounterPrice;
    }

    if (extraData.systemMessage) {
      if (!Array.isArray(thread.messages)) thread.messages = [];
      thread.messages.push({
        id: `sys_${Date.now()}`,
        senderRole: 'system',
        senderName: 'Karighar Escrow Rails',
        text: extraData.systemMessage,
        timestamp: new Date().toISOString(),
        messageType: extraData.messageType || 'acceptance_card',
        cardData: extraData.cardData || null,
        isAiAssisted: false
      });
    }

    db.chatThreads[threadIndex] = thread;
    this._saveDb(db);
    return thread;
  }

  markAsRead(threadId, role) {
    const db = this._getDb();
    if (!Array.isArray(db.chatThreads)) return null;

    const thread = db.chatThreads.find(t => t.id === threadId);
    if (!thread) return null;

    if (role === 'artisan') {
      thread.unreadCountArtisan = 0;
    } else {
      thread.unreadCountBuyer = 0;
    }

    this._saveDb(db);
    return thread;
  }
}

const chatRepository = new ChatRepository();
module.exports = chatRepository;
