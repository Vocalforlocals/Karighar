// ==============================================================================
// Karighar (कारीघर) — Controllers Facade
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const authController = require('./auth_controller');
const productController = require('./product_controller');
const buyerController = require('./buyer_controller');
const orderController = require('./order_controller');
const chatController = require('./chat_controller');
const aiController = require('./ai_controller');
const bhashiniController = require('./bhashini_controller');
const tenderController = require('./tender_controller');
const creditController = require('./credit_controller');
const blockchainController = require('./blockchain_controller');
const aiAssistantController = require('./ai_assistant_controller');

module.exports = {
  authController,
  productController,
  buyerController,
  orderController,
  chatController,
  aiController,
  aiAssistantController,
  bhashiniController,
  tenderController,
  creditController,
  blockchainController
};
