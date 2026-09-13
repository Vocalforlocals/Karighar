// ==============================================================================
// Karighar (कारीघर) — Order & Escrow Domain Repository
// Manages Smart Escrow, Delivery QR Milestones, and PFMS Settlement
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const crypto = require('crypto');
const { dbAdapter } = require('../database/db_adapter');

class OrderRepository {
  constructor() {
    this.adapter = dbAdapter;
  }

  _getOrders() {
    const db = this.adapter.read();
    return db.orders || [];
  }

  _saveOrders(orders) {
    const db = this.adapter.read();
    db.orders = orders;
    return this.adapter.write(db);
  }

  getAll() {
    return this._getOrders();
  }

  getById(id) {
    const list = this._getOrders();
    return list.find(o => o.id === id) || null;
  }

  create(data) {
    const list = this._getOrders();
    const newOrder = {
      id: data.id || `ORD-2026-${Math.floor(1000 + Math.random() * 9000)}`,
      productId: data.productId || 'prod_01',
      productTitle: data.productTitle || 'Banarasi Silk Handloom Saree',
      productImage: data.productImage || 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800',
      artisanId: data.artisanId || 'art_ramdev_01',
      artisanName: data.artisanName || 'Ramdev Varma',
      buyerName: data.buyerName || 'Buyer Client',
      quantity: Number(data.quantity) || 1,
      totalPrice: Number(data.totalPrice || data.amount) || 8500,
      amount: Number(data.amount || data.totalPrice) || 8500,
      currency: data.currency || 'INR',
      status: data.status || 'in_loom',
      escrowStatus: data.escrowStatus || 'HELD_IN_ESCROW',
      escrowTxId: data.escrowTxId || `0x${crypto.randomBytes(10).toString('hex')}`,
      orderDate: data.orderDate || new Date().toISOString(),
      deliveryAddress: data.deliveryAddress || 'Standard Delivery Address',
      pfmsRef: data.pfmsRef || null,
      polygonTx: data.polygonTx || null,
      createdAt: new Date().toISOString()
    };

    list.unshift(newOrder);
    this._saveOrders(list);
    return newOrder;
  }

  updateStatus(orderId, status) {
    const list = this._getOrders();
    const order = list.find(o => o.id === orderId);
    if (!order) return null;

    order.status = status || order.status;
    if (status === 'delivered') {
      order.escrowStatus = 'RELEASED_TO_ARTISAN';
    }
    this._saveOrders(list);
    return order;
  }

  releaseEscrow(orderId, customAmount = null) {
    const list = this._getOrders();
    const order = list.find(o => o.id === orderId);

    const amount = customAmount || (order ? (order.amount || order.totalPrice) : 8500);
    const pfmsRef = `PFMS-DBT-${Math.floor(10000000 + Math.random() * 90000000)}`;
    const polygonTx = `0x${crypto.randomBytes(16).toString('hex')}`;

    if (order) {
      order.status = 'delivered';
      order.escrowStatus = 'RELEASED_TO_ARTISAN';
      order.pfmsRef = pfmsRef;
      order.polygonTx = polygonTx;
      order.settledAt = new Date().toISOString();
      this._saveOrders(list);
    }

    return {
      success: true,
      orderId,
      amount,
      escrowStatus: 'RELEASED_TO_ARTISAN',
      pfmsTransactionId: pfmsRef,
      polygonSmartContractTx: polygonTx,
      beneficiaryAccount: 'State Bank of India (Aadhaar DBT Linked: **********8412)',
      disbursedAt: new Date().toISOString()
    };
  }

  settleViaPfmsCallback(orderId, utr, ackNo) {
    const list = this._getOrders();
    const order = list.find(o => o.id === orderId);

    if (order) {
      order.escrowStatus = 'SETTLED_TO_BENEFICIARY';
      order.utrNumber = utr;
      order.pfmsAckNo = ackNo;
      order.settledAt = new Date().toISOString();
      this._saveOrders(list);
    }

    return {
      orderId,
      escrowStatus: 'SETTLED_TO_BENEFICIARY',
      bankUtrNumber: utr,
      pfmsAckNumber: ackNo,
      beneficiaryBank: 'State Bank of India',
      settledAt: new Date().toISOString()
    };
  }

  count() {
    return this._getOrders().length;
  }
}

module.exports = new OrderRepository();
