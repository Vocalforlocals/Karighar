// ==============================================================================
// Karighar (कारीघर) — OpenAPI 3.0 Specification & Interactive Playground
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

function getOpenApiSpec() {
  return {
    openapi: '3.0.3',
    info: {
      title: 'Karighar Unified REST API Gateway',
      version: '1.0.0',
      description: 'Production-ready backend API for AI-driven market linkage, smart cataloging, autonomous negotiation, and financial inclusion for marginalized artisans under MoSJE Problem Statement #26090.',
      contact: {
        name: 'Ministry of Social Justice and Empowerment (MoSJE) - Smart India Hackathon 2026',
        url: 'https://socialjustice.gov.in'
      }
    },
    servers: [
      {
        url: 'https://localhost:8443',
        description: 'Secure Localhost HTTPS Environment (Primary)'
      },
      {
        url: 'https://10.63.63.42:8443',
        description: 'Mobile Wi-Fi LAN Ingress'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      }
    },
    paths: {
      '/api/v1/health': {
        get: {
          summary: 'System Health & Connectivity Status',
          tags: ['System & Telemetry'],
          responses: {
            '200': { description: 'Server healthy and active.' }
          }
        }
      },
      '/api/v1/auth/login': {
        post: {
          summary: 'Issue HMAC-SHA256 JWT Token',
          tags: ['Authentication & Security'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    email: { type: 'string', example: 'ramdev@karighar.gov.in' },
                    role: { type: 'string', enum: ['ARTISAN', 'BUYER', 'MOSJE_OFFICER'], example: 'ARTISAN' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Authenticated successfully with JWT.' }
          }
        }
      },
      '/api/v1/auth/verify-artisan': {
        post: {
          summary: 'PM-Vishwakarma & UIDAI Aadhaar e-KYC Verification',
          tags: ['Authentication & Security'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    aadhaarNumber: { type: 'string', example: '5489-1234-8412' },
                    artisanId: { type: 'string', example: 'art_ramdev_01' },
                    craftCategory: { type: 'string', example: 'Banarasi Brocade Silk' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Aadhaar and PM-Vishwakarma credentials verified.' }
          }
        }
      },
      '/api/v1/products': {
        get: {
          summary: 'List Handcrafted GI Products',
          tags: ['Marketplace & Catalog'],
          parameters: [
            { name: 'category', in: 'query', schema: { type: 'string' }, description: 'Filter by craft category' },
            { name: 'q', in: 'query', schema: { type: 'string' }, description: 'Search term' }
          ],
          responses: {
            '200': { description: 'List of authentic artisan products.' }
          }
        },
        post: {
          summary: 'Publish New Craft & Mint SHA-256 GI Passport',
          tags: ['Marketplace & Catalog'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  required: ['title', 'price'],
                  properties: {
                    title: { type: 'string', example: 'Pure Varanasi Mulberry Silk Saree' },
                    category: { type: 'string', example: 'Textiles & Weaves' },
                    craftForm: { type: 'string', example: 'Banarasi Handloom Brocade' },
                    price: { type: 'number', example: 8500 },
                    estimatedHours: { type: 'number', example: 96 }
                  }
                }
              }
            }
          },
          responses: {
            '201': { description: 'Product published and broadcasted.' }
          }
        }
      },
      '/api/v1/products/{id}': {
        get: {
          summary: 'Get Craft Details with Cryptographic Provenance Hash',
          tags: ['Marketplace & Catalog'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'string' }, example: 'prod_01' }
          ],
          responses: {
            '200': { description: 'Craft details and SHA-256 hash.' }
          }
        }
      },
      '/api/v1/tenders': {
        get: {
          summary: 'List Institutional B2B Tenders',
          tags: ['Institutional Trade & Pooling'],
          responses: {
            '200': { description: 'Available tenders.' }
          }
        }
      },
      '/api/v1/tenders/{id}/pool': {
        post: {
          summary: 'Artisan Allocates Loom Units to Tender Pool',
          tags: ['Institutional Trade & Pooling'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'string' }, example: 'tender_taj_500' }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    artisanId: { type: 'string', example: 'art_ramdev_01' },
                    artisanName: { type: 'string', example: 'Master Ramdev' },
                    committedUnits: { type: 'number', example: 50 }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Capacity allocated successfully.' }
          }
        }
      },
      '/api/v1/negotiate/evaluate': {
        post: {
          summary: 'Varta-AI Living-Wage Defense Evaluation',
          tags: ['Autonomous AI & Governance'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    offeredPrice: { type: 'number', example: 5200 },
                    daysOfCraft: { type: 'number', example: 14 },
                    rawMaterialCost: { type: 'number', example: 2800 }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Wage analysis with lowball flag and legal counter-offer.' }
          }
        }
      },
      '/api/v1/escrow/verify': {
        post: {
          summary: 'Verify Parcel QR & Disburse Funds via PFMS',
          tags: ['Smart Escrow & Payments'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    orderId: { type: 'string', example: 'ORD-2026-9041' },
                    amount: { type: 'number', example: 8500 }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Escrow released directly to artisan bank.' }
          }
        }
      },
      '/api/v1/credit/profile/{artisanId}': {
        get: {
          summary: 'Get PM-Vishwakarma Alternative Credit Score',
          tags: ['Financial Inclusion'],
          parameters: [
            { name: 'artisanId', in: 'path', required: true, schema: { type: 'string' }, example: 'art_ramdev_01' }
          ],
          responses: {
            '200': { description: 'Credit score (842/900 AAA Prime).' }
          }
        }
      },
      '/api/v1/credit/disburse': {
        post: {
          summary: '1-Tap Collateral-Free Subsidized Loan Claim',
          tags: ['Financial Inclusion'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    amount: { type: 'number', example: 100000 }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Loan disbursed to Aadhaar-linked bank.' }
          }
        }
      },
      '/api/v1/artisan/stats': {
        get: {
          summary: 'Get Real-Time Artisan Studio Dashboard Metrics',
          tags: ['Artisan Studio & Guilds'],
          parameters: [
            { name: 'artisanId', in: 'query', required: false, schema: { type: 'string' }, example: 'art_ramdev_01' }
          ],
          responses: {
            '200': { description: 'Live GMV, active loom prep, pending quotes, and GI compliance metrics.' }
          }
        }
      },
      '/api/v1/artisan/quotes': {
        get: {
          summary: 'Get Pending B2B Bulk Quotes for Artisan',
          tags: ['Artisan Studio & Guilds'],
          parameters: [
            { name: 'artisanId', in: 'query', required: false, schema: { type: 'string' }, example: 'art_ramdev_01' }
          ],
          responses: {
            '200': { description: 'Active RFQ quotes from institutional buyers.' }
          }
        }
      },
      '/api/v1/ai/weave-inspect': {
        post: {
          summary: 'Computer Vision Neural Weave Quality Inspection & GI Verification',
          tags: ['AI Studio & Quality Verification'],
          requestBody: {
            required: false,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    imageUrl: { type: 'string', example: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Microscopic EPI/PPI yarn density, symmetry score, and GI certification grade.' }
          }
        }
      },
      '/api/v1/ai/voice-catalog': {
        post: {
          summary: 'Bhashini AI Multilingual Voice-to-Catalog Structured Extraction',
          tags: ['AI Studio & Quality Verification'],
          requestBody: {
            required: false,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    language: { type: 'string', example: 'Hindi' },
                    transcript: { type: 'string', example: 'यह शुद्ध कतान सिल्क साड़ी है...' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Extracted multilingual title, description, materials, labor hours, and fair pricing.' }
          }
        }
      },
      '/api/v1/ai/camera/process-angle': {
        post: {
          summary: 'Multi-Angle Camera Computer Vision Analysis & 4K Neural Enhancement',
          tags: ['AI Studio & Quality Verification'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    angleKey: { type: 'string', enum: ['overview', 'texture', 'motif', 'loom'], example: 'texture' },
                    angleIndex: { type: 'number', example: 1 },
                    angleLabel: { type: 'string', example: 'Weave Texture' },
                    craftPreset: { type: 'string', example: 'Banarasi Katan Silk Saree' },
                    enhancementOptions: {
                      type: 'object',
                      properties: {
                        superResolution: { type: 'boolean', example: true },
                        studioLighting: { type: 'boolean', example: true },
                        colorCalibration: { type: 'boolean', example: true },
                        backgroundDeClutter: { type: 'boolean', example: true }
                      }
                    }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Angle quality metrics, warp/weft density (EPI/PPI), knot symmetry, and cryptographic angle hash.' }
          }
        }
      },
      '/api/v1/ai/camera/multi-angle-inspect': {
        post: {
          summary: 'Composite 360° Multi-Angle GI Weave Inspection & Provenance Certificate',
          tags: ['AI Studio & Quality Verification'],
          requestBody: {
            required: false,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    angles: { type: 'array', items: { type: 'object' } },
                    productId: { type: 'string', example: 'prod_01' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Composite GI compliance report, anti-powerloom proof, and SHA-256 provenance certificate hash.' }
          }
        }
      },
      '/api/v1/ai/camera/upload': {
        post: {
          summary: 'Camera Image Ingestion & SHA-256 Provenance Asset Registration',
          tags: ['AI Studio & Quality Verification'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    fileName: { type: 'string', example: 'angle_texture.jpg' },
                    angle: { type: 'string', example: 'texture' },
                    imageBase64: { type: 'string', example: 'data:image/jpeg;base64,...' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Registered asset URL, SHA-256 hash, and dimensions.' }
          }
        }
      },
      '/api/v1/webhooks/gem': {
        post: {
          summary: 'Government e-Marketplace (GeM) Tender Ingestion',
          tags: ['Government System Webhooks'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    tenderRef: { type: 'string', example: 'GEM/2026/B/894120' },
                    issuingMinistry: { type: 'string', example: 'Ministry of Culture' },
                    title: { type: 'string', example: 'Corporate Gifting: 300 Dhokra Brass Figurines' },
                    category: { type: 'string', example: 'Metal Crafts' },
                    quantity: { type: 'number', example: 300 },
                    budgetPerUnit: { type: 'number', example: 1800 },
                    deadline: { type: 'string', example: '2026-11-20' }
                  }
                }
              }
            }
          },
          responses: {
            '201': { description: 'GeM tender ingested into Karighar.' }
          }
        }
      },
      '/api/v1/webhooks/pfms': {
        post: {
          summary: 'Public Financial Management System (PFMS) Bank Settlement Callback',
          tags: ['Government System Webhooks'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    orderId: { type: 'string', example: 'ORD-2026-9041' },
                    amount: { type: 'number', example: 8500 },
                    pfmsAckNo: { type: 'string', example: 'PFMS-ACK-2026-98124' },
                    utrNumber: { type: 'string', example: 'SBIN00412891241' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Settlement confirmed by Core Banking.' }
          }
        }
      },
      '/api/v1/webhooks/icegate': {
        post: {
          summary: 'DGFT ICEGATE Customs Clearance Approval Webhook',
          tags: ['Government System Webhooks'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    shippingBillNumber: { type: 'string', example: 'SB-IN-VAR-2026-4401' },
                    orderId: { type: 'string', example: 'ORD-2026-9041' },
                    destinationCountry: { type: 'string', example: 'United States' },
                    portOfExport: { type: 'string', example: 'IGI International Airport (DEL), New Delhi' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Customs clearance granted.' }
          }
        }
      },
      '/api/v1/blockchain/blocks': {
        get: {
          summary: 'Retrieve Immutable Blockchain Blocks',
          tags: ['Blockchain & Trust Architecture'],
          description: 'Inspect the MoSJE Sovereign Subnet block chain, Merkle roots, PoA validator signatures, and confirmed transactions.',
          responses: {
            '200': { description: 'Blocks retrieved successfully with Merkle roots.' }
          }
        }
      },
      '/api/v1/blockchain/tx/{hash}': {
        get: {
          summary: 'Inspect Specific Blockchain Transaction',
          tags: ['Blockchain & Trust Architecture'],
          parameters: [
            { name: 'hash', in: 'path', required: true, schema: { type: 'string' }, description: 'Transaction Hash' }
          ],
          responses: {
            '200': { description: 'Transaction details with cryptographic proof.' },
            '404': { description: 'Transaction not found.' }
          }
        }
      },
      '/api/v1/admin/audit-logs': {
        get: {
          summary: 'Retrieve CERT-In Compliant Hash-Chained Audit Trail',
          tags: ['CERT-In Compliance & Audit'],
          description: 'Inspect the tamper-evident JSONL audit trail with SHA-256 hash-chaining for MoSJE cybersecurity and regulatory compliance.',
          parameters: [
            { name: 'limit', in: 'query', schema: { type: 'integer', default: 50 }, description: 'Number of recent audit events to retrieve' }
          ],
          responses: {
            '200': { description: 'Audit trail records retrieved with cryptographic integrity hashes.' }
          }
        }
      },
      '/api/v1/admin/db/stats': {
        get: {
          summary: 'Inspect Database Architecture & Engine Telemetry',
          tags: ['Database & Cloud Infrastructure'],
          description: 'Inspect live storage engine status, atomic file-swap verification, entity row counts, and embedded relational SQLite metrics.',
          responses: {
            '200': { description: 'Database storage metrics and engine telemetry.' }
          }
        }
      },
      '/api/v1/auth/register': {
        post: {
          summary: 'Register New Artisan or Buyer Account',
          tags: ['Authentication & Identity'],
          description: 'Registers a new user account with role-specific profile data, password hashing, and JWT token issuance.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  required: ['fullName', 'phone'],
                  properties: {
                    fullName: { type: 'string', example: 'Master Ramdev Varma' },
                    phone: { type: 'string', example: '+91 98765 43210' },
                    email: { type: 'string', example: 'ramdev@karighar.gov.in' },
                    password: { type: 'string', example: 'karighar2026' },
                    role: { type: 'string', enum: ['ARTISAN', 'BUYER'], default: 'ARTISAN' },
                    craftCategory: { type: 'string', example: 'Textiles & Weaves' },
                    clusterLocation: { type: 'string', example: 'Varanasi, Uttar Pradesh' },
                    organization: { type: 'string', example: 'FabIndia Overseas' }
                  }
                }
              }
            }
          },
          responses: {
            '201': { description: 'User account created and JWT issued.' },
            '400': { description: 'Validation error or existing account.' }
          }
        }
      },
      '/api/v1/auth/login': {
        post: {
          summary: 'Authenticate User via Password or Quick Role',
          tags: ['Authentication & Identity'],
          description: 'Authenticates a user via phone/email and password, or 1-tap evaluator persona role.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    email: { type: 'string', example: 'ramdev@karighar.gov.in' },
                    phone: { type: 'string', example: '+91 98765 43210' },
                    password: { type: 'string', example: 'karighar2026' },
                    role: { type: 'string', example: 'ARTISAN' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'JWT authentication token and user profile.' },
            '400': { description: 'Invalid credentials.' }
          }
        }
      },
      '/api/v1/auth/send-otp': {
        post: {
          summary: 'Request Mobile OTP for Authentication',
          tags: ['Authentication & Identity'],
          description: 'Generates and delivers a 4-digit verification code to the mobile number with 5-minute TTL.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  required: ['phone'],
                  properties: {
                    phone: { type: 'string', example: '+91 98765 43210' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'OTP dispatched successfully.' }
          }
        }
      },
      '/api/v1/auth/verify-otp': {
        post: {
          summary: 'Verify Mobile OTP & Authenticate Session',
          tags: ['Authentication & Identity'],
          description: 'Verifies the 4-digit OTP, auto-provisions or retrieves user account, and mints session JWT.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  required: ['phone', 'otp'],
                  properties: {
                    phone: { type: 'string', example: '+91 98765 43210' },
                    otp: { type: 'string', example: '7829' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'OTP verified and session token returned.' },
            '400': { description: 'Invalid or expired OTP.' }
          }
        }
      },
      '/api/v1/auth/me': {
        get: {
          summary: 'Get Current Authenticated User Profile',
          tags: ['Authentication & Identity'],
          description: 'Decodes JWT Bearer token and returns authenticated user identity, role, and permissions.',
          parameters: [
            { name: 'Authorization', in: 'header', required: true, schema: { type: 'string', example: 'Bearer <token>' } }
          ],
          responses: {
            '200': { description: 'Current user profile.' },
            '401': { description: 'Unauthorized / invalid token.' }
          }
        }
      },
      '/api/v1/auth/verify-artisan': {
        post: {
          summary: 'Verify Aadhaar & PM-Vishwakarma Biometric e-KYC',
          tags: ['Authentication & Identity'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    aadhaarNumber: { type: 'string', example: '998241028412' },
                    artisanId: { type: 'string', example: 'art_ramdev_01' },
                    craftCategory: { type: 'string', example: 'Handloom Textiles' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Aadhaar biometric e-KYC verification result.' }
          }
        }
      },
      '/api/v1/bhashini/languages': {
        get: {
          summary: 'List All 22 Scheduled Indian Languages + Bihari Regional Dialects',
          tags: ['Bhashini & Voice AI'],
          description: 'Fetches the complete matrix of 26 supported Indian languages including Hindi, Maithili, Bhojpuri, Magahi, Angika, Tamil, Bengali, Telugu, etc., with ASR, NMT, and TTS capabilities.',
          responses: {
            '200': { description: 'Supported languages catalog with ISO codes, native scripts, and regional flags.' }
          }
        }
      },
      '/api/v1/bhashini/asr': {
        post: {
          summary: 'Automatic Speech Recognition (Speech-to-Text)',
          tags: ['Bhashini & Voice AI'],
          description: 'Transcribes base64 audio into native text using Bhashini ULCA / Dhruva inference across 26 Indian languages and Bihari dialects.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    audioBase64: { type: 'string', example: 'UklGRiQAAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQAAAAA=' },
                    languageCode: { type: 'string', enum: ['bho', 'mai', 'mag', 'anp', 'hi', 'ta', 'bn', 'te', 'mr', 'gu', 'kn', 'ml', 'or', 'pa', 'as', 'ur', 'sa', 'en'], example: 'bho' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Recognized text transcription with confidence score and dialect identification.' }
          }
        }
      },
      '/api/v1/bhashini/translate': {
        post: {
          summary: 'Indic Machine Translation (NMT)',
          tags: ['Bhashini & Voice AI'],
          description: 'Translates artisan text between any pair of Indic/Bihari languages and English using Bhashini NMT models.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  required: ['text'],
                  properties: {
                    text: { type: 'string', example: 'हमार बैंक खाता के बैलेंस केतना बा?' },
                    sourceLang: { type: 'string', example: 'bho' },
                    targetLang: { type: 'string', example: 'en' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Translated text output.' }
          }
        }
      },
      '/api/v1/bhashini/tts': {
        post: {
          summary: 'Text-to-Speech Synthesis (TTS)',
          tags: ['Bhashini & Voice AI'],
          description: 'Synthesizes natural mother-tongue spoken audio from text using Bhashini TTS neural voices (male/female).',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  required: ['text'],
                  properties: {
                    text: { type: 'string', example: 'प्रणाम! आपके बैंक खाते में ₹48,500 जमा हो चुके हैं।' },
                    languageCode: { type: 'string', example: 'mai' },
                    gender: { type: 'string', enum: ['female', 'male'], default: 'female' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Base64 WAV audio payload for immediate web and mobile playback.' }
          }
        }
      },
      '/api/v1/bhashini/voice-assistant': {
        post: {
          summary: 'Setu Didi Unified Multilingual Conversational Voice Assistant',
          tags: ['Bhashini & Voice AI'],
          description: 'Full voice loop: Mother-tongue speech/text input -> Intent resolution (DBT, loom orders, B2B quotes, PM-Vishwakarma subsidies) -> Mother-tongue dialect response -> Synthesized audio speech output.',
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    query: { type: 'string', example: 'हमार बैंक खाता के बैलेंस केतना बा?' },
                    languageCode: { type: 'string', example: 'bho' },
                    gender: { type: 'string', enum: ['female', 'male'], default: 'female' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Complete conversational response with localized text, English translation, UI route, and audioBase64.' }
          }
        }
      }
    }
  };
}


