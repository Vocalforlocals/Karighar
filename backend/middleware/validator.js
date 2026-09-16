// ==============================================================================
// Karighar (कारीघर) — Input Validation & Sanitization Middleware
// Protects endpoints against injection, malformed payloads & buffer overflows
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

class ValidationError extends Error {
  constructor(message, field = null) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
    this.statusCode = 400;
  }
}

/**
 * Basic string sanitizer to strip script tags and excessive control chars
 */
function sanitizeString(str) {
  if (typeof str !== 'string') return '';
  return str
    .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
    .trim();
}

/**
 * Validate presence of required non-empty fields in payload
 */
function validateRequired(obj, fields) {
  if (!obj || typeof obj !== 'object') {
    throw new ValidationError('Request body must be a valid JSON object');
  }
  for (const field of fields) {
    const val = obj[field];
    if (val === undefined || val === null || (typeof val === 'string' && val.trim() === '')) {
      throw new ValidationError(`Missing required field: '${field}'`, field);
    }
  }
}

/**
 * Validate email format
 */
function isValidEmail(email) {
  if (typeof email !== 'string') return false;
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

/**
 * Validate 10-digit Indian mobile number
 */
function isValidPhone(phone) {
  if (typeof phone !== 'string') return false;
  const digits = phone.replace(/\D/g, '');
  return digits.length >= 10 && digits.length <= 13;
}

const validator = {
  ValidationError,
  sanitizeString,
  validateRequired,
  isValidEmail,
  isValidPhone,

  validateAuthRegister(body) {
    validateRequired(body, ['name', 'email', 'role']);
    if (!isValidEmail(body.email)) {
      throw new ValidationError('Invalid email format', 'email');
    }
    const role = (body.role || '').toUpperCase();
    if (role !== 'BUYER' && role !== 'ARTISAN') {
      throw new ValidationError("Role must be either 'BUYER' or 'ARTISAN'", 'role');
    }
    return {
      name: sanitizeString(body.name),
      email: body.email.toLowerCase().trim(),
      phone: sanitizeString(body.phone || ''),
      role
    };
  },

  validateAuthLogin(body) {
    validateRequired(body, ['email']);
    if (!isValidEmail(body.email)) {
      throw new ValidationError('Invalid email format', 'email');
    }
    return {
      email: body.email.toLowerCase().trim(),
      password: body.password || '',
      role: (body.role || '').toUpperCase()
    };
  },

  validateProductCreate(body) {
    validateRequired(body, ['title', 'price']);
    const price = parseFloat(body.price);
    if (isNaN(price) || price <= 0) {
      throw new ValidationError('Price must be a positive number', 'price');
    }
    return {
      title: sanitizeString(body.title),
      category: sanitizeString(body.category || 'Textiles & Weaves'),
      craftForm: sanitizeString(body.craftForm || 'Handloom'),
      description: sanitizeString(body.description || ''),
      price,
      estimatedHours: parseInt(body.estimatedHours, 10) || 24,
      stockQuantity: parseInt(body.stockQuantity, 10) || 1,
      images: Array.isArray(body.images) ? body.images : [],
      rawImage: body.rawImage || '',
      tags: Array.isArray(body.tags) ? body.tags : ['GI Certified']
    };
  },

  validateOrderCreate(body) {
    validateRequired(body, ['productId', 'amount']);
    const amount = parseFloat(body.amount);
    if (isNaN(amount) || amount <= 0) {
      throw new ValidationError('Amount must be a positive number', 'amount');
    }
    return {
      productId: body.productId,
      buyerName: sanitizeString(body.buyerName || 'Buyer'),
      buyerEmail: body.buyerEmail ? body.buyerEmail.toLowerCase().trim() : '',
      amount,
      quantity: parseInt(body.quantity, 10) || 1,
      shippingAddress: body.shippingAddress || {}
    };
  },

  validateChatMessage(body) {
    validateRequired(body, ['text']);
    return {
      text: sanitizeString(body.text),
      senderRole: body.senderRole === 'artisan' ? 'artisan' : 'buyer',
      senderName: sanitizeString(body.senderName || ''),
      messageType: body.messageType || 'text',
      cardData: body.cardData || null,
      isAiAssisted: !!body.isAiAssisted
    };
  },

  validateCounterOffer(body) {
    validateRequired(body, ['counterPrice']);
    const price = parseFloat(body.counterPrice);
    if (isNaN(price) || price <= 0) {
      throw new ValidationError('Counter price must be a valid positive number', 'counterPrice');
    }
    return {
      counterPrice: price,
      note: sanitizeString(body.note || '')
    };
  }
};

module.exports = validator;
