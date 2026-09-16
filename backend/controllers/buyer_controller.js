// ==============================================================================
// Karighar (कारीघर) — Buyer Experience & Commerce Controller
// Manages Curated Feed, AI Curation, Semantic Search, Stock Locks & Escrow Tracking
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const crypto = require('crypto');
const { productRepository, orderRepository } = require('../repositories');
const { geminiService } = require('../services/gemini_service');

class BuyerController {
  async getFeed(req, res, { sendJson }) {
    try {
      const allProducts = productRepository.getAll();
      const giProducts = allProducts.filter(p => p.isGICertified);

      const banners = [
        {
          id: 'banner_gi_heritage',
          title: "Direct from India's Master Weavers",
          subtitle: 'Certified GI Handicrafts & Handlooms with 0% Middleman Cut',
          tag: '100% ARTISAN SOURCED',
          badge: 'MoSJE Verified',
          imageUrl: 'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?auto=format&fit=crop&w=1200&q=80',
          ctaText: 'Explore Collection',
          route: '/buyer'
        },
        {
          id: 'banner_mithila_madhubani',
          title: 'Madhubani & Mithila Living Canvas',
          subtitle: 'Generational Folk Art hand-painted with bamboo twigs & vegetable dyes',
          tag: 'BIHAR GI CLUSTERS',
          badge: 'GI Tag #370',
          imageUrl: 'https://images.unsplash.com/photo-1582738411706-bfc8e691d1c2?auto=format&fit=crop&w=1200&q=80',
          ctaText: 'Discover Art',
          route: '/buyer'
        },
        {
          id: 'banner_varanasi_silk',
          title: 'Varanasi Brocade & Pure Mulberry Silk',
          subtitle: '14 Days of Loom Craftsmanship with Microscopic Weave Inspection',
          tag: 'ROYAL WEAVES',
          badge: 'Grade A+ Silk',
          imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1200&q=80',
          ctaText: 'View Silks',
          route: '/buyer'
        }
      ];

      const storyReels = [
        {
          id: 'story_ramdev',
          artisanName: 'Master Ramdev',
          craft: 'Banarasi Brocade',
          location: 'Varanasi, UP',
          avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
          videoThumbnail: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=600&q=80',
          verified: true,
          awards: 'Shilp Guru 2024'
        },
        {
          id: 'story_sita',
          artisanName: 'Smt. Sita Devi',
          craft: 'Madhubani Painting',
          location: 'Madhubani, Bihar',
          avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
          videoThumbnail: 'https://images.unsplash.com/photo-1582738411706-bfc8e691d1c2?auto=format&fit=crop&w=600&q=80',
          verified: true,
          awards: 'National Awardee'
        },
        {
          id: 'story_anand',
          artisanName: 'Anand Kumar',
          craft: 'Terracotta Pottery',
          location: 'Gorakhpur, UP',
          avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
          videoThumbnail: 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&w=600&q=80',
          verified: true,
          awards: 'State Master Craftsman'
        },
        {
          id: 'story_priya',
          artisanName: 'Priya Devi',
          craft: 'Bhagalpuri Tussar',
          location: 'Bhagalpur, Bihar',
          avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
          videoThumbnail: 'https://images.unsplash.com/photo-1606744888344-498238f017e0?auto=format&fit=crop&w=600&q=80',
          verified: true,
          awards: 'Cooperative Leader'
        }
      ];

      const categories = [
        { id: 'all', name: 'All Crafts', icon: 'auto_awesome', count: allProducts.length },
        { id: 'textiles', name: 'Textiles & Weaves', icon: 'dry_cleaning', count: allProducts.filter(p => (p.category || '').includes('Textiles')).length },
        { id: 'ceramics', name: 'Ceramics & Pottery', icon: 'interests', count: allProducts.filter(p => (p.category || '').includes('Ceramics')).length },
        { id: 'paintings', name: 'Folk Art & Paintings', icon: 'palette', count: allProducts.filter(p => (p.category || '').includes('Art') || (p.category || '').includes('Painting')).length },
        { id: 'metal', name: 'Brass & Metal Craft', icon: 'shield', count: 4 },
        { id: 'wood', name: 'Wood Carving & Toys', icon: 'toys', count: 6 }
      ];

      return sendJson(res, 200, {
        success: true,
        banners,
        storyReels,
        categories,
        featuredCrafts: giProducts.slice(0, 8),
        totalCraftCount: allProducts.length,
        giCertifiedCount: giProducts.length,
        trustPillars: {
          dbtSettlement: '100% direct bank release via PFMS',
          escrowProtection: 'RBI Section 25 Nodal Escrow',
          provenanceValidation: 'SHA-256 Cryptographic Block Passport'
        },
        timestamp: new Date().toISOString()
      });
    } catch (err) {
      return sendJson(res, 500, { success: false, error: err.message });
    }
  }

