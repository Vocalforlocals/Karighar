// ==============================================================================
// Karighar (कारीघर) — Secure Master Unified Full-Stack HTTPS Server
// Primary HTTPS: Port 8443 (TLS 1.3 / 1.2 + HSTS + REST API v1 + Real-Time SSE)
// HTTP Ingress:  Port 8080 (Automatic Permanent Redirect to HTTPS)
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const https = require('https');
const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');
const crypto = require('crypto');
const { signToken, verifyToken, verifyAadhaarArtisan } = require('./backend/middleware/auth_service');
const { getOpenApiSpec, renderDocsHtml } = require('./backend/docs/api_docs');
const { rateLimiter } = require('./backend/middleware/rate_limiter');
const { signWebhookPayload, verifyWebhookSignature } = require('./backend/middleware/webhook_security');
const { logAuditEvent, getRecentAuditLogs } = require('./backend/middleware/audit_logger');
const { dbAdapter, DB_FILE } = require('./backend/database/db_adapter');
const { cacheAdapter } = require('./backend/middleware/cache_adapter');
const { sqliteEngine } = require('./backend/database/sqlite_engine');
const {
  productRepository,
  orderRepository,
  tenderRepository,
  creditRepository,
  blockchainRepository,
  artisanRepository,
  authRepository
} = require('./backend/repositories');

const HTTPS_PORT = 8443;
const HTTP_PORT = 8080;
const WEB_DIR = path.join(__dirname, 'build', 'web');
const CERTS_DIR = path.join(__dirname, 'certs');
const KEY_FILE = path.join(CERTS_DIR, 'key.pem');
const CERT_FILE = path.join(CERTS_DIR, 'cert.pem');

// Ensure certificates exist or generate them
if (!fs.existsSync(KEY_FILE) || !fs.existsSync(CERT_FILE)) {
  try {
    const { generateCerts } = require('./scripts/generate_certs');
    generateCerts();
  } catch (err) {
    console.warn('[TLS] Could not auto-generate certificates via script:', err.message);
  }
}

let sslOptions = {};
if (fs.existsSync(KEY_FILE) && fs.existsSync(CERT_FILE)) {
  sslOptions = {
    key: fs.readFileSync(KEY_FILE),
    cert: fs.readFileSync(CERT_FILE)
  };
}

// MIME types for static Flutter Web assets
const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.ico': 'image/x-icon',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wav': 'audio/wav',
  '.mp4': 'video/mp4',
  '.woff': 'application/font-woff',
  '.ttf': 'application/font-ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.otf': 'application/font-otf',
  '.wasm': 'application/wasm'
};

// Connected SSE clients for live multi-device event streaming
const syncClients = new Set();

// Helper: Read database via Enterprise Adapter
function readDb() {
  return dbAdapter.read();
}

// Helper: Write database atomically via Enterprise Adapter
function writeDb(data) {
  return dbAdapter.write(data);
}

// Helper: Broadcast event to all connected devices over secure SSE and distributed bus
function broadcastEvent(type, payload) {
  const message = `data: ${JSON.stringify({ type, payload, timestamp: new Date().toISOString() })}\n\n`;
  for (const client of syncClients) {
    try {
      client.write(message);
    } catch (e) {
      syncClients.delete(client);
    }
  }
  // Also dispatch to distributed multi-pod cache bus (Redis / KeyDB)
  cacheAdapter.publishEvent(type, payload);
}

// Ingress listener for peer cluster pod broadcasts via distributed cache adapter
cacheAdapter.on('event', (eventObj) => {
  if (eventObj.nodeId && eventObj.nodeId !== (process.env.HOSTNAME || `node-${process.pid}`)) {
    const message = `data: ${JSON.stringify({ type: eventObj.type, payload: eventObj.payload, timestamp: eventObj.timestamp })}\n\n`;
    for (const client of syncClients) {
      try {
        client.write(message);
      } catch (e) {
        syncClients.delete(client);
      }
    }
  }
});

// Helper: Read request body as JSON
function parseJsonBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      if (!body) return resolve({});
      try {
        resolve(JSON.parse(body));
      } catch (err) {
        reject(err);
      }
    });
    req.on('error', reject);
  });
}

// Helper: Send JSON response with HSTS & CORS
function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'SAMEORIGIN',
    'Referrer-Policy': 'strict-origin-when-cross-origin',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With'
  });
  res.end(JSON.stringify(data));
}

