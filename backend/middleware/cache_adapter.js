// ==============================================================================
// Karighar (कारीघर) — Distributed State & Cache Abstraction Layer
// Multi-Node Redis Pub/Sub & Shared State with In-Memory Zero-Dependency Fallback
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const EventEmitter = require('events');

const ENGINE = (process.env.CACHE_ENGINE || 'memory').toLowerCase();
const REDIS_URL = process.env.REDIS_URL || 'redis://127.0.0.1:6379';
const CHANNEL_NAME = 'karighar:events:broadcast';

class CacheAdapter extends EventEmitter {
  constructor() {
    super();
    this.engine = 'memory';
    this.redisClient = null;
    this.redisSubscriber = null;
    this.memoryStore = new Map();
    this.connected = false;

    if (ENGINE === 'redis') {
      this._initRedis();
    }
  }

  _initRedis() {
    try {
      // Optional ioredis or redis client if installed in container
      const Redis = require('ioredis');
      this.redisClient = new Redis(REDIS_URL, {
        maxRetriesPerRequest: 1,
        connectTimeout: 3000,
        lazyConnect: true
      });
      this.redisSubscriber = new Redis(REDIS_URL, {
        maxRetriesPerRequest: 1,
        connectTimeout: 3000,
        lazyConnect: true
      });

      Promise.all([this.redisClient.connect(), this.redisSubscriber.connect()])
        .then(() => {
          this.engine = 'redis';
          this.connected = true;
          console.log('[CACHE] Connected to Redis Distributed Cluster at:', REDIS_URL);

          this.redisSubscriber.subscribe(CHANNEL_NAME);
          this.redisSubscriber.on('message', (channel, message) => {
            if (channel === CHANNEL_NAME) {
              try {
                const parsed = JSON.parse(message);
                this.emit('event', parsed);
              } catch (_) {}
            }
          });
        })
        .catch(err => {
          console.warn('[CACHE WARN] Redis connection failed, falling back to In-Memory bus:', err.message);
          this.engine = 'memory';
          this.connected = false;
        });
    } catch (err) {
      console.warn('[CACHE WARN] Redis driver not available. Operating in In-Memory mode.');
      this.engine = 'memory';
      this.connected = false;
    }
  }

  getEngine() {
    return this.engine;
  }

  isRedisActive() {
    return this.engine === 'redis' && this.connected;
  }

  /**
   * Broadcast an event across all cluster pods and local subscribers
   */
  publishEvent(type, payload) {
    const eventObj = {
      type,
      payload,
      nodeId: process.env.HOSTNAME || `node-${process.pid}`,
      timestamp: new Date().toISOString()
    };

    // 1. Emit locally immediately
    this.emit('event', eventObj);

    // 2. Publish to Redis channel for peer pods if active
    if (this.isRedisActive() && this.redisClient) {
      try {
        this.redisClient.publish(CHANNEL_NAME, JSON.stringify(eventObj));
      } catch (err) {
        console.error('[CACHE ERROR] Redis publish failed:', err.message);
      }
    }

    return eventObj;
  }

  /**
   * Key-value cache operations with optional TTL (seconds)
   */
  async get(key) {
    if (this.isRedisActive() && this.redisClient) {
      try {
        const val = await this.redisClient.get(key);
        return val ? JSON.parse(val) : null;
      } catch (_) {}
    }
    const item = this.memoryStore.get(key);
    if (!item) return null;
    if (item.expiry && Date.now() > item.expiry) {
      this.memoryStore.delete(key);
      return null;
    }
    return item.value;
  }

  async set(key, value, ttlSeconds = null) {
    if (this.isRedisActive() && this.redisClient) {
      try {
        const strVal = JSON.stringify(value);
        if (ttlSeconds) {
          await this.redisClient.setex(key, ttlSeconds, strVal);
        } else {
          await this.redisClient.set(key, strVal);
        }
        return true;
      } catch (_) {}
    }
    this.memoryStore.set(key, {
      value,
      expiry: ttlSeconds ? Date.now() + (ttlSeconds * 1000) : null
    });
    return true;
  }

  getStatus() {
    return {
      activeEngine: this.getEngine(),
      configuredEngine: ENGINE,
      redisUrl: ENGINE === 'redis' ? REDIS_URL : 'N/A (In-Memory)',
      redisConnected: this.connected,
      memoryKeyCount: this.memoryStore.size
    };
  }
}

const cacheAdapter = new CacheAdapter();

module.exports = {
  cacheAdapter
};
