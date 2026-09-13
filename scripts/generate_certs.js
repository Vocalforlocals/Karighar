// ==============================================================================
// Karighar (कारीघर) — TLS Certificate Generation Script
// Generates RSA 2048 Key and X.509 Certificate with Subject Alternative Names (SAN)
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

const CERTS_DIR = path.join(__dirname, '..', 'certs');
const KEY_FILE = path.join(CERTS_DIR, 'key.pem');
const CERT_FILE = path.join(CERTS_DIR, 'cert.pem');
const CONF_FILE = path.join(CERTS_DIR, 'openssl.cnf');

function getLanIps() {
  const ifaces = os.networkInterfaces();
  const ips = new Set(['127.0.0.1', '10.63.63.42']);
  for (const name in ifaces) {
    for (const iface of ifaces[name]) {
      if (iface.family === 'IPv4' && !iface.internal) {
        ips.add(iface.address);
      }
    }
  }
  return Array.from(ips);
}

function generateCerts() {
  if (!fs.existsSync(CERTS_DIR)) {
    fs.mkdirSync(CERTS_DIR, { recursive: true });
  }

  const lanIps = getLanIps();
  const ipEntries = lanIps.map((ip, i) => `IP.${i + 1}  = ${ip}`).join('\n');

  // OpenSSL SAN configuration
  const configContent = `[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
x509_extensions    = v3_req

[dn]
C  = IN
ST = Uttar Pradesh
L  = Varanasi
O  = Karighar MoSJE Trust
OU = Digital Craft Authentication
CN = localhost

[v3_req]
subjectAltName = @alt_names
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth

[alt_names]
DNS.1 = localhost
DNS.2 = *.localhost
${ipEntries}
`;

  fs.writeFileSync(CONF_FILE, configContent, 'utf8');

  console.log('[TLS] Generating 2048-bit RSA Private Key & Self-Signed X.509 Certificate...');

  try {
    const cmd = `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "${KEY_FILE}" -out "${CERT_FILE}" -config "${CONF_FILE}"`;
    execSync(cmd, { stdio: 'pipe' });
    console.log('[TLS] Certificate successfully generated:');
    console.log(`      Private Key: ${KEY_FILE}`);
    console.log(`      Certificate: ${CERT_FILE}`);
    return true;
  } catch (err) {
    console.error('[TLS] Error executing openssl:', err.message);
    if (err.stderr) console.error(err.stderr.toString());
    return false;
  }
}

if (require.main === module) {
  generateCerts();
}

module.exports = { generateCerts, KEY_FILE, CERT_FILE, CERTS_DIR };
