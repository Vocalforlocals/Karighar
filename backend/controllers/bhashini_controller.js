// ==============================================================================
// Karighar (कारीघर) — Bhashini National Language Translation Controller
// Powers 22 Scheduled Indian + Bihari Regional Dialects (ASR, NMT & TTS)
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { bhashiniService } = require('../services/bhashini_service');
const { logAuditEvent } = require('../middleware/audit_logger');

class BhashiniController {
  async getLanguages(req, res, { sendJson }) {
    const langs = bhashiniService.getSupportedLanguages();
    const bihariCount = langs.filter(l => l.isBihari).length;
    const scheduledCount = langs.filter(l => l.isScheduled).length;

    return sendJson(res, 200, {
      success: true,
      totalCount: langs.length,
      scheduledIndianCount: scheduledCount,
      bihariRegionalCount: bihariCount,
      provider: 'Bhashini / National Language Translation Mission (NLTM)',
      gateway: bhashiniService.inferenceUrl,
      liveConfigured: bhashiniService.isLiveConfigured(req.headers['x-bhashini-key']),
      languages: langs
    });
  }

  async asr(req, res, { body, sendJson }) {
    try {
      const audioBase64 = body.audioBase64 || body.audioContent || '';
      const languageCode = body.languageCode || body.language || 'hi';
      const apiKey = req.headers['x-bhashini-key'] || req.headers['authorization'] || null;
      const userId = req.headers['x-bhashini-user-id'] || null;

      const asrResult = await bhashiniService.recognizeSpeech({
        audioBase64,
        languageCode,
        apiKey,
        userId
      });

      return sendJson(res, 200, asrResult);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async translate(req, res, { body, sendJson }) {
    try {
      const text = body.text || body.sourceText || '';
      const sourceLang = body.sourceLang || body.sourceLanguage || 'bho';
      const targetLang = body.targetLang || body.targetLanguage || 'en';
      const apiKey = req.headers['x-bhashini-key'] || req.headers['authorization'] || null;
      const userId = req.headers['x-bhashini-user-id'] || null;

      const translationResult = await bhashiniService.translateText({
        text,
        sourceLang,
        targetLang,
        apiKey,
        userId
      });

      return sendJson(res, 200, translationResult);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async tts(req, res, { body, sendJson }) {
    try {
      const text = body.text || '';
      const languageCode = body.languageCode || body.language || 'hi';
      const gender = body.gender || 'female';
      const apiKey = req.headers['x-bhashini-key'] || req.headers['authorization'] || null;
      const userId = req.headers['x-bhashini-user-id'] || null;

      const ttsResult = await bhashiniService.synthesizeSpeech({
        text,
        languageCode,
        gender,
        apiKey,
        userId
      });

      return sendJson(res, 200, ttsResult);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }

  async voiceAssistant(req, res, { body, sendJson }) {
    try {
      const query = body.query || body.transcript || body.text || '';
      const audioBase64 = body.audioBase64 || body.audioContent || null;
      const languageCode = body.languageCode || body.language || 'bho';
      const gender = body.gender || 'female';
      const apiKey = req.headers['x-bhashini-key'] || req.headers['authorization'] || null;
      const userId = req.headers['x-bhashini-user-id'] || null;

      const assistantResult = await bhashiniService.processVoiceAssistant({
        query,
        audioBase64,
        languageCode,
        gender,
        apiKey,
        userId
      });

      logAuditEvent({
        action: 'BHASHINI_VOICE_QUERY_PROCESSED',
        actor: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || 'ARTISAN_VOICE',
        role: 'ARTISAN',
        ip: req.headers['x-forwarded-for'] || req.socket?.remoteAddress || '127.0.0.1',
        status: 'SUCCESS',
        details: {
          language: assistantResult.language.name,
          isBihari: assistantResult.language.isBihari,
          intent: assistantResult.intent,
          query: assistantResult.query
        }
      });

      return sendJson(res, 200, assistantResult);
    } catch (err) {
      return sendJson(res, 400, { success: false, error: err.message });
    }
  }
}

const bhashiniController = new BhashiniController();
module.exports = bhashiniController;
