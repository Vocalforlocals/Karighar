// ==============================================================================
// Karighar (कारीघर) — Product Domain Controller
// Manages GI Handicrafts, SHA-256 Provenance Hashing & Catalog Operations
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { productRepository } = require('../repositories');
const validator = require('../middleware/validator');

class ProductController {
  async getAll(req, res, { parsedUrl, sendJson }) {
    try {
      const category = parsedUrl.searchParams.get('category');
      const search = parsedUrl.searchParams.get('q');
      const artisanId = parsedUrl.searchParams.get('artisanId');
      const products = productRepository.getAll({ category, search, artisanId });
      return sendJson(res, 200, { success: true, count: products.length, products });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async getById(req, res, { params, sendJson }) {
    try {
      const product = productRepository.getById(params.id);
      if (!product) {
        return sendJson(res, 404, { success: false, error: 'Product not found' });
      }
      return sendJson(res, 200, { success: true, product });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async create(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const validated = validator.validateProductCreate(body);
      const newProduct = productRepository.create({
        ...body,
        ...validated
      });

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('PRODUCT_CREATED', newProduct);
      }
      return sendJson(res, 201, { success: true, product: newProduct });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const productController = new ProductController();
module.exports = productController;
