import '../l10n/locale_manager.dart';

class ProductDraft {
  final String id;
  final String title;
  final String category;
  final String craftForm;
  final String description;
  final String descriptionHindi;
  final double price;
  final double rawMaterialCost;
  final int estimatedLoomHours;
  final double hourlyRate;
  final List<String> tags;
  final String previewImage;
  final String provenanceHash;

  ProductDraft({
    required this.id,
    required this.title,
    required this.category,
    required this.craftForm,
    required this.description,
    required this.descriptionHindi,
    required this.price,
    required this.rawMaterialCost,
    required this.estimatedLoomHours,
    this.hourlyRate = 120.0,
    required this.tags,
    required this.previewImage,
    required this.provenanceHash,
  });

  double get laborCost => estimatedLoomHours * hourlyRate;
  double get fairWageFloor => rawMaterialCost + laborCost;
}

class SetuDidiResponse {
  final String userQuery;
  final String responseText;
  final String? englishTranslation;
  final String actionRoute;
  final bool isProductListing;
  final ProductDraft? productDraft;
  final String? actionLabel;

  SetuDidiResponse({
    required this.userQuery,
    required this.responseText,
    this.englishTranslation,
    required this.actionRoute,
    this.isProductListing = false,
    this.productDraft,
    this.actionLabel,
  });
}

