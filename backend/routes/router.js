// ==============================================================================
// Karighar (कारीघर) — Centralized Enterprise Router & Request Dispatcher
// Fast Parameterized Route Matching, Method Routing, and Structured Errors
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const controllers = require('../controllers');
const { getOpenApiSpec } = require('../docs/api_docs');

class Router {
  constructor() {
    this.routes = [];
    this._registerRoutes();
  }

  add(method, pathPattern, handler) {
    // Convert path pattern (e.g. /api/v1/products/:id) to regex
    const paramNames = [];
    const regexPattern = pathPattern.replace(/:([a-zA-Z0-9_]+)/g, (_, paramName) => {
      paramNames.push(paramName);
      return '([^/]+)';
    });

    const regex = new RegExp(`^${regexPattern}$`);
    this.routes.push({
      method: method.toUpperCase(),
      pathPattern,
      regex,
      paramNames,
      handler
    });
  }

  get(path, handler) { this.add('GET', path, handler); }
  post(path, handler) { this.add('POST', path, handler); }
  put(path, handler) { this.add('PUT', path, handler); }
  patch(path, handler) { this.add('PATCH', path, handler); }
  delete(path, handler) { this.add('DELETE', path, handler); }

  _registerRoutes() {
    const {
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
    } = controllers;

    // OpenAPI Spec
    this.get('/api/v1/openapi.json', (req, res, ctx) => ctx.sendJson(res, 200, getOpenApiSpec()));

    // Authentication & KYC
    this.post('/api/v1/auth/register', (req, res, ctx) => authController.register(req, res, ctx));
    this.post('/api/v1/auth/login', (req, res, ctx) => authController.login(req, res, ctx));
    this.post('/api/v1/auth/send-otp', (req, res, ctx) => authController.sendOtp(req, res, ctx));
    this.post('/api/v1/auth/verify-otp', (req, res, ctx) => authController.verifyOtp(req, res, ctx));
    this.get('/api/v1/auth/me', (req, res, ctx) => authController.getMe(req, res, ctx));
    this.post('/api/v1/auth/verify-artisan', (req, res, ctx) => authController.verifyArtisan(req, res, ctx));

    // Products & Craft Provenance
    this.get('/api/v1/products', (req, res, ctx) => productController.getAll(req, res, ctx));
    this.get('/api/v1/products/:id', (req, res, ctx) => productController.getById(req, res, ctx));
    this.post('/api/v1/products', (req, res, ctx) => productController.create(req, res, ctx));

    // Buyer Commerce & Feed
    this.get('/api/v1/buyer/feed', (req, res, ctx) => buyerController.getFeed(req, res, ctx));
    this.get('/api/v1/buyer/categories', (req, res, ctx) => buyerController.getCategories(req, res, ctx));
    this.post('/api/v1/buyer/ai-curate', (req, res, ctx) => buyerController.aiCurate(req, res, ctx));
    this.post('/api/v1/buyer/semantic-search', (req, res, ctx) => buyerController.semanticSearch(req, res, ctx));
    this.post('/api/v1/buyer/reserve-stock', (req, res, ctx) => buyerController.reserveStock(req, res, ctx));
    this.post('/api/v1/buyer/payment/create-order', (req, res, ctx) => buyerController.createPaymentOrder(req, res, ctx));
    this.post('/api/v1/buyer/payment/verify-webhook', (req, res, ctx) => buyerController.verifyPaymentWebhook(req, res, ctx));
    this.get('/api/v1/buyer/track/:orderId', (req, res, ctx) => buyerController.trackOrder(req, res, ctx));

    // Orders & Escrow
    this.get('/api/v1/orders', (req, res, ctx) => orderController.getAll(req, res, ctx));
    this.get('/api/v1/orders/:id', (req, res, ctx) => orderController.getById(req, res, ctx));
    this.post('/api/v1/orders', (req, res, ctx) => orderController.create(req, res, ctx));
    this.patch('/api/v1/orders/:id/status', (req, res, ctx) => orderController.updateStatus(req, res, ctx));
    this.post('/api/v1/escrow/verify', (req, res, ctx) => aiController.verifyEscrow(req, res, ctx));

    // Real-Time Chat & Negotiation
    this.get('/api/v1/chat/threads', (req, res, ctx) => chatController.getThreads(req, res, ctx));
    this.get('/api/v1/chat/threads/:id', (req, res, ctx) => chatController.getThreadById(req, res, ctx));
    this.post('/api/v1/chat/threads', (req, res, ctx) => chatController.createThread(req, res, ctx));
    this.post('/api/v1/chat/threads/:id/messages', (req, res, ctx) => chatController.sendMessage(req, res, ctx));
    this.post('/api/v1/chat/threads/:id/counter', (req, res, ctx) => chatController.submitCounterOffer(req, res, ctx));
    this.post('/api/v1/chat/threads/:id/accept', (req, res, ctx) => chatController.acceptDeal(req, res, ctx));
    this.post('/api/v1/chat/threads/:id/read', (req, res, ctx) => chatController.markAsRead(req, res, ctx));

    // Google Gemini AI Services
    this.get('/api/v1/ai/status', (req, res, ctx) => aiController.getStatus(req, res, ctx));
    this.post('/api/v1/ai/weave-inspect', (req, res, ctx) => aiController.inspectWeave(req, res, ctx));
    this.post('/api/v1/ai/voice-catalog', (req, res, ctx) => aiController.voiceCatalog(req, res, ctx));
    this.post('/api/v1/ai/gemini-chat', (req, res, ctx) => aiController.geminiChat(req, res, ctx));
    this.post('/api/v1/negotiate/evaluate', (req, res, ctx) => aiController.evaluateNegotiation(req, res, ctx));
    this.post('/api/v1/ai/camera/process-angle', (req, res, ctx) => aiController.processCameraAngle(req, res, ctx));
    this.post('/api/v1/ai/camera/multi-angle-inspect', (req, res, ctx) => aiController.multiAngleInspect(req, res, ctx));
    this.post('/api/v1/ai/camera/upload', (req, res, ctx) => aiController.uploadCameraAsset(req, res, ctx));
    this.post('/api/v1/ai/analyze-product-photo', (req, res, ctx) => aiController.analyzeProductPhoto(req, res, ctx));
    this.post('/api/v1/ai/voice-conversation', (req, res, ctx) => aiController.voiceConversation(req, res, ctx));
    this.post('/api/v1/ai-assistant/step', (req, res, ctx) => aiAssistantController.handleStep(req, res, ctx));

    // Bhashini Language Mission
    this.get('/api/v1/bhashini/languages', (req, res, ctx) => bhashiniController.getLanguages(req, res, ctx));
    this.post('/api/v1/bhashini/asr', (req, res, ctx) => bhashiniController.asr(req, res, ctx));
    this.post('/api/v1/bhashini/translate', (req, res, ctx) => bhashiniController.translate(req, res, ctx));
    this.post('/api/v1/bhashini/tts', (req, res, ctx) => bhashiniController.tts(req, res, ctx));
    this.post('/api/v1/bhashini/voice-assistant', (req, res, ctx) => bhashiniController.voiceAssistant(req, res, ctx));

    // Tenders & Pooling
    this.get('/api/v1/tenders', (req, res, ctx) => tenderController.getAll(req, res, ctx));
    this.post('/api/v1/tenders/:id/pool', (req, res, ctx) => tenderController.poolCapacity(req, res, ctx));

    // Credit Hub & Telemetry
    this.get('/api/v1/credit/profile/:id', (req, res, ctx) => creditController.getProfile(req, res, ctx));
    this.post('/api/v1/credit/disburse', (req, res, ctx) => creditController.disburseLoan(req, res, ctx));
    this.get('/api/v1/artisan/stats', (req, res, ctx) => creditController.getArtisanStats(req, res, ctx));
    this.get('/api/v1/artisan/quotes', (req, res, ctx) => creditController.getArtisanQuotes(req, res, ctx));
    this.get('/api/v1/gis/clusters', (req, res, ctx) => creditController.getGisClusters(req, res, ctx));

    // Blockchain & Admin
    this.get('/api/v1/blockchain/blocks', (req, res, ctx) => blockchainController.getBlocks(req, res, ctx));
    this.get('/api/v1/blockchain/tx/:hash', (req, res, ctx) => blockchainController.getTransaction(req, res, ctx));
    this.get('/api/v1/admin/audit-logs', (req, res, ctx) => blockchainController.getAuditLogs(req, res, ctx));
    this.get('/api/v1/admin/db/stats', (req, res, ctx) => blockchainController.getDbStats(req, res, ctx));

    // Government Webhooks
    this.post('/api/v1/webhooks/gem', (req, res, ctx) => blockchainController.handleGemWebhook(req, res, ctx));
    this.post('/api/v1/webhooks/pfms', (req, res, ctx) => blockchainController.handlePfmsWebhook(req, res, ctx));
    this.post('/api/v1/webhooks/icegate', (req, res, ctx) => blockchainController.handleIcegateWebhook(req, res, ctx));
  }

  /**
   * Dispatch an incoming request to matching route
   * Returns true if handled, false if not an API route
   */
  async dispatch(req, res, context) {
    const { pathname, method, sendJson } = context;

    // Only handle /api/ routes
    if (!pathname.startsWith('/api/')) {
      return false;
    }

    for (const route of this.routes) {
      if (route.method !== method) continue;

      const match = pathname.match(route.regex);
      if (match) {
        const params = {};
        for (let i = 0; i < route.paramNames.length; i++) {
          params[route.paramNames[i]] = match[i + 1];
        }

        try {
          await route.handler(req, res, {
            ...context,
            params
          });
          return true;
        } catch (err) {
          console.error(`[ROUTER ERROR] ${method} ${pathname}:`, err);
          sendJson(res, 500, {
            success: false,
            error: 'Internal Server Error in Karighar API gateway',
            message: err.message,
            timestamp: new Date().toISOString()
          });
          return true;
        }
      }
    }

    // If an /api/ route is not matched, return structured 404
    sendJson(res, 404, {
      success: false,
      error: `API Route not found: ${method} ${pathname}`,
      timestamp: new Date().toISOString()
    });
    return true;
  }
}

const router = new Router();
module.exports = { router, Router };