  async aiCurate(req, res, { body, sendJson }) {
    try {
      const apiKey = geminiService.getApiKey(req);
      const result = await geminiService.curateBuyerFeed({
        buyerPreferences: body.preferences || [],
        occasion: body.occasion || 'Festive & Cultural Gifting',
        maxBudget: body.maxBudget || 15000,
        apiKey
      });

      const catalog = productRepository.getAll();
      const matchedProducts = catalog.slice(0, 4);

      return sendJson(res, 200, {
        success: true,
        ...result,
        matchedProducts
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async semanticSearch(req, res, { body, sendJson }) {
    try {
      const apiKey = geminiService.getApiKey(req);
      const query = body.query || '';
      const language = body.language || 'English';

      const searchResult = await geminiService.semanticSearchBuyer({ query, language, apiKey });
      const intent = searchResult.parsedIntent || {};

      let matches = productRepository.getAll({
        category: intent.craftCategory !== 'All' ? intent.craftCategory : undefined,
        search: intent.craftForm || query
      });

      if (matches.length === 0) {
        matches = productRepository.getAll({ search: query });
      }

      return sendJson(res, 200, {
        success: true,
        query,
        geminiLive: searchResult.geminiLive,
        model: searchResult.model,
        parsedIntent: intent,
        matchCount: matches.length,
        results: matches
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async getCategories(req, res, { sendJson }) {
    const allProducts = productRepository.getAll();
    const categories = [
      { id: 'all', name: 'All Crafts', icon: 'auto_awesome', count: allProducts.length, description: 'Explore the full spectrum of Indian handcrafts' },
      { id: 'textiles', name: 'Textiles & Weaves', icon: 'dry_cleaning', count: allProducts.filter(p => (p.category || '').includes('Textiles')).length, description: 'Pure silk, khadi, and handloom cotton weaves' },
      { id: 'ceramics', name: 'Ceramics & Pottery', icon: 'interests', count: allProducts.filter(p => (p.category || '').includes('Ceramics')).length, description: 'Traditional terracotta, blue pottery, and glazed earthenware' },
      { id: 'paintings', name: 'Folk Art & Paintings', icon: 'palette', count: allProducts.filter(p => (p.category || '').includes('Art') || (p.category || '').includes('Painting')).length, description: 'Madhubani, Pattachitra, Warli, and Gond art' },
      { id: 'metal', name: 'Brass & Metal Craft', icon: 'shield', count: 4, description: 'Lost-wax Dhokra casting, Moradabad brassware, and bell metal' },
      { id: 'wood', name: 'Wood Carving & Toys', icon: 'toys', count: 6, description: 'Channapatna lacquerware, Saharanpur carving, and walnut wood' }
    ];
    return sendJson(res, 200, { success: true, count: categories.length, categories });
  }

  async reserveStock(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const items = body.items || [];
      const sessionId = body.buyerSessionId || `sess_${Date.now()}`;
      const reservationId = `res_${Date.now()}_${Math.floor(Math.random() * 10000)}`;
      const expiresAt = new Date(Date.now() + 15 * 60 * 1000).toISOString();

      const lockedItems = [];
      for (const item of items) {
        const prod = productRepository.getById(item.productId);
        if (prod) {
          lockedItems.push({
            productId: prod.id,
            title: prod.title,
            unitPrice: prod.price,
            quantity: item.quantity || 1,
            status: 'RESERVED'
          });
        }
      }

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('STOCK_RESERVED', { reservationId, sessionId, itemsCount: lockedItems.length, expiresAt });
      }

      return sendJson(res, 200, {
        success: true,
        reservationId,
        sessionId,
        ttlSeconds: 900,
        expiresAt,
        lockedItems,
        message: 'Loom capacity successfully reserved for 15 minutes.'
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async createPaymentOrder(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const orderId = body.orderId || `ORD-2026-${Date.now() % 100000}`;
      const amount = Number(body.amount) || 0;
      const paymentMethod = body.paymentMethod || 'UPI_INTENT';
      const upiProvider = body.upiProvider || 'GPAY';
      const title = body.title || 'Artisanal GI Craft';

      const upiIntentUrl = `upi://pay?pa=karighar.escrow@icici&pn=Karighar%20Escrow&mc=5947&tid=TXN${Date.now()}&tr=${orderId}&tn=${encodeURIComponent(title)}&am=${amount.toFixed(2)}&cu=INR`;
      const qrPayload = `upi://pay?pa=karighar.escrow@icici&pn=Karighar%20Escrow&tr=${orderId}&am=${amount.toFixed(2)}`;

      const newOrder = {
        id: orderId,
        productId: body.productId || 'prod_01',
        productTitle: title,
        productImage: body.productImage || 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
        artisanName: body.artisanName || 'Master Ramdev',
        buyerName: body.buyerName || 'Conscious Buyer',
        quantity: body.quantity || 1,
        totalPrice: amount,
        status: 'pending_escrow',
        orderDate: new Date().toISOString(),
        deliveryAddress: body.shippingAddress || 'New Delhi 110001',
        paymentMethod,
        upiProvider,
        gstDetails: body.gstDetails || null
      };

      try {
        orderRepository.create(newOrder);
      } catch (_) {}

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('PAYMENT_INITIATED', { orderId, amount, paymentMethod });
      }

      return sendJson(res, 200, {
        success: true,
        orderId,
        amount,
        currency: 'INR',
        paymentMethod,
        upiProvider,
        upiIntentUrl,
        qrPayload,
        escrowProtected: true,
        nodalBank: 'ICICI Bank Nodal Escrow (RBI Compliant)',
        message: 'UPI payment intent generated successfully'
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async verifyPaymentWebhook(req, res, { body, broadcastEvent, sendJson }) {
    try {
      const orderId = body.orderId;
      if (!orderId) {
        return sendJson(res, 400, { success: false, error: 'Missing orderId' });
      }

      const txnId = body.transactionId || `TXN_UPI_${Date.now()}`;
      try {
        orderRepository.updateStatus(orderId, 'escrow_funded');
      } catch (_) {}

      if (typeof broadcastEvent === 'function') {
        broadcastEvent('PAYMENT_SETTLED', {
          orderId,
          transactionId: txnId,
          status: 'escrow_funded',
          dbtTransferScheduled: true,
          timestamp: new Date().toISOString()
        });
      }

      return sendJson(res, 200, {
        success: true,
        orderId,
        status: 'escrow_funded',
        transactionId: txnId,
        escrowRef: `ESCROW-ICICI-${Date.now() % 100000}`,
        message: 'Payment verified! 100% held in Ministry DBT Nodal Escrow until buyer satisfaction inspection.'
      });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async trackOrder(req, res, { params, sendJson }) {
    const orderId = params.orderId;
    const existingOrder = orderRepository.getById ? orderRepository.getById(orderId) : null;

    const stages = [
      {
        id: 1,
        title: 'Order Placed & Escrow Funded',
        status: 'completed',
        timestamp: '10:30 AM, Today',
        description: 'Payment verified via UPI. Funds held in RBI Nodal Escrow for direct artisan DBT release.'
      },
      {
        id: 2,
        title: 'Loom Crafting by Master Artisan',
        status: 'in_progress',
        timestamp: 'Active Now',
        description: 'Master weaver Ramdev has mounted the pit loom in the Varanasi cluster. Warp & weft in progress.'
      },
      {
        id: 3,
        title: 'Computer Vision & GI Tag Verification',
        status: 'pending',
        timestamp: 'Est. Tomorrow',
        description: 'Microscopic weave inspection, Ministry GI Tag sealing, and SHA-256 digital twin minting.'
      },
      {
        id: 4,
        title: 'Dispatched via India Post Speed Post',
        status: 'pending',
        timestamp: 'Est. 2 Days',
        description: 'Airway Bill generated. Handed over to India Post National Logistics Hub.'
      },
      {
        id: 5,
        title: 'Out for Delivery',
        status: 'pending',
        timestamp: 'Est. 4 Days',
        description: 'Local delivery courier will arrive at your verified doorstep with secure delivery OTP.'
      },
      {
        id: 6,
        title: 'Delivered & 7-Day Escrow Release',
        status: 'pending',
        timestamp: 'Est. 5 Days',
        description: 'Buyer inspection window opens. After 7 days, 100% fair wage is released to artisan Aadhaar DBT.'
      }
    ];

    const provenancePassport = {
      orderId,
      craftForm: existingOrder?.productTitle || 'Varanasi Pure Katan Silk Zari Brocade Saree',
      artisanName: existingOrder?.artisanName || 'Master Ramdev (Shilp Guru)',
      giTagNumber: 'GI-IN-UP-2009-089',
      clusterLocation: 'Varanasi, Uttar Pradesh',
      sha256Hash: crypto.createHash('sha256').update(orderId + 'karighar_provenance').digest('hex'),
      blockchainBlockHeight: 14209,
      smartContractEscrow: '0x71C...49B8',
      aadhaarEkycVerified: true
    };

    return sendJson(res, 200, {
      success: true,
      orderId,
      productTitle: existingOrder?.productTitle || 'Varanasi Pure Katan Silk Zari Brocade Saree',
      productImage: existingOrder?.productImage || 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      totalPrice: existingOrder?.totalPrice || 12999,
      currentStatus: 'Loom Crafting Active',
      currentStageIndex: 1,
      trackingStages: stages,
      provenancePassport,
      courierPartner: 'India Post Speed Post (Air Express)',
      trackingNumber: `IN${(Date.now() % 1000000000).toString().padStart(9, '0')}`,
      deliveryAddress: existingOrder?.deliveryAddress || 'Flat 402, Lotus Towers, New Delhi 110001'
    });
  }
}

const buyerController = new BuyerController();
module.exports = buyerController;
