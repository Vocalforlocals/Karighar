// ==============================================================================
// Karighar (कारीघर) — Product Domain Repository
// Manages GI Handicrafts, SHA-256 Provenance Hashing, and Catalog Queries
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const crypto = require('crypto');
const { dbAdapter } = require('../database/db_adapter');

class ProductRepository {
  constructor() {
    this.adapter = dbAdapter;
  }

  _getProducts() {
    const db = this.adapter.read();
    return db.products || [];
  }

  _saveProducts(products) {
    const db = this.adapter.read();
    db.products = products;
    return this.adapter.write(db);
  }

  getAll({ category, search, artisanId } = {}) {
    let list = this._getProducts();

    if (category && category !== 'All' && category !== 'All Crafts') {
      const catLower = category.toLowerCase();
      list = list.filter(p => (p.category || '').toLowerCase().includes(catLower));
    }

    if (search) {
      const q = search.toLowerCase();
      list = list.filter(p =>
        (p.title || '').toLowerCase().includes(q) ||
        (p.description || '').toLowerCase().includes(q) ||
        (p.craftForm || '').toLowerCase().includes(q) ||
        (p.clusterLocation || '').toLowerCase().includes(q) ||
        (Array.isArray(p.tags) && p.tags.some(t => t.toLowerCase().includes(q)))
      );
    }

    if (artisanId) {
      list = list.filter(p => p.artisanId === artisanId);
    }

    return list;
  }

  getById(id) {
    const list = this._getProducts();
    return list.find(p => p.id === id) || null;
  }

  create(data) {
    const list = this._getProducts();

    const id = data.id || `prod_${Date.now()}`;
    const title = data.title || 'Handcrafted Cultural Masterpiece';
    const artisanId = data.artisanId || 'art_ramdev_01';
    const artisanName = data.artisanName || 'Master Ramdev';
    const price = Number(data.price) || 8500;

    // Mint cryptographic SHA-256 GI Provenance Hash
    const rawPayload = `${id}:${artisanId}:${title}:${price}:${data.craftForm || ''}:${Date.now()}`;
    const sha256Hash = data.sha256Hash || crypto.createHash('sha256').update(rawPayload).digest('hex');

    const newProduct = {
      id,
      artisanId,
      artisanName,
      title,
      category: data.category || 'Textiles & Weaves',
      craftForm: data.craftForm || 'Handloom Brocade',
      description: data.description || 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.',
      images: Array.isArray(data.images) && data.images.length > 0 ? data.images : [
        'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800'
      ],
      rawImage: data.rawImage || 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800',
      price,
      estimatedHours: Number(data.estimatedHours) || 48,
      isGICertified: data.isGICertified !== false,
      giTagNumber: data.giTagNumber || `GI-IN-${Math.floor(1000 + Math.random() * 9000)}`,
      clusterLocation: data.clusterLocation || 'Varanasi, Uttar Pradesh',
      geoCoordinates: data.geoCoordinates || '25.3176° N, 82.9739° E',
      stockQuantity: Number(data.stockQuantity) || 1,
      status: 'active',
      tags: Array.isArray(data.tags) ? data.tags : ['GI Certified', 'Handmade'],
      materialsUsed: Array.isArray(data.materialsUsed) ? data.materialsUsed : ['Natural Raw Materials'],
      aiEnhancementsApplied: ['4K Neural Studio Filter'],
      weaveQuality: data.weaveQuality || { epi: 120, ppi: 110, grade: 'Grade A+ GI Handloom' },
      sha256Hash,
      createdAt: new Date().toISOString()
    };

    list.unshift(newProduct);
    this._saveProducts(list);

    return newProduct;
  }

  updateStock(id, quantityDelta) {
    const list = this._getProducts();
    const product = list.find(p => p.id === id);
    if (!product) return null;

    product.stockQuantity = Math.max(0, (product.stockQuantity || 1) + quantityDelta);
    this._saveProducts(list);
    return product;
  }

  count() {
    return this._getProducts().length;
  }
}

module.exports = new ProductRepository();
