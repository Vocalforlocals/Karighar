// ==============================================================================
// Karighar (कारीघर) — Domain Repositories Facade
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const productRepository = require('./product_repository');
const orderRepository = require('./order_repository');
const tenderRepository = require('./tender_repository');
const creditRepository = require('./credit_repository');
const blockchainRepository = require('./blockchain_repository');
const artisanRepository = require('./artisan_repository');
const authRepository = require('./auth_repository');

module.exports = {
  productRepository,
  orderRepository,
  tenderRepository,
  creditRepository,
  blockchainRepository,
  artisanRepository,
  authRepository
};
