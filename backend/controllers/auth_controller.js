// ==============================================================================
// Karighar (कारीघर) — Authentication & PM-Vishwakarma E-KYC Controller
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { authRepository, artisanRepository } = require('../repositories');
const { verifyToken } = require('../middleware/auth_service');
const { logAuditEvent } = require('../middleware/audit_logger');
const validator = require('../middleware/validator');

class AuthController {
  async register(req, res, { body, sendJson }) {
    try {
      const validated = validator.validateAuthRegister(body);
      const { user, token } = authRepository.registerUser(body);

      logAuditEvent({
        action: 'USER_REGISTERED',
        actor: user.phone || user.email,
        role: user.role,
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
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

  async login(req, res, { body, sendJson }) {
    try {
      const validated = validator.validateAuthLogin(body);
      const { user, token } = authRepository.authenticateUser(body);

      logAuditEvent({
        action: 'USER_LOGIN',
        actor: user.email || user.phone,
        role: user.role,
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
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

  async sendOtp(req, res, { body, sendJson }) {
    try {
      if (!body.phone) {
        return sendJson(res, 400, { success: false, error: "Missing required field: 'phone'" });
      }
      const result = authRepository.generateOtp(body.phone);

      logAuditEvent({
        action: 'OTP_REQUESTED',
        actor: body.phone,
        role: 'ANONYMOUS',
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
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

  async verifyOtp(req, res, { body, sendJson }) {
    try {
      if (!body.phone || !body.otp) {
        return sendJson(res, 400, { success: false, error: "Fields 'phone' and 'otp' are required" });
      }
      const { user, token } = authRepository.verifyOtp(body.phone, body.otp);

      logAuditEvent({
        action: 'OTP_VERIFIED_LOGIN',
        actor: user.phone,
        role: user.role,
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
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

  async getMe(req, res, { sendJson }) {
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

  async verifyArtisan(req, res, { body, sendJson }) {
    try {
      const result = artisanRepository.verifyArtisan({
        aadhaarNumber: body.aadhaarNumber,
        artisanId: body.artisanId,
        craftCategory: body.craftCategory
      });

      logAuditEvent({
        action: 'ARTISAN_AADHAAR_KYC_VERIFIED',
        actor: body.artisanId || 'UNKNOWN_ARTISAN',
        role: 'ARTISAN',
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
        status: result.verified ? 'SUCCESS' : 'FAILED',
        details: { craftCategory: body.craftCategory, trustScore: result.profile?.trustScore }
      });

      return sendJson(res, 200, { success: true, kyc: result });
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const authController = new AuthController();
module.exports = authController;
