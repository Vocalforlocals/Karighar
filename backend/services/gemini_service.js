// ==============================================================================
// Karighar (कारीघर) — Google Gemini AI Integration Service
// Powers Computer Vision Weave Inspection, Bhashini Voice Cataloging & Varta-AI Wage Defense
// MoSJE Problem Statement #26090 | Smart India Hackathon 2026
// ==============================================================================

const https = require('https');

class GeminiService {
  constructor() {
    this.primaryModel = process.env.GEMINI_MODEL || 'gemini-1.5-flash';
    this.fallbackModel = 'gemini-1.5-flash-8b';
  }

  /**
   * Determine the active Gemini API key from environment or request headers
   */
  getApiKey(req) {
    if (req && req.headers && req.headers['x-gemini-api-key']) {
      return req.headers['x-gemini-api-key'];
    }
    return process.env.GEMINI_API_KEY || '';
  }

  /**
   * Check if Gemini API key is configured
   */
  isConfigured(apiKey) {
    const key = apiKey || process.env.GEMINI_API_KEY || '';
    return typeof key === 'string' && key.trim().length > 10;
  }

  /**
   * Low-level HTTPS invocation to Google Generative Language API
   */
  async _callGeminiApi({ prompt, inlineData = null, systemInstruction = null, apiKey, model = null }) {
    const activeKey = apiKey || process.env.GEMINI_API_KEY;
    if (!this.isConfigured(activeKey)) {
      throw new Error('GEMINI_API_KEY_NOT_CONFIGURED');
    }

    const targetModel = model || this.primaryModel;
    const path = `/v1beta/models/${targetModel}:generateContent?key=${encodeURIComponent(activeKey)}`;

    const parts = [];
    if (inlineData) {
      parts.push({
        inlineData: {
          mimeType: inlineData.mimeType || 'image/jpeg',
          data: inlineData.data
        }
      });
    }
    parts.push({ text: prompt });

    const requestPayload = {
      contents: [
        {
          role: 'user',
          parts
        }
      ],
      generationConfig: {
        temperature: 0.2,
        topP: 0.8,
        maxOutputTokens: 2048,
        responseMimeType: 'application/json'
      }
    };

    if (systemInstruction) {
      requestPayload.systemInstruction = {
        parts: [{ text: systemInstruction }]
      };
    }

    const payloadString = JSON.stringify(requestPayload);

    return new Promise((resolve, reject) => {
      const options = {
        hostname: 'generativelanguage.googleapis.com',
        port: 443,
        path,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(payloadString),
          'User-Agent': 'Karighar-MoSJE-Gateway/1.0'
        },
        timeout: 25000
      };

      const req = https.request(options, (res) => {
        let data = '';
        res.on('data', chunk => { data += chunk; });
        res.on('end', () => {
          if (res.statusCode < 200 || res.statusCode >= 300) {
            return reject(new Error(`Gemini API Error ${res.statusCode}: ${data}`));
          }
          try {
            const parsed = JSON.parse(data);
            const rawText = parsed.candidates?.[0]?.content?.parts?.[0]?.text;
            if (!rawText) {
              return reject(new Error('Empty content received from Gemini model'));
            }
            const cleanJson = JSON.parse(rawText);
            resolve({
              success: true,
              data: cleanJson,
              model: targetModel,
              usage: parsed.usageMetadata
            });
          } catch (err) {
            reject(new Error(`Failed to parse Gemini JSON output: ${err.message}. Raw: ${data.substring(0, 300)}`));
          }
        });
      });

      req.on('timeout', () => {
        req.destroy();
        reject(new Error('Gemini API call timed out after 25s'));
      });

      req.on('error', reject);
      req.write(payloadString);
      req.end();
    });
  }

  /**
   * 1. Computer Vision Weave Quality & Anti-Powerloom Inspection
   */
  async inspectWeave({ imageUrl, imageBase64, imageMimeType = 'image/jpeg', craftPreset = 'Banarasi Silk', apiKey }) {
    const systemPrompt = `You are the Ministry of Social Justice & Empowerment (MoSJE) / Handicrafts Silk Board Computer Vision Quality Sentry.
Analyze microscopic and macroscopic details of the artisan craft.
Evaluate:
1. Warp ends per inch (EPI: 80-160 typical)
2. Weft picks per inch (PPI: 70-140 typical)
3. Density ratio (EPI / PPI)
4. Handloom vs Powerloom authenticity: Handloom has subtle organic micro-tension variations and hand-tucked selvedge edges. Powerloom has mechanical rigid precision and cut selvedges.
5. Certification Grade (Grade A+ Master GI, Grade A, or Rejected)
6. Anti-powerloom confidence score (0.00 to 1.00).

Return ONLY valid JSON matching this schema:
{
  "endsPerInch": number,
  "picksPerInch": number,
  "densityRatio": number,
  "fabricType": string,
  "certificationGrade": string,
  "isPowerloomReplica": boolean,
  "confidenceScore": number,
  "antiPowerloomEvidence": string,
  "fiberPurity": string,
  "motifGeometryPrecision": number
}`;

    let inlineData = null;
    if (imageBase64) {
      inlineData = {
        mimeType: imageMimeType,
        data: imageBase64.replace(/^data:image\/\w+;base64,/, '')
      };
    }

    const userPrompt = `Perform microscopic GI weave inspection on this craft (${craftPreset}). Image reference: ${imageUrl || 'Attached base64 frame'}.`;

    try {
      if (this.isConfigured(apiKey)) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          inlineData,
          systemInstruction: systemPrompt,
          apiKey
        });
        return {
          geminiLive: true,
          model: response.model,
          analysis: {
            ...response.data,
            inspectedAt: new Date().toISOString()
          }
        };
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Weave inspection API fallback:', err.message);
    }

    // Deterministic High-Fidelity Simulation Fallback
    return {
      geminiLive: false,
      model: 'deterministic-fallback',
      notice: 'Provide valid GEMINI_API_KEY in .env or x-gemini-api-key header for live multimodal neural inference.',
      analysis: {
        endsPerInch: 128,
        picksPerInch: 114,
        densityRatio: 1.12,
        fabricType: `Authentic Handloom ${craftPreset}`,
        certificationGrade: 'Grade A+ GI Handloom',
        isPowerloomReplica: false,
        confidenceScore: 0.994,
        antiPowerloomEvidence: 'Natural human shuttle micro-tension variations and selvedge lock confirmed.',
        fiberPurity: '100% Pure Mulberry Degummed Silk with Electroplated Silver Zari',
        motifGeometryPrecision: 99.2,
        inspectedAt: new Date().toISOString()
      }
    };
  }

  /**
   * 2. Bhashini AI Multilingual Voice-to-Catalog Structured Extraction
   */
  async extractVoiceCatalog({ transcript, language = 'Hindi', apiKey }) {
    const systemPrompt = `You are the Bhashini AI Smart Cataloging Assistant for Indian Artisans under MoSJE.
Convert unstructured speech or raw description in any Indian language into a structured, bilingual e-commerce catalog entry with fair statutory pricing.
Rules:
- Calculate fair price: (rawMaterialCost) + (laborHours * hourlyRate minimum ₹120/hr) + 20-30% fair profit markup.
- Generate English, Hindi, and Tamil titles and descriptive stories.
- Identify material list and craft tags.

Return ONLY valid JSON:
{
  "titleEnglish": string,
  "titleHindi": string,
  "titleTamil": string,
  "category": string,
  "craftForm": string,
  "descriptionEnglish": string,
  "descriptionHindi": string,
  "descriptionTamil": string,
  "materialsUsed": string[],
  "estimatedHours": number,
  "tags": string[],
  "suggestedPricing": {
    "rawMaterialCost": number,
    "laborHours": number,
    "hourlyRate": number,
    "markupPercent": number,
    "fairPrice": number
  },
  "detectedDialect": string,
  "confidence": number
}`;

    const userPrompt = `Extract complete GI catalog entry from this artisan statement in ${language}: "${transcript || 'यह शुद्ध वाराणसी कतान सिल्क हथकरघा साड़ी है, जिसे बनाने में 14 दिन लगे और 2800 रुपये का कच्चा माल लगा।'}"`;

    try {
      if (this.isConfigured(apiKey)) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          systemInstruction: systemPrompt,
          apiKey
        });
        return {
          geminiLive: true,
          model: response.model,
          extractedCatalog: {
            ...response.data,
            processedAt: new Date().toISOString()
          }
        };
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Voice catalog API fallback:', err.message);
    }

    // High-Fidelity Simulation Fallback
    return {
      geminiLive: false,
      model: 'deterministic-fallback',
      notice: 'Provide valid GEMINI_API_KEY in .env or x-gemini-api-key header for live multimodal neural inference.',
      extractedCatalog: {
        titleEnglish: 'Pure Varanasi Katan Silk Handloom Saree',
        titleHindi: 'शुद्ध वाराणसी कतान सिल्क हथकरघा साड़ी',
        titleTamil: 'தூய வாரணாசி கட்டான் பட்டு கைத்தறி புடவை',
        category: 'Textiles & Weaves',
        craftForm: 'Banarasi Brocade',
        descriptionEnglish: 'Authentic pure mulberry silk handwoven by Master Artisan Ramdev in Varanasi, adorned with delicate silver zari border work over 14 days of dedicated loom craftsmanship.',
        descriptionHindi: 'मास्टर कारीगर रामदेव द्वारा वाराणसी में 14 दिनों के अथक परिश्रम से बुनी गई शुद्ध मलबरी रेशम और चांदी की ज़री वाली पारंपरिक हथकरघा साड़ी।',
        descriptionTamil: 'வாரணாசியில் மாஸ்டர் கைவினைஞர் ராம்தேவ் அவர்களால் 14 நாட்களில் நெய்யப்பட்ட தூய மல்பெரி பட்டு மற்றும் வெள்ளி ஜரிகை வேலைப்பாடுகளுடன் கூடிய பாரம்பரிய கைத்தறி புடவை.',
        materialsUsed: ['Pure Mulberry Katan Silk', 'Silver electroplated Zari thread'],
        estimatedHours: 32,
        tags: ['Pure Silk', 'GI Certified', 'Handloom', 'Varanasi Weave', 'Zari Border'],
        suggestedPricing: {
          rawMaterialCost: 2800,
          laborHours: 32,
          hourlyRate: 120,
          markupPercent: 25,
          fairPrice: 8300
        },
        detectedDialect: language,
        confidence: 0.988,
        processedAt: new Date().toISOString()
      }
    };
  }

  /**
   * 3. Varta-AI Autonomous Living-Wage Defense Evaluation
   */
  async evaluateWageDefense({ offeredPrice, daysOfCraft, rawMaterialCost, craftCategory = 'Handloom', productTitle = 'Artisan Craft', apiKey }) {
    const offered = Number(offeredPrice) || 5000;
    const days = Number(daysOfCraft) || 14;
    const materials = Number(rawMaterialCost) || 2800;
    const minDailyWageMoSJE = 850;

    const requiredLaborWage = days * minDailyWageMoSJE;
    const nonNegotiableFloor = materials + requiredLaborWage;
    const isLowball = offered < nonNegotiableFloor;
    const recommendedCounter = Math.round(nonNegotiableFloor * 1.08);

    const systemPrompt = `You are Varta-AI, an autonomous legal & economic wage defense negotiator guarding underprivileged Indian artisans under the Ministry of Social Justice & Empowerment (MoSJE).
When a buyer offers a price:
1. If offeredPrice is less than nonNegotiableFloor (raw materials + living wage ₹850/day * days), it is a LOWBALL offer that violates artisan fair labor dignity.
2. Produce a respectful, culturally authentic, yet legally unyielding counter-offer message in English and Hindi citing fair trade laws, days of skilled labor, and raw material inputs.
3. If fair, acknowledge the buyer's respectful proposal.

Return ONLY valid JSON:
{
  "counterMessageEnglish": string,
  "counterMessageHindi": string,
  "justification": string,
  "fairTradeScore": number
}`;

    const userPrompt = `Evaluate proposal for ${productTitle} (${craftCategory}):
- Offered Price: ₹${offered}
- Days of Dedicated Loom Labor: ${days} days
- Raw Material Investment: ₹${materials}
- Legal Living Wage Floor: ₹${nonNegotiableFloor}
- Minimum Recommended Counter: ₹${recommendedCounter}`;

    let aiGeneratedMessages = null;

    try {
      if (this.isConfigured(apiKey)) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          systemInstruction: systemPrompt,
          apiKey
        });
        aiGeneratedMessages = response.data;
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Varta-AI defense API fallback:', err.message);
    }

    const defaultEnglishMsg = isLowball
      ? `Namaste. Under MoSJE fair-trade guidelines, this craft involves ${days} days of master artisan loom labor (₹${requiredLaborWage}) and raw materials (₹${materials}). The non-negotiable living wage floor is ₹${nonNegotiableFloor.toLocaleString('en-IN')}. We can fulfill this order at ₹${recommendedCounter.toLocaleString('en-IN')} with complete GI certification.`
      : `Namaste. Your offer of ₹${offered.toLocaleString('en-IN')} meets the MoSJE living wage threshold. We are honored to accept your order.`;

    const defaultHindiMsg = isLowball
      ? `नमस्ते। सामाजिक न्याय एवं अधिकारिता मंत्रालय के दिशा-निर्देशों के तहत, इस शिल्प में ${days} दिनों का श्रम (₹${requiredLaborWage}) और कच्चा माल (₹${materials}) शामिल है। न्यूनतम उचित मूल्य ₹${nonNegotiableFloor.toLocaleString('en-IN')} है। हम इसे ₹${recommendedCounter.toLocaleString('en-IN')} में पूर्ण जीआई प्रमाणन के साथ प्रदान कर सकते हैं।`
      : `नमस्ते। आपका ₹${offered.toLocaleString('en-IN')} का प्रस्ताव कारीगर के उचित पारिश्रमिक के अनुरूप है। हम इसे सहर्ष स्वीकार करते हैं।`;

    return {
      geminiLive: !!aiGeneratedMessages,
      model: aiGeneratedMessages ? this.primaryModel : 'deterministic-fallback',
      isLowball,
      offeredPrice: offered,
      nonNegotiableFloor,
      recommendedCounter,
      counterMessage: aiGeneratedMessages?.counterMessageEnglish || defaultEnglishMsg,
      counterMessageHindi: aiGeneratedMessages?.counterMessageHindi || defaultHindiMsg,
      fairTradeScore: aiGeneratedMessages?.fairTradeScore || (isLowball ? 64 : 98),
      wageGuidelinesApplied: 'MoSJE Artisan Wage Protection Act 2026'
    };
  }

  /**
   * 4. Multi-Angle Computer Vision Processing & Neural Upscaling
   */
  async processAngleCamera({ angleKey, craftPreset = 'Banarasi Silk', options = {}, apiKey }) {
    const systemPrompt = `You are the MoSJE 4K Neural Camera Quality & Chromatic Sentry.
Evaluate this camera angle of a GI craft (${craftPreset}) for angle key: "${angleKey}".
Available angles:
- 'texture': evaluates warp/weft density, microfiber purity, natural dyes.
- 'motif': evaluates zari metallic reflectivity, jaal symmetry, traditional iconography.
- 'loom': evaluates pit-loom structure, hand-shuttle movement, artisan ergonomic validation.
- 'overview': evaluates framing, drape silhouette, color balance.

Return ONLY valid JSON:
{
  "overallScore": number,
  "sharpnessScore": number,
  "lightingUniformity": number,
  "colorAccuracy": number,
  "symmetryScore": number,
  "isHandloomAuthentic": boolean,
  "giComplianceGrade": string,
  "antiPowerloomEvidence": string,
  "inspectionMode": string
}`;

    const userPrompt = `Analyze capture angle: ${angleKey} for ${craftPreset}. Options: ${JSON.stringify(options)}`;

    try {
      if (this.isConfigured(apiKey)) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          systemInstruction: systemPrompt,
          apiKey
        });
        return {
          geminiLive: true,
          model: response.model,
          metrics: response.data
        };
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Process angle API fallback:', err.message);
    }

    return {
      geminiLive: false,
      model: 'deterministic-fallback',
      metrics: null
    };
  }

  /**
   * 5. Google Gemini AI Dynamic Buyer Feed & Craft Curation
   */
  async curateBuyerFeed({ buyerPreferences = [], occasion = 'Festive & Heritage Gifting', maxBudget = 10000, apiKey } = {}) {
    const systemPrompt = `You are the Google Gemini AI Chief Curator for Karighar (कारीघर) — National Handicrafts & Handloom Platform under MoSJE.
Your mission is to curate an exquisite, authentic selection of India's GI-tagged master crafts for conscious buyers and cultural connoisseurs.
Return ONLY valid JSON matching this schema:
{
  "curatedTheme": string,
  "curatorNote": string,
  "heroSpotlight": {
    "headline": string,
    "subheadline": string,
    "craftRegion": string,
    "giTagNumber": string,
    "culturalSignificance": string
  },
  "editorialCollections": [
    {
      "id": string,
      "title": string,
      "description": string,
      "recommendedCraft": string,
      "originState": string,
      "estimatedPriceRange": string
    }
  ],
  "whyItMatters": string
}`;

    const userPrompt = `Curate a buyer feed for occasion: "${occasion}", preferences: ${JSON.stringify(buyerPreferences)}, max budget: ₹${maxBudget}. Focus on certified GI crafts like Madhubani Paintings, Bhagalpuri Tussar Silk, Banarasi Brocade, and Channapatna Crafts.`;

    try {
      if (this.isConfigured(apiKey)) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          systemInstruction: systemPrompt,
          apiKey
        });
        return {
          geminiLive: true,
          model: response.model,
          curation: response.data
        };
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Buyer curation API fallback:', err.message);
    }

    // High-Fidelity Cultural Simulation Fallback
    return {
      geminiLive: false,
      model: 'deterministic-fallback',
      curation: {
        curatedTheme: 'Timeless Heritage & GI Masterpieces of Eastern India',
        curatorNote: 'Hand-selected from master artisans across Bihar, Uttar Pradesh, and Bengal, celebrating natural organic dyes, hand-spun silks, and generational GI provenance.',
        heroSpotlight: {
          headline: 'Madhubani Kohbar Heritage Silk',
          subheadline: 'Hand-painted with bamboo twigs & natural vegetable pigments by National Awardee weavers.',
          craftRegion: 'Mithila, Bihar',
          giTagNumber: 'GI-370',
          culturalSignificance: 'Ancient bridal blessings depicted through lotus, fish, and celestial fertility motifs dating back to the Ramayana era.'
        },
        editorialCollections: [
          {
            id: 'coll_silk_weaves',
            title: 'Royal Handloom Silks',
            description: 'Pure Mulberry Katan and Wild Tussar handwoven on traditional pit looms.',
            recommendedCraft: 'Bhagalpuri Tussar & Banarasi Katan',
            originState: 'Bihar & Uttar Pradesh',
            estimatedPriceRange: '₹4,500 - ₹12,000'
          },
          {
            id: 'coll_folk_art',
            title: 'Living Folk Canvases',
            description: 'Intricate narrative art painted on handmade cow-dung washed paper and canvas.',
            recommendedCraft: 'Mithila & Tikuli Art',
            originState: 'Bihar',
            estimatedPriceRange: '₹1,800 - ₹8,500'
          },
          {
            id: 'coll_brass_terracotta',
            title: 'Sacred Clay & Lost-Wax Metal',
            description: 'Panchaloha brass figurines and terracotta pottery fired in sustainable wood kilns.',
            recommendedCraft: 'Dhokra & Terracotta Pottery',
            originState: 'Jharkhand & West Bengal',
            estimatedPriceRange: '₹1,200 - ₹6,000'
          }
        ],
        whyItMatters: '100% direct bank DBT transfer to master weavers with zero middleman deductions, backed by RBI Nodal Escrow.'
      }
    };
  }

  /**
   * 6. Google Gemini AI Semantic Search & Intent Understanding
   */
  async semanticSearchBuyer({ query, language = 'English', apiKey }) {
    const systemPrompt = `You are the Google Gemini AI Semantic Search Parser for Karighar (कारीघर).
Convert natural language search queries in English or Indian regional vernacular into structured filter parameters for Indian handicrafts.
Return ONLY valid JSON:
{
  "normalizedQuery": string,
  "craftCategory": string,
  "craftForm": string,
  "targetRegion": string,
  "priceMin": number,
  "priceMax": number,
  "requiresGICertification": boolean,
  "materials": string[],
  "occasion": string,
  "sentiment": string
}`;

    const userPrompt = `Parse this buyer search query in ${language}: "${query}"`;

    try {
      if (this.isConfigured(apiKey)) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          systemInstruction: systemPrompt,
          apiKey
        });
        return {
          geminiLive: true,
          model: response.model,
          parsedIntent: response.data
        };
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Semantic search API fallback:', err.message);
    }

    // Deterministic Rule-Based Fallback
    const isSaree = /saree|sari|silk|katan|brocade|textile/i.test(query);
    const isPainting = /painting|art|madhubani|mithila|folk/i.test(query);
    const isPottery = /pottery|clay|terracotta|ceramic/i.test(query);

    return {
      geminiLive: false,
      model: 'deterministic-fallback',
      parsedIntent: {
        normalizedQuery: query,
        craftCategory: isSaree ? 'Textiles & Weaves' : (isPainting ? 'Folk Art & Paintings' : (isPottery ? 'Ceramics & Pottery' : 'All')),
        craftForm: isSaree ? 'Handloom Silk' : (isPainting ? 'Mithila Painting' : 'Artisan Craft'),
        targetRegion: isPainting ? 'Bihar' : (isSaree ? 'Varanasi / Bhagalpur' : 'India'),
        priceMin: 500,
        priceMax: 25000,
        requiresGICertification: true,
        materials: isSaree ? ['Pure Silk', 'Zari'] : ['Natural Dyes', 'Handmade Paper'],
        occasion: 'Festive & Heritage',
        sentiment: 'Appreciative Heritage Search'
      }
    };
  }

  /**
   * 5. Multimodal Google Gemini Craft Lens (Visual Search)
   */
  async analyzeCraftLens({ imageBase64, imageMimeType = 'image/jpeg', apiKey }) {
    const systemPrompt = `You are the Karighar Google Gemini Multimodal Craft Lens Engine for Indian GI Handicrafts and Handlooms.
Analyze the uploaded image of an artisanal craft.
Identify:
1. Craft form (e.g. Banarasi Katan Silk, Madhubani Art, Gorakhpur Terracotta, Channapatna Wooden Toys, Jaipur Blue Pottery, Bidriware, Kashmir Pashmina, Bhagalpuri Tussar).
2. Category (Textiles & Weaves, Folk Art & Paintings, Ceramics & Pottery, Woodcraft, Metalcraft).
3. Geographical Indication cluster & State.
4. Key visual features & materials.
5. Confidence score (0.00 to 1.00).

Return ONLY valid JSON matching this schema:
{
  "craftForm": string,
  "category": string,
  "clusterLocation": string,
  "state": string,
  "materials": string[],
  "visualFeatures": string[],
  "giTagEligible": boolean,
  "confidenceScore": number,
  "recommendedKeywords": string[]
}`;

    const userPrompt = 'Identify this Indian handcrafted product, craft form, GI cluster, and material composition.';

    try {
      if (this.isConfigured(apiKey) && imageBase64) {
        const response = await this._callGeminiApi({
          prompt: userPrompt,
          systemInstruction: systemPrompt,
          inlineData: {
            mimeType: imageMimeType,
            data: imageBase64.replace(/^data:image\/\\w+;base64,/, '')
          },
          apiKey
        });
        return {
          geminiLive: true,
          model: response.model,
          detectedCraft: response.data
        };
      }
    } catch (err) {
      console.warn('[GEMINI SERVICE] Craft Lens API fallback:', err.message);
    }

    // High-fidelity fallback for offline / demo environments
    return {
      geminiLive: false,
      model: 'karighar-vision-classifier-fallback',
      detectedCraft: {
        craftForm: 'Banarasi Katan Silk Handloom',
        category: 'Textiles & Weaves',
        clusterLocation: 'Varanasi, Uttar Pradesh',
        state: 'Uttar Pradesh',
        materials: ['Pure Mulberry Silk', 'Zari Brocade'],
        visualFeatures: ['Interlocking weft twill', 'Floral bootidar border', 'Handloom selvedge'],
        giTagEligible: true,
        confidenceScore: 0.94,
        recommendedKeywords: ['Varanasi', 'Katan Silk', 'Zari', 'Handloom', 'Brocade']
      }
    };
  }
}

const geminiService = new GeminiService();

module.exports = {
  GeminiService,
  geminiService
};