class SetuDidiAiEngine {
  /// Analyzes any spoken or typed voice instruction and generates intelligent responses or craft listings.
  static SetuDidiResponse processVoiceCommand(String rawInput, {AppLanguage lang = AppLanguage.hindi}) {
    final query = rawInput.trim();
    final lower = query.toLowerCase();

    // 1. PRODUCT LISTING & VOICE DESCRIPTION COMMANDS
    final isListingIntent = lower.contains('list') ||
        lower.contains('लिस्ट') ||
        lower.contains('add') ||
        lower.contains('जोड़ो') ||
        lower.contains('bechna') ||
        lower.contains('बेचना') ||
        lower.contains('product') ||
        lower.contains('प्रोडक्ट') ||
        lower.contains('create') ||
        lower.contains('बनाओ') ||
        lower.contains('upload') ||
        lower.contains('अपलोड') ||
        lower.contains('description') ||
        lower.contains('विवरण') ||
        lower.contains('saree') ||
        lower.contains('साड़ी') ||
        lower.contains('painting') ||
        lower.contains('पेंटिंग') ||
        lower.contains('pottery') ||
        lower.contains('पॉटरी') ||
        lower.contains('shawl') ||
        lower.contains('शॉल') ||
        lower.contains('toy') ||
        lower.contains('खिलौना') ||
        lower.contains('craft') ||
        lower.contains('शिल्प') ||
        lower.contains('दुकान') ||
        lower.contains('सामान');

    if (isListingIntent) {
      return _generateCraftListing(query, lower, lang);
    }

    // 2. LOOM & ORDERS
    if (lower.contains('order') ||
        lower.contains('ऑर्डर') ||
        lower.contains('loom') ||
        lower.contains('लूम') ||
        lower.contains('करघा') ||
        lower.contains('बुनाई')) {
      return SetuDidiResponse(
        userQuery: query,
        responseText: 'हाँ काका/दीदी! आपके 2 हथकरघा ऑर्डर सक्रिय हैं। 1 नया बनारसी कतान सिल्क साड़ी ऑर्डर आज प्राप्त हुआ है।',
        englishTranslation: 'Yes! You have 2 active loom orders. 1 new Banarasi Katan Silk saree order received today.',
        actionRoute: '/artisan/orders',
        actionLabel: 'View Loom Orders',
      );
    }

    // 3. DBT BANK BALANCE & EARNINGS
    if (lower.contains('balance') ||
        lower.contains('बैलेंस') ||
        lower.contains('खाता') ||
        lower.contains('रुपया') ||
        lower.contains('पैसे') ||
        lower.contains('dbt') ||
        lower.contains('bank') ||
        lower.contains('कमाई')) {
      return SetuDidiResponse(
        userQuery: query,
        responseText: 'प्रणाम! आपके आधार-लिंक्ड बैंक खाते में ₹48,500 की सीधी डीबीटी राशि जमा है। सभी लेनदेन सुरक्षित हैं।',
        englishTranslation: 'Greetings! Your Aadhaar-linked bank account has ₹48,500 safely deposited via direct DBT.',
        actionRoute: '/artisan/earnings',
        actionLabel: 'Open DBT Bank Rails',
      );
    }

    // 4. BUYER CHAT & NEGOTIATION
    if (lower.contains('chat') ||
        lower.contains('चैट') ||
        lower.contains('quote') ||
        lower.contains('कोटेशन') ||
        lower.contains('buyer') ||
        lower.contains('खरीदार') ||
        lower.contains('fabindia') ||
        lower.contains('बात')) {
      return SetuDidiResponse(
        userQuery: query,
        responseText: 'FabIndia ने 25 साड़ियों के लिए ₹7,200/पीस का प्रस्ताव भेजा है। आप बायर चैट में जाकर सीधे स्वीकार या काउंटर कर सकते हैं।',
        englishTranslation: 'FabIndia has offered ₹7,200/unit for 25 sarees. You can accept or send a counter offer in Buyer Chat.',
        actionRoute: '/artisan/chat',
        actionLabel: 'Open Buyer Chat',
      );
    }

    // 5. GOVT SCHEMES & VISHWAKARMA SUBSIDY
    if (lower.contains('subsidy') ||
        lower.contains('सब्सिडी') ||
        lower.contains('vishwakarma') ||
        lower.contains('विश्वकर्मा') ||
        lower.contains('loan') ||
        lower.contains('लोन') ||
        lower.contains('grant') ||
        lower.contains('अनुदान') ||
        lower.contains('योजना')) {
      return SetuDidiResponse(
        userQuery: query,
        responseText: 'पीएम-विश्वकर्मा योजना के तहत आपका ₹6,800 का औजार व कच्चा माल अनुदान स्वीकृत हो चुका है। 5% पर ₹1 लाख का क्रेडिट उपलब्ध है।',
        englishTranslation: 'Under PM-Vishwakarma scheme, your ₹6,800 raw material tooling grant is approved by MoSJE.',
        actionRoute: '/artisan/credit',
        actionLabel: 'View Vishwakarma Credit',
      );
    }

    // 6. MARKETPLACE BROWSING
    if (lower.contains('market') ||
        lower.contains('बाज़ार') ||
        lower.contains('shop') ||
        lower.contains('खरीदारी')) {
      return SetuDidiResponse(
        userQuery: query,
        responseText: 'कारीघर बाज़ार खुल रहा है जहाँ खरीदार सीधे देश भर के प्रमाणित शिल्पकारों से हस्तशिल्प खरीदते हैं।',
        englishTranslation: 'Opening Karighar Buyer Marketplace where connoisseurs buy certified crafts directly.',
        actionRoute: '/buyer',
        actionLabel: 'Browse Marketplace',
      );
    }

    // 7. DEFAULT GUIDANCE & GENERAL ASSISTANT
    return SetuDidiResponse(
      userQuery: query,
      responseText: 'नमस्ते! मैं आपकी सेतु दीदी हूँ। आप मुझसे कह सकते हैं: "बनारसी सिल्क साड़ी 7500 रुपये में लिस्ट करो", "खाता बैलेंस बताओ", या "आज के ऑर्डर दिखाओ"।',
      englishTranslation: 'Namaste! I am your Setu Didi. You can say: "List a Banarasi silk saree for ₹7,500", "Check bank balance", or "Show today\'s loom orders".',
      actionRoute: '/artisan/studio',
      actionLabel: 'Open AI Studio',
    );
  }