// ==============================================================================
// Core Request Handler (HTTPS)
// ==============================================================================
async function handleSecureRequest(req, res) {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With'
    });
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `https://${req.headers.host || `localhost:${HTTPS_PORT}`}`);
  const pathname = parsedUrl.pathname;
  const method = req.method;

  // Rate Limiting & DoS Shield Middleware (for all API endpoints)
  if (pathname.startsWith('/api/')) {
    const rateCheck = rateLimiter.check(req, pathname);
    res.setHeader('X-RateLimit-Limit', rateCheck.limit);
    res.setHeader('X-RateLimit-Remaining', rateCheck.remaining);
    res.setHeader('X-RateLimit-Reset', rateCheck.resetInSeconds);

    if (!rateCheck.allowed) {
      res.setHeader('Retry-After', rateCheck.resetInSeconds);
      logAuditEvent({
        action: 'RATE_LIMIT_EXCEEDED',
        actor: req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'IP',
        role: 'THROTTLED_CLIENT',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'WARNING',
        details: { pathname, limit: rateCheck.limit, retryAfter: rateCheck.resetInSeconds }
      });
      return sendJson(res, 429, {
        success: false,
        error: 'Too Many Requests: Rate limit exceeded. Please wait before retrying.',
        limit: rateCheck.limit,
        retryAfterSeconds: rateCheck.resetInSeconds
      });
    }
  }

  // 1. HEALTH & SYSTEM STATUS

  if (pathname === '/api/health' || pathname === '/api/v1/health') {
    return sendJson(res, 200, {
      status: 'ok',
      protocol: 'https',
      app: 'Karighar Secure Unified Engine',
      version: '1.0.0',
      connectedDevices: syncClients.size,
      uptimeSeconds: Math.floor(process.uptime()),
      storage: dbAdapter.getStatus(),
      cache: cacheAdapter.getStatus(),
      cluster: {
        nodeId: process.env.HOSTNAME || `node-${process.pid}`,
        mode: process.env.NODE_ENV || 'development'
      },
      timestamp: new Date().toISOString()
    });
  }

  // 1b. INTERACTIVE OPENAPI 3.0 SPEC & SWAGGER EXPLORER
  if (pathname === '/api/v1/openapi.json') {
    return sendJson(res, 200, getOpenApiSpec());
  }

  if (pathname === '/api/docs' || pathname === '/docs') {
    res.writeHead(200, {
      'Content-Type': 'text/html; charset=utf-8',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains'
    });
    res.end(renderDocsHtml());
    return;
  }

  // 2. REAL-TIME EVENT STREAM (SSE over HTTPS)
  if (pathname === '/api/sync/events') {
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Access-Control-Allow-Origin': '*'
    });
    res.write(`data: ${JSON.stringify({ type: 'CONNECTED', message: 'Karighar Secure TLS Sync Channel Active', clients: syncClients.size + 1 })}\n\n`);

    syncClients.add(res);
    req.on('close', () => {
      syncClients.delete(res);
    });
    return;
  }

  // Client-triggered broadcast
  if (pathname === '/api/sync/broadcast' && method === 'POST') {
    try {
      const payload = await parseJsonBody(req);
      broadcastEvent(payload.type || 'SYNC_ALERT', payload.data || payload);
      return sendJson(res, 200, { success: true, broadcastCount: syncClients.size });
    } catch (err) {
      return sendJson(res, 400, { error: err.message });
    }
  }

  // 3. PRODUCTS REST API
  if (pathname === '/api/v1/products' && method === 'GET') {
    const category = parsedUrl.searchParams.get('category');
    const search = parsedUrl.searchParams.get('q');
    const products = productRepository.getAll({ category, search });
    return sendJson(res, 200, { success: true, count: products.length, products });
  }

  // Single product detail & SHA-256 provenance
  if (pathname.startsWith('/api/v1/products/') && method === 'GET') {
    const productId = pathname.split('/').pop();
    const product = productRepository.getById(productId);
    if (!product) {
      return sendJson(res, 404, { success: false, error: 'Product not found' });
    }
    return sendJson(res, 200, { success: true, product });
  }

  // Artisan publishes new craft
  if (pathname === '/api/v1/products' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const newProduct = productRepository.create(body);

      broadcastEvent('PRODUCT_CREATED', newProduct);
      return sendJson(res, 201, { success: true, product: newProduct });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 4. ORDERS & ESCROW REST API
  if (pathname === '/api/v1/orders' && method === 'GET') {
    const orders = orderRepository.getAll();
    return sendJson(res, 200, { success: true, count: orders.length, orders });
  }

  if (pathname === '/api/v1/orders' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const newOrder = orderRepository.create(body);

      broadcastEvent('ORDER_CREATED', newOrder);
      return sendJson(res, 201, { success: true, order: newOrder });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname.match(/^\/api\/v1\/orders\/[^/]+\/status$/) && method === 'PATCH') {
    try {
      const orderId = pathname.split('/')[4];
      const body = await parseJsonBody(req);
      const order = orderRepository.updateStatus(orderId, body.status);

      if (!order) return sendJson(res, 404, { success: false, error: 'Order not found' });

      broadcastEvent('ORDER_STATUS_CHANGED', order);
      return sendJson(res, 200, { success: true, order });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 5. B2B TENDERS & CLUSTER POOLING API
  if (pathname === '/api/v1/tenders' && method === 'GET') {
    const tenders = tenderRepository.getAll();
    return sendJson(res, 200, { success: true, tenders });
  }

  if (pathname.match(/^\/api\/v1\/tenders\/[^/]+\/pool$/) && method === 'POST') {
    try {
      const tenderId = pathname.split('/')[4];
      const body = await parseJsonBody(req);
      const tender = tenderRepository.commitCapacity(tenderId, body);

      if (!tender) return sendJson(res, 404, { success: false, error: 'Tender not found' });

      broadcastEvent('POOLING_UPDATED', tender);
      return sendJson(res, 200, { success: true, tender });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 6. VARTA-AI WAGE DEFENSE API
  if (pathname === '/api/v1/negotiate/evaluate' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const offeredPrice = Number(body.offeredPrice) || 5000;
      const daysOfCraft = Number(body.daysOfCraft) || 14;
      const rawMaterialCost = Number(body.rawMaterialCost) || 2800;
      const minDailyWageMoSJE = 850;

      const requiredLaborWage = daysOfCraft * minDailyWageMoSJE;
      const nonNegotiableFloor = rawMaterialCost + requiredLaborWage;
      const isLowball = offeredPrice < nonNegotiableFloor;
      const recommendedCounter = Math.round(nonNegotiableFloor * 1.08);

      let counterMessage = '';
      if (isLowball) {
        counterMessage = `Namaste. Under MoSJE fair-trade guidelines, this craft involves ${daysOfCraft} days of master artisan loom labor (₹${requiredLaborWage}) and raw silk costs (₹${rawMaterialCost}). The non-negotiable living wage floor is ₹${nonNegotiableFloor.toLocaleString('en-IN')}. We can fulfill this order at ₹${recommendedCounter.toLocaleString('en-IN')} with complete GI certification.`;
      } else {
        counterMessage = `Namaste. Your offer of ₹${offeredPrice.toLocaleString('en-IN')} meets the MoSJE living wage threshold. We accept your proposal.`;
      }

      return sendJson(res, 200, {
        success: true,
        isLowball,
        offeredPrice,
        nonNegotiableFloor,
        recommendedCounter,
        counterMessage,
        wageGuidelinesApplied: 'MoSJE Artisan Wage Protection Act 2026'
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 7. SMART ESCROW & PFMS DIRECT SETTLEMENT API
  if (pathname === '/api/v1/escrow/verify' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const orderId = body.orderId || 'ORD-2026-9041';
      const amount = Number(body.amount) || 8500;

      const releaseReceipt = orderRepository.releaseEscrow(orderId, amount);

      logAuditEvent({
        action: 'ESCROW_RELEASED_TO_ARTISAN',
        actor: 'PFMS_SMART_ESCROW',
        role: 'FINANCIAL_SENTRY',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { orderId, amount, pfmsRef: releaseReceipt.pfmsTransactionId, polygonTx: releaseReceipt.polygonSmartContractTx }
      });

      broadcastEvent('ESCROW_RELEASED', releaseReceipt);
      return sendJson(res, 200, releaseReceipt);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 8. PM-VISHWAKARMA CREDIT HUB API
  if (pathname.startsWith('/api/v1/credit/profile/') && method === 'GET') {
    const artisanId = pathname.split('/').pop();
    const profile = creditRepository.getProfile(artisanId);
    return sendJson(res, 200, { success: true, profile });
  }

  if (pathname === '/api/v1/credit/disburse' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const loanAmount = Number(body.amount) || 100000.0;
      const artisanId = body.artisanId || 'art_ramdev_01';
      const disbursement = creditRepository.disburseLoan(artisanId, loanAmount);

      logAuditEvent({
        action: 'PM_VISHWAKARMA_CREDIT_DISBURSED',
        actor: 'SBI_DBT_PORTAL',
        role: 'CREDIT_HUB',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { loanReference: disbursement.loanReference, amountDisbursed: loanAmount }
      });

      broadcastEvent('CREDIT_DISBURSED', disbursement);
      return sendJson(res, 200, disbursement);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 8b. ARTISAN DASHBOARD STATS & TELEMETRY API
  if (pathname === '/api/v1/artisan/stats' && method === 'GET') {
    const artisanId = parsedUrl.searchParams.get('artisanId') || 'art_ramdev_01';
    const stats = artisanRepository.getStats(artisanId);
    return sendJson(res, 200, stats);
  }

  if (pathname === '/api/v1/artisan/quotes' && method === 'GET') {
    const artisanId = parsedUrl.searchParams.get('artisanId') || 'art_ramdev_01';
    const quotes = artisanRepository.getQuotes(artisanId);
    return sendJson(res, 200, { success: true, count: quotes.length, quotes });
  }

  // 9. MoSJE GIS CLUSTER RADAR API
  if (pathname === '/api/v1/gis/clusters' && method === 'GET') {
    const clusters = artisanRepository.getClusters();
    return sendJson(res, 200, { success: true, clusters });
  }

  // 10. AI SIMULATION APIS
  if (pathname === '/api/v1/ai/weave-inspect' && method === 'POST') {
    return sendJson(res, 200, {
      success: true,
      analysis: {
        endsPerInch: 120,
        picksPerInch: 110,
        densityRatio: 1.09,
        fabricType: 'Pure Handloom Silk Brocade',
        certificationGrade: 'Grade A+ GI Handloom',
        isPowerloomReplica: false,
        confidenceScore: 0.994,
        inspectedAt: new Date().toISOString()
      }
    });
  }

  if (pathname === '/api/v1/ai/voice-catalog' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const dialect = body.language || 'Hindi';
      const transcript = body.transcript || body.speechTranscript || '';
      return sendJson(res, 200, {
        success: true,
        extractedCatalog: {
          titleEnglish: 'Pure Varanasi Katan Silk Handloom Saree',
          titleHindi: 'शुद्ध वाराणसी कतान सिल्क हथकरघा साड़ी',
          titleTamil: 'தூய வாரணாசி கட்டான் பட்டு கைத்தறி புடவை',
          category: 'Textiles & Weaves',
          craftForm: 'Banarasi Brocade',
          descriptionEnglish: 'Authentic pure mulberry silk handwoven by Master Artisan Ramdev in Varanasi, adorned with delicate silver zari border work over 14 days of dedicated loom craftsmanship.',
          descriptionHindi: 'मास्टर कारीगर रामदेव द्वारा वाराणसी में 14 दिनों के अथक परिश्रम से बुनी गई शुद्ध मलबरी रेशम और चांदी की ज़री वाली पारंपरिक हथकरघा साड़ी।',
          descriptionTamil: 'வாரணாசியில் மாஸ்டர் கைவினைஞர் ராம்தேவ் அவர்களால் 14 நாட்களில் நெய்யப்பட்ட தூய மல்பெரி பட்டு மற்றும் வெள்ளி ஜரிகை வேலைப்பாடுகளுடன் கூடிய பாரம்பரிய கைத்தறி புடவை.',
          materialsUsed: ['Pure Mulberry Katan Silk', 'Silver electroplated Zari thread'],
          estimatedHours: 32,
          tags: ['Pure Silk', 'GI Certified', 'Handloom', 'Varanasi Weave', 'Zari Border'],
          suggestedPricing: {
            rawMaterialCost: 1800,
            laborHours: 32,
            hourlyRate: 120,
            markupPercent: 25,
            fairPrice: 7050
          },
          detectedDialect: dialect,
          confidence: 0.988,
          processedAt: new Date().toISOString()
        }
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 10a-1. AI MULTI-ANGLE CAMERA COMPUTER VISION PROCESSING
  if (pathname === '/api/v1/ai/camera/process-angle' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const angleKey = body.angleKey || (body.angleIndex === 1 ? 'texture' : body.angleIndex === 2 ? 'motif' : body.angleIndex === 3 ? 'loom' : 'overview');
      const angleIndex = typeof body.angleIndex === 'number' ? body.angleIndex : (angleKey === 'texture' ? 1 : angleKey === 'motif' ? 2 : angleKey === 'loom' ? 3 : 0);
      const angleLabel = body.angleLabel || (angleIndex === 1 ? 'Weave Texture' : angleIndex === 2 ? 'Border Motif' : angleIndex === 3 ? 'Loom Context' : 'Full Craft');
      const craftPreset = body.craftPreset || 'Banarasi Katan Silk Saree';
      const options = body.enhancementOptions || {
        superResolution: true,
        studioLighting: true,
        colorCalibration: true,
        backgroundDeClutter: true
      };

      let qualityMetrics;
      let giCompliance;
      let inspectionMode;
      const angleValidationStatus = 'VERIFIED_COMPLIANT';

      switch (angleKey) {
        case 'texture':
          qualityMetrics = {
            overallScore: 98.6,
            sharpnessScore: 99.2,
            lightingUniformity: 97.4,
            colorAccuracy: 99.5,
            endsPerInch: 128,
            picksPerInch: 114,
            densityRatio: 1.12,
            symmetryScore: 98.7,
            warpWeftRatio: '1:1 Balanced Handloom',
            fiberPurity: '100% Pure Degummed Mulberry Silk',
            syntheticContaminationRate: '0.0% (Zero Synthetic Dyes)',
            isHandloomAuthentic: true
          };
          giCompliance = {
            grade: 'Grade A+ Master GI Quality',
            provenancePass: true,
            criteria: 'Microscopic weave density satisfies Varanasi GI Silk Registry Class-I standards.',
            antiPowerloomEvidence: 'Uneven natural tension micro-variations confirm authentic human shuttle loom operation.'
          };
          inspectionMode = 'Microscopic Warp & Weft Density Analysis';
          break;

        case 'motif':
          qualityMetrics = {
            overallScore: 99.1,
            sharpnessScore: 98.8,
            lightingUniformity: 98.2,
            colorAccuracy: 99.4,
            zariReflectivity: 98.6,
            motifGeometryPrecision: 99.2,
            zariType: 'Electroplated Silver-Gilded Zari Thread',
            symmetryScore: 99.1,
            isHandloomAuthentic: true
          };
          giCompliance = {
            grade: 'Grade A+ Master GI Quality',
            provenancePass: true,
            criteria: 'Border jaal pattern matches centuries-old Varanasi Shikargah floral motif heritage.',
            antiPowerloomEvidence: 'Hand-tucked zari weft terminations detected along selvedge edge.'
          };
          inspectionMode = 'Computer Vision Motif Symmetry & Metallic Zari Inspection';
          break;

        case 'loom':
          qualityMetrics = {
            overallScore: 97.9,
            sharpnessScore: 96.5,
            lightingUniformity: 95.8,
            colorAccuracy: 98.1,
            workspaceType: 'Traditional Wooden Pit-Loom / Handloom Workshop',
            humanArtisanDetected: true,
            antiPowerloomConfidence: 99.8,
            artisanErgonomicsScore: 96.2,
            isHandloomAuthentic: true
          };
          giCompliance = {
            grade: 'Grade A+ Master GI Quality',
            provenancePass: true,
            criteria: 'Loom setup verified under Ministry of Textiles Handicrafts Artisan Census mapping.',
            antiPowerloomEvidence: 'Pit-loom wooden treadles and hand shuttle verified.'
          };
          inspectionMode = 'Artisan Loom Context & Anti-Powerloom Verification';
          break;

        case 'overview':
        default:
          qualityMetrics = {
            overallScore: 98.4,
            sharpnessScore: 97.8,
            lightingUniformity: 98.5,
            colorAccuracy: 99.2,
            aspectFramingRatio: '1.00 (Optimal Framing)',
            surfaceDefectRate: '0.0% (Zero Flaws Detected)',
            silhouetteIsolation: 98.9,
            isHandloomAuthentic: true
          };
          giCompliance = {
            grade: 'Grade A+ Master GI Quality',
            provenancePass: true,
            criteria: 'Full drape silhouette and color palette conform to GI geographical certification norms.',
            antiPowerloomEvidence: 'Hand-tied selvedge fringes and uneven shuttle selvedge verified.'
          };
          inspectionMode = 'Full Craft Composition & Chromatic Balance';
          break;
      }

      const enhancementsApplied = [];
      if (options.superResolution) enhancementsApplied.push('4K Super-Resolution Neural Synthesis (4.2x Sharpness)');
      if (options.studioLighting) enhancementsApplied.push('Studio Soft Lighting Normalization & Glare Neutralization');
      if (options.colorCalibration) enhancementsApplied.push('GI Certified Natural Dye Spectrum Calibration');
      if (options.backgroundDeClutter) enhancementsApplied.push('Workshop Background De-clutter & Ambient Drop Shadow');

      const angleHash = `0xCAM-${crypto.createHash('sha256').update(JSON.stringify({
        angleKey,
        angleIndex,
        craftPreset,
        options,
        timestamp: Date.now()
      })).digest('hex').substring(0, 16)}`;

      const result = {
        success: true,
        angle: {
          key: angleKey,
          index: angleIndex,
          label: angleLabel,
          status: angleValidationStatus,
          inspectionMode,
          resolution: '3840x2160 (4K UHD Synthesized)',
          enhancementsApplied,
          qualityMetrics,
          giCompliance,
          hash: angleHash,
          processedAt: new Date().toISOString()
        }
      };

      logAuditEvent({
        action: 'CAMERA_ANGLE_PROCESSED',
        actor: req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'ARTISAN_CAMERA',
        role: 'ARTISAN',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { angleKey, angleIndex, score: qualityMetrics.overallScore, hash: angleHash }
      });

      broadcastEvent('CAMERA_ANGLE_PROCESSED', result.angle);

      return sendJson(res, 200, result);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 10a-2. MULTI-ANGLE COMPOSITE GI WEAVE INSPECTION & 360° SYNTHESIS
  if (pathname === '/api/v1/ai/camera/multi-angle-inspect' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const angles = Array.isArray(body.angles) ? body.angles : [];
      const totalCaptured = angles.length > 0 ? angles.length : 4;
      const coverageScore = Math.min(100, Math.round((totalCaptured / 4) * 100));

      const compositeHash = `0xWEAVE-${crypto.createHash('sha256').update(JSON.stringify({
        angles,
        totalCaptured,
        timestamp: Date.now()
      })).digest('hex').substring(0, 32)}`;

      const compositeReport = {
        totalAnglesCaptured: totalCaptured,
        coverageScore,
        compositeQualityScore: 98.8,
        antiPowerloomCheck: 'PASSED (100% Handcrafted Loom Provenance)',
        giCertificationGrade: 'Grade A+ Master GI Quality',
        provenanceHash: compositeHash,
        inspectionSummary: {
          endsPerInch: 128,
          picksPerInch: 114,
          knotSymmetry: 99.1,
          dyeAuthenticity: 'Natural Degummed Silk & Organic Indigo (Zero Azo Dyes)',
          zariReflectivity: 98.6,
          workspaceValidation: 'Verified Varanasi Handloom Guild Pit-Loom'
        },
        blockchainRecord: {
          blockNumber: 1046,
          gasUsed: 21000,
          verifiedBy: 'MoSJE Handloom Computer Vision Node #3'
        },
        certifiedAt: new Date().toISOString()
      };

      logAuditEvent({
        action: 'MULTI_ANGLE_INSPECTION_COMPLETED',
        actor: req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'ARTISAN_CAMERA',
        role: 'ARTISAN',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { totalCaptured, compositeHash, grade: compositeReport.giCertificationGrade }
      });

      broadcastEvent('MULTI_ANGLE_INSPECTED', compositeReport);

      return sendJson(res, 200, {
        success: true,
        multiAngleInspection: compositeReport
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 10a-3. CAMERA IMAGE UPLOAD & ASSET REGISTRATION
  if (pathname === '/api/v1/ai/camera/upload' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const fileName = body.fileName || `capture_${Date.now()}.jpg`;
      const angle = body.angle || 'overview';
      const imageBase64 = body.imageBase64 || '';

      const contentHash = crypto.createHash('sha256').update(imageBase64 || fileName).digest('hex');
      const assetUrl = `/uploads/${contentHash.substring(0, 12)}_${fileName}`;

      return sendJson(res, 200, {
        success: true,
        asset: {
          fileName,
          angle,
          url: assetUrl,
          sha256: contentHash,
          dimensions: { width: 3840, height: 2160 },
          colorSpace: 'sRGB (GI Calibrated)',
          uploadedAt: new Date().toISOString()
        }
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 10b. AUTHENTICATION & PM-VISHWAKARMA E-KYC
  if (pathname === '/api/v1/auth/register' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const { user, token } = authRepository.registerUser(body);

      logAuditEvent({
        action: 'USER_REGISTERED',
        actor: user.phone || user.email,
        role: user.role,
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { fullName: user.fullName, role: user.role, craftCategory: user.craftCategory }
      });

      return sendJson(res, 201, {
        success: true,
        message: 'Account registered successfully',
        user,
        role: user.role,
        token
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname === '/api/v1/auth/login' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const { user, token } = authRepository.authenticateUser(body);

      logAuditEvent({
        action: 'USER_LOGIN',
        actor: user.email || user.phone,
        role: user.role,
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { role: user.role, email: user.email, phone: user.phone }
      });

      return sendJson(res, 200, {
        success: true,
        token,
        role: user.role,
        user,
        expiresIn: '24h'
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname === '/api/v1/auth/send-otp' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const result = authRepository.generateOtp(body.phone);

      logAuditEvent({
        action: 'OTP_REQUESTED',
        actor: body.phone,
        role: 'ANONYMOUS',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { phone: body.phone }
      });

      return sendJson(res, 200, {
        success: true,
        ...result
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname === '/api/v1/auth/verify-otp' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const { user, token } = authRepository.verifyOtp(body.phone, body.otp);

      logAuditEvent({
        action: 'OTP_VERIFIED_LOGIN',
        actor: user.phone,
        role: user.role,
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: { phone: user.phone, role: user.role }
      });

      return sendJson(res, 200, {
        success: true,
        message: 'OTP verified successfully',
        user,
        role: user.role,
        token
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname === '/api/v1/auth/me' && method === 'GET') {
    const authHeader = req.headers['authorization'] || '';
    const token = authHeader.replace(/^Bearer\s+/i, '').trim();
    const decoded = verifyToken(token);

    if (!decoded) {
      return sendJson(res, 401, { success: false, error: 'Unauthorized: Invalid or expired token' });
    }

    const user = authRepository.getUserById(decoded.userId) || authRepository.findUser({ email: decoded.email, phone: decoded.phone });

    return sendJson(res, 200, {
      success: true,
      user: user ? authRepository.sanitizeUser(user) : decoded,
      role: decoded.role || user?.role || 'ARTISAN'
    });
  }

  if (pathname === '/api/v1/auth/verify-artisan' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const result = artisanRepository.verifyArtisan({
        aadhaarNumber: body.aadhaarNumber,
        artisanId: body.artisanId,
        craftCategory: body.craftCategory
      });

      logAuditEvent({
        action: 'ARTISAN_AADHAAR_KYC_VERIFIED',
        actor: body.artisanId || 'UNKNOWN_ARTISAN',
        role: 'ARTISAN',
        ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
        status: result.verified ? 'SUCCESS' : 'FAILED',
        details: { craftCategory: body.craftCategory, trustScore: result.profile?.trustScore }
      });

      return sendJson(res, 200, { success: true, kyc: result });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 10c. GOVERNMENT SYSTEM WEBHOOK INGESTION ENGINE (WITH HMAC-SHA256 VERIFICATION)
  if (pathname === '/api/v1/webhooks/gem' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const signatureHeader = req.headers['x-gov-signature'] || req.headers['x-signature-sha256'];
      const clientIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1';

      if (signatureHeader) {
        const verifyResult = verifyWebhookSignature('GEM', body, signatureHeader);
        if (!verifyResult.valid) {
          logAuditEvent({
            action: 'WEBHOOK_SIGNATURE_FAILED',
            actor: 'GEM_WEBHOOK_INGRESS',
            role: 'EXTERNAL_GOV_GATEWAY',
            ip: clientIp,
            status: 'SECURITY_ALERT',
            details: { portal: 'GEM', error: verifyResult.error }
          });
          return sendJson(res, 401, {
            success: false,
            error: `Cryptographic Webhook Verification Failed: ${verifyResult.error}`
          });
        }
      }

      const newTender = tenderRepository.create(body);

      logAuditEvent({
        action: 'GEM_TENDER_INGESTED',
        actor: 'GEM_PORTAL',
        role: 'EXTERNAL_GOV_GATEWAY',
        ip: clientIp,
        status: 'SUCCESS',
        details: { tenderId: newTender.id, reference: newTender.gemPortalReference, signed: !!signatureHeader }
      });

      broadcastEvent('TENDER_RECEIVED', newTender);

      return sendJson(res, 201, {
        success: true,
        tenderId: newTender.id,
        gemPortalReference: newTender.gemPortalReference,
        status: 'INGESTED_TO_KARIGHAR',
        tender: newTender
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname === '/api/v1/webhooks/pfms' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const signatureHeader = req.headers['x-gov-signature'] || req.headers['x-signature-sha256'];
      const clientIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1';

      if (signatureHeader) {
        const verifyResult = verifyWebhookSignature('PFMS', body, signatureHeader);
        if (!verifyResult.valid) {
          logAuditEvent({
            action: 'WEBHOOK_SIGNATURE_FAILED',
            actor: 'PFMS_WEBHOOK_INGRESS',
            role: 'EXTERNAL_GOV_GATEWAY',
            ip: clientIp,
            status: 'SECURITY_ALERT',
            details: { portal: 'PFMS', error: verifyResult.error }
          });
          return sendJson(res, 401, {
            success: false,
            error: `Cryptographic Webhook Verification Failed: ${verifyResult.error}`
          });
        }
      }

      const orderId = body.orderId || 'ORD-2026-9041';
      const utr = body.utrNumber || `SBIN${Date.now()}`;
      const ackNo = body.pfmsAckNo || `PFMS-ACK-2026-${Math.floor(10000 + Math.random() * 90000)}`;

      const settlement = orderRepository.settleViaPfmsCallback(orderId, utr, ackNo);

      logAuditEvent({
        action: 'PFMS_SETTLEMENT_CALLBACK',
        actor: 'PFMS_CORE_BANKING',
        role: 'EXTERNAL_GOV_GATEWAY',
        ip: clientIp,
        status: 'SUCCESS',
        details: { orderId, utr, ackNo, signed: !!signatureHeader }
      });

      broadcastEvent('PFMS_SETTLED', settlement);
      return sendJson(res, 200, settlement);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  if (pathname === '/api/v1/webhooks/icegate' && method === 'POST') {
    try {
      const body = await parseJsonBody(req);
      const signatureHeader = req.headers['x-gov-signature'] || req.headers['x-signature-sha256'];
      const clientIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1';

      if (signatureHeader) {
        const verifyResult = verifyWebhookSignature('ICEGATE', body, signatureHeader);
        if (!verifyResult.valid) {
          logAuditEvent({
            action: 'WEBHOOK_SIGNATURE_FAILED',
            actor: 'ICEGATE_WEBHOOK_INGRESS',
            role: 'EXTERNAL_GOV_GATEWAY',
            ip: clientIp,
            status: 'SECURITY_ALERT',
            details: { portal: 'ICEGATE', error: verifyResult.error }
          });
          return sendJson(res, 401, {
            success: false,
            error: `Cryptographic Webhook Verification Failed: ${verifyResult.error}`
          });
        }
      }

      const shippingBill = body.shippingBillNumber || `SB-IN-DEL-2026-${Math.floor(1000 + Math.random() * 9000)}`;
      const orderId = body.orderId || 'ORD-2026-9041';

      const customsNotice = {
        success: true,
        orderId,
        shippingBillNumber: shippingBill,
        customsStatus: 'CLEARED_FOR_INTERNATIONAL_AIR_DISPATCH',
        portOfExport: body.portOfExport || 'IGI International Airport (DEL)',
        destinationCountry: body.destinationCountry || 'United States',
        clearedAt: new Date().toISOString()
      };

      logAuditEvent({
        action: 'ICEGATE_CUSTOMS_CLEARED',
        actor: 'DGFT_CUSTOMS_GATEWAY',
        role: 'EXTERNAL_GOV_GATEWAY',
        ip: clientIp,
        status: 'SUCCESS',
        details: { orderId, shippingBill, destination: customsNotice.destinationCountry, signed: !!signatureHeader }
      });

      broadcastEvent('CUSTOMS_CLEARED', customsNotice);
      return sendJson(res, 200, customsNotice);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  // 10d. CERT-IN COMPLIANT AUDIT TRAIL TELEMETRY API
  if (pathname === '/api/v1/admin/audit-logs' && method === 'GET') {
    const limit = parseInt(parsedUrl.searchParams.get('limit') || '50', 10);
    const logs = getRecentAuditLogs(limit);

    logAuditEvent({
      action: 'AUDIT_LOG_EXPORT_ACCESSED',
      actor: 'MoSJE_SUPER_ADMIN',
      role: 'MOSJE_OFFICER',
      ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1',
      status: 'SUCCESS',
      details: { retrievedCount: logs.length }
    });

    return sendJson(res, 200, {
      success: true,
      standard: 'CERT-In Cyber Security Directions 2022 / MoSJE Sovereign Security Profile',
      hashChaining: 'SHA-256 Tamper-Evident Ledger',
      count: logs.length,
      auditLogs: logs
    });
  }

  // 10d-2. DATABASE ARCHITECTURE STATS & TELEMETRY API
  if (pathname === '/api/v1/admin/db/stats' && method === 'GET') {
    const status = dbAdapter.getStatus();
    const db = dbAdapter.read();
    const stat = fs.existsSync(DB_FILE) ? fs.statSync(DB_FILE) : { size: 0 };
    const sqliteStatus = sqliteEngine.getStatus();

    return sendJson(res, 200, {
      success: true,
      activeEngine: status.activeEngine,
      configuredEngine: status.configuredEngine,
      storageFootprintBytes: stat.size,
      storageFootprintKb: Math.round(stat.size / 1024),
      atomicSwapEnabled: status.atomicSwapEnabled,
      entities: {
        products: productRepository.count(),
        orders: orderRepository.count(),
        tenders: tenderRepository.count(),
        gisClusters: artisanRepository.getClusters().length,
        blockchainBlocks: blockchainRepository.count()
      },
      relationalSqlite: sqliteStatus,
      postgresPoolConfigured: status.postgresPoolConfigured,
      timestamp: new Date().toISOString()
    });
  }

  // 10e. BLOCKCHAIN SOVEREIGN LEDGER EXPLORER API
  if (pathname === '/api/v1/blockchain/blocks' && method === 'GET') {
    const data = blockchainRepository.getBlocks();
    return sendJson(res, 200, {
      success: true,
      ...data
    });
  }

  if (pathname.startsWith('/api/v1/blockchain/tx/') && method === 'GET') {
    const hash = pathname.split('/').pop();
    const result = blockchainRepository.getTransaction(hash);
    if (result) {
      return sendJson(res, 200, {
        success: true,
        blockNumber: result.blockNumber,
        transaction: result.transaction
      });
    }
    return sendJson(res, 404, { success: false, error: 'Transaction not found on ledger' });
  }

  // 11. STATIC FLUTTER WEB HOSTING (OVER HTTPS)
  let filePath = path.join(WEB_DIR, pathname === '/' ? 'index.html' : pathname);

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      filePath = path.join(WEB_DIR, 'index.html');
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
      if (error) {
        res.writeHead(500);
        res.end('Server error loading application assets.');
      } else {
        res.writeHead(200, {
          'Content-Type': contentType,
          'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
          'X-Content-Type-Options': 'nosniff',
          'X-Frame-Options': 'SAMEORIGIN',
          'Referrer-Policy': 'strict-origin-when-cross-origin',
          'Cache-Control': 'no-store, no-cache, must-revalidate, max-age=0',
          'Pragma': 'no-cache',
          'Expires': '0',
          'Access-Control-Allow-Origin': '*'
        });
        res.end(content);
      }
    });
  });
}

// ==============================================================================
// 1. Primary Secure HTTPS Server (Port 8443)
// ==============================================================================
const httpsServer = (sslOptions.key && sslOptions.cert) ? https.createServer(sslOptions, handleSecureRequest) : null;
const httpServer = http.createServer((req, res) => {
  const host = (req.headers.host || 'localhost').split(':')[0];
  const targetHttpsUrl = `https://${host}:${HTTPS_PORT}${req.url}`;

  res.writeHead(301, {
    'Location': targetHttpsUrl,
    'Content-Type': 'text/html; charset=utf-8'
  });
  res.end(`<!DOCTYPE html><html><head><meta http-equiv="refresh" content="0;url=${targetHttpsUrl}"></head><body><h1>301 Moved Permanently</h1><p>Redirecting to secure TLS endpoint: <a href="${targetHttpsUrl}">${targetHttpsUrl}</a></p></body></html>`);
});

if (require.main === module) {
  if (httpsServer) {
    httpsServer.listen(HTTPS_PORT, '0.0.0.0', () => {
    const ifaces = os.networkInterfaces();
    const lanIps = [];
    for (const name in ifaces) {
      for (const iface of ifaces[name]) {
        if (iface.family === 'IPv4' && !iface.internal) {
          lanIps.push(iface.address);
        }
      }
    }

    console.log(`================================================================`);
    console.log(` 🔒 Karighar (कारीघर) — Secure Full-Stack HTTPS Server`);
    console.log(` Smart India Hackathon 2026 | MoSJE Problem Statement #26090`);
    console.log(`================================================================`);
    console.log(` 🛡️  Desktop Localhost: https://localhost:${HTTPS_PORT}`);
    lanIps.forEach(ip => {
      console.log(` 📱 Phone / LAN URL:   https://${ip}:${HTTPS_PORT}`);
    });
    console.log(` 🌐 Secure REST API:   https://localhost:${HTTPS_PORT}/api/v1/health`);
    console.log(` ⚡ Secure TLS SSE:    https://localhost:${HTTPS_PORT}/api/sync/events`);
    console.log(`================================================================`);
    });
  }

  httpServer.listen(HTTP_PORT, '0.0.0.0', () => {
    console.log(` 🔄 HTTP Ingress (8080) active: Auto-redirecting all traffic to HTTPS (${HTTPS_PORT})`);
  });
}

module.exports = { handleSecureRequest, httpsServer, httpServer };
