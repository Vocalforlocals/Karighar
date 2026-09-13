const { handleSecureRequest } = require('../serve_flutter');

module.exports = async (req, res) => {
  try {
    await handleSecureRequest(req, res);
  } catch (err) {
    console.error('[VERCEL API ERROR]', err);
    res.statusCode = 500;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({ success: false, error: 'Internal server error in Karighar API gateway' }));
  }
};
