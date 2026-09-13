// ==============================================================================
// Karighar (कारीघर) — Authentication & PM-Vishwakarma KYC Service
// Provides HMAC-SHA256 JWT Token Minting & Aadhaar / UIDAI Artisan e-KYC
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const crypto = require('crypto');

const JWT_SECRET = process.env.KARIGHAR_JWT_SECRET || process.env.SHILPSETU_JWT_SECRET || 'KARIGHAR_MOSJE_SECURE_HMAC_SECRET_2026';

/**
 * Mint an RFC 7519 compliant HMAC-SHA256 JSON Web Token
 */
function signToken(payload, expiresInSeconds = 86400) {
  const header = {
    alg: 'HS256',
    typ: 'JWT'
  };

  const now = Math.floor(Date.now() / 1000);
  const fullPayload = {
    ...payload,
    iat: now,
    exp: now + expiresInSeconds,
    iss: 'Karighar-MoSJE-Gateway'
  };

  const encodedHeader = Buffer.from(JSON.stringify(header)).toString('base64url');
  const encodedPayload = Buffer.from(JSON.stringify(fullPayload)).toString('base64url');
  const signature = crypto
    .createHmac('sha256', JWT_SECRET)
    .update(`${encodedHeader}.${encodedPayload}`)
    .digest('base64url');

  return `${encodedHeader}.${encodedPayload}.${signature}`;
}

/**
 * Verify and decode an HMAC-SHA256 JWT
 */
function verifyToken(token) {
  if (!token) return null;
  const parts = token.split('.');
  if (parts.length !== 3) return null;

  const [encodedHeader, encodedPayload, signature] = parts;
  const expectedSignature = crypto
    .createHmac('sha256', JWT_SECRET)
    .update(`${encodedHeader}.${encodedPayload}`)
    .digest('base64url');

  if (signature !== expectedSignature) {
    return null; // Invalid signature
  }

  try {
    const payload = JSON.parse(Buffer.from(encodedPayload, 'base64url').toString('utf8'));
    const now = Math.floor(Date.now() / 1000);
    if (payload.exp && payload.exp < now) {
      return null; // Token expired
    }
    return payload;
  } catch (err) {
    return null;
  }
}

/**
 * Mock PM-Vishwakarma & UIDAI Aadhaar Biometric e-KYC Verification
 */
function verifyAadhaarArtisan({ aadhaarNumber, artisanId, craftCategory }) {
  // Normalize Aadhaar format
  const cleanAadhaar = (aadhaarNumber || '').replace(/\D/g, '');
  const isValidFormat = cleanAadhaar.length === 12;

  const artisanDatabase = {
    'art_ramdev_01': {
      artisanName: 'Ramdev Varma',
      gender: 'Male',
      age: 48,
      socialCategory: 'OBC (Other Backward Classes) - Traditional Weaver',
      clusterLocation: 'Varanasi, Uttar Pradesh',
      craftGuild: 'Varanasi Mulberry Silk Weaving Guild',
      pmVishwakarmaId: 'PMV-UP-2024-VAR-0891',
      skillLevel: 'Master Craftsman (Level 5 Assessed)',
      trustScore: 842,
      toolkitProvided: true,
      bankAccountLinked: 'State Bank of India (Aadhaar Seeded)'
    },
    'art_shanti_02': {
      artisanName: 'Shanti Devi',
      gender: 'Female',
      age: 42,
      socialCategory: 'SC (Scheduled Caste) - Folk Artisan',
      clusterLocation: 'Jitwarpur, Madhubani, Bihar',
      craftGuild: 'Mithila Folk Painting Collective',
      pmVishwakarmaId: 'PMV-BR-2023-MTH-0412',
      skillLevel: 'Master Artisan (Level 5 Assessed)',
      trustScore: 880,
      toolkitProvided: true,
      bankAccountLinked: 'Punjab National Bank (Aadhaar Seeded)'
    }
  };

  const record = artisanDatabase[artisanId] || {
    artisanName: 'Verified Craftsperson',
    gender: 'N/A',
    age: 38,
    socialCategory: 'Marginalized Traditional Craftsperson (MoSJE Beneficiary)',
    clusterLocation: 'Handicraft Cluster, India',
    craftGuild: 'National Artisan Cooperative',
    pmVishwakarmaId: `PMV-IN-2026-${Math.floor(1000 + Math.random() * 9000)}`,
    skillLevel: 'Skilled Artisan',
    trustScore: 810,
    toolkitProvided: true,
    bankAccountLinked: 'DBT Enabled Account'
  };

  const kycRef = `KYC-UIDAI-${crypto.randomBytes(8).toString('hex').toUpperCase()}`;

  return {
    verified: isValidFormat || !!artisanDatabase[artisanId],
    kycReference: kycRef,
    verifiedAt: new Date().toISOString(),
    aadhaarMasked: cleanAadhaar.length === 12 ? `XXXXXXXX${cleanAadhaar.slice(8)}` : 'XXXXXXXX8412',
    artisanId: artisanId || 'art_ramdev_01',
    craftCategory: craftCategory || 'Handloom Textiles',
    profile: record,
    governmentScheme: 'PM-Vishwakarma Yojana (Ministry of Social Justice & Empowerment)'
  };
}

module.exports = {
  signToken,
  verifyToken,
  verifyAadhaarArtisan
};