/**
 * Generate a responsive interactive HTML API documentation portal
 */
function renderDocsHtml() {
  const spec = getOpenApiSpec();
  const specJson = JSON.stringify(spec);

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Karighar — REST API Gateway & Swagger Explorer</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@700;900&family=Plus+Jakarta+Sans:wght@400;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
  <style>
    :root {
      --saffron: #E8833A;
      --saffron-dark: #C66823;
      --teal: #1A6B6A;
      --teal-dark: #124D4C;
      --bg: #0F172A;
      --surface: #1E293B;
      --surface-border: #334155;
      --text-main: #F8FAFC;
      --text-muted: #94A3B8;
      --accent-green: #10B981;
      --accent-blue: #38BDF8;
      --accent-purple: #A855F7;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Plus Jakarta Sans', sans-serif;
      background-color: var(--bg);
      color: var(--text-main);
      padding: 0;
      margin: 0;
      line-height: 1.5;
    }
    header {
      background: linear-gradient(135deg, #1E293B 0%, #0F172A 100%);
      border-bottom: 1px solid var(--surface-border);
      padding: 24px 32px;
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: center;
      gap: 16px;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .brand-title {
      font-family: 'Cinzel', serif;
      font-size: 24px;
      font-weight: 900;
      color: var(--saffron);
      letter-spacing: 1px;
    }
    .badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 10px;
      border-radius: 9999px;
      font-size: 11px;
      font-weight: 700;
      letter-spacing: 0.5px;
    }
    .badge-tls {
      background: rgba(16, 185, 129, 0.15);
      color: var(--accent-green);
      border: 1px solid rgba(16, 185, 129, 0.3);
    }
    .badge-sih {
      background: rgba(232, 131, 58, 0.15);
      color: var(--saffron);
      border: 1px solid rgba(232, 131, 58, 0.3);
    }
    .container {
      max-width: 1280px;
      margin: 0 auto;
      padding: 32px 24px;
    }
    .hero {
      background: var(--surface);
      border: 1px solid var(--surface-border);
      border-radius: 16px;
      padding: 24px;
      margin-bottom: 32px;
    }
    .hero h1 {
      font-size: 22px;
      margin-bottom: 8px;
    }
    .hero p {
      color: var(--text-muted);
      font-size: 14px;
      max-width: 800px;
    }
    .endpoint-card {
      background: var(--surface);
      border: 1px solid var(--surface-border);
      border-radius: 12px;
      margin-bottom: 16px;
      overflow: hidden;
      transition: border-color 0.2s;
    }
    .endpoint-card:hover {
      border-color: var(--teal);
    }
    .endpoint-header {
      padding: 16px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
      user-select: none;
    }
    .endpoint-meta {
      display: flex;
      align-items: center;
      gap: 12px;
      font-family: 'JetBrains Mono', monospace;
      font-size: 13px;
    }
    .method-pill {
      font-weight: 800;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 11px;
    }
    .get { background: rgba(56, 189, 248, 0.2); color: var(--accent-blue); }
    .post { background: rgba(16, 185, 129, 0.2); color: var(--accent-green); }
    .patch { background: rgba(168, 85, 247, 0.2); color: var(--accent-purple); }
    .endpoint-desc {
      color: var(--text-muted);
      font-size: 13px;
    }
    .endpoint-body {
      padding: 20px;
      border-top: 1px solid var(--surface-border);
      background: rgba(15, 23, 42, 0.6);
      display: none;
    }
    .endpoint-body.open {
      display: block;
    }
    .action-btn {
      background: var(--teal);
      color: #fff;
      border: none;
      padding: 8px 16px;
      border-radius: 8px;
      font-weight: 700;
      font-size: 12px;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: opacity 0.2s;
    }
    .action-btn:hover { opacity: 0.9; }
    .action-btn.secondary {
      background: transparent;
      border: 1px solid var(--surface-border);
      color: var(--text-muted);
    }
    pre {
      background: #0B1120;
      padding: 14px;
      border-radius: 8px;
      font-family: 'JetBrains Mono', monospace;
      font-size: 12px;
      color: #E2E8F0;
      overflow-x: auto;
      margin-top: 10px;
      border: 1px solid #1E293B;
    }
    textarea {
      width: 100%;
      height: 100px;
      background: #0B1120;
      border: 1px solid var(--surface-border);
      border-radius: 8px;
      color: #E2E8F0;
      padding: 10px;
      font-family: 'JetBrains Mono', monospace;
      font-size: 12px;
      margin-top: 6px;
      resize: vertical;
    }
    .response-box {
      margin-top: 14px;
    }
    .status-badge {
      font-size: 11px;
      font-weight: 800;
      padding: 2px 6px;
      border-radius: 4px;
      margin-left: 8px;
    }
    .status-200 { background: var(--accent-green); color: #000; }
    .status-400 { background: #EF4444; color: #fff; }
  </style>
</head>
<body>
  <header>
    <div class="brand">
      <div class="brand-title">KARIGHAR API GATEWAY</div>
      <span class="badge badge-tls">🔒 TLS 1.3 ENCRYPTED</span>
      <span class="badge badge-sih">SIH 2026 #26090</span>
    </div>
    <div>
      <a href="/api/v1/openapi.json" target="_blank" class="action-btn secondary">📥 Download OpenAPI 3.0 Spec (JSON)</a>
      <a href="/" target="_blank" class="action-btn" style="background: var(--saffron);">📱 Open Karighar App</a>
    </div>
  </header>

  <div class="container">
    <div class="hero">
      <h1>🏛️ Ministry of Social Justice & Empowerment — Developer Portal</h1>
      <p>Interactive OpenAPI 3.0 Swagger explorer. Evaluators can test live endpoints, run Varta-AI wage calculations, inspect SHA-256 cryptographic provenance, test PM-Vishwakarma Aadhaar KYC, and ingest Government e-Marketplace (GeM) webhooks directly.</p>
    </div>

    <div id="endpoints-list"></div>
  </div>

  <script>
    const spec = ${specJson};

    function renderEndpoints() {
      const container = document.getElementById('endpoints-list');
      let html = '';

      for (const [path, methods] of Object.entries(spec.paths)) {
        for (const [method, details] of Object.entries(methods)) {
          const methodUpper = method.toUpperCase();
          const endpointId = 'ep_' + Math.random().toString(36).substring(2, 9);
          const hasBody = details.requestBody && details.requestBody.content && details.requestBody.content['application/json'];
          let defaultBody = '';
          if (hasBody) {
            const props = details.requestBody.content['application/json'].schema.properties || {};
            const sample = {};
            for (const [k, v] of Object.entries(props)) {
              sample[k] = v.example !== undefined ? v.example : (v.type === 'number' ? 100 : 'sample');
            }
            defaultBody = JSON.stringify(sample, null, 2);
          }

          html += \`
            <div class="endpoint-card">
              <div class="endpoint-header" onclick="toggleEndpoint('\${endpointId}')">
                <div class="endpoint-meta">
                  <span class="method-pill \${method}">\${methodUpper}</span>
                  <span>\${path}</span>
                </div>
                <div class="endpoint-desc">\${details.summary || ''}</div>
              </div>
              <div class="endpoint-body" id="\${endpointId}">
                <p style="font-size: 13px; color: #94A3B8; margin-bottom: 12px;">\${details.summary || ''}</p>
                \${hasBody ? \`
                  <label style="font-size: 11px; font-weight: bold; color: #38BDF8;">REQUEST BODY (JSON):</label>
                  <textarea id="\${endpointId}_body">\${defaultBody}</textarea>
                \` : ''}
                <div style="margin-top: 12px;">
                  <button class="action-btn" onclick="executeRequest('\${methodUpper}', '\${path}', '\${endpointId}', \${hasBody})">
                    ⚡ Execute Request
                  </button>
                </div>
                <div class="response-box" id="\${endpointId}_res" style="display: none;">
                  <div style="font-size: 11px; font-weight: bold; color: #94A3B8; margin-bottom: 4px;">
                    RESPONSE: <span id="\${endpointId}_status"></span>
                  </div>
                  <pre id="\${endpointId}_output"></pre>
                </div>
              </div>
            </div>
          \`;
        }
      }
      container.innerHTML = html;
    }

    function toggleEndpoint(id) {
      const el = document.getElementById(id);
      el.classList.toggle('open');
    }

    async function executeRequest(method, path, id, hasBody) {
      const resBox = document.getElementById(id + '_res');
      const statusSpan = document.getElementById(id + '_status');
      const outputPre = document.getElementById(id + '_output');

      resBox.style.display = 'block';
      statusSpan.innerHTML = '<span style="color: #38BDF8;">Sending...</span>';
      outputPre.textContent = 'Processing request...';

      let url = path;
      // Handle simple path params
      if (url.includes('{id}')) url = url.replace('{id}', 'prod_01');
      if (url.includes('{artisanId}')) url = url.replace('{artisanId}', 'art_ramdev_01');

      let bodyData = null;
      if (hasBody) {
        try {
          bodyData = document.getElementById(id + '_body').value;
          JSON.parse(bodyData); // validate
        } catch (e) {
          statusSpan.innerHTML = '<span class="status-badge status-400">Invalid JSON</span>';
          outputPre.textContent = 'Error parsing request body JSON: ' + e.message;
          return;
        }
      }

      const startTime = performance.now();
      try {
        const resp = await fetch(url, {
          method: method,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: hasBody ? bodyData : null
        });

        const elapsed = Math.round(performance.now() - startTime);
        const data = await resp.json();

        statusSpan.innerHTML = \`<span class="status-badge status-\${resp.status >= 200 && resp.status < 300 ? '200' : '400'}">\${resp.status} \${resp.statusText}</span> (\${elapsed}ms)\`;
        outputPre.textContent = JSON.stringify(data, null, 2);
      } catch (err) {
        statusSpan.innerHTML = '<span class="status-badge status-400">Network Error</span>';
        outputPre.textContent = err.toString();
      }
    }

    renderEndpoints();
  </script>
</body>
</html>`;
}

module.exports = {
  getOpenApiSpec,
  renderDocsHtml
};
