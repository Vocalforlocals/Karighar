// ==============================================================================
// Karighar (कारीघर) — Tender & Cooperative Pooling Domain Repository
// Manages GeM Institutional RFQs and Decentralized Loom Commitments
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { dbAdapter } = require('../database/db_adapter');

class TenderRepository {
  constructor() {
    this.adapter = dbAdapter;
  }

  _getTenders() {
    const db = this.adapter.read();
    return db.tenders || [];
  }

  _saveTenders(tenders) {
    const db = this.adapter.read();
    db.tenders = tenders;
    return this.adapter.write(db);
  }

  getAll() {
    return this._getTenders();
  }

  getById(id) {
    const list = this._getTenders();
    return list.find(t => t.id === id) || null;
  }

  create(data) {
    const list = this._getTenders();
    const qty = Number(data.quantity || data.totalQuantity) || 200;
    const budget = Number(data.budgetPerUnit || data.maxBudgetPerUnit) || 2000;

    const newTender = {
      id: data.id || `tender_gem_${Date.now()}`,
      title: data.title || 'Institutional Craft Procurement',
      issuingEntity: data.issuingMinistry || data.issuingEntity || 'Ministry of Social Justice & Empowerment',
      category: data.category || 'Handloom Textiles',
      totalQuantity: qty,
      pooledQuantity: 0,
      maxBudgetPerUnit: budget,
      totalBudgetValue: qty * budget,
      deadline: data.deadline || '2026-11-30',
      hsnCode: data.hsnCode || '5007',
      status: 'open_for_pooling',
      description: data.description || 'Official GeM procurement tender ingested into Karighar cluster network.',
      contributors: [],
      gemPortalReference: data.tenderRef || data.gemPortalReference || `GEM/2026/B/${Math.floor(100000 + Math.random() * 900000)}`,
      ingestedAt: new Date().toISOString()
    };

    list.unshift(newTender);
    this._saveTenders(list);
    return newTender;
  }

  commitCapacity(tenderId, { artisanId, artisanName, committedUnits, committedLooms, clusterName }) {
    const list = this._getTenders();
    const tender = list.find(t => t.id === tenderId);
    if (!tender) return null;

    const units = Number(committedUnits) || 50;
    tender.pooledQuantity = Math.min(tender.totalQuantity, (tender.pooledQuantity || 0) + units);
    tender.contributors = tender.contributors || [];
    tender.contributors.push({
      artisanId: artisanId || 'art_ramdev_01',
      name: artisanName || 'Ramdev Varma',
      clusterName: clusterName || 'Varanasi Guild',
      committedLooms: Number(committedLooms) || 2,
      committedUnits: units,
      committedAt: new Date().toISOString()
    });

    if (tender.pooledQuantity >= tender.totalQuantity) {
      tender.status = 'pool_completed';
    }

    this._saveTenders(list);
    return tender;
  }

  count() {
    return this._getTenders().length;
  }
}

module.exports = new TenderRepository();
