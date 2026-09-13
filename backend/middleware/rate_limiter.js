// ==============================================================================
// Karighar (कारीघर) — Token Bucket Rate Limiter Middleware
// Zero-dependency in-memory DoS protection & endpoint throttling
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

class TokenBucketRateLimiter {
  constructor() {
    this.buckets = new Map();
    // Default rate limit profiles
    this.profiles = {
      AUTH: { limit: 20, windowMs: 60 * 1000 },
      FINANCIAL: { limit: 40, windowMs: 60 * 1000 },
      WEBHOOK: { limit: 60, windowMs: 60 * 1000 },
      STANDARD: { limit: 150, windowMs: 60 * 1000 }
    };

    // Garbage collection every 5 minutes to prevent memory leaks (unref ensures serverless runtimes do not hang)
    const cleanupTimer = setInterval(() => this.cleanup(), 5 * 60 * 1000);
    if (cleanupTimer.unref) cleanupTimer.unref();
  }

  getClientIp(req) {
    if (!req) return '127.0.0.1';
    const forwarded = req.headers && req.headers['x-forwarded-for'];
    if (forwarded) {
      return forwarded.split(',')[0].trim();
    }
    return (req.socket && req.socket.remoteAddress) || req.ip || '127.0.0.1';
  }

  getProfileType(pathname) {
    if (pathname.startsWith('/api/v1/auth/')) return 'AUTH';
    if (pathname.startsWith('/api/v1/credit/') || pathname.startsWith('/api/v1/escrow/')) return 'FINANCIAL';
    if (pathname.startsWith('/api/v1/webhooks/')) return 'WEBHOOK';
    return 'STANDARD';
  }

  check(req, pathname) {
    const profileType = this.getProfileType(pathname);
    const profile = this.profiles[profileType];
    const ip = this.getClientIp(req);
    const key = `${profileType}:${ip}`;
    const now = Date.now();

    let record = this.buckets.get(key);
    if (!record || now - record.resetTime > profile.windowMs) {
      record = {
        tokens: profile.limit - 1,
        resetTime: now + profile.windowMs
      };
      this.buckets.set(key, record);
      return {
        allowed: true,
        limit: profile.limit,
        remaining: record.tokens,
        resetInSeconds: Math.ceil(profile.windowMs / 1000)
      };
    }

    if (record.tokens > 0) {
      record.tokens -= 1;
      return {
        allowed: true,
        limit: profile.limit,
        remaining: record.tokens,
        resetInSeconds: Math.ceil((record.resetTime - now) / 1000)
      };
    }

    // Rate limit exceeded
    return {
      allowed: false,
      limit: profile.limit,
      remaining: 0,
      resetInSeconds: Math.max(1, Math.ceil((record.resetTime - now) / 1000))
    };
  }

  cleanup() {
    const now = Date.now();
    for (const [key, record] of this.buckets.entries()) {
      if (now > record.resetTime) {
        this.buckets.delete(key);
      }
    }
  }
}

const rateLimiter = new TokenBucketRateLimiter();

module.exports = {
  rateLimiter,
  TokenBucketRateLimiter
};
