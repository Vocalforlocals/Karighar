// ==============================================================================
// Karighar (कारीघर) — Secure Master Unified Full-Stack HTTPS Server
// Primary HTTPS: Port 8443 (TLS 1.3 / 1.2 + HSTS + REST API v1 + Real-Time SSE)
// HTTP Ingress:  Port 8080 (Direct Web & API Serving + Zero SSL Warnings)
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const https = require('https');
const http = require('http');
const fs = require('fs');
const path = require('path');
const os = require('os');
const crypto = require('crypto');

// Lightweight Native .env loader
const envPath = path.join(__dirname, '.env');
if (fs.existsSync(envPath)) {
  try {
    const envContent = fs.readFileSync(envPath, 'utf8');
    for (const line of envContent.split('\n')) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const idx = trimmed.indexOf('=');
      if (idx > 0) {
        const key = trimmed.substring(0, idx).trim();
        const val = trimmed.substring(idx + 1).trim().replace(/^['"]|['"]$/g, '');
        if (!process.env[key]) {
          process.env[key] = val;
        }
      }
    }
  } catch (e) {
    console.warn('[ENV] Warning loading .env:', e.message);
  }
}

const { router } = require('./backend/routes/router');
const { getOpenApiSpec, renderDocsHtml } = require('./backend/docs/api_docs');
const { rateLimiter } = require('./backend/middleware/rate_limiter');
const { logAuditEvent } = require('./backend/middleware/audit_logger');
const { dbAdapter } = require('./backend/database/db_adapter');
const { cacheAdapter } = require('./backend/middleware/cache_adapter');
const { sqliteEngine } = require('./backend/database/sqlite_engine');

const HTTPS_PORT = parseInt(process.env.HTTPS_PORT || '8443', 10);
const HTTP_PORT = parseInt(process.env.PORT || process.env.HTTP_PORT || '8080', 10);
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
    console.warn('[TLS] Notice auto-generating certificates:', err.message);
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
  '.jpeg': 'image/jpeg',
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

// Helper: Read request body as JSON with DoS protection
function parseJsonBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      // DoS Protection: Payload size capped at 25MB (comfortably permits 4K images & audio)
      if (body.length > 25 * 1024 * 1024) {
        req.destroy();
        reject(new Error('Request payload exceeds 25MB safety threshold'));
      }
    });
    req.on('end', () => {
      req.rawBody = body;
      if (!body) return resolve({});
      try {
        resolve(JSON.parse(body));
      } catch (err) {
        reject(new Error(`Malformed JSON body: ${err.message}`));
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
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With, x-gemini-api-key, x-bhashini-key, x-bhashini-user-id, x-gov-signature, x-signature-sha256'
  });
  res.end(JSON.stringify(data));
}