  static SetuDidiResponse _generateCraftListing(String originalQuery, String lower, AppLanguage lang) {
    // 1. Extract Price from voice command
    double extractedPrice = 0.0;
    final priceRegex = RegExp(r'(\d+[\d,]*)');
    final match = priceRegex.firstMatch(lower.replaceAll(',', ''));
    if (match != null) {
      extractedPrice = double.tryParse(match.group(1)!) ?? 0.0;
    }

    // 2. Identify Craft Archetype
    String title;
    String category;
    String craftForm;
    String descEn;
    String descHi;
    double defaultPrice;
    double rawMaterialCost;
    int estimatedHours;
    List<String> tags;
    String previewImage;

    if (lower.contains('madhubani') || lower.contains('मधुबनी') || lower.contains('mithila') || lower.contains('मिथिला') || lower.contains('painting') || lower.contains('पेंटिंग')) {
      title = 'Mithila Handpainted Royal Peacock Folk Art Canvas';
      category = 'Folk Art & Paintings';
      craftForm = 'Mithila Folk Painting';
      defaultPrice = 3500.0;
      rawMaterialCost = 750.0;
      estimatedHours = 22;
      previewImage = 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80';
      descEn = 'Handcrafted on natural handmade paper using fine bamboo nibs and twig brushes with plant-derived organic pigment dyes by heritage artisans in Madhubani, Bihar. Depicts royal peacock and lotus motifs symbolizing sacred harmony and prosperity, fully backed by MoSJE fair-wage standards.';
      descHi = 'बिहार के मधुबनी की पारंपरिक शैली में प्राकृतिक वानस्पतिक रंगों और बांस की कलम से हाथ से तैयार की गई सुंदर मोर पेंटिंग। यह पर्यावरण-अनुकूल और राष्ट्रीय पुरस्कार प्राप्त शिल्पकारों द्वारा निर्मित जीआई प्रमाणित कृति है।';
      tags = ['GI Certified', 'Natural Pigments', 'Handmade Paper', 'Mithila Folk Art', 'MoSJE Fair Wage'];
    } else if (lower.contains('pottery') || lower.contains('पॉटरी') || lower.contains('blue') || lower.contains('vase') || lower.contains('फूलदान') || lower.contains('मिट्टी')) {
      title = 'Jaipur Blue Pottery Royal Cobalt Floral Vase';
      category = 'Ceramics & Pottery';
      craftForm = 'Glazed Quartz Pottery';
      defaultPrice = 1950.0;
      rawMaterialCost = 500.0;
      estimatedHours = 14;
      previewImage = 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80';
      descEn = 'Distinctive low-fire quartz and Multani mitti pottery handcrafted by master potters in Jaipur, Rajasthan. Hand-glazed with Egyptian cobalt oxides and adorned with traditional Mughal floral jaali arabesques. 100% lead-free, authentic GI-tagged heirloom ceramic.';
      descHi = 'जयपुर की पारंपरिक ब्लू पॉटरी कला द्वारा क्वार्ट्ज पत्थर और मुल्तानी मिट्टी से हस्तनिर्मित शाही कोबाल्ट फूलदान। पारंपरिक मुग़ल फूलों के रूपांकनों से सुसज्जित एवं सीसा-मुक्त पर्यावरण सुरक्षित चमक।';
      tags = ['GI Certified', 'Lead Free Glaze', 'Jaipur Craft', 'Quartz Ceramic', 'Hand Painted'];
    } else if (lower.contains('pashmina') || lower.contains('पश्मीना') || lower.contains('shawl') || lower.contains('शॉल') || lower.contains('kashmiri') || lower.contains('कश्मीरी')) {
      title = 'Kashmiri Handspun Pure Pashmina Sozni Needlework Shawl';
      category = 'Textiles & Weaves';
      craftForm = 'Sozni Needle Embroidery';
      defaultPrice = 9800.0;
      rawMaterialCost = 3200.0;
      estimatedHours = 52;
      previewImage = 'https://images.unsplash.com/photo-1607344645866-009c320c5ab8?w=800&auto=format&fit=crop&q=80';
      descEn = 'Finest grade Changthangi cashmere goat wool handspun on traditional charkha and woven on Kashmiri wood looms. Embellished with delicate Sozni needlework taking over 5 weeks of dedicated artisan precision. Certified authentic Pashmina Mark with GI blockchain verification.';
      descHi = 'लद्दाख की चांगथांगी बकरियों की शुद्ध पश्मीना ऊन से हाथ से कता और कश्मीरी हथकरघे पर बुना गया शॉल। सोझनी सुई की महीन कढ़ाई से सुसज्जित, 100% शुद्ध पश्मीना मार्क और जीआई ब्लॉकचेन प्रमाणित।';
      tags = ['100% Pure Pashmina', 'GI Certified', 'Handspun Charkha', 'Sozni Needlework', 'Ethical Cashmere'];
    } else if (lower.contains('toy') || lower.contains('खिलौना') || lower.contains('wood') || lower.contains('लकड़ी') || lower.contains('channapatna') || lower.contains('चन्नपटना')) {
      title = 'Channapatna Non-Toxic Natural Lacquer Wooden Play Set';
      category = 'Woodcraft & Toys';
      craftForm = 'Hale Wood Lacquer Craft';
      defaultPrice = 1450.0;
      rawMaterialCost = 380.0;
      estimatedHours = 10;
      previewImage = 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800&auto=format&fit=crop&q=80';
      descEn = 'Turned on traditional wood lathes using seasoned Wrightia tinctoria (Aale Mara) soft wood and polished with non-toxic natural lacquer extracted from vegetable dyes in Karnataka’s toy town. Child-safe, eco-friendly, and certified with the GI heritage seal.';
      descHi = 'कर्नाटक के चन्नपटना के कारीगरों द्वारा प्राकृतिक वनस्पति रंगों (हल्दी, नील व कुमकुम) से हाथ से तराशे गए बाल-सुरक्षित और पर्यावरण-अनुकूल लकड़ी के खिलौने। जीआई मुहर प्रमाणित।';
      tags = ['GI Certified', 'Non-Toxic Vegetable Dyes', 'Child Safe Wood', 'Channapatna Craft'];
    } else {
      // Default / Banarasi Silk Saree Weave Archetype
      title = 'Varanasi Raw Mulberry Silk Handloom Saree';
      category = 'Textiles & Weaves';
      craftForm = 'Banarasi Handloom Brocade';
      defaultPrice = 7500.0;
      rawMaterialCost = 2100.0;
      estimatedHours = 36;
      previewImage = 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80';
      descEn = 'Authentic pure mulberry silk handwoven by master weavers in Varanasi, adorned with intricate silver electroplated zari floral borders over 14 days of dedicated loom craftsmanship. Fully compliant with MoSJE fair-wage standards and protected with Silk Mark & GI provenance seals.';
      descHi = 'वाराणसी के बुनकर क्लस्टर द्वारा 14 दिनों के गहन हथकरघा श्रम से तैयार शुद्ध शहतूत कतान सिल्क साड़ी। इसमें चांदी की जरी बॉर्डर और प्राकृतिक रंगों का मनोहारी संगम है। सिल्क मार्क और जीआई टैग प्रमाणित।';
      tags = ['100% Handloom', 'GI Certified', 'Silk Mark Approved', 'Pure Mulberry Silk', 'MoSJE Fair Wage'];
    }

    final finalPrice = extractedPrice > 0 ? extractedPrice : defaultPrice;
    final provenanceHash = '0xSETU-${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';

    final draft = ProductDraft(
      id: 'prod_voice_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      craftForm: craftForm,
      description: descEn,
      descriptionHindi: descHi,
      price: finalPrice,
      rawMaterialCost: rawMaterialCost,
      estimatedLoomHours: estimatedHours,
      tags: tags,
      previewImage: previewImage,
      provenanceHash: provenanceHash,
    );

    return SetuDidiResponse(
      userQuery: originalQuery,
      responseText: 'काका/दीदी! मैंने आपके निर्देशानुसार "$title" की पूरी लिस्टिंग, प्रामाणिक विवरण और ₹${finalPrice.toStringAsFixed(0)} का मूल्य तैयार कर दिया है। आप इसे 1-टैप में सीधे बाज़ार में पब्लिश कर सकते हैं!',
      englishTranslation: 'I have prepared the complete listing for "$title" at ₹${finalPrice.toStringAsFixed(0)} with authentic AI description, fair-wage analysis, and GI tags. You can publish it directly to the marketplace!',
      actionRoute: '/artisan/studio',
      isProductListing: true,
      productDraft: draft,
      actionLabel: 'Publish to Marketplace',
    );
  }
}
