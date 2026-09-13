import 'package:flutter/material.dart';

enum AppLanguage { english, hindi, tamil }

class LocaleManager {
  static final ValueNotifier<AppLanguage> currentLanguage = ValueNotifier(AppLanguage.english);

  static void setLanguage(AppLanguage language) {
    currentLanguage.value = language;
  }

  static Locale getLocale(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return const Locale('hi');
      case AppLanguage.tamil:
        return const Locale('ta');
      case AppLanguage.english:
        return const Locale('en');
    }
  }

  static String getLanguageLabel(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return 'हि';
      case AppLanguage.tamil:
        return 'த';
      case AppLanguage.english:
        return 'EN';
    }
  }

  static String tr(String key) {
    final lang = currentLanguage.value;

    // Direct match
    if (_translations.containsKey(key)) {
      final dict = _translations[key]!;
      return dict[lang] ?? dict[AppLanguage.english] ?? key;
    }

    // Case-insensitive / trimmed match
    final trimmed = key.trim().toLowerCase();
    for (final entry in _translations.entries) {
      if (entry.key.toLowerCase() == trimmed) {
        return entry.value[lang] ?? entry.value[AppLanguage.english] ?? key;
      }
    }

    return key;
  }

  static final Map<String, Map<AppLanguage, String>> _translations = {
    // Top-level & Navigation
    'app_title': {
      AppLanguage.english: 'KARIGHAR',
      AppLanguage.hindi: 'कारीघर',
      AppLanguage.tamil: 'காரிகர்',
    },
    'KARIGHAR': {
      AppLanguage.english: 'KARIGHAR',
      AppLanguage.hindi: 'कारीघर',
      AppLanguage.tamil: 'காரிகர்',
    },
    'Karighar': {
      AppLanguage.english: 'Karighar',
      AppLanguage.hindi: 'कारीघर',
      AppLanguage.tamil: 'காரிகர்',
    },
    'A Home for Artisans': {
      AppLanguage.english: 'A Home for Artisans',
      AppLanguage.hindi: 'कारीगरों का अपना घर',
      AppLanguage.tamil: 'கைவினைஞர்களுக்கான இல்லம்',
    },
    'SHILPSETU': {
      AppLanguage.english: 'KARIGHAR',
      AppLanguage.hindi: 'कारीघर',
      AppLanguage.tamil: 'காரிகர்',
    },
    'ShilpSetu': {
      AppLanguage.english: 'Karighar',
      AppLanguage.hindi: 'कारीघर',
      AppLanguage.tamil: 'காரிகர்',
    },
    'Dashboard': {
      AppLanguage.english: 'Dashboard',
      AppLanguage.hindi: 'डैशबोर्ड',
      AppLanguage.tamil: 'முகப்பு',
    },
    'AI Studio': {
      AppLanguage.english: 'AI Studio',
      AppLanguage.hindi: 'एआई स्टूडियो',
      AppLanguage.tamil: 'AI அரங்கம்',
    },
    'Orders': {
      AppLanguage.english: 'Orders',
      AppLanguage.hindi: 'ऑर्डर',
      AppLanguage.tamil: 'ஆர்டர்கள்',
    },
    'Quotes': {
      AppLanguage.english: 'Quotes',
      AppLanguage.hindi: 'प्रस्ताव',
      AppLanguage.tamil: 'விலைக்கோரிக்கைகள்',
    },
    'Earnings': {
      AppLanguage.english: 'Earnings',
      AppLanguage.hindi: 'कमाई',
      AppLanguage.tamil: 'வருமானம்',
    },
    'Explore': {
      AppLanguage.english: 'Explore',
      AppLanguage.hindi: 'खोजें',
      AppLanguage.tamil: 'ஆராயுங்கள்',
    },
    'Cart': {
      AppLanguage.english: 'Cart',
      AppLanguage.hindi: 'कार्ट',
      AppLanguage.tamil: 'கூடை',
    },
    'Chat': {
      AppLanguage.english: 'Chat',
      AppLanguage.hindi: 'चैट',
      AppLanguage.tamil: 'அரட்டை',
    },
    'Tour': {
      AppLanguage.english: 'Tour',
      AppLanguage.hindi: 'टूर',
      AppLanguage.tamil: 'பயணம்',
    },

    // Roles & Switches
    'Artisan': {
      AppLanguage.english: 'Artisan',
      AppLanguage.hindi: 'कारीगर',
      AppLanguage.tamil: 'கைவினைஞர்',
    },
    'Buyer': {
      AppLanguage.english: 'Buyer',
      AppLanguage.hindi: 'क्रेता',
      AppLanguage.tamil: 'வாங்குபவர்',
    },
    'Admin': {
      AppLanguage.english: 'Admin',
      AppLanguage.hindi: 'प्रशासक',
      AppLanguage.tamil: 'நிர்வாகி',
    },
    'artisan_studio': {
      AppLanguage.english: 'Artisan Studio',
      AppLanguage.hindi: 'कारीगर स्टूडियो',
      AppLanguage.tamil: 'கைவினைஞர் அரங்கம்',
    },
    'Artisan Studio': {
      AppLanguage.english: 'Artisan Studio',
      AppLanguage.hindi: 'कारीगर स्टूडियो',
      AppLanguage.tamil: 'கைவினைஞர் அரங்கம்',
    },
    'buyer_marketplace': {
      AppLanguage.english: 'Buyer Marketplace',
      AppLanguage.hindi: 'क्रेता बाज़ार',
      AppLanguage.tamil: 'வாங்குவோர் சந்தை',
    },
    'Buyer Marketplace': {
      AppLanguage.english: 'Buyer Marketplace',
      AppLanguage.hindi: 'क्रेता बाज़ार',
      AppLanguage.tamil: 'வாங்குவோர் சந்தை',
    },
    'Karighar Marketplace': {
      AppLanguage.english: 'Karighar Marketplace',
      AppLanguage.hindi: 'कारीघर बाज़ार',
      AppLanguage.tamil: 'காரிகர் சந்தை',
    },
    'ShilpSetu Marketplace': {
      AppLanguage.english: 'Karighar Marketplace',
      AppLanguage.hindi: 'कारीघर बाज़ार',
      AppLanguage.tamil: 'காரிகர் சந்தை',
    },
    'admin_panel': {
      AppLanguage.english: 'MoSJE Admin Panel',
      AppLanguage.hindi: 'मंत्रालय नियंत्रण कक्ष',
      AppLanguage.tamil: 'அரசு நிர்வாகம்',
    },
    'MoSJE Admin Panel': {
      AppLanguage.english: 'MoSJE Admin Panel',
      AppLanguage.hindi: 'मंत्रालय नियंत्रण कक्ष',
      AppLanguage.tamil: 'அரசு நிர்வாகம்',
    },
    'Switch Role / Logout': {
      AppLanguage.english: 'Switch Role / Logout',
      AppLanguage.hindi: 'भूमिका बदलें / लॉगआउट',
      AppLanguage.tamil: 'பங்கு மாற்றம் / வெளியேறு',
    },

    // Artisan Studio & Metrics
    'total_gmv': {
      AppLanguage.english: 'Total GMV',
      AppLanguage.hindi: 'कुल सकल बिक्री',
      AppLanguage.tamil: 'மொத்த விற்பனை',
    },
    'Total GMV': {
      AppLanguage.english: 'Total GMV',
      AppLanguage.hindi: 'कुल सकल बिक्री',
      AppLanguage.tamil: 'மொத்த விற்பனை',
    },
    'active_orders': {
      AppLanguage.english: 'Active Orders',
      AppLanguage.hindi: 'सक्रिय ऑर्डर',
      AppLanguage.tamil: 'செயலில் உள்ள ஆர்டர்கள்',
    },
    'Active Orders': {
      AppLanguage.english: 'Active Orders',
      AppLanguage.hindi: 'सक्रिय ऑर्डर',
      AppLanguage.tamil: 'செயலில் உள்ள ஆர்டர்கள்',
    },
    'bulk_quotes': {
      AppLanguage.english: 'Bulk Quotes',
      AppLanguage.hindi: 'थोक मूल्य प्रस्ताव',
      AppLanguage.tamil: 'மொத்த விலை கோரிக்கைகள்',
    },
    'Bulk Quotes': {
      AppLanguage.english: 'Bulk Quotes',
      AppLanguage.hindi: 'थोक मूल्य प्रस्ताव',
      AppLanguage.tamil: 'மொத்த விலை கோரிக்கைகள்',
    },
    'GI Compliance': {
      AppLanguage.english: 'GI Compliance',
      AppLanguage.hindi: 'जीआई अनुपालन',
      AppLanguage.tamil: 'புவிசார் குறியீடு',
    },
    'add_product_ai': {
      AppLanguage.english: 'Add Product (AI)',
      AppLanguage.hindi: 'नया उत्पाद जोड़ें (एआई)',
      AppLanguage.tamil: 'பொருள் சேர்க்க (AI)',
    },
    'Add Product (AI)': {
      AppLanguage.english: 'Add Product (AI)',
      AppLanguage.hindi: 'नया उत्पाद जोड़ें (एआई)',
      AppLanguage.tamil: 'பொருள் சேர்க்க (AI)',
    },
    'View Quotes': {
      AppLanguage.english: 'View Quotes',
      AppLanguage.hindi: 'प्रस्ताव देखें',
      AppLanguage.tamil: 'விலை கோரிக்கைகள்',
    },
    'Institutional B2B Cluster Pooling': {
      AppLanguage.english: 'Institutional B2B Cluster Pooling',
      AppLanguage.hindi: 'संस्थागत बी2बी क्लस्टर पूलिंग',
      AppLanguage.tamil: 'நிறுவன B2B தொகுப்பு',
    },
    'Karighar Credit Working Capital': {
      AppLanguage.english: 'Karighar Credit Working Capital',
      AppLanguage.hindi: 'कारीघर क्रेडिट कार्यशील पूंजी',
      AppLanguage.tamil: 'காரிகர் கடன் உதவி',
    },
    'Shilp-Credit Working Capital': {
      AppLanguage.english: 'Karighar Credit Working Capital',
      AppLanguage.hindi: 'कारीघर क्रेडिट कार्यशील पूंजी',
      AppLanguage.tamil: 'காரிகர் கடன் உதவி',
    },
    'image_studio': {
      AppLanguage.english: 'AI Image Studio',
      AppLanguage.hindi: 'एआई फोटो स्टूडियो',
      AppLanguage.tamil: 'AI புகைப்பட அரங்கம்',
    },
    'voice_catalog': {
      AppLanguage.english: 'Voice-to-Catalog AI',
      AppLanguage.hindi: 'आवाज़ से कैटलॉग बनाएं',
      AppLanguage.tamil: 'குரல் வழி பட்டியல்',
    },
    'pricing_engine': {
      AppLanguage.english: 'Smart Pricing Engine',
      AppLanguage.hindi: 'उचित मूल्य निर्धारण',
      AppLanguage.tamil: 'நியாய விலை கால்குலேட்டர்',
    },
    'chat': {
      AppLanguage.english: 'Chat & Negotiate',
      AppLanguage.hindi: 'बातचीत और मोलभाव',
      AppLanguage.tamil: 'செய்திகள்',
    },
    'Chat & Negotiate': {
      AppLanguage.english: 'Chat & Negotiate',
      AppLanguage.hindi: 'बातचीत और मोलभाव',
      AppLanguage.tamil: 'செய்திகள் மற்றும் பேச்சுவார்த்தை',
    },
    'earnings': {
      AppLanguage.english: 'DBT Earnings',
      AppLanguage.hindi: 'प्रत्यक्ष बैंक कमाई',
      AppLanguage.tamil: 'வங்கி வருமானம்',
    },
    'DBT Earnings': {
      AppLanguage.english: 'DBT Earnings',
      AppLanguage.hindi: 'प्रत्यक्ष बैंक कमाई',
      AppLanguage.tamil: 'வங்கி வருமானம்',
    },
    '100% Certified': {
      AppLanguage.english: '100% Certified',
      AppLanguage.hindi: '100% प्रमाणित',
      AppLanguage.tamil: '100% சான்றளிக்கப்பட்டது',
    },
    'MoSJE Verified': {
      AppLanguage.english: 'MoSJE Verified',
      AppLanguage.hindi: 'मंत्रालय द्वारा सत्यापित',
      AppLanguage.tamil: 'அரசு சரிபார்க்கப்பட்டது',
    },
    'Launch AI Studio Wizard': {
      AppLanguage.english: 'Launch AI Studio Wizard',
      AppLanguage.hindi: 'एआई स्टूडियो विज़ार्ड शुरू करें',
      AppLanguage.tamil: 'AI கலைக்கூட வழிகாட்டியைத் தொடங்குக',
    },
    '4K AI': {
      AppLanguage.english: '4K AI',
      AppLanguage.hindi: '4के एआई',
      AppLanguage.tamil: '4K AI',
    },
    'Photograph loom craft, speak description in Hindi, get 4K enhancement & MoSJE pricing.': {
      AppLanguage.english: 'Photograph loom craft, speak description in Hindi, get 4K enhancement & MoSJE pricing.',
      AppLanguage.hindi: 'हथकरघा शिल्प की फोटो लें, हिंदी में विवरण बोलें, 4के गुणवत्ता और सरकारी मूल्य प्राप्त करें।',
      AppLanguage.tamil: 'நெசவுப் பொருளைப் படம் பிடியுங்கள், விவரத்தைப் பேசுங்கள், 4K மெருகேற்றலும் அரசு விலையும் பெறுங்கள்.',
    },
    '+38.4% Uplift': {
      AppLanguage.english: '+38.4% Uplift',
      AppLanguage.hindi: '+38.4% वृद्धि',
      AppLanguage.tamil: '+38.4% உயர்வு',
    },
    'Units': {
      AppLanguage.english: 'Units',
      AppLanguage.hindi: 'यूनिट',
      AppLanguage.tamil: 'அலகுகள்',
    },
    '2 in Loom Prep': {
      AppLanguage.english: '2 in Loom Prep',
      AppLanguage.hindi: '2 करघे की तैयारी में',
      AppLanguage.tamil: '2 தறி தயாரிப்பில்',
    },
    'Pending': {
      AppLanguage.english: 'Pending',
      AppLanguage.hindi: 'लंबित',
      AppLanguage.tamil: 'நிலுவையில்',
    },
    'FabIndia, Oberoi': {
      AppLanguage.english: 'FabIndia, Oberoi',
      AppLanguage.hindi: 'फैबइंडिया, ओबेरॉय',
      AppLanguage.tamil: 'ஃபேப்இந்தியா, ஓபராய்',
    },
    'Pool loom capacity for FabIndia & Taj Hotels bulk tenders with guaranteed MoSJE DBT fair wages.': {
      AppLanguage.english: 'Pool loom capacity for FabIndia & Taj Hotels bulk tenders with guaranteed MoSJE DBT fair wages.',
      AppLanguage.hindi: 'फैबइंडिया और ताज होटल्स के बड़े टेंडरों के लिए करघा क्षमता साझा करें और प्रत्यक्ष बैंक मजदूरी पाएं।',
      AppLanguage.tamil: 'ஃபேப்இந்தியா மற்றும் தாஜ் ஹோட்டல்களின் மொத்த டெண்டர்களுக்கு தறி திறனை இணைத்து நேரடி வங்கிக் கூலி பெறுங்கள்.',
    },
    'PM-Vishwakarma Karighar Credit Hub': {
      AppLanguage.english: 'PM-Vishwakarma Karighar Credit Hub',
      AppLanguage.hindi: 'पीएम-विश्वकर्मा कारीघर क्रेडिट हब',
      AppLanguage.tamil: 'பிஎம்-விஸ்வகர்மா காரிகர் கிரெடிட் மையம்',
    },
    'PM-Vishwakarma Shilp-Credit Hub': {
      AppLanguage.english: 'PM-Vishwakarma Karighar Credit Hub',
      AppLanguage.hindi: 'पीएम-विश्वकर्मा कारीघर क्रेडिट हब',
      AppLanguage.tamil: 'பிஎம்-விஸ்வகர்மா காரிகர் கிரெடிட் மையம்',
    },
    'Pre-approved ₹1,00,000 collateral-free working capital loan based on loom fulfillment score.': {
      AppLanguage.english: 'Pre-approved ₹1,00,000 collateral-free working capital loan based on loom fulfillment score.',
      AppLanguage.hindi: 'करघा कार्य प्रदर्शन के आधार पर ₹1,00,000 की पूर्व-स्वीकृत बिना गारंटी कार्यशील पूंजी ऋण।',
      AppLanguage.tamil: 'தறி உற்பத்தி மதிப்பெண் அடிப்படையில் ₹1,00,000 வரை பிணையில்லா முன்-அங்கீகரிக்கப்பட்ட நடைமுறை மூலதனக் கடன்.',
    },
    'Recent Loom Orders': {
      AppLanguage.english: 'Recent Loom Orders',
      AppLanguage.hindi: 'हाल के करघा ऑर्डर',
      AppLanguage.tamil: 'சமீபத்திய தறி ஆர்டர்கள்',
    },
    'View All': {
      AppLanguage.english: 'View All',
      AppLanguage.hindi: 'सभी देखें',
      AppLanguage.tamil: 'அனைத்தையும் காண்க',
    },
    'No orders yet': {
      AppLanguage.english: 'No orders yet',
      AppLanguage.hindi: 'अभी कोई ऑर्डर नहीं है',
      AppLanguage.tamil: 'இன்னும் ஆர்டர்கள் இல்லை',
    },
    'No crafts cataloged yet': {
      AppLanguage.english: 'No crafts cataloged yet',
      AppLanguage.hindi: 'अभी कोई शिल्प सूचीबद्ध नहीं है',
      AppLanguage.tamil: 'இன்னும் கைவினைப் பொருட்கள் பட்டியலிடப்படவில்லை',
    },
    'My Active Catalog': {
      AppLanguage.english: 'My Active Catalog',
      AppLanguage.hindi: 'मेरा सक्रिय कैटलॉग',
      AppLanguage.tamil: 'எனது நேரடிப் பட்டியல்',
    },
    'New Craft': {
      AppLanguage.english: 'New Craft',
      AppLanguage.hindi: 'नया शिल्प',
      AppLanguage.tamil: 'புதிய கைவினை',
    },
    'LIVE ON MARKET': {
      AppLanguage.english: 'LIVE ON MARKET',
      AppLanguage.hindi: 'बाज़ार में लाइव',
      AppLanguage.tamil: 'சந்தையில் நேரலை',
    },
    'loom craft': {
      AppLanguage.english: 'loom craft',
      AppLanguage.hindi: 'करघा शिल्प',
      AppLanguage.tamil: 'தறி கைவினை',
    },
    'Ramdev Varma': {
      AppLanguage.english: 'Ramdev Varma',
      AppLanguage.hindi: 'रामदेव वर्मा',
      AppLanguage.tamil: 'ராம்தேவ் வர்மா',
    },
    'GI Master': {
      AppLanguage.english: 'GI Master',
      AppLanguage.hindi: 'जीआई मास्टर',
      AppLanguage.tamil: 'புவிசார் நிபுணர்',
    },
    'Banarasi Silk Weavers Guild • Varanasi, UP': {
      AppLanguage.english: 'Banarasi Silk Weavers Guild • Varanasi, UP',
      AppLanguage.hindi: 'बनारसी रेशम बुनकर संघ • वाराणसी, उत्तर प्रदेश',
      AppLanguage.tamil: 'பனாரசி பட்டு நெசவாளர் சங்கம் • வாரணாசி, உ.பி',
    },
    'Setu Didi (Voice)': {
      AppLanguage.english: 'Setu Didi (Voice)',
      AppLanguage.hindi: 'सेतु दीदी (आवाज़)',
      AppLanguage.tamil: 'சேது தீதி (குரல்)',
    },
    'Qty': {
      AppLanguage.english: 'Qty',
      AppLanguage.hindi: 'मात्रा',
      AppLanguage.tamil: 'அளவு',
    },
    'IN PRODUCTION': {
      AppLanguage.english: 'IN PRODUCTION',
      AppLanguage.hindi: 'उत्पादन में',
      AppLanguage.tamil: 'உற்பத்தியில்',
    },
    'DISPATCHED': {
      AppLanguage.english: 'DISPATCHED',
      AppLanguage.hindi: 'भेज दिया गया',
      AppLanguage.tamil: 'அனுப்பப்பட்டது',
    },
    'DELIVERED': {
      AppLanguage.english: 'DELIVERED',
      AppLanguage.hindi: 'डिलीवर किया गया',
      AppLanguage.tamil: 'வழங்கப்பட்டது',
    },

    // AI Studio Wizard
    'AI Studio Wizard': {
      AppLanguage.english: 'AI Studio Wizard',
      AppLanguage.hindi: 'एआई स्टूडियो विज़ार्ड',
      AppLanguage.tamil: 'AI கலைக்கூட வழிகாட்டி',
    },
    'Image Studio': {
      AppLanguage.english: 'Image Studio',
      AppLanguage.hindi: 'फोटो स्टूडियो',
      AppLanguage.tamil: 'புகைப்பட அரங்கம்',
    },
    'Voice Info': {
      AppLanguage.english: 'Voice Info',
      AppLanguage.hindi: 'ध्वनि विवरण',
      AppLanguage.tamil: 'குரல் விவரம்',
    },
    'Smart Pricing': {
      AppLanguage.english: 'Smart Pricing',
      AppLanguage.hindi: 'उचित मूल्य',
      AppLanguage.tamil: 'நியாய விலை',
    },
    'Review': {
      AppLanguage.english: 'Review',
      AppLanguage.hindi: 'समीक्षा',
      AppLanguage.tamil: 'மதிப்பாய்வு',
    },
    'Take a camera photo or upload from gallery to enhance': {
      AppLanguage.english: 'Take a camera photo or upload from gallery to enhance',
      AppLanguage.hindi: 'कैमरे से फोटो लें या गैलरी से अपलोड कर बेहतर बनाएं',
      AppLanguage.tamil: 'புகைப்படம் எடுக்கவும் அல்லது கேலரியில் இருந்து பதிவேற்றவும்',
    },
    '4K AI Ready': {
      AppLanguage.english: '4K AI Ready',
      AppLanguage.hindi: '4के एआई तैयार',
      AppLanguage.tamil: '4K AI தயார்',
    },
    'Take Camera Photo': {
      AppLanguage.english: 'Take Camera Photo',
      AppLanguage.hindi: 'कैमरे से फोटो लें',
      AppLanguage.tamil: 'கேமராவில் படம் எடுக்க',
    },
    'Upload from Gallery': {
      AppLanguage.english: 'Upload from Gallery',
      AppLanguage.hindi: 'गैलरी से अपलोड करें',
      AppLanguage.tamil: 'கேலரியில் இருந்து பதிவேற்ற',
    },
    'Multi-Angle Craft Gallery': {
      AppLanguage.english: 'Multi-Angle Craft Gallery',
      AppLanguage.hindi: 'विभिन्न कोण शिल्प गैलरी',
      AppLanguage.tamil: 'பல கோண கைவினை அரங்கம்',
    },
    'Full Craft': {
      AppLanguage.english: 'Full Craft',
      AppLanguage.hindi: 'सम्पूर्ण शिल्प',
      AppLanguage.tamil: 'முழு கைவினை',
    },
    'Weave Texture': {
      AppLanguage.english: 'Weave Texture',
      AppLanguage.hindi: 'बुनाई बनावट',
      AppLanguage.tamil: 'நெசவு அமைப்பு',
    },
    'Border Motif': {
      AppLanguage.english: 'Border Motif',
      AppLanguage.hindi: 'किनारा रूपांकन',
      AppLanguage.tamil: 'பார்டர் வேலைப்பாடு',
    },
    'Artisan at Loom': {
      AppLanguage.english: 'Artisan at Loom',
      AppLanguage.hindi: 'करघे पर कारीगर',
      AppLanguage.tamil: 'தறியில் கைவினைஞர்',
    },
    'Sample Craft Presets': {
      AppLanguage.english: 'Sample Craft Presets',
      AppLanguage.hindi: 'नमूना शिल्प विकल्प',
      AppLanguage.tamil: 'மாதிரி கைவினை',
    },
    'Reset Demo': {
      AppLanguage.english: 'Reset Demo',
      AppLanguage.hindi: 'डेमो रीसेट करें',
      AppLanguage.tamil: 'மீட்டமைக்க',
    },
    'Applying 4K Neural Studio Enhancements...': {
      AppLanguage.english: 'Applying 4K Neural Studio Enhancements...',
      AppLanguage.hindi: '4के न्यूरल स्टूडियो सुधार लागू हो रहा है...',
      AppLanguage.tamil: '4K நியூரோ ஸ்டுடியோ மேம்பாடுகள் செயல்படுத்தப்படுகின்றன...',
    },
    'Simulating soft studio lighting & removing workshop glare': {
      AppLanguage.english: 'Simulating soft studio lighting & removing workshop glare',
      AppLanguage.hindi: 'सॉफ्ट स्टूडियो लाइटिंग और चमक निवारण...',
      AppLanguage.tamil: 'ஸ்டுடியோ ஒளி மற்றும் பளபளப்பு நீக்கம்...',
    },
    'AI Quality Assessment Score': {
      AppLanguage.english: 'AI Quality Assessment Score',
      AppLanguage.hindi: 'एआई गुणवत्ता मूल्यांकन स्कोर',
      AppLanguage.tamil: 'AI தர மதிப்பீடு',
    },
    'Lighting & Exposure': {
      AppLanguage.english: 'Lighting & Exposure',
      AppLanguage.hindi: 'प्रकाश और एक्सपोज़र',
      AppLanguage.tamil: 'ஒளி மற்றும் வெளிப்பாடு',
    },
    'Color Authenticity': {
      AppLanguage.english: 'Color Authenticity',
      AppLanguage.hindi: 'रंग प्रामाणिकता',
      AppLanguage.tamil: 'நிற நம்பகத்தன்மை',
    },
    'Karighar AI Vision Engine (HTTPS 8443)': {
      AppLanguage.english: 'Karighar AI Vision Engine (HTTPS 8443)',
      AppLanguage.hindi: 'कारीघर एआई विज़न इंजन (HTTPS 8443)',
      AppLanguage.tamil: 'காரிகர் AI பார்வை எஞ்சின் (HTTPS 8443)',
    },
    'ShilpSetu AI Vision Engine (HTTPS 8443)': {
      AppLanguage.english: 'Karighar AI Vision Engine (HTTPS 8443)',
      AppLanguage.hindi: 'कारीघर एआई विज़न इंजन (HTTPS 8443)',
      AppLanguage.tamil: 'காரிகர் AI பார்வை எஞ்சின் (HTTPS 8443)',
    },
    'Server Angle Verified': {
      AppLanguage.english: 'Server Angle Verified',
      AppLanguage.hindi: 'सर्वर द्वारा कोण प्रमाणित',
      AppLanguage.tamil: 'சர்வர் மூலம் கோணம் சரிபார்க்கப்பட்டது',
    },
    'Run AI Vision Inspection': {
      AppLanguage.english: 'Run AI Vision Inspection',
      AppLanguage.hindi: 'एआई विज़न जांच चलाएं',
      AppLanguage.tamil: 'AI பார்வை சோதனையை இயக்கவும்',
    },
    'Analyzing angle with server neural vision...': {
      AppLanguage.english: 'Analyzing angle with server neural vision...',
      AppLanguage.hindi: 'सर्वर न्यूरल विज़न द्वारा कोण का विश्लेषण जारी है...',
      AppLanguage.tamil: 'சர்வர் பார்வை மூலம் கோணம் ஆய்வு செய்யப்படுகிறது...',
    },
    'Microscopic Weave Density': {
      AppLanguage.english: 'Microscopic Weave Density',
      AppLanguage.hindi: 'सूक्ष्म बुनाई घनत्व',
      AppLanguage.tamil: 'நுண்ணிய நெசவு அடர்த்தி',
    },
    'Knot Symmetry': {
      AppLanguage.english: 'Knot Symmetry',
      AppLanguage.hindi: 'गांठ समरूपता',
      AppLanguage.tamil: 'முடிச்சு சமச்சீர்நிலை',
    },
    'Anti-Powerloom Verification': {
      AppLanguage.english: 'Anti-Powerloom Verification',
      AppLanguage.hindi: 'पावरलूम-रोधी सत्यापन',
      AppLanguage.tamil: 'பவர்லூம் எதிர்ப்பு சரிபார்ப்பு',
    },
    'AI Vision Telemetry & Server Verification': {
      AppLanguage.english: 'AI Vision Telemetry & Server Verification',
      AppLanguage.hindi: 'एआई विज़न टेलीमेट्री एवं सर्वर सत्यापन',
      AppLanguage.tamil: 'AI பார்வை தொலை அளவியல் & சர்வர் சரிபார்ப்பு',
    },
    'Angle Verified by Server': {
      AppLanguage.english: 'Angle Verified by Server',
      AppLanguage.hindi: 'सर्वर द्वारा कोण सत्यापित',
      AppLanguage.tamil: 'சர்வர் மூலம் கோணம் சரிபார்க்கப்பட்டது',
    },
    'Background De-clutter': {
      AppLanguage.english: 'Background De-clutter',
      AppLanguage.hindi: 'पृष्ठभूमि सफाई',
      AppLanguage.tamil: 'பின்னணி இரைச்சல் நீக்கம்',
    },
    'Resolution Upscaling': {
      AppLanguage.english: 'Resolution Upscaling',
      AppLanguage.hindi: 'रिज़ॉल्यूशन सुधार',
      AppLanguage.tamil: 'தெளிவுத்திறன் மேம்பாடு',
    },
    'Voice-to-Catalog AI': {
      AppLanguage.english: 'Voice-to-Catalog AI',
      AppLanguage.hindi: 'आवाज़ से कैटलॉग बनाएं',
      AppLanguage.tamil: 'குரல் வழி பட்டியல்',
    },
    'Powered by Bhashini AI': {
      AppLanguage.english: 'Powered by Bhashini AI',
      AppLanguage.hindi: 'भाषिणी एआई द्वारा संचालित',
      AppLanguage.tamil: 'பாஷினி AI மூலம் இயக்கப்படுகிறது',
    },
    'Listening in Hindi / Local Dialect...': {
      AppLanguage.english: 'Listening in Hindi / Local Dialect...',
      AppLanguage.hindi: 'हिंदी / स्थानीय बोली में सुन रहे हैं...',
      AppLanguage.tamil: 'உள்ளூர் மொழியில் கேட்கிறது...',
    },
    'Tap the microphone to speak details of your craft': {
      AppLanguage.english: 'Tap the microphone to speak details of your craft',
      AppLanguage.hindi: 'शिल्प का विवरण बोलने के लिए माइक दबाएं',
      AppLanguage.tamil: 'விவரங்களை பேச மைக்கை தொடவும்',
    },
    'Tap to finish recording': {
      AppLanguage.english: 'Tap to finish recording',
      AppLanguage.hindi: 'रिकॉर्डिंग समाप्त करने के लिए दबाएं',
      AppLanguage.tamil: 'பதிவை முடிக்க தொடவும்',
    },
    'Hold / tap to speak': {
      AppLanguage.english: 'Hold / tap to speak',
      AppLanguage.hindi: 'बोलने के लिए दबाएं',
      AppLanguage.tamil: 'பேச தொடவும்',
    },
    'Try Demo Voice Description': {
      AppLanguage.english: 'Try Demo Voice Description',
      AppLanguage.hindi: 'नमूना आवाज़ आज़माएं',
      AppLanguage.tamil: 'மாதிரி குரல் விவரம்',
    },
    'Listen to Craft Story': {
      AppLanguage.english: 'Listen to Craft Story',
      AppLanguage.hindi: 'शिल्प कथा सुनें',
      AppLanguage.tamil: 'கைவினை கதையைக் கேளுங்கள்',
    },
    'AI Structured Metadata Extraction': {
      AppLanguage.english: 'AI Structured Metadata Extraction',
      AppLanguage.hindi: 'एआई संरचित डेटा निष्कर्षण',
      AppLanguage.tamil: 'AI கட்டமைக்கப்பட்ட தரவு',
    },
    'Product Title': {
      AppLanguage.english: 'Product Title',
      AppLanguage.hindi: 'उत्पाद का शीर्षक',
      AppLanguage.tamil: 'பொருளின் பெயர்',
    },
    'Category': {
      AppLanguage.english: 'Category',
      AppLanguage.hindi: 'श्रेणी',
      AppLanguage.tamil: 'பிரிவு',
    },
    'Craft Form': {
      AppLanguage.english: 'Craft Form',
      AppLanguage.hindi: 'शिल्प का प्रकार',
      AppLanguage.tamil: 'கைவினை வகை',
    },
    'Craft Story & Description': {
      AppLanguage.english: 'Craft Story & Description',
      AppLanguage.hindi: 'शिल्प कथा और विवरण',
      AppLanguage.tamil: 'கைவினை கதையும் விளக்கமும்',
    },
    'AI Extracted Tags:': {
      AppLanguage.english: 'AI Extracted Tags:',
      AppLanguage.hindi: 'एआई टैग्स:',
      AppLanguage.tamil: 'AI குறிச்சொற்கள்:',
    },
    'Add Tag': {
      AppLanguage.english: 'Add Tag',
      AppLanguage.hindi: 'टैग जोड़ें',
      AppLanguage.tamil: 'குறிச்சொல் சேர்',
    },
    'Fair labor valuation benchmarked against MoSJE standards': {
      AppLanguage.english: 'Fair labor valuation benchmarked against MoSJE standards',
      AppLanguage.hindi: 'मंत्रालय मानकों पर आधारित उचित श्रम मूल्यांकन',
      AppLanguage.tamil: 'அரசு வழிகாட்டுதலின்படி நியாயமான கூலி',
    },
    'MoSJE Fair Wage': {
      AppLanguage.english: 'MoSJE Fair Wage',
      AppLanguage.hindi: 'सरकारी उचित पारिश्रमिक',
      AppLanguage.tamil: 'அரசு நியாய கூலி',
    },
    'RECOMMENDED FAIR MARKET VALUE': {
      AppLanguage.english: 'RECOMMENDED FAIR MARKET VALUE',
      AppLanguage.hindi: 'अनुशंसित उचित बाज़ार मूल्य',
      AppLanguage.tamil: 'பரிந்துரைக்கப்பட்ட நியாய சந்தை விலை',
    },
    'Base Cost': {
      AppLanguage.english: 'Base Cost',
      AppLanguage.hindi: 'मूल लागत',
      AppLanguage.tamil: 'அடிப்படை செலவு',
    },
    'Artisan Margin': {
      AppLanguage.english: 'Artisan Margin',
      AppLanguage.hindi: 'कारीगर लाभ',
      AppLanguage.tamil: 'கைவினைஞர் லாபம்',
    },
    'Direct DBT Payout: 100%': {
      AppLanguage.english: 'Direct DBT Payout: 100%',
      AppLanguage.hindi: 'प्रत्यक्ष बैंक भुगतान: 100%',
      AppLanguage.tamil: 'நேரடி வங்கி செலுத்துதல்: 100%',
    },
    'Cost Breakdown Inputs': {
      AppLanguage.english: 'Cost Breakdown Inputs',
      AppLanguage.hindi: 'लागत विवरण इनपुट',
      AppLanguage.tamil: 'செலவு விவரங்கள்',
    },
    'Raw Material Cost': {
      AppLanguage.english: 'Raw Material Cost',
      AppLanguage.hindi: 'कच्चे माल की लागत',
      AppLanguage.tamil: 'மூலப்பொருள் செலவு',
    },
    'Loom Labor Hours': {
      AppLanguage.english: 'Loom Labor Hours',
      AppLanguage.hindi: 'करघा श्रम घंटे',
      AppLanguage.tamil: 'தறி உழைப்பு நேரம்',
    },
    'Fair Wage Rate (MoSJE Std.)': {
      AppLanguage.english: 'Fair Wage Rate (MoSJE Std.)',
      AppLanguage.hindi: 'उचित मजदूरी दर (सरकारी मानक)',
      AppLanguage.tamil: 'நியாய ஊதிய விகிதம்',
    },
    'Artisan Profit Markup': {
      AppLanguage.english: 'Artisan Profit Markup',
      AppLanguage.hindi: 'कारीगर लाभ मार्जिन',
      AppLanguage.tamil: 'கைவினைஞர் லாப விளிம்பு',
    },
    'Final Review & Publish': {
      AppLanguage.english: 'Final Review & Publish',
      AppLanguage.hindi: 'अंतिम समीक्षा और प्रकाशन',
      AppLanguage.tamil: 'இறுதி மதிப்பாய்வு மற்றும் வெளியீடு',
    },
    'Verify your AI cataloged product details before listing live.': {
      AppLanguage.english: 'Verify your AI cataloged product details before listing live.',
      AppLanguage.hindi: 'लाइव करने से पहले अपने उत्पाद के विवरण जांचें।',
      AppLanguage.tamil: 'நேரலைக்கு முன் விவரங்களை சரிபார்க்கவும்.',
    },
    'Listing Price': {
      AppLanguage.english: 'Listing Price',
      AppLanguage.hindi: 'सूचीबद्ध मूल्य',
      AppLanguage.tamil: 'பட்டியல் விலை',
    },
    'Loom Time': {
      AppLanguage.english: 'Loom Time',
      AppLanguage.hindi: 'करघा समय',
      AppLanguage.tamil: 'தறி நேரம்',
    },
    'Hours': {
      AppLanguage.english: 'Hours',
      AppLanguage.hindi: 'घंटे',
      AppLanguage.tamil: 'மணிநேரம்',
    },
    'NEURAL WEAVE INSPECTION': {
      AppLanguage.english: 'NEURAL WEAVE INSPECTION',
      AppLanguage.hindi: 'न्यूरल बुनाई निरीक्षण',
      AppLanguage.tamil: 'நெசவு ஆய்வு',
    },
    'Back': {
      AppLanguage.english: 'Back',
      AppLanguage.hindi: 'पीछे',
      AppLanguage.tamil: 'பின்செல்',
    },
    'Publish to Marketplace': {
      AppLanguage.english: 'Publish to Marketplace',
      AppLanguage.hindi: 'बाज़ार में प्रकाशित करें',
      AppLanguage.tamil: 'சந்தையில் வெளியிடவும்',
    },
    'Product published to Karighar & Buyer Discovery!': {
      AppLanguage.english: 'Product published to Karighar & Buyer Discovery!',
      AppLanguage.hindi: 'उत्पाद कारीघर बाज़ार में सफलतापूर्वक प्रकाशित!',
      AppLanguage.tamil: 'பொருள் காரிகர் சந்தையில் வெளியிடப்பட்டது!',
    },
    'Product published to ShilpSetu & Buyer Discovery!': {
      AppLanguage.english: 'Product published to Karighar & Buyer Discovery!',
      AppLanguage.hindi: 'उत्पाद कारीघर बाज़ार में सफलतापूर्वक प्रकाशित!',
      AppLanguage.tamil: 'பொருள் காரிகர் சந்தையில் வெளியிடப்பட்டது!',
    },

    // Buyer Marketplace
    'Curated Heritage Crafts': {
      AppLanguage.english: 'Curated Heritage Crafts',
      AppLanguage.hindi: 'विशिष्ट पारंपरिक शिल्प',
      AppLanguage.tamil: 'பாரம்பரிய கைவினைப் பொருட்கள்',
    },
    'Search GI crafts, silk sarees, pottery...': {
      AppLanguage.english: 'Search GI crafts, silk sarees, pottery...',
      AppLanguage.hindi: 'जीआई शिल्प, सिल्क साड़ियां, बर्तन खोजें...',
      AppLanguage.tamil: 'பாரம்பரிய கைவினை, புடவைகள், மண்பாண்டங்களைத் தேடுங்கள்...',
    },
    '100% Direct Artisan Sourced': {
      AppLanguage.english: '100% Direct Artisan Sourced',
      AppLanguage.hindi: '100% सीधे कारीगर से प्राप्त',
      AppLanguage.tamil: '100% கைவினைஞரிடமிருந்து நேரடி',
    },
    'All': {
      AppLanguage.english: 'All',
      AppLanguage.hindi: 'सभी',
      AppLanguage.tamil: 'அனைத்தும்',
    },
    'Textiles & Weaves': {
      AppLanguage.english: 'Textiles & Weaves',
      AppLanguage.hindi: 'वस्त्र और बुनाई',
      AppLanguage.tamil: 'நெசவு மற்றும் துணிகள்',
    },
    'Ceramics & Pottery': {
      AppLanguage.english: 'Ceramics & Pottery',
      AppLanguage.hindi: 'मिट्टी के बर्तन',
      AppLanguage.tamil: 'மண்பாண்டங்கள்',
    },
    'Folk Art & Paintings': {
      AppLanguage.english: 'Folk Art & Paintings',
      AppLanguage.hindi: 'लोक कला और चित्रकला',
      AppLanguage.tamil: 'நாட்டுப்புற ஓவியங்கள்',
    },
    'Buy Now': {
      AppLanguage.english: 'Buy Now',
      AppLanguage.hindi: 'अभी खरीदें',
      AppLanguage.tamil: 'இப்போது வாங்க',
    },
    'Add to Cart': {
      AppLanguage.english: 'Add to Cart',
      AppLanguage.hindi: 'कार्ट में जोड़ें',
      AppLanguage.tamil: 'கூடையில் சேர்',
    },
    'Request Bulk Quote': {
      AppLanguage.english: 'Request Bulk Quote',
      AppLanguage.hindi: 'थोक कोटेशन मांगें',
      AppLanguage.tamil: 'மொத்த விலை கேட்க',
    },
    'Explore Institutional Tenders': {
      AppLanguage.english: 'Explore Institutional Tenders',
      AppLanguage.hindi: 'संस्थागत निविदाएं देखें',
      AppLanguage.tamil: 'நிறுவன டெண்டர்களை காண்க',
    },
    'Checkout': {
      AppLanguage.english: 'Checkout',
      AppLanguage.hindi: 'चेकआउट',
      AppLanguage.tamil: 'பணம் செலுத்துக',
    },
    'Your Cart': {
      AppLanguage.english: 'Your Cart',
      AppLanguage.hindi: 'आपकी कार्ट',
      AppLanguage.tamil: 'உங்கள் கூடை',
    },
    'Total Price': {
      AppLanguage.english: 'Total Price',
      AppLanguage.hindi: 'कुल मूल्य',
      AppLanguage.tamil: 'மொத்த விலை',
    },
    'Direct Artisan Fair Wage': {
      AppLanguage.english: 'Direct Artisan Fair Wage',
      AppLanguage.hindi: 'कारीगर को उचित पारिश्रमिक',
      AppLanguage.tamil: 'கைவினைஞருக்கான நேரடி ஊதியம்',
    },

    // Additional Features & Screens
    'Blockchain Ledger Explorer': {
      AppLanguage.english: 'Blockchain Ledger Explorer',
      AppLanguage.hindi: 'ब्लॉकचेन खाता अन्वेषक',
      AppLanguage.tamil: 'பிளாக்செயின் பதிவு',
    },
    'MoSJE Sovereign Consortium Subnet': {
      AppLanguage.english: 'MoSJE Sovereign Consortium Subnet',
      AppLanguage.hindi: 'मंत्रालय संप्रभु कंसोर्टियम सबनेट',
      AppLanguage.tamil: 'அரசு கூட்டமைப்பு சப்நெட்',
    },
    'GIS Artisan Cluster Map': {
      AppLanguage.english: 'GIS Artisan Cluster Map',
      AppLanguage.hindi: 'जीआईएस क्लस्टर मानचित्र',
      AppLanguage.tamil: 'GIS கைவினைஞர் வரைபடம்',
    },
    'Delivery Verification': {
      AppLanguage.english: 'Delivery Verification',
      AppLanguage.hindi: 'वितरण सत्यापन',
      AppLanguage.tamil: 'டெலிவரி சரிபார்ப்பு',
    },
    'Craft Passport': {
      AppLanguage.english: 'Craft Passport',
      AppLanguage.hindi: 'शिल्प पासपोर्ट',
      AppLanguage.tamil: 'கைவினை பாஸ்போர்ட்',
    },
    'Global Export Clearance': {
      AppLanguage.english: 'Global Export Clearance',
      AppLanguage.hindi: 'वैश्विक निर्यात निकासी',
      AppLanguage.tamil: 'உலகளாவிய ஏற்றுமதி அனுமதி',
    },
    'Global Export Customs': {
      AppLanguage.english: 'Global Export Customs',
      AppLanguage.hindi: 'वैश्विक निर्यात सीमा शुल्क',
      AppLanguage.tamil: 'உலகளாவிய ஏற்றுமதி சுங்கம்',
    },
    'RFP Tender Board': {
      AppLanguage.english: 'RFP Tender Board',
      AppLanguage.hindi: 'आरएफपी निविदा बोर्ड',
      AppLanguage.tamil: 'டெண்டர் பலகை',
    },
    'AR Craft Viewer': {
      AppLanguage.english: 'AR Craft Viewer',
      AppLanguage.hindi: 'एआर शिल्प दृश्य',
      AppLanguage.tamil: 'AR கைவினை பார்வை',
    },
    'Invoice Preview': {
      AppLanguage.english: 'Invoice Preview',
      AppLanguage.hindi: 'चालान पूर्वावलोकन',
      AppLanguage.tamil: 'விலைப்பட்டியல்',
    },

    // Tour & Onboarding
    'Start 60s Evaluator Tour': {
      AppLanguage.english: 'Start 60s Evaluator Tour',
      AppLanguage.hindi: '60 सेकंड का टूर शुरू करें',
      AppLanguage.tamil: '60 வினாடி சுற்றுப்பயணம்',
    },
    'SIH 2026 EVALUATOR TOUR': {
      AppLanguage.english: 'SIH 2026 EVALUATOR TOUR',
      AppLanguage.hindi: 'एसआईएच 2026 मूल्यांकनकर्ता टूर',
      AppLanguage.tamil: 'SIH 2026 மதிப்பீட்டாளர் பயணம்',
    },
    'ARTISAN INCLUSIVITY & AI': {
      AppLanguage.english: 'ARTISAN INCLUSIVITY & AI',
      AppLanguage.hindi: 'कारीगर समावेशिता और एआई',
      AppLanguage.tamil: 'கைவினைஞர் உள்ளடக்கம் & AI',
    },
    'ECONOMIC FAIR TRADE': {
      AppLanguage.english: 'ECONOMIC FAIR TRADE',
      AppLanguage.hindi: 'आर्थिक निष्पक्ष व्यापार',
      AppLanguage.tamil: 'பொருளாதார நியாய வர்த்தகம்',
    },
    'BUYER TRUST & IMMERSION': {
      AppLanguage.english: 'BUYER TRUST & IMMERSION',
      AppLanguage.hindi: 'क्रेता विश्वास और अनुभव',
      AppLanguage.tamil: 'வாங்குபவர் நம்பிக்கை & அனுபவம்',
    },
    'Next Pillar': {
      AppLanguage.english: 'Next Pillar',
      AppLanguage.hindi: 'अगला चरण',
      AppLanguage.tamil: 'அடுத்த பகுதி',
    },
    'Previous': {
      AppLanguage.english: 'Previous',
      AppLanguage.hindi: 'पिछला',
      AppLanguage.tamil: 'முந்தைய',
    },
    'Finish Tour': {
      AppLanguage.english: 'Finish Tour',
      AppLanguage.hindi: 'टूर समाप्त करें',
      AppLanguage.tamil: 'பயணத்தை முடிக்க',
    },

    // Auth & Onboarding
    'Sign In / Continue': {
      AppLanguage.english: 'Sign In / Continue',
      AppLanguage.hindi: 'साइन इन करें / आगे बढ़ें',
      AppLanguage.tamil: 'உள்நுழைய / தொடரவும்',
    },
    'Continue': {
      AppLanguage.english: 'Continue',
      AppLanguage.hindi: 'जारी रखें',
      AppLanguage.tamil: 'தொடரவும்',
    },
    'Select Your Role': {
      AppLanguage.english: 'Select Your Role',
      AppLanguage.hindi: 'अपनी भूमिका चुनें',
      AppLanguage.tamil: 'உங்கள் பங்கைத் தேர்ந்தெடுக்கவும்',
    },
    'Login': {
      AppLanguage.english: 'Login',
      AppLanguage.hindi: 'साइन इन',
      AppLanguage.tamil: 'உள்நுழைவு',
    },
    'Register': {
      AppLanguage.english: 'Register',
      AppLanguage.hindi: 'पंजीकरण',
      AppLanguage.tamil: 'பதிவு',
    },
    'Sign In to Your Account': {
      AppLanguage.english: 'Sign In to Your Account',
      AppLanguage.hindi: 'अपने खाते में साइन इन करें',
      AppLanguage.tamil: 'உங்கள் கணக்கில் உள்நுழைக',
    },
    'Create Artisan / Buyer Account': {
      AppLanguage.english: 'Create Artisan / Buyer Account',
      AppLanguage.hindi: 'कारीगर / खरीदार खाता बनाएं',
      AppLanguage.tamil: 'கைவினைஞர் / வாங்குபவர் கணக்கை உருவாக்கவும்',
    },
    'Mobile OTP': {
      AppLanguage.english: 'Mobile OTP',
      AppLanguage.hindi: 'मोबाइल ओटीपी',
      AppLanguage.tamil: 'மொபைல் OTP',
    },
    'Email & Password': {
      AppLanguage.english: 'Email & Password',
      AppLanguage.hindi: 'ईमेल और पासवर्ड',
      AppLanguage.tamil: 'மின்னஞ்சல் & கடவுச்சொல்',
    },
    'Mobile Number': {
      AppLanguage.english: 'Mobile Number',
      AppLanguage.hindi: 'मोबाइल नंबर',
      AppLanguage.tamil: 'கைபேசி எண்',
    },
    'Send OTP': {
      AppLanguage.english: 'Send OTP',
      AppLanguage.hindi: 'ओटीपी भेजें',
      AppLanguage.tamil: 'OTP அனுப்பு',
    },
    'Resend OTP': {
      AppLanguage.english: 'Resend OTP',
      AppLanguage.hindi: 'ओटीपी पुनः भेजें',
      AppLanguage.tamil: 'OTP மீண்டும் அனுப்பு',
    },
    'One Time Password (OTP)': {
      AppLanguage.english: 'One Time Password (OTP)',
      AppLanguage.hindi: 'वन टाइम पासवर्ड (ओटीपी)',
      AppLanguage.tamil: 'ஒரு முறை கடவுச்சொல் (OTP)',
    },
    'Enter 4-digit OTP': {
      AppLanguage.english: 'Enter 4-digit OTP',
      AppLanguage.hindi: '4 अंकों का ओटीपी दर्ज करें',
      AppLanguage.tamil: '4-இலக்க OTP உள்ளிடவும்',
    },
    'Full Name': {
      AppLanguage.english: 'Full Name',
      AppLanguage.hindi: 'पूरा नाम',
      AppLanguage.tamil: 'முழு பெயர்',
    },
    'Enter your full name': {
      AppLanguage.english: 'Enter your full name',
      AppLanguage.hindi: 'अपना पूरा नाम दर्ज करें',
      AppLanguage.tamil: 'உங்கள் முழு பெயரை உள்ளிடவும்',
    },
    'Email Address': {
      AppLanguage.english: 'Email Address',
      AppLanguage.hindi: 'ईमेल पता',
      AppLanguage.tamil: 'மின்னஞ்சல் முகவரி',
    },
    'Password': {
      AppLanguage.english: 'Password',
      AppLanguage.hindi: 'पासवर्ड',
      AppLanguage.tamil: 'கடவுச்சொல்',
    },
    'I am registering as': {
      AppLanguage.english: 'I am registering as',
      AppLanguage.hindi: 'मैं पंजीकरण कर रहा हूँ',
      AppLanguage.tamil: 'நான் பதிவு செய்வது',
    },
    'Artisan / Weaver': {
      AppLanguage.english: 'Artisan / Weaver',
      AppLanguage.hindi: 'कारीगर / बुनकर',
      AppLanguage.tamil: 'கைவினைஞர் / நெசவாளர்',
    },
    'Buyer / Enterprise': {
      AppLanguage.english: 'Buyer / Enterprise',
      AppLanguage.hindi: 'क्रेता / संस्था',
      AppLanguage.tamil: 'வாங்குபவர் / நிறுவனம்',
    },
    'Craft Category': {
      AppLanguage.english: 'Craft Category',
      AppLanguage.hindi: 'शिल्प श्रेणी',
      AppLanguage.tamil: 'கைவினை வகை',
    },
    'State / Cluster': {
      AppLanguage.english: 'State / Cluster',
      AppLanguage.hindi: 'राज्य / क्लस्टर',
      AppLanguage.tamil: 'மாநிலம் / மையம்',
    },
    'Organization / Business Name': {
      AppLanguage.english: 'Organization / Business Name',
      AppLanguage.hindi: 'संस्था / व्यापार का नाम',
      AppLanguage.tamil: 'நிறுவனத்தின் பெயர்',
    },
    '1-Tap Evaluator Quick Access': {
      AppLanguage.english: '1-Tap Evaluator Quick Access',
      AppLanguage.hindi: '1-क्लिक मूल्यांकनकर्ता त्वरित पहुंच',
      AppLanguage.tamil: '1-கிளிக் மதிப்பீட்டாளர் அணுகல்',
    },
    'Artisan (Ramdev Varma)': {
      AppLanguage.english: 'Artisan (Ramdev Varma)',
      AppLanguage.hindi: 'कारीगर (रामदेव वर्मा)',
      AppLanguage.tamil: 'கைவினைஞர் (ராம்தேவ் வர்மா)',
    },
    'Buyer (FabIndia B2B)': {
      AppLanguage.english: 'Buyer (FabIndia B2B)',
      AppLanguage.hindi: 'क्रेता (फैबइंडिया बी2बी)',
      AppLanguage.tamil: 'வாங்குபவர் (FabIndia B2B)',
    },
    'MoSJE Officer (Admin)': {
      AppLanguage.english: 'MoSJE Officer (Admin)',
      AppLanguage.hindi: 'मंत्रालय अधिकारी (प्रशासक)',
      AppLanguage.tamil: 'அரசு அதிகாரி (நிர்வாகி)',
    },
    'Already have an account? Login': {
      AppLanguage.english: 'Already have an account? Login',
      AppLanguage.hindi: 'पहले से खाता है? साइन इन करें',
      AppLanguage.tamil: 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழைக',
    },
    'Don\'t have an account? Register': {
      AppLanguage.english: 'Don\'t have an account? Register',
      AppLanguage.hindi: 'खाता नहीं है? पंजीकरण करें',
      AppLanguage.tamil: 'கணக்கு இல்லையா? பதிவு செய்க',
    },
    'Don\'t have an account?': {
      AppLanguage.english: 'Don\'t have an account?',
      AppLanguage.hindi: 'क्या आपके पास खाता नहीं है?',
      AppLanguage.tamil: 'கணக்கு இல்லையா?',
    },
    'Register Now': {
      AppLanguage.english: 'Register Now',
      AppLanguage.hindi: 'अभी पंजीकरण करें',
      AppLanguage.tamil: 'இப்போதே பதிவு செய்க',
    },
    'Already have an account?': {
      AppLanguage.english: 'Already have an account?',
      AppLanguage.hindi: 'क्या आपके पास पहले से खाता है?',
      AppLanguage.tamil: 'ஏற்கனவே கணக்கு உள்ளதா?',
    },
    'Sign In here': {
      AppLanguage.english: 'Sign In here',
      AppLanguage.hindi: 'यहाँ साइन इन करें',
      AppLanguage.tamil: 'இங்கே உள்நுழைக',
    },
    'Join as Artisan or Buyer': {
      AppLanguage.english: 'Join as Artisan or Buyer',
      AppLanguage.hindi: 'कारीगर या खरीदार के रूप में जुड़ें',
      AppLanguage.tamil: 'கைவினைஞர் அல்லது வாங்குபவராக சேரவும்',
    },
    'Sign In with Mobile or Email': {
      AppLanguage.english: 'Sign In with Mobile or Email',
      AppLanguage.hindi: 'मोबाइल या ईमेल से साइन इन करें',
      AppLanguage.tamil: 'மொபைல் அல்லது மின்னஞ்சல் மூலம் உள்நுழைக',
    },
    'Sign In & Continue': {
      AppLanguage.english: 'Sign In & Continue',
      AppLanguage.hindi: 'साइन इन करें और आगे बढ़ें',
      AppLanguage.tamil: 'உள்நுழைந்து தொடரவும்',
    },
    'Create Account': {
      AppLanguage.english: 'Create Account',
      AppLanguage.hindi: 'खाता बनाएं',
      AppLanguage.tamil: 'கணக்கை உருவாக்கு',
    },
    'Protected by Ministry of Social Justice & Empowerment': {
      AppLanguage.english: 'Protected by Ministry of Social Justice & Empowerment',
      AppLanguage.hindi: 'सामाजिक न्याय एवं अधिकारिता मंत्रालय द्वारा संरक्षित',
      AppLanguage.tamil: 'சமூக நீதி மற்றும் அதிகாரமளித்தல் அமைச்சகத்தால் பாதுகாக்கப்படுகிறது',
    },
    'Back to Marketplace': {
      AppLanguage.english: 'Back to Marketplace',
      AppLanguage.hindi: 'बाज़ार पर वापस जाएँ',
      AppLanguage.tamil: 'சந்தைக்குத் திரும்பு',
    },
    'Change Language': {
      AppLanguage.english: 'Change Language',
      AppLanguage.hindi: 'भाषा बदलें',
      AppLanguage.tamil: 'மொழியை மாற்றுக',
    },
    'AI Image Studio': {
      AppLanguage.english: 'AI Image Studio',
      AppLanguage.hindi: 'एआई इमेज स्टूडियो',
      AppLanguage.tamil: 'AI பட ஸ்டுடியோ',
    },
    'Stop': {
      AppLanguage.english: 'Stop',
      AppLanguage.hindi: 'रोकें',
      AppLanguage.tamil: 'நிறுத்து',
    },
    'Add custom tag...': {
      AppLanguage.english: 'Add custom tag...',
      AppLanguage.hindi: 'कस्टम टैग जोड़ें...',
      AppLanguage.tamil: 'தனிப்பயன் குறிச்சொல்லைச் சேர்க்கவும்...',
    },
    'Smart Pricing Engine': {
      AppLanguage.english: 'Smart Pricing Engine',
      AppLanguage.hindi: 'स्मार्ट मूल्य निर्धारण इंजन',
      AppLanguage.tamil: 'ஸ்மார்ட் விலை நிர்ணய இயந்திரம்',
    },
    'Enter a valid 10-digit mobile number': {
      AppLanguage.english: 'Enter a valid 10-digit mobile number',
      AppLanguage.hindi: 'मान्य 10-अंकीय मोबाइल नंबर दर्ज करें',
      AppLanguage.tamil: 'சரியான 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்',
    },
    'Failed to send OTP': {
      AppLanguage.english: 'Failed to send OTP',
      AppLanguage.hindi: 'ओटीपी भेजने में विफल',
      AppLanguage.tamil: 'OTP அனுப்ப முடியவில்லை',
    },
    'Please enter mobile number and OTP': {
      AppLanguage.english: 'Please enter mobile number and OTP',
      AppLanguage.hindi: 'कृपया मोबाइल नंबर और ओटीपी दर्ज करें',
      AppLanguage.tamil: 'தயவுசெய்து மொபைல் எண் மற்றும் OTP ஐ உள்ளிடவும்',
    },
    'Please enter email/phone and password': {
      AppLanguage.english: 'Please enter email/phone and password',
      AppLanguage.hindi: 'कृपया ईमेल/फोन और पासवर्ड दर्ज करें',
      AppLanguage.tamil: 'தயவுசெய்து மின்னஞ்சல்/தொலைபேசி மற்றும் கடவுச்சொல்லை உள்ளிடவும்',
    },
    'Authentication failed. Please verify your credentials.': {
      AppLanguage.english: 'Authentication failed. Please verify your credentials.',
      AppLanguage.hindi: 'प्रमाणीकरण विफल। कृपया अपने क्रेडेंशियल सत्यापित करें।',
      AppLanguage.tamil: 'அங்கீகரிப்பு தோல்வியடைந்தது. உங்கள் விவரங்களைச் சரிபார்க்கவும்.',
    },
    'Please enter your full name': {
      AppLanguage.english: 'Please enter your full name',
      AppLanguage.hindi: 'कृपया अपना पूरा नाम दर्ज करें',
      AppLanguage.tamil: 'உங்கள் முழு பெயரை உள்ளிடவும்',
    },
    'Please enter a valid mobile number': {
      AppLanguage.english: 'Please enter a valid mobile number',
      AppLanguage.hindi: 'कृपया एक मान्य मोबाइल नंबर दर्ज करें',
      AppLanguage.tamil: 'தயவுசெய்து சரியான மொபைல் எண்ணை உள்ளிடவும்',
    },
    'Account created successfully! Welcome to Karighar.': {
      AppLanguage.english: 'Account created successfully! Welcome to Karighar.',
      AppLanguage.hindi: 'खाता सफलतापूर्वक बनाया गया! कारीघर में आपका स्वागत है।',
      AppLanguage.tamil: 'கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டது! காரிகருக்கு நல்வரவு.',
    },
    'Registration failed. Please try again.': {
      AppLanguage.english: 'Registration failed. Please try again.',
      AppLanguage.hindi: 'पंजीकरण विफल। कृपया पुनः प्रयास करें।',
      AppLanguage.tamil: 'பதிவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.',
    },
    'CRAFT • CULTURE • COMMUNITY • OPPORTUNITY': {
      AppLanguage.english: 'CRAFT • CULTURE • COMMUNITY • OPPORTUNITY',
      AppLanguage.hindi: 'शिल्प • संस्कृति • समुदाय • अवसर',
      AppLanguage.tamil: 'கைவினை • கலாச்சாரம் • சமூகம் • வாய்ப்பு',
    },
    'Aadhaar / PM-Vishwakarma ID': {
      AppLanguage.english: 'Aadhaar / PM-Vishwakarma ID',
      AppLanguage.hindi: 'आधार / पीएम-विश्वकर्मा आईडी',
      AppLanguage.tamil: 'ஆதார் / பிஎம்-விஸ்வகர்மா ஐடி',
    },
  };
}

extension TranslateX on String {
  String get tr => LocaleManager.tr(this);
}