// ==============================================================================
// Core Request Handler (Universal HTTPS & HTTP)
// ==============================================================================
async function handleSecureRequest(req, res) {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With, x-gemini-api-key, x-bhashini-key, x-bhashini-user-id, x-gov-signature, x-signature-sha256'
    });
    res.end();
    return;
  }

  const parsedUrl = new URL(req.url, `https://${req.headers.host || `localhost:${HTTPS_PORT}`}`);
  const pathname = parsedUrl.pathname;
  const method = req.method;

  // 1. Rate Limiting & DoS Shield Middleware
  if (pathname.startsWith('/api/')) {
    const rateCheck = rateLimiter.check(req, pathname);
    res.setHeader('X-RateLimit-Limit', rateCheck.limit);
    res.setHeader('X-RateLimit-Remaining', rateCheck.remaining);
    res.setHeader('X-RateLimit-Reset', rateCheck.resetInSeconds);

    if (!rateCheck.allowed) {
      res.setHeader('Retry-After', rateCheck.resetInSeconds);
      logAuditEvent({
        action: 'RATE_LIMIT_EXCEEDED',
        actor: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || 'IP',
        role: 'THROTTLED_CLIENT',
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
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

  // 2. Health Check
  if (pathname === '/api/health' || pathname === '/api/v1/health') {
    return sendJson(res, 200, {
      status: 'ok',
      protocol: req.socket?.encrypted ? 'https' : 'http',
      app: 'Karighar Secure Unified Engine',
      version: '2.0.0',
      connectedDevices: syncClients.size,
      uptimeSeconds: Math.floor(process.uptime()),
      memoryUsageMB: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
      storage: dbAdapter.getStatus(),
      cache: cacheAdapter.getStatus(),
      cluster: {
        nodeId: process.env.HOSTNAME || `node-${process.pid}`,
        mode: process.env.NODE_ENV || 'development'
      },
      timestamp: new Date().toISOString()
    });
  }

  // 3. Interactive Documentation
  if (pathname === '/api/docs' || pathname === '/docs') {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    return res.end(renderDocsHtml());
  }

  // 4. Real-Time Event Stream (SSE)
  if (pathname === '/api/sync/events') {
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Access-Control-Allow-Origin': '*'
    });
    res.write(`data: ${JSON.stringify({ type: 'CONNECTED', message: 'Karighar Live Multi-Device Sync Active', clients: syncClients.size + 1 })}\n\n`);

    syncClients.add(res);
    req.on('close', () => {
      syncClients.delete(res);
    });
    return;
  }

  // 5. Client Broadcast Trigger
  if (pathname === '/api/sync/broadcast' && method === 'POST') {
    try {
      const payload = await parseJsonBody(req);
      broadcastEvent(payload.type || 'SYNC_ALERT', payload.data || payload);
      return sendJson(res, 200, { success: true, broadcastCount: syncClients.size });
    } catch (err) {
      return sendJson(res, 400, { error: err.message });
    }
  }

  // 6. Dispatch API Routes via Centralized Modular Router
  if (pathname.startsWith('/api/')) {
    let body = {};
    if (['POST', 'PUT', 'PATCH'].includes(method)) {
      try {
        body = await parseJsonBody(req);
      } catch (err) {
        return sendJson(res, 400, { success: false, error: err.message });
      }
    }

    const context = {
      parsedUrl,
      pathname,
      method,
      body,
      sendJson,
      broadcastEvent,
      syncClients
    };

    const handled = await router.dispatch(req, res, context);
    if (handled) return;
  }

  // 7. Static Flutter Web Asset Hosting & SPA Fallback
  let filePath = path.join(WEB_DIR, pathname === '/' ? 'index.html' : pathname);

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      // SPA Fallback for client-side routing
      filePath = path.join(WEB_DIR, 'index.html');
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    fs.readFile(filePath, (error, content) => {
      if (error) {
        res.writeHead(500, { 'Content-Type': 'text/plain' });
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
// Server Instances Initialization
// ==============================================================================
const httpsServer = (sslOptions.key && sslOptions.cert) ? https.createServer(sslOptions, handleSecureRequest) : null;
const httpServer = http.createServer((req, res) => {
  return handleSecureRequest(req, res);
});

if (require.main === module) {
  // Discover LAN IPs for multi-device testing
  const ifaces = os.networkInterfaces();
  const lanIps = [];
  for (const name in ifaces) {
    for (const iface of ifaces[name]) {
      if (iface.family === 'IPv4' && !iface.internal) {
        lanIps.push(iface.address);
      }
    }
  }

  if (httpsServer) {
    httpsServer.listen(HTTPS_PORT, '0.0.0.0', () => {
      console.log(`🔒 HTTPS Server running on port ${HTTPS_PORT}`);
    });
  }

  httpServer.listen(HTTP_PORT, '0.0.0.0', () => {
    console.log(`================================================================`);
    console.log(` 🚀 Karighar (कारीघर) — Enterprise Full-Stack Server v2.0`);
    console.log(` Smart India Hackathon 2026 | MoSJE Problem Statement #26090`);
    console.log(`================================================================`);
    console.log(` 💻 Web Localhost:    http://localhost:${HTTP_PORT}`);
    lanIps.forEach(ip => {
      console.log(` 📱 Mobile / LAN:     http://${ip}:${HTTP_PORT}`);
    });
    console.log(` 🌐 REST API Health:  http://localhost:${HTTP_PORT}/api/v1/health`);
    console.log(` 📖 Swagger Docs:     http://localhost:${HTTP_PORT}/api/docs`);
    console.log(` ⚡ Real-Time SSE:    http://localhost:${HTTP_PORT}/api/sync/events`);
    console.log(`================================================================`);
  });
}

module.exports = { handleSecureRequest, httpsServer, httpServer, broadcastEvent };
