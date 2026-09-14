import 'package:flutter/material.dart';

enum AppLanguage {
  // Bihari & Purvanchal Languages
  hindi,
  maithili,
  bhojpuri,
  magahi,
  angika,

  // 22 Official Scheduled Indian Languages
  assamese,
  bengali,
  bodo,
  dogri,
  gujarati,
  kannada,
  kashmiri,
  konkani,
  malayalam,
  manipuri,
  marathi,
  nepali,
  odia,
  punjabi,
  sanskrit,
  santali,
  sindhi,
  tamil,
  telugu,
  urdu,

  // International
  english,
}

class LocaleManager {
  static final ValueNotifier<AppLanguage> currentLanguage = ValueNotifier(AppLanguage.english);

  static void setLanguage(AppLanguage language) {
    currentLanguage.value = language;
  }

  static bool isBihariLanguage(AppLanguage lang) {
    return lang == AppLanguage.hindi ||
        lang == AppLanguage.maithili ||
        lang == AppLanguage.bhojpuri ||
        lang == AppLanguage.magahi ||
        lang == AppLanguage.angika;
  }

  static Locale getLocale(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi: return const Locale('hi', 'IN');
      case AppLanguage.maithili: return const Locale('mai', 'IN');
      case AppLanguage.bhojpuri: return const Locale('bho', 'IN');
      case AppLanguage.magahi: return const Locale('mag', 'IN');
      case AppLanguage.angika: return const Locale('anp', 'IN');
      case AppLanguage.assamese: return const Locale('as', 'IN');
      case AppLanguage.bengali: return const Locale('bn', 'IN');
      case AppLanguage.bodo: return const Locale('brx', 'IN');
      case AppLanguage.dogri: return const Locale('doi', 'IN');
      case AppLanguage.gujarati: return const Locale('gu', 'IN');
      case AppLanguage.kannada: return const Locale('kn', 'IN');
      case AppLanguage.kashmiri: return const Locale('ks', 'IN');
      case AppLanguage.konkani: return const Locale('kok', 'IN');
      case AppLanguage.malayalam: return const Locale('ml', 'IN');
      case AppLanguage.manipuri: return const Locale('mni', 'IN');
      case AppLanguage.marathi: return const Locale('mr', 'IN');
      case AppLanguage.nepali: return const Locale('ne', 'IN');
      case AppLanguage.odia: return const Locale('or', 'IN');
      case AppLanguage.punjabi: return const Locale('pa', 'IN');
      case AppLanguage.sanskrit: return const Locale('sa', 'IN');
      case AppLanguage.santali: return const Locale('sat', 'IN');
      case AppLanguage.sindhi: return const Locale('sd', 'IN');
      case AppLanguage.tamil: return const Locale('ta', 'IN');
      case AppLanguage.telugu: return const Locale('te', 'IN');
      case AppLanguage.urdu: return const Locale('ur', 'IN');
      case AppLanguage.english: return const Locale('en', 'US');
    }
  }

  static String getLanguageLabel(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi: return 'हि';
      case AppLanguage.maithili: return 'मै';
      case AppLanguage.bhojpuri: return 'भो';
      case AppLanguage.magahi: return 'मग';
      case AppLanguage.angika: return 'अं';
      case AppLanguage.assamese: return 'অ';
      case AppLanguage.bengali: return 'বা';
      case AppLanguage.bodo: return 'बो';
      case AppLanguage.dogri: return 'डो';
      case AppLanguage.gujarati: return 'ગુ';
      case AppLanguage.kannada: return 'ಕ';
      case AppLanguage.kashmiri: return 'ک';
      case AppLanguage.konkani: return 'कों';
      case AppLanguage.malayalam: return 'മ';
      case AppLanguage.manipuri: return 'মৈ';
      case AppLanguage.marathi: return 'म';
      case AppLanguage.nepali: return 'ने';
      case AppLanguage.odia: return 'ଓ';
      case AppLanguage.punjabi: return 'ਪੰ';
      case AppLanguage.sanskrit: return 'सं';
      case AppLanguage.santali: return 'सं';
      case AppLanguage.sindhi: return 'सिं';
      case AppLanguage.tamil: return 'த';
      case AppLanguage.telugu: return 'తె';
      case AppLanguage.urdu: return 'اردو';
      case AppLanguage.english: return 'EN';
    }
  }

  static String getLanguageName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi: return 'हिंदी (Hindi)';
      case AppLanguage.maithili: return 'मैथिली (Maithili - बिहार)';
      case AppLanguage.bhojpuri: return 'भोजपुरी (Bhojpuri - बिहार)';
      case AppLanguage.magahi: return 'मगही (Magahi - बिहार)';
      case AppLanguage.angika: return 'अंगिका (Angika - बिहार)';
      case AppLanguage.bengali: return 'বাংলা (Bengali)';
      case AppLanguage.tamil: return 'தமிழ் (Tamil)';
      case AppLanguage.telugu: return 'తెలుగు (Telugu)';
      case AppLanguage.marathi: return 'मराठी (Marathi)';
      case AppLanguage.gujarati: return 'ગુજરાતી (Gujarati)';
      case AppLanguage.kannada: return 'ಕನ್ನಡ (Kannada)';
      case AppLanguage.malayalam: return 'മലയാളം (Malayalam)';
      case AppLanguage.odia: return 'ଓଡ଼ିଆ (Odia)';
      case AppLanguage.punjabi: return 'ਪੰਜਾਬੀ (Punjabi)';
      case AppLanguage.assamese: return 'অসমীয়া (Assamese)';
      case AppLanguage.urdu: return 'اردو (Urdu)';
      case AppLanguage.sanskrit: return 'संस्कृतम् (Sanskrit)';
      case AppLanguage.kashmiri: return 'कश्मीरी (Kashmiri)';
      case AppLanguage.konkani: return 'कोंकणी (Konkani)';
      case AppLanguage.sindhi: return 'सिंधी (Sindhi)';
      case AppLanguage.nepali: return 'नेपाली (Nepali)';
      case AppLanguage.santali: return 'संताली (Santali)';
      case AppLanguage.bodo: return 'बड़ो (Bodo)';
      case AppLanguage.dogri: return 'डोगरी (Dogri)';
      case AppLanguage.manipuri: return 'মৈতৈলোন্ (Manipuri)';
      case AppLanguage.english: return 'English (Global)';
    }
  }

  static String tr(String key) {
    final lang = currentLanguage.value;

    // 1. Check regional/Bihari extended dictionary
    if (_bihariAndRegionalTranslations.containsKey(key)) {
      final regDict = _bihariAndRegionalTranslations[key]!;
      if (regDict.containsKey(lang)) {
        return regDict[lang]!;
      }
    }

    // 2. Direct match in base translations
    if (_translations.containsKey(key)) {
      final dict = _translations[key]!;
      if (dict.containsKey(lang)) return dict[lang]!;

      // Fallback for Bihari dialects to Hindi if available
      if (isBihariLanguage(lang) && dict.containsKey(AppLanguage.hindi)) {
        return dict[AppLanguage.hindi]!;
      }
      return dict[AppLanguage.english] ?? key;
    }

    // 3. Case-insensitive / trimmed match
    final trimmed = key.trim().toLowerCase();
    for (final entry in _translations.entries) {
      if (entry.key.toLowerCase() == trimmed) {
        if (entry.value.containsKey(lang)) return entry.value[lang]!;
        if (isBihariLanguage(lang) && entry.value.containsKey(AppLanguage.hindi)) {
          return entry.value[AppLanguage.hindi]!;
        }
        return entry.value[AppLanguage.english] ?? key;
      }
    }

    return key;
  }

  static void showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _LanguagePickerBottomSheet(),
    );
  }

  static final Map<String, Map<AppLanguage, String>> _bihariAndRegionalTranslations = {
    'app_title': {
      AppLanguage.maithili: 'कारीघर',
      AppLanguage.bhojpuri: 'कारीघर',
      AppLanguage.magahi: 'कारीघर',
      AppLanguage.angika: 'कारीघर',
      AppLanguage.bengali: 'কারিঘর',
      AppLanguage.telugu: 'కారిఘర్',
      AppLanguage.marathi: 'कारीघर',
      AppLanguage.gujarati: 'કારીઘર',
      AppLanguage.kannada: 'ಕಾರಿಘರ್',
      AppLanguage.malayalam: 'കാരിഘർ',
      AppLanguage.odia: 'କାରିଘର',
      AppLanguage.punjabi: 'ਕਾਰੀਘਰ',
      AppLanguage.assamese: 'কাৰীঘৰ',
      AppLanguage.urdu: 'کاری گھر',
      AppLanguage.sanskrit: 'कारिघरम्',
    },
    'KARIGHAR': {
      AppLanguage.maithili: 'कारीघर',
      AppLanguage.bhojpuri: 'कारीघर',
      AppLanguage.magahi: 'कारीघर',
      AppLanguage.angika: 'कारीघर',
      AppLanguage.bengali: 'কারিঘর',
      AppLanguage.telugu: 'కారిఘర్',
      AppLanguage.marathi: 'कारीघर',
      AppLanguage.gujarati: 'કારીઘર',
      AppLanguage.kannada: 'ಕಾರಿಘರ್',
      AppLanguage.malayalam: 'കാരിഘർ',
      AppLanguage.odia: 'କାରିଘର',
      AppLanguage.punjabi: 'ਕਾਰੀਘਰ',
      AppLanguage.assamese: 'কাৰীঘৰ',
      AppLanguage.urdu: 'کاری گھر',
      AppLanguage.sanskrit: 'कारिघरम्',
    },
    'Karighar': {
      AppLanguage.maithili: 'कारीघर',
      AppLanguage.bhojpuri: 'कारीघर',
      AppLanguage.magahi: 'कारीघर',
      AppLanguage.angika: 'कारीघर',
      AppLanguage.bengali: 'কারিঘর',
      AppLanguage.telugu: 'కారిఘర్',
      AppLanguage.marathi: 'कारीघर',
      AppLanguage.gujarati: 'કારીઘર',
      AppLanguage.kannada: 'ಕಾರಿಘರ್',
      AppLanguage.malayalam: 'കാരിഘർ',
      AppLanguage.odia: 'କାରିଘର',
      AppLanguage.punjabi: 'ਕਾਰੀਘਰ',
      AppLanguage.assamese: 'কাৰীঘৰ',
      AppLanguage.urdu: 'کاری گھر',
      AppLanguage.sanskrit: 'कारिघरम्',
    },
    'A Home for Artisans': {
      AppLanguage.maithili: 'कारीगर लोकनिक अपन घर',
      AppLanguage.bhojpuri: 'कारीगर लोगन के आपन घर',
      AppLanguage.magahi: 'कारीगर सबके आपन घर',
      AppLanguage.angika: 'कारीगर सिनी के अपन घर',
      AppLanguage.bengali: 'কারিগরদের নিজস্ব ঠিকানা',
      AppLanguage.telugu: 'చేతివృత్తుల వారి స్వగృహం',
      AppLanguage.marathi: 'कारागिरांचे हक्काचे घर',
      AppLanguage.gujarati: 'કારીગરોનું પોતાનું ઘર',
      AppLanguage.kannada: 'ಕುಶಲಕರ್ಮಿಗಳ ಸ್ವಂತ ಮನೆ',
      AppLanguage.malayalam: 'കരകൗശല വിദഗ്ദ്ധരുടെ സ്വന്തം ഭവനം',
      AppLanguage.odia: 'କାରିଗରମାନଙ୍କର ନିଜସ୍ୱ ଘର',
      AppLanguage.punjabi: 'ਕਾਰੀਗਰਾਂ ਦਾ ਆਪਣਾ ਘਰ',
      AppLanguage.assamese: 'শিল্পীসকলৰ আপোন ঘৰ',
      AppLanguage.urdu: 'دستکاروں کا اپنا گھر',
      AppLanguage.sanskrit: 'शिल्पिनां स्वकीय गृहम्',
    },
    'Dashboard': {
      AppLanguage.maithili: 'डैशबोर्ड',
      AppLanguage.bhojpuri: 'डैशबोर्ड',
      AppLanguage.magahi: 'डैशबोर्ड',
      AppLanguage.angika: 'डैशबोर्ड',
      AppLanguage.bengali: 'ড্যাশবোর্ড',
      AppLanguage.telugu: 'డ్యాష్‌బోర్డ్',
      AppLanguage.marathi: 'डॅशबोर्ड',
      AppLanguage.gujarati: 'ડેશબોર્ડ',
      AppLanguage.kannada: 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್',
      AppLanguage.malayalam: 'ഡാഷ്‌ബോർഡ്',
      AppLanguage.odia: 'ଡ୍ୟାସବୋର୍ଡ',
      AppLanguage.punjabi: 'ਡੈਸ਼ਬੋਰਡ',
      AppLanguage.assamese: 'ডেশ্ববৰ্ড',
      AppLanguage.urdu: 'ڈیش بورڈ',
      AppLanguage.sanskrit: 'फलकम्',
    },
    'AI Studio': {
      AppLanguage.maithili: 'एआई स्टुडियो',
      AppLanguage.bhojpuri: 'एआई स्टूडियो',
      AppLanguage.magahi: 'एआई स्टूडियो',
      AppLanguage.angika: 'एआई स्टूडियो',
      AppLanguage.bengali: 'এআই স্টুডিও',
      AppLanguage.telugu: 'AI స్టూడియో',
      AppLanguage.marathi: 'एआय स्टुडिओ',
      AppLanguage.gujarati: 'AI સ્ટુડિયો',
      AppLanguage.kannada: 'AI ಸ್ಟುಡಿಯೋ',
      AppLanguage.malayalam: 'AI സ്റ്റുഡിയോ',
      AppLanguage.odia: 'AI ଷ୍ଟୁଡିଓ',
      AppLanguage.punjabi: 'AI ਸਟੂਡੀਓ',
      AppLanguage.assamese: 'AI ষ্টুডিঅ’',
      AppLanguage.urdu: 'اے آئی اسٹوڈیو',
      AppLanguage.sanskrit: 'एआई कार्यशाला',
    },
    'Orders': {
      AppLanguage.maithili: 'आर्डर / समादेश',
      AppLanguage.bhojpuri: 'ऑर्डर सभ',
      AppLanguage.magahi: 'ऑर्डर',
      AppLanguage.angika: 'ऑर्डर',
      AppLanguage.bengali: 'অর্ডার সমূহ',
      AppLanguage.telugu: 'ఆర్డర్లు',
      AppLanguage.marathi: 'ऑर्डर्स',
      AppLanguage.gujarati: 'ઓર્ડર્સ',
      AppLanguage.kannada: 'ಆದೇಶಗಳು',
      AppLanguage.malayalam: 'ഓർഡറുകൾ',
      AppLanguage.odia: 'ଅର୍ଡରଗୁଡ଼ିକ',
      AppLanguage.punjabi: 'ਆਰਡਰ',
      AppLanguage.assamese: 'অৰ্ডাৰসমূহ',
      AppLanguage.urdu: 'آرڈرز',
      AppLanguage.sanskrit: 'आदेशाः',
    },
    'Quotes': {
      AppLanguage.maithili: 'प्रस्ताव',
      AppLanguage.bhojpuri: 'मोल-भाव',
      AppLanguage.magahi: 'भाव-ताव',
      AppLanguage.angika: 'प्रस्ताव',
      AppLanguage.bengali: 'দরদাম প্রস্তাব',
      AppLanguage.telugu: 'కోట్స్',
      AppLanguage.marathi: 'कोटेशन्स',
      AppLanguage.gujarati: 'ભાવપત્રક',
      AppLanguage.kannada: 'ದರಪಟ್ಟಿ',
      AppLanguage.malayalam: 'വിലവിവരങ്ങൾ',
      AppLanguage.odia: 'ମୂଲ୍ୟ ପ୍ରସ୍ତାବ',
      AppLanguage.punjabi: 'ਕੋਟਸ',
      AppLanguage.assamese: 'মূল্য প্ৰস্তাৱ',
      AppLanguage.urdu: 'کوٹس',
      AppLanguage.sanskrit: 'मूल्यप्रस्तावाः',
    },
    'Earnings': {
      AppLanguage.maithili: 'कमाई / आमदनी',
      AppLanguage.bhojpuri: 'कमाई',
      AppLanguage.magahi: 'कमाई',
      AppLanguage.angika: 'कमाई',
      AppLanguage.bengali: 'উপার্জন',
      AppLanguage.telugu: 'ఆదాయం',
      AppLanguage.marathi: 'कमाई / उत्पन्न',
      AppLanguage.gujarati: 'કમાણી',
      AppLanguage.kannada: 'ಗಳಿಕೆ',
      AppLanguage.malayalam: 'വരുമാനം',
      AppLanguage.odia: 'ଉପାର୍ଜନ',
      AppLanguage.punjabi: 'ਕਮਾਈ',
      AppLanguage.assamese: 'উপাৰ্জন',
      AppLanguage.urdu: 'آمدنی',
      AppLanguage.sanskrit: 'आयः / उपार्जनम्',
    },
    'Explore': {
      AppLanguage.maithili: 'खोजू',
      AppLanguage.bhojpuri: 'खोजीं',
      AppLanguage.magahi: 'खोजऽ',
      AppLanguage.angika: 'खोजो',
      AppLanguage.bengali: 'অনুসন্ধান',
      AppLanguage.telugu: 'అన్వేషించండి',
      AppLanguage.marathi: 'शोधा',
      AppLanguage.gujarati: 'શોધો',
      AppLanguage.kannada: 'ಅನ್ವೇಷಿಸಿ',
      AppLanguage.malayalam: 'കണ്ടെത്തുക',
      AppLanguage.odia: 'ଅନ୍ୱେଷଣ କରନ୍ତୁ',
      AppLanguage.punjabi: 'ਖੋਜੋ',
      AppLanguage.assamese: 'অনুসন্ধান কৰক',
      AppLanguage.urdu: 'تلاش کریں',
      AppLanguage.sanskrit: 'अन्वेषणम्',
    },
    'Cart': {
      AppLanguage.maithili: 'थैली / कार्ट',
      AppLanguage.bhojpuri: 'झोरा / कार्ट',
      AppLanguage.magahi: 'झोरा / कार्ट',
      AppLanguage.angika: 'थैला / कार्ट',
      AppLanguage.bengali: 'কার্ট',
      AppLanguage.telugu: 'కార్ట్',
      AppLanguage.marathi: 'कार्ट',
      AppLanguage.gujarati: 'કાર્ટ',
      AppLanguage.kannada: 'ಕಾರ್ಟ್',
      AppLanguage.malayalam: 'കാർട്ട്',
      AppLanguage.odia: 'କାର୍ଟ',
      AppLanguage.punjabi: 'ਕਾਰਟ',
      AppLanguage.assamese: 'কাৰ্ট',
      AppLanguage.urdu: 'ٹوکری',
      AppLanguage.sanskrit: 'पात्रम्',
    },
    'Chat': {
      AppLanguage.maithili: 'वार्ता / चैट',
      AppLanguage.bhojpuri: 'बातचीत / चैट',
      AppLanguage.magahi: 'गोठबात / चैट',
      AppLanguage.angika: 'बातचीत / चैट',
      AppLanguage.bengali: 'আড্ডা / চ্যাট',
      AppLanguage.telugu: 'చాట్',
      AppLanguage.marathi: 'संभाषण / चॅट',
      AppLanguage.gujarati: 'વાતચીત',
      AppLanguage.kannada: 'ಸಂಭಾಷಣೆ',
      AppLanguage.malayalam: 'ചാറ്റ്',
      AppLanguage.odia: 'ଚାଟ୍',
      AppLanguage.punjabi: 'ਗੱਲਬਾਤ',
      AppLanguage.assamese: 'বাৰ্তালাপ',
      AppLanguage.urdu: 'بات چیت',
      AppLanguage.sanskrit: 'वार्तालापः',
    },
    'Tour': {
      AppLanguage.maithili: 'टूर / दर्शन',
      AppLanguage.bhojpuri: 'टूर / भ्रमण',
      AppLanguage.magahi: 'टूर',
      AppLanguage.angika: 'टूर',
      AppLanguage.bengali: 'ট্যুর',
      AppLanguage.telugu: 'టూర్',
      AppLanguage.marathi: 'टूर',
      AppLanguage.gujarati: 'ટૂર',
      AppLanguage.kannada: 'ಪ್ರವಾಸ',
      AppLanguage.malayalam: 'ടൂർ',
      AppLanguage.odia: 'ଟୁର',
      AppLanguage.punjabi: 'ਟੂਰ',
      AppLanguage.assamese: 'ভ্ৰমণ',
      AppLanguage.urdu: 'دورہ',
      AppLanguage.sanskrit: 'पर्यटनम्',
    },
    'Artisan': {
      AppLanguage.maithili: 'कारीगर',
      AppLanguage.bhojpuri: 'कारीगर',
      AppLanguage.magahi: 'कारीगर',
      AppLanguage.angika: 'कारीगर',
      AppLanguage.bengali: 'কারিগর',
      AppLanguage.telugu: 'చేతివృత్తి నిపుణుడు',
      AppLanguage.marathi: 'कारागीर',
      AppLanguage.gujarati: 'કારીગર',
      AppLanguage.kannada: 'ಕುಶಲಕರ್ಮಿ',
      AppLanguage.malayalam: 'കരകൗശല വിദഗ്ദ്ധൻ',
      AppLanguage.odia: 'କାରିଗର',
      AppLanguage.punjabi: 'ਕਾਰੀਗਰ',
      AppLanguage.assamese: 'শিল্পী',
      AppLanguage.urdu: 'دستکار',
      AppLanguage.sanskrit: 'शिल्पी',
    },
    'Buyer': {
      AppLanguage.maithili: 'गाहक / क्रेता',
      AppLanguage.bhojpuri: 'खरीददार / गाहक',
      AppLanguage.magahi: 'क्रेता / गाहक',
      AppLanguage.angika: 'खरीदार / क्रेता',
      AppLanguage.bengali: 'ক্রেতা',
      AppLanguage.telugu: 'కొనుగోలుదారు',
      AppLanguage.marathi: 'खरेदीदार',
      AppLanguage.gujarati: 'ખરીદદાર',
      AppLanguage.kannada: 'ಖರೀದಿದಾರ',
      AppLanguage.malayalam: 'വാങ്ങുന്നയാൾ',
      AppLanguage.odia: 'କ୍ରେତା',
      AppLanguage.punjabi: 'ਖਰੀਦਦਾਰ',
      AppLanguage.assamese: 'ক্ৰেতা',
      AppLanguage.urdu: 'خریدار',
      AppLanguage.sanskrit: 'क्रेता',
    },
    'Admin': {
      AppLanguage.maithili: 'प्रशासक',
      AppLanguage.bhojpuri: 'प्रशासक',
      AppLanguage.magahi: 'प्रशासक',
      AppLanguage.angika: 'प्रशासक',
      AppLanguage.bengali: 'প্রশাসক',
      AppLanguage.telugu: 'నిర్వాహకుడు',
      AppLanguage.marathi: 'प्रशासक',
      AppLanguage.gujarati: 'સંચાલક',
      AppLanguage.kannada: 'ನಿರ್ವಾಹಕ',
      AppLanguage.malayalam: 'അഡ്മിൻ',
      AppLanguage.odia: 'ପ୍ରଶାସକ',
      AppLanguage.punjabi: 'ਪ੍ਰਸ਼ਾਸਕ',
      AppLanguage.assamese: 'প্ৰশাসক',
      AppLanguage.urdu: 'منتظم',
      AppLanguage.sanskrit: 'प्रशासकः',
    },
    'Change Language': {
      AppLanguage.maithili: 'भाषा बदलो',
      AppLanguage.bhojpuri: 'भाषा बदलीं',
      AppLanguage.magahi: 'भाषा बदलऽ',
      AppLanguage.angika: 'भाषा बदलो',
      AppLanguage.bengali: 'ভাষা পরিবর্তন করুন',
      AppLanguage.telugu: 'భాషను మార్చండి',
      AppLanguage.marathi: 'भाषा बदला',
      AppLanguage.gujarati: 'ભાષા બદલો',
      AppLanguage.kannada: 'ಭಾಷೆಯನ್ನು ಬದಲಾಯಿಸಿ',
      AppLanguage.malayalam: 'ഭാഷ മാറ്റുക',
      AppLanguage.odia: 'ଭାଷା ପରିବର୍ତ୍ତନ କରନ୍ତୁ',
      AppLanguage.punjabi: 'ਭਾਸ਼ਾ ਬਦਲੋ',
      AppLanguage.assamese: 'ভাষা সলনি কৰক',
      AppLanguage.urdu: 'زبان تبدیل کریں',
      AppLanguage.sanskrit: 'भाषां परिवर्तयतु',
    },
    'Login': {
      AppLanguage.maithili: 'प्रवेश करू',
      AppLanguage.bhojpuri: 'लॉग इन करीं',
      AppLanguage.magahi: 'प्रवेश करऽ',
      AppLanguage.angika: 'प्रवेश करिया',
      AppLanguage.bengali: 'লগ ইন',
      AppLanguage.telugu: 'లాగిన్',
      AppLanguage.marathi: 'लॉग इन करा',
      AppLanguage.gujarati: 'લૉગ ઇન',
      AppLanguage.kannada: 'ಲಾಗಿನ್',
      AppLanguage.malayalam: 'ലോഗിൻ',
      AppLanguage.odia: 'ଲଗ୍ ଇନ୍',
      AppLanguage.punjabi: 'ਲਾਗ ਇਨ',
      AppLanguage.assamese: 'লগ ইন',
      AppLanguage.urdu: 'لاگ ان',
      AppLanguage.sanskrit: 'प्रवेशः',
    },
    'Register': {
      AppLanguage.maithili: 'पंजीकरण करू',
      AppLanguage.bhojpuri: 'खाता बनाईं',
      AppLanguage.magahi: 'खाता बनावऽ',
      AppLanguage.angika: 'खाता बनावो',
      AppLanguage.bengali: 'নিবন্ধন',
      AppLanguage.telugu: 'నమోదు చేయండి',
      AppLanguage.marathi: 'नोंदणी करा',
      AppLanguage.gujarati: 'નોંધણી',
      AppLanguage.kannada: 'ನೋಂದಣಿ',
      AppLanguage.malayalam: 'രജിസ്റ്റർ ചെയ്യുക',
      AppLanguage.odia: 'ପଞ୍ଜୀକରଣ',
      AppLanguage.punjabi: 'ਰਜਿਸਟਰ ਕਰੋ',
      AppLanguage.assamese: 'পঞ্জীয়ন',
      AppLanguage.urdu: 'رجسٹر کریں',
      AppLanguage.sanskrit: 'पञ्जीकरणम्',
    },
    'Welcome': {
      AppLanguage.maithili: 'अभिनंदन / प्रणाम',
      AppLanguage.bhojpuri: 'राउर स्वागत बा',
      AppLanguage.magahi: 'तोहार स्वागत हे',
      AppLanguage.angika: 'अपने के स्वागत छै',
      AppLanguage.bengali: 'স্বাগতম',
      AppLanguage.telugu: 'స్వాగతం',
      AppLanguage.marathi: 'स्वागत आहे',
      AppLanguage.gujarati: 'સ્વાગત છે',
      AppLanguage.kannada: 'ಸ್ವಾಗತ',
      AppLanguage.malayalam: 'സ്വാഗതം',
      AppLanguage.odia: 'ସ୍ୱାଗତ',
      AppLanguage.punjabi: 'ਜੀ ਆਇਆਂ ਨੂੰ',
      AppLanguage.assamese: 'স্বাগতম',
      AppLanguage.urdu: 'خوش آمدید',
      AppLanguage.sanskrit: 'स्वागतम्',
    }
  };

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

    // 🛍️ Buyer Header, Search & Navigation
    'Search': {
      AppLanguage.english: 'Search',
      AppLanguage.hindi: 'खोजें',
      AppLanguage.tamil: 'தேடு',
      AppLanguage.bengali: 'অনুসন্ধান',
      AppLanguage.telugu: 'వెతకండి',
      AppLanguage.marathi: 'शोधा',
      AppLanguage.gujarati: 'શોધો',
    },
    'All Crafts': {
      AppLanguage.english: 'All Crafts',
      AppLanguage.hindi: 'सभी शिल्प',
      AppLanguage.tamil: 'அனைத்து கைவினைகள்',
      AppLanguage.bengali: 'সকল হস্তশিল্প',
      AppLanguage.telugu: 'అన్ని చేతిపనులు',
      AppLanguage.marathi: 'सर्व हस्तकला',
      AppLanguage.gujarati: 'બધી હસ્તકલા',
    },
    'Silk Sarees': {
      AppLanguage.english: 'Silk Sarees',
      AppLanguage.hindi: 'सिल्क साड़ियाँ',
      AppLanguage.tamil: 'பட்டுப் புடவைகள்',
      AppLanguage.bengali: 'রেশম শাড়ি',
      AppLanguage.telugu: 'పట్టు చీరలు',
      AppLanguage.marathi: 'रेशमी साड्या',
      AppLanguage.gujarati: 'રેશમી સાડીઓ',
    },
    'Mithila Art': {
      AppLanguage.english: 'Mithila Art',
      AppLanguage.hindi: 'मिथिला कला',
      AppLanguage.tamil: 'மிதிலா கலை',
      AppLanguage.bengali: 'মিথিলা শিল্প',
      AppLanguage.telugu: 'మిథిలా కళ',
      AppLanguage.marathi: 'मिथिला कला',
      AppLanguage.gujarati: 'મિથિલા કલા',
    },
    'Folk Art': {
      AppLanguage.english: 'Folk Art',
      AppLanguage.hindi: 'लोक कला',
      AppLanguage.tamil: 'நாட்டுப்புறக் கலை',
      AppLanguage.bengali: 'লোকশিল্প',
      AppLanguage.telugu: 'జానపద కళ',
      AppLanguage.marathi: 'लोककला',
      AppLanguage.gujarati: 'લોક કલા',
    },
    'Terracotta': {
      AppLanguage.english: 'Terracotta',
      AppLanguage.hindi: 'टेराकोटा मिट्टी',
      AppLanguage.tamil: 'சுடுமண் கலை',
      AppLanguage.bengali: 'পোড়ামাটি',
      AppLanguage.telugu: 'టెర్రకోట',
      AppLanguage.marathi: 'टेराकोटा',
      AppLanguage.gujarati: 'ટેરાકોટા',
    },
    'Clay Terracotta': {
      AppLanguage.english: 'Clay Terracotta',
      AppLanguage.hindi: 'टेराकोटा मिट्टी',
      AppLanguage.tamil: 'சுடுமண் கலை',
      AppLanguage.bengali: 'পোড়ামাটির কাজ',
      AppLanguage.telugu: 'టెర్రకోట మట్టి',
      AppLanguage.marathi: 'मातीचे काम',
      AppLanguage.gujarati: 'માટીકામ',
    },
    'Wooden Toys': {
      AppLanguage.english: 'Wooden Toys',
      AppLanguage.hindi: 'लकड़ी के खिलौने',
      AppLanguage.tamil: 'மர பொம்மைகள்',
      AppLanguage.bengali: 'কাঠের খেলনা',
      AppLanguage.telugu: 'చెక్క బొమ్మలు',
      AppLanguage.marathi: 'लाकडी खेळणी',
      AppLanguage.gujarati: 'લાકડાના રમકડાં',
    },
    'Wooden Crafts': {
      AppLanguage.english: 'Wooden Crafts',
      AppLanguage.hindi: 'काष्ठ शिल्प',
      AppLanguage.tamil: 'மரக் கைவினை',
      AppLanguage.bengali: 'কাষ্ঠশিল্প',
      AppLanguage.telugu: 'చెక్క చేతిపనులు',
      AppLanguage.marathi: 'लाकडी कलाकुसर',
      AppLanguage.gujarati: 'કાષ્ઠ હસ્તકલા',
    },
    'Brass & Metal': {
      AppLanguage.english: 'Brass & Metal',
      AppLanguage.hindi: 'पीतल एवं धातु शिल्प',
      AppLanguage.tamil: 'பித்தளை மற்றும் உலோகம்',
      AppLanguage.bengali: 'পিতল ও ধাতুশিল্প',
      AppLanguage.telugu: 'ఇత్తడి మరియు లోహం',
      AppLanguage.marathi: 'पितळ व धातू कला',
      AppLanguage.gujarati: 'પિત્તળ અને ધાતુ',
    },
    'Metal & Bell Craft': {
      AppLanguage.english: 'Metal & Bell Craft',
      AppLanguage.hindi: 'पीतल एवं धातु शिल्प',
      AppLanguage.tamil: 'பித்தளை மணி கைவினை',
      AppLanguage.bengali: 'ধাতব বেল শিল্প',
      AppLanguage.telugu: 'లోహ గంటల చేతిపని',
      AppLanguage.marathi: 'धातू व घंटा कला',
      AppLanguage.gujarati: 'ધાતુ અને ઘંટ કલા',
    },
    'B2B RFP Tenders': {
      AppLanguage.english: 'B2B RFP Tenders',
      AppLanguage.hindi: 'थोक निविदाएं (B2B)',
      AppLanguage.tamil: 'மொத்த டெண்டர்கள் (B2B)',
      AppLanguage.bengali: 'বি২বি দরপত্র',
      AppLanguage.telugu: 'బి2బి టెండర్లు',
      AppLanguage.marathi: 'बी2बी निविदा',
      AppLanguage.gujarati: 'બી૨બી ટેન્ડરો',
    },
    'Blockchain Ledger': {
      AppLanguage.english: 'Blockchain Ledger',
      AppLanguage.hindi: 'ब्लॉकचेन बहीखाता',
      AppLanguage.tamil: 'பிளாக்செயின் லெட்ஜர்',
      AppLanguage.bengali: 'ব্লকচেইন লেজার',
      AppLanguage.telugu: 'బ్లాక్‌చెయిన్ లెడ్జర్',
      AppLanguage.marathi: 'ब्लॉकचेन लेजर',
      AppLanguage.gujarati: 'બ્લોકચેન લેજર',
    },
    'Textiles & Weaves': {
      AppLanguage.english: 'Textiles & Weaves',
      AppLanguage.hindi: 'वस्त्र एवं हथकरघा',
      AppLanguage.tamil: 'ஜவுளி மற்றும் நெசவுகள்',
      AppLanguage.bengali: 'বস্ত্র ও বয়নশিল্প',
      AppLanguage.telugu: 'వస్త్రాలు మరియు నేత',
      AppLanguage.marathi: 'कापड व विणकाम',
      AppLanguage.gujarati: 'કાપડ અને વણાટ',
    },
    'Folk Art & Paintings': {
      AppLanguage.english: 'Folk Art & Paintings',
      AppLanguage.hindi: 'लोक कला एवं चित्रकारी',
      AppLanguage.tamil: 'நாட்டுப்புறக் கலை & ஓவியங்கள்',
      AppLanguage.bengali: 'লোকশিল্প ও চিত্রকর্ম',
      AppLanguage.telugu: 'జానపద కళ & చిత్రాలు',
      AppLanguage.marathi: 'लोककला आणि चित्रे',
      AppLanguage.gujarati: 'લોકકલા અને ચિત્રો',
    },
    'Ceramics & Pottery': {
      AppLanguage.english: 'Ceramics & Pottery',
      AppLanguage.hindi: 'मिट्टी के बर्तन एवं सिरेमिक्स',
      AppLanguage.tamil: 'மட்பாண்டங்கள் மற்றும் பீங்கான்',
      AppLanguage.bengali: 'মৃৎশিল্প ও সিরামিক',
      AppLanguage.telugu: 'మట్టిపాత్రలు & పింగాణీ',
      AppLanguage.marathi: 'मातीची भांडी व सिरॅमिक्स',
      AppLanguage.gujarati: 'માટીકામ અને પોટરી',
    },
    'Woodcraft & Toys': {
      AppLanguage.english: 'Woodcraft & Toys',
      AppLanguage.hindi: 'काष्ठ शिल्प एवं खिलौने',
      AppLanguage.tamil: 'மரவேலை & பொம்மைகள்',
      AppLanguage.bengali: 'কাঠের কাজ ও খেলনা',
      AppLanguage.telugu: 'చెక్కపని & బొమ్మలు',
      AppLanguage.marathi: 'लाकूडकाम आणि खेळणी',
      AppLanguage.gujarati: 'લાકડાકામ અને રમકડાં',
    },
    'Wishlist': {
      AppLanguage.english: 'Wishlist',
      AppLanguage.hindi: 'पसंदीदा सूची',
      AppLanguage.tamil: 'விருப்பப்பட்டியல்',
      AppLanguage.bengali: 'পছন্দের তালিকা',
      AppLanguage.telugu: 'కోరికల జాబితా',
      AppLanguage.marathi: 'आवडीची यादी',
      AppLanguage.gujarati: 'પસંદગી યાદી',
    },
    'Add to Cart': {
      AppLanguage.english: 'Add to Cart',
      AppLanguage.hindi: 'कार्ट में जोड़ें',
      AppLanguage.tamil: 'கூடையில் சேர்',
      AppLanguage.bengali: 'কার্টে যোগ করুন',
      AppLanguage.telugu: 'కార్ట్‌కు జోడించు',
      AppLanguage.marathi: 'कार्टमध्ये जोडा',
      AppLanguage.gujarati: 'કાર્ટમાં ઉમેરો',
    },
    'ADD TO CART': {
      AppLanguage.english: 'ADD TO CART',
      AppLanguage.hindi: 'कार्ट में जोड़ें',
      AppLanguage.tamil: 'கூடையில் சேர்',
      AppLanguage.bengali: 'কার্টে যোগ করুন',
      AppLanguage.telugu: 'కార్ట్‌కు జోడించు',
      AppLanguage.marathi: 'कार्टमध्ये जोडा',
      AppLanguage.gujarati: 'કાર્ટમાં ઉમેરો',
    },
    'Buy Now': {
      AppLanguage.english: 'Buy Now',
      AppLanguage.hindi: 'अभी खरीदें',
      AppLanguage.tamil: 'இப்போதே வாங்கு',
      AppLanguage.bengali: 'এখনই কিনুন',
      AppLanguage.telugu: 'ఇప్పుడే కొనండి',
      AppLanguage.marathi: 'आता खरेदी करा',
      AppLanguage.gujarati: 'હમણાં ખરીદો',
    },
    'BUY NOW': {
      AppLanguage.english: 'BUY NOW',
      AppLanguage.hindi: 'अभी खरीदें',
      AppLanguage.tamil: 'இப்போதே வாங்கு',
      AppLanguage.bengali: 'এখনই কিনুন',
      AppLanguage.telugu: 'ఇప్పుడే కొనండి',
      AppLanguage.marathi: 'आता खरेदी करा',
      AppLanguage.gujarati: 'હમણાં ખરીદો',
    },
    'GI Certified': {
      AppLanguage.english: 'GI Certified',
      AppLanguage.hindi: 'जीआई प्रमाणित',
      AppLanguage.tamil: 'GI சான்றளிக்கப்பட்டது',
      AppLanguage.bengali: 'জিআই প্রত্যয়িত',
      AppLanguage.telugu: 'జిఐ సర్టిఫైడ్',
      AppLanguage.marathi: 'जीआय प्रमाणित',
      AppLanguage.gujarati: 'જીઆઈ પ્રમાણિત',
    },
    'GI Tag Verified': {
      AppLanguage.english: 'GI Tag Verified',
      AppLanguage.hindi: 'जीआई टैग सत्यापित',
      AppLanguage.tamil: 'GI குறி சரிபார்க்கப்பட்டது',
      AppLanguage.bengali: 'জিআই ট্যাগ যাচাইকৃত',
      AppLanguage.telugu: 'జిఐ ట్యాగ్ ధృవీకరించబడింది',
      AppLanguage.marathi: 'जीआय टॅग पडताळणीकृत',
      AppLanguage.gujarati: 'જીઆઈ ટેગ ચકાસાયેલ',
    },
    'Free Delivery': {
      AppLanguage.english: 'Free Delivery',
      AppLanguage.hindi: 'मुफ़्त डिलीवरी',
      AppLanguage.tamil: 'இலவச டெலிவரி',
      AppLanguage.bengali: 'বিনামূল্যে ডেলিভারি',
      AppLanguage.telugu: 'ఉచిత డెలివరీ',
      AppLanguage.marathi: 'मोफत डिलिव्हरी',
      AppLanguage.gujarati: 'મફત ડિલિવરી',
    },
    'Free Express Delivery': {
      AppLanguage.english: 'Free Express Delivery',
      AppLanguage.hindi: 'मुफ़्त एक्सप्रेस डिलीवरी',
      AppLanguage.tamil: 'இலவச விரைவு டெலிவரி',
      AppLanguage.bengali: 'বিনামূল্যে এক্সপ্রেস ডেলিভারি',
      AppLanguage.telugu: 'ఉచిత ఎక్స్‌ప్రెస్ డెలివరీ',
      AppLanguage.marathi: 'मोफत जलद डिलिव्हरी',
      AppLanguage.gujarati: 'મફત એક્સપ્રેસ ડિલિવરી',
    },
    'Filters': {
      AppLanguage.english: 'Filters',
      AppLanguage.hindi: 'फ़िल्टर',
      AppLanguage.tamil: 'வடிகட்டிகள்',
      AppLanguage.bengali: 'ফিল্টার',
      AppLanguage.telugu: 'ఫిల్టర్లు',
      AppLanguage.marathi: 'फिल्टर्स',
      AppLanguage.gujarati: 'ફિલ્ટર્સ',
    },
    'Price Range': {
      AppLanguage.english: 'Price Range',
      AppLanguage.hindi: 'मूल्य सीमा',
      AppLanguage.tamil: 'விலை வரம்பு',
      AppLanguage.bengali: 'দামের পরিসর',
      AppLanguage.telugu: 'ధర పరిధి',
      AppLanguage.marathi: 'किंमत श्रेणी',
      AppLanguage.gujarati: 'કિંમત શ્રેણી',
    },
    'Craft Cluster / State': {
      AppLanguage.english: 'Craft Cluster / State',
      AppLanguage.hindi: 'शिल्प क्लस्टर / राज्य',
      AppLanguage.tamil: 'கைவினைத் தொகுப்பு / மாநிலம்',
      AppLanguage.bengali: 'শিল্প ক্লাস্টার / রাজ্য',
      AppLanguage.telugu: 'క్రాఫ్ట్ క్లస్టర్ / రాష్ట్రం',
      AppLanguage.marathi: 'हस्तकला समूह / राज्य',
      AppLanguage.gujarati: 'હસ્તકલા ક્લસ્ટર / રાજ્ય',
    },
    'Master Artisan Honors': {
      AppLanguage.english: 'Master Artisan Honors',
      AppLanguage.hindi: 'कारीगर सम्मान व पुरस्कार',
      AppLanguage.tamil: 'தலைமை கைவினைஞர் கௌரவங்கள்',
      AppLanguage.bengali: 'কারিগর সম্মাননা',
      AppLanguage.telugu: 'మాస్టర్ ఆర్టిసన్ గౌరవాలు',
      AppLanguage.marathi: 'कारागीर सन्मान',
      AppLanguage.gujarati: 'કારીગર સન્માન',
    },
    'Clear All Filters': {
      AppLanguage.english: 'Clear All Filters',
      AppLanguage.hindi: 'सभी फ़िल्टर हटाएं',
      AppLanguage.tamil: 'அனைத்து வடிகட்டிகளையும் அகற்று',
      AppLanguage.bengali: 'সব ফিল্টার সাফ করুন',
      AppLanguage.telugu: 'అన్ని ఫిల్టర్లను తొలగించు',
      AppLanguage.marathi: 'सर्व फिल्टर्स काढा',
      AppLanguage.gujarati: 'બધા ફિલ્ટર્સ સાફ કરો',
    },
    'Sort By': {
      AppLanguage.english: 'Sort By',
      AppLanguage.hindi: 'क्रमबद्ध करें',
      AppLanguage.tamil: 'வரிசைப்படுத்து',
      AppLanguage.bengali: 'ক্রমানুসারে সাজান',
      AppLanguage.telugu: 'క్రమబద్ధీకరించు',
      AppLanguage.marathi: 'क्रमवारी लावा',
      AppLanguage.gujarati: 'ક્રમબદ્ધ કરો',
    },
    'Popularity': {
      AppLanguage.english: 'Popularity',
      AppLanguage.hindi: 'लोकप्रियता',
      AppLanguage.tamil: 'பிரபலம்',
      AppLanguage.bengali: 'জনপ্রিয়তা',
      AppLanguage.telugu: 'జనాదరణ',
      AppLanguage.marathi: 'लोकप्रियता',
      AppLanguage.gujarati: 'લોકપ્રિયતા',
    },
    'Price: Low to High': {
      AppLanguage.english: 'Price: Low to High',
      AppLanguage.hindi: 'मूल्य: कम से अधिक',
      AppLanguage.tamil: 'விலை: குறைவாக இருந்து அதிகமாக',
      AppLanguage.bengali: 'দাম: কম থেকে বেশি',
      AppLanguage.telugu: 'ధర: తక్కువ నుండి ఎక్కువ',
      AppLanguage.marathi: 'किंमत: कमी ते जास्त',
      AppLanguage.gujarati: 'કિંમત: ઓછાથી વધુ',
    },
    'Price: High to Low': {
      AppLanguage.english: 'Price: High to Low',
      AppLanguage.hindi: 'मूल्य: अधिक से कम',
      AppLanguage.tamil: 'விலை: அதிகமாக இருந்து குறைவாக',
      AppLanguage.bengali: 'দাম: বেশি থেকে কম',
      AppLanguage.telugu: 'ధర: ఎక్కువ నుండి తక్కువ',
      AppLanguage.marathi: 'किंमत: जास्त ते कमी',
      AppLanguage.gujarati: 'કિંમત: વધુથી ઓછા',
    },
    'Customer Rating': {
      AppLanguage.english: 'Customer Rating',
      AppLanguage.hindi: 'ग्राहक रेटिंग',
      AppLanguage.tamil: 'வாடிக்கையாளர் மதிப்பீடு',
      AppLanguage.bengali: 'গ্রাহক রেটিং',
      AppLanguage.telugu: 'కస్టమర్ రేటింగ్',
      AppLanguage.marathi: 'ग्राहक रेटिंग',
      AppLanguage.gujarati: 'ગ્રાહક રેટિંગ',
    },
    'Discovered Crafts': {
      AppLanguage.english: 'Discovered Crafts',
      AppLanguage.hindi: 'खोजे गए प्रामाणिक शिल्प',
      AppLanguage.tamil: 'கண்டறியப்பட்ட கைவினைகள்',
      AppLanguage.bengali: 'আবিষ্কৃত শিল্পকলা',
      AppLanguage.telugu: 'కనుగొన్న చేతిపనులు',
      AppLanguage.marathi: 'शोधलेल्या हस्तकला',
      AppLanguage.gujarati: 'શોધાયેલ હસ્તકલા',
    },
    'The Grand GI Heritage Showcase': {
      AppLanguage.english: 'The Grand GI Heritage Showcase',
      AppLanguage.hindi: 'भव्य राष्ट्रीय जीआई धरोहर प्रदर्शनी',
      AppLanguage.tamil: 'மாபெரும் தேசிய GI பாரம்பரிய கண்காட்சி',
      AppLanguage.bengali: 'ঐতিহ্যবাহী জিআই শিল্প প্রদর্শনী',
      AppLanguage.telugu: 'గ్రాండ్ జిఐ వారసత్వ ప్రదర్శన',
      AppLanguage.marathi: 'भव्य राष्ट्रीय जीआय वारसा प्रदर्शन',
      AppLanguage.gujarati: 'ભવ્ય રાષ્ટ્રીય જીઆઈ વારસો પ્રદર્શન',
    },
    'Explore Masterworks': {
      AppLanguage.english: 'Explore Masterworks',
      AppLanguage.hindi: 'उत्कृष्ट कृतियाँ देखें',
      AppLanguage.tamil: 'சிறந்த படைப்புகளை ஆராயுங்கள்',
      AppLanguage.bengali: 'শ্রেষ্ঠ শিল্পকর্ম অন্বেষণ করুন',
      AppLanguage.telugu: 'అద్భుత కళాఖండాలను అన్వేషించండి',
      AppLanguage.marathi: 'उत्कृष्ट कलाकृती पहा',
      AppLanguage.gujarati: 'શ્રેષ્ઠ કૃતિઓ જુઓ',
    },
    'Living Heritage Masterpieces': {
      AppLanguage.english: 'Living Heritage Masterpieces',
      AppLanguage.hindi: 'जीवंत सांस्कृतिक विरासत कृतियां',
      AppLanguage.tamil: 'வாழும் பாரம்பரிய தலைசிறந்த படைப்புகள்',
      AppLanguage.bengali: 'জীবন্ত ঐতিহ্যের মাস্টারপিস',
      AppLanguage.telugu: 'సజీవ వారసత్వ కళాఖండాలు',
      AppLanguage.marathi: 'जिवंत वारसा उत्कृष्ट नमुने',
      AppLanguage.gujarati: 'જીવંત વારસો શ્રેષ્ઠ કૃતિઓ',
    },
    'Flash Craft Bazaars': {
      AppLanguage.english: 'Flash Craft Bazaars',
      AppLanguage.hindi: 'विशेष शिल्प बाज़ार',
      AppLanguage.tamil: 'சிறப்பு கைவினைச் சந்தை',
      AppLanguage.bengali: 'ফ্ল্যাশ ক্রাফট বাজার',
      AppLanguage.telugu: 'ఫ్లాష్ క్రాఫ్ట్ బజార్',
      AppLanguage.marathi: 'फ्लॅश हस्तकला बाजार',
      AppLanguage.gujarati: 'વિશેષ હસ્તકલા બજાર',
    },
    'PRICE DETAILS': {
      AppLanguage.english: 'PRICE DETAILS',
      AppLanguage.hindi: 'मूल्य विवरण',
      AppLanguage.tamil: 'விலை விவரங்கள்',
      AppLanguage.bengali: 'মূল্য বিবরণী',
      AppLanguage.telugu: 'ధర వివరాలు',
      AppLanguage.marathi: 'किंमत तपशील',
      AppLanguage.gujarati: 'કિંમત વિગતો',
    },
    'Total Payable': {
      AppLanguage.english: 'Total Payable',
      AppLanguage.hindi: 'कुल देय राशि',
      AppLanguage.tamil: 'மொத்த செலுத்த வேண்டிய தொகை',
      AppLanguage.bengali: 'মোট প্রদেয়',
      AppLanguage.telugu: 'మొత్తం చెల్లించవలసినది',
      AppLanguage.marathi: 'एकूण देय रक्कम',
      AppLanguage.gujarati: 'કુલ ચૂકવવાપાત્ર રકમ',
    },
    'PROCEED TO PAYMENT': {
      AppLanguage.english: 'PROCEED TO PAYMENT',
      AppLanguage.hindi: 'भुगतान के लिए आगे बढ़ें',
      AppLanguage.tamil: 'பணம் செலுத்த தொடரவும்',
      AppLanguage.bengali: 'পেমেন্টে এগিয়ে যান',
      AppLanguage.telugu: 'చెల్లింపుకు కొనసాగండి',
      AppLanguage.marathi: 'पेमेंटसाठी पुढे जा',
      AppLanguage.gujarati: 'ચૂકવણી માટે આગળ વધો',
    },
    'Available Offers': {
      AppLanguage.english: 'Available Offers',
      AppLanguage.hindi: 'उपलब्ध विशेष ऑफ़र',
      AppLanguage.tamil: 'கிடைக்கும் சலுகைகள்',
      AppLanguage.bengali: 'উপলব্ধ অফার সমূহ',
      AppLanguage.telugu: 'అందుబాటులో ఉన్న ఆఫర్లు',
      AppLanguage.marathi: 'उपलब्ध ऑफर्स',
      AppLanguage.gujarati: 'ઉપલબ્ધ ઓફર્સ',
    },
    'GI Passport': {
      AppLanguage.english: 'GI Passport',
      AppLanguage.hindi: 'जीआई पासपोर्ट',
      AppLanguage.tamil: 'GI பாஸ்போர்ட்',
      AppLanguage.bengali: 'জিআই পাসপোর্ট',
      AppLanguage.telugu: 'జిఐ పాస్‌పోర్ట్',
      AppLanguage.marathi: 'जीआय पासपोर्ट',
      AppLanguage.gujarati: 'જીઆઈ પાસપોર્ટ',
    },
    'View in AR 3D': {
      AppLanguage.english: 'View in AR 3D',
      AppLanguage.hindi: '3D AR में देखें',
      AppLanguage.tamil: 'AR 3D இல் பார்க்கவும்',
      AppLanguage.bengali: 'এআর ৩ডি-তে দেখুন',
      AppLanguage.telugu: 'AR 3D లో వీక్షించండి',
      AppLanguage.marathi: 'एआर 3D मध्ये पहा',
      AppLanguage.gujarati: 'એઆર 3D માં જુઓ',
    },
    'Your cart is empty': {
      AppLanguage.english: 'Your cart is empty',
      AppLanguage.hindi: 'आपकी कार्ट खाली है',
      AppLanguage.tamil: 'உங்கள் கூடை காலியாக உள்ளது',
      AppLanguage.bengali: 'আপনার কার্ট খালি',
      AppLanguage.telugu: 'మీ కార్ట్ ఖాళీగా ఉంది',
      AppLanguage.marathi: 'तुमची कार्ट रिकामी आहे',
      AppLanguage.gujarati: 'તમારી કાર્ટ ખાલી છે',
    },
    'Explore GI-tagged masterpieces from artisan clusters': {
      AppLanguage.english: 'Explore GI-tagged masterpieces from artisan clusters',
      AppLanguage.hindi: 'शिल्प समूहों से जीआई-प्रमाणित उत्कृष्ट कृतियाँ देखें',
      AppLanguage.tamil: 'கைவினைத் தொகுப்புகளிலிருந்து GI தலைசிறந்த படைப்புகளைக் கண்டறியவும்',
      AppLanguage.bengali: 'কারিগর ক্লাস্টার থেকে জিআই-ট্যাগযুক্ত শিল্পকর্ম অন্বেষণ করুন',
      AppLanguage.telugu: 'కళాకారుల సమూహాల నుండి జిఐ కళాఖండాలను అన్వేషించండి',
      AppLanguage.marathi: 'कारागीर समूहांकडून जीआय-टॅग केलेल्या उत्कृष्ट कलाकृती शोधा',
      AppLanguage.gujarati: 'કારીગર ક્લસ્ટરોમાંથી જીઆઈ-ટેગ કરેલી ઉત્કૃષ્ટ કૃતિઓ શોધો',
    },
    'Explore Marketplace': {
      AppLanguage.english: 'Explore Marketplace',
      AppLanguage.hindi: 'बाज़ार देखें',
      AppLanguage.tamil: 'சந்தையை ஆராயுங்கள்',
      AppLanguage.bengali: 'মার্কেটপ্লেস অন্বেষণ করুন',
      AppLanguage.telugu: 'మార్కెట్‌ప్లేస్‌ను అన్వేషించండి',
      AppLanguage.marathi: 'बाजारपेठ पहा',
      AppLanguage.gujarati: 'બજાર જુઓ',
    },
    'Deliver To:': {
      AppLanguage.english: 'Deliver To:',
      AppLanguage.hindi: 'डिलीवरी पता:',
      AppLanguage.tamil: 'விநியோக முகவரி:',
      AppLanguage.bengali: 'ডেলিভারি ঠিকানা:',
      AppLanguage.telugu: 'డెలివరీ చిరునామా:',
      AppLanguage.marathi: 'डिलिव्हरी पत्ता:',
      AppLanguage.gujarati: 'ડિલિવરી સરનામું:',
    },
    'Change': {
      AppLanguage.english: 'Change',
      AppLanguage.hindi: 'बदलें',
      AppLanguage.tamil: 'மாற்று',
      AppLanguage.bengali: 'পরিবর্তন করুন',
      AppLanguage.telugu: 'మార్చండి',
      AppLanguage.marathi: 'बदला',
      AppLanguage.gujarati: 'બદલો',
    },
    'B2B Corporate GST Tax Invoice': {
      AppLanguage.english: 'B2B Corporate GST Tax Invoice',
      AppLanguage.hindi: 'B2B कॉर्पोरेट जीएसटी टैक्स इनवॉइस',
      AppLanguage.tamil: 'B2B கார்ப்பரேட் ஜிஎஸ்டி வரி விலைப்பட்டியல்',
      AppLanguage.bengali: 'B2B কর্পোরেট জিএসটি ট্যাক্স চালান',
      AppLanguage.telugu: 'B2B కార్పొరేట్ జిఎస్‌టి టాక్స్ ఇన్‌వాయిస్',
      AppLanguage.marathi: 'B2B कॉर्पोरेट जीएसटी टॅक्स इनव्हॉइस',
      AppLanguage.gujarati: 'B2B કોર્પોરેટ જીએસટી ટેક્સ ઇનવોઇસ',
    },
    'Fair-Value Craft Discount': {
      AppLanguage.english: 'Fair-Value Craft Discount',
      AppLanguage.hindi: 'उचित-मूल्य शिल्प छूट',
      AppLanguage.tamil: 'நியாய விலை கைவினைத் தள்ளுபடி',
      AppLanguage.bengali: 'ন্যায্য মূল্য কারুশিল্প ছাড়',
      AppLanguage.telugu: 'న్యాయమైన ధర చేతిపనుల తగ్గింపు',
      AppLanguage.marathi: 'वाजवी-मूल्य हस्तकला सवलत',
      AppLanguage.gujarati: 'વાજબી મૂલ્ય હસ્તકલા છૂટ',
    },
    'Delivery Charges': {
      AppLanguage.english: 'Delivery Charges',
      AppLanguage.hindi: 'डिलीवरी शुल्क',
      AppLanguage.tamil: 'டெலிவரி கட்டணம்',
      AppLanguage.bengali: 'ডেলিভারি চার্জ',
      AppLanguage.telugu: 'డెలివరీ ఛార్జీలు',
      AppLanguage.marathi: 'डिलिव्हरी शुल्क',
      AppLanguage.gujarati: 'ડિલિવરી ચાર્જ',
    },
    'FREE': {
      AppLanguage.english: 'FREE',
      AppLanguage.hindi: 'मुफ़्त',
      AppLanguage.tamil: 'இலவசம்',
      AppLanguage.bengali: 'বিনামূল্যে',
      AppLanguage.telugu: 'ఉచితం',
      AppLanguage.marathi: 'मोफत',
      AppLanguage.gujarati: 'મફત',
    },
    'Total Payable Amount': {
      AppLanguage.english: 'Total Payable Amount',
      AppLanguage.hindi: 'कुल देय राशि',
      AppLanguage.tamil: 'மொத்த செலுத்த வேண்டிய தொகை',
      AppLanguage.bengali: 'মোট প্রদেয় পরিমাণ',
      AppLanguage.telugu: 'మొత్తం చెల్లించవలసిన మొత్తం',
      AppLanguage.marathi: 'एकूण देय रक्कम',
      AppLanguage.gujarati: 'કુલ ચૂકવવાપાત્ર રકમ',
    },
    '100% Secure • RBI Nodal Escrow Certified': {
      AppLanguage.english: '100% Secure • RBI Nodal Escrow Certified',
      AppLanguage.hindi: '100% सुरक्षित • आरबीआई नोडल एस्क्रो प्रमाणित',
      AppLanguage.tamil: '100% பாதுகாப்பானது • RBI நோடல் எஸ்க்ரோ சான்றளிக்கப்பட்டது',
      AppLanguage.bengali: '১০০% সুরক্ষিত • আরবিআই নোডাল এসক্রো প্রত্যয়িত',
      AppLanguage.telugu: '100% సురక్షితం • RBI నోడల్ ఎస్క్రో సర్టిఫైడ్',
      AppLanguage.marathi: '100% सुरक्षित • आरबीआय नोडल एस्क्रो प्रमाणित',
      AppLanguage.gujarati: '100% સુરક્ષિત • આરબીઆઈ નોડલ એસ્ક્રો પ્રમાણિત',
    },
    'Select Delivery Address': {
      AppLanguage.english: 'Select Delivery Address',
      AppLanguage.hindi: 'डिलीवरी पता चुनें',
      AppLanguage.tamil: 'டெலிவரி முகவரியைத் தேர்ந்தெடுக்கவும்',
      AppLanguage.bengali: 'ডেলিভারি ঠিকানা নির্বাচন করুন',
      AppLanguage.telugu: 'డెలివరీ చిరునామాను ఎంచుకోండి',
      AppLanguage.marathi: 'डिलिव्हरी पत्ता निवडा',
      AppLanguage.gujarati: 'ડિલિવરી સરનામું પસંદ કરો',
    },
    'Global Export & Customs Clearance (DGFT)': {
      AppLanguage.english: 'Global Export & Customs Clearance (DGFT)',
      AppLanguage.hindi: 'वैश्विक निर्यात एवं सीमा शुल्क मंजूरी (DGFT)',
      AppLanguage.tamil: 'உலகளாவிய ஏற்றுமதி & சுங்க அனுமதி (DGFT)',
      AppLanguage.bengali: 'বিশ্বব্যাপী রপ্তানি ও শুল্ক ছাড়পত্র (ডিজিএফটি)',
      AppLanguage.telugu: 'గ్లోబల్ ఎగుమతి & కస్టమ్స్ క్లియరెన్స్ (DGFT)',
      AppLanguage.marathi: 'जागतिक निर्यात आणि सीमाशुल्क मंजुरी (DGFT)',
      AppLanguage.gujarati: 'વૈશ્વિક નિકાસ અને કસ્ટમ્સ ક્લિયરન્સ (DGFT)',
    },
    'B2B Bulk Quote': {
      AppLanguage.english: 'B2B Bulk Quote',
      AppLanguage.hindi: 'B2B थोक कोटेशन',
      AppLanguage.tamil: 'B2B மொத்த விலைப்பட்டியல்',
      AppLanguage.bengali: 'B2B বাল্ক কোট',
      AppLanguage.telugu: 'B2B బల్క్ కోట్',
      AppLanguage.marathi: 'B2B मोठ्या प्रमाणात कोटेशन',
      AppLanguage.gujarati: 'B2B જથ્થાબંધ ક્વોટ',
    },
    'Request B2B Bulk / Corporate Quote': {
      AppLanguage.english: 'Request B2B Bulk / Corporate Quote',
      AppLanguage.hindi: 'B2B थोक / कॉर्पोरेट कोटेशन का अनुरोध करें',
      AppLanguage.tamil: 'B2B மொத்த / கார்ப்பரேட் மேற்கோளைக் கோருங்கள்',
      AppLanguage.bengali: 'B2B বাল্ক / কর্পোরেট কোটেশন অনুরোধ করুন',
      AppLanguage.telugu: 'B2B బల్క్ / కార్పొరేట్ కొటేషన్‌ను అభ్యర్థించండి',
      AppLanguage.marathi: 'B2B मोठ्या प्रमाणात / कॉर्पोरेट कोटेशनची विनंती करा',
      AppLanguage.gujarati: 'B2B બલ્ક / કોર્પોરેટ ક્વોટેશન માટે વિનંતી કરો',
    },
    'Craft Heritage & Story': {
      AppLanguage.english: 'Craft Heritage & Story',
      AppLanguage.hindi: 'शिल्प धरोहर एवं कथा',
      AppLanguage.tamil: 'கைவினை பாரம்பரியம் & கதை',
      AppLanguage.bengali: 'ঐতিহ্য ও গল্প',
      AppLanguage.telugu: 'హస్తకళ వారసత్వం & కథ',
      AppLanguage.marathi: 'हस्तकला वारसा आणि गोष्ट',
      AppLanguage.gujarati: 'હસ્તકલા વારસો અને વાર્તા',
    },
    'Authentic Materials Used': {
      AppLanguage.english: 'Authentic Materials Used',
      AppLanguage.hindi: 'उपयोग की गई प्रामाणिक सामग्रियां',
      AppLanguage.tamil: 'பயன்படுத்தப்பட்ட உண்மையான பொருட்கள்',
      AppLanguage.bengali: 'ব্যবহৃত খাঁটি উপকরণ',
      AppLanguage.telugu: 'ఉపయోగించిన ప్రామాణిక పదార్థాలు',
      AppLanguage.marathi: 'वापरलेले अस्सल साहित्य',
      AppLanguage.gujarati: 'ઉપયોગમાં લેવાયેલ વાસ્તવિક સામગ્રી',
    },
    '100% Fair Wage & Value Transparency': {
      AppLanguage.english: '100% Fair Wage & Value Transparency',
      AppLanguage.hindi: '100% उचित पारिश्रमिक एवं मूल्य पारदर्शिता',
      AppLanguage.tamil: '100% நியாயமான ஊதியம் & வெளிப்படைத்தன்மை',
      AppLanguage.bengali: '১০০% ন্যায্য মজুরি এবং মূল্য স্বচ্ছতা',
      AppLanguage.telugu: '100% న్యాయమైన వేతనం & విలువ పారదర్శకత',
      AppLanguage.marathi: '१००% वाजवी मजुरी आणि मूल्य पारदर्शकता',
      AppLanguage.gujarati: '૧૦૦% વાજબી વેતન અને મૂલ્ય પારદર્શિતા',
    },
    'Sign In / Register': {
      AppLanguage.english: 'Sign In / Register',
      AppLanguage.hindi: 'साइन इन / रजिस्टर करें',
      AppLanguage.tamil: 'உள்நுழைக / பதிவு செய்க',
      AppLanguage.bengali: 'সাইন ইন / রেজিস্টার করুন',
      AppLanguage.telugu: 'సైన్ ఇన్ / నమోదు చేయండి',
      AppLanguage.marathi: 'साइन इन / नोंदणी करा',
      AppLanguage.gujarati: 'સાઇન ઇન / રજીસ્ટર કરો',
    },
    'Artisan Seller Portal': {
      AppLanguage.english: 'Artisan Seller Portal',
      AppLanguage.hindi: 'कारीगर विक्रेता पोर्टल',
      AppLanguage.tamil: 'கைவினைஞர் விற்பனையாளர் தளம்',
      AppLanguage.bengali: 'কারিগর বিক্রেতা পোর্টাল',
      AppLanguage.telugu: 'చేతివృత్తుల విక్రేత పోర్టల్',
      AppLanguage.marathi: 'कारागीर विक्रेता पोर्टल',
      AppLanguage.gujarati: 'કારીગર વિક્રેતા પોર્ટલ',
    },
    'Home': {
      AppLanguage.english: 'Home',
      AppLanguage.hindi: 'होम',
      AppLanguage.tamil: 'முகப்பு',
      AppLanguage.bengali: 'হোম',
      AppLanguage.telugu: 'హోమ్',
      AppLanguage.marathi: 'मुख्य पृष्ठ',
      AppLanguage.gujarati: 'હોમ',
    },
    'Stories': {
      AppLanguage.english: 'Stories',
      AppLanguage.hindi: 'कथाएं',
      AppLanguage.tamil: 'கதைகள்',
      AppLanguage.bengali: 'গল্প',
      AppLanguage.telugu: 'కథలు',
      AppLanguage.marathi: 'गोष्टी',
      AppLanguage.gujarati: 'વાર્તાઓ',
    },
    'Profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.hindi: 'प्रोफ़ाइल',
      AppLanguage.tamil: 'சுயவிவரம்',
      AppLanguage.bengali: 'প্রোফাইল',
      AppLanguage.telugu: 'ప్రొఫైల్',
      AppLanguage.marathi: 'प्रोफाइल',
      AppLanguage.gujarati: 'પ્રોફાઇલ',
    },
    'View Authentic Crafts': {
      AppLanguage.english: 'View Authentic Crafts',
      AppLanguage.hindi: 'प्रामाणिक शिल्प देखें',
      AppLanguage.tamil: 'உண்மையான கைவினைகளைக் காண்க',
      AppLanguage.bengali: 'খাঁটি শিল্পকর্ম দেখুন',
      AppLanguage.telugu: 'ప్రామాణిక చేతిపనులను వీక్షించండి',
      AppLanguage.marathi: 'अस्सल हस्तकला पहा',
      AppLanguage.gujarati: 'અસલી હસ્તકલા જુઓ',
    },
    'Language & Bhashini Voice Assistant': {
      AppLanguage.english: 'Language & Bhashini Voice Assistant',
      AppLanguage.hindi: 'भाषा एवं भाषिणी वॉयस असिस्टेंट',
      AppLanguage.tamil: 'மொழி & பாஷினி குரல் உதவியாளர்',
      AppLanguage.bengali: 'ভাষা ও ভাষিণী ভয়েস সহকারী',
      AppLanguage.telugu: 'భాష & భాషిణి వాయిస్ అసిస్టెంట్',
      AppLanguage.marathi: 'भाषा आणि भाषिणी व्हॉइस असिस्टंट',
      AppLanguage.gujarati: 'ભાષા અને ભાષિણી વોઇસ આસિસ્ટન્ટ',
    },
    'Active App Language': {
      AppLanguage.english: 'Active App Language',
      AppLanguage.hindi: 'सक्रिय ऐप भाषा',
      AppLanguage.tamil: 'செயலில் உள்ள பயன்பாட்டு மொழி',
      AppLanguage.bengali: 'সক্রিয় অ্যাপের ভাষা',
      AppLanguage.telugu: 'ప్రస్తుత యాప్ భాష',
      AppLanguage.marathi: 'सक्रिय ॲप भाषा',
      AppLanguage.gujarati: 'સક્રિય એપ્લિકેશન ભાષા',
    },
    'Order History & Escrow Tracking': {
      AppLanguage.english: 'Order History & Escrow Tracking',
      AppLanguage.hindi: 'ऑर्डर इतिहास एवं एस्क्रो ट्रैकिंग',
      AppLanguage.tamil: 'ஆர்டர் வரலாறு & எஸ்க்ரோ கண்காணிப்பு',
      AppLanguage.bengali: 'অর্ডার ইতিহাস ও এসক্রো ট্র্যাকিং',
      AppLanguage.telugu: 'ఆర్డర్ చరిత్ర & ఎస్క్రో ట్రాకింగ్',
      AppLanguage.marathi: 'ऑर्डर इतिहास आणि एस्क्रो ट्रॅकिंग',
      AppLanguage.gujarati: 'ઓર્ડર ઇતિહાસ અને એસ્ક્રો ટ્રેકિંગ',
    },
    'Start Exploring Crafts': {
      AppLanguage.english: 'Start Exploring Crafts',
      AppLanguage.hindi: 'शिल्प खोजना शुरू करें',
      AppLanguage.tamil: 'கைவினைகளை ஆராயத் தொடங்குங்கள்',
      AppLanguage.bengali: 'শিল্প অন্বেষণ শুরু করুন',
      AppLanguage.telugu: 'చేతిపనుల అన్వేషణ ప్రారంభించండి',
      AppLanguage.marathi: 'हस्तकला शोधणे सुरू करा',
      AppLanguage.gujarati: 'હસ્તકલા શોધવાનું શરૂ કરો',
    },
    'Buyer Hub & Portals': {
      AppLanguage.english: 'Buyer Hub & Portals',
      AppLanguage.hindi: 'क्रेता केंद्र एवं पोर्टल',
      AppLanguage.tamil: 'வாங்குபவர் மையம் & தளங்கள்',
      AppLanguage.bengali: 'ক্রেতা হাব ও পোর্টাল',
      AppLanguage.telugu: 'కొనుగోలుదారు హబ్ & పోర్టల్స్',
      AppLanguage.marathi: 'खरेदीदार केंद्र आणि पोर्टल',
      AppLanguage.gujarati: 'ખરીદનાર હબ અને પોર્ટલ',
    },
    'Corporate & Hotel Bulk RFPs': {
      AppLanguage.english: 'Corporate & Hotel Bulk RFPs',
      AppLanguage.hindi: 'कॉर्पोरेट एवं होटल बल्क RFP निविदाएं',
      AppLanguage.tamil: 'கார்ப்பரேட் & ஹோட்டல் மொத்த டெண்டர்கள்',
      AppLanguage.bengali: 'কর্পোরেট ও হোটেল বাল্ক আরএফপি',
      AppLanguage.telugu: 'కార్పొరేట్ & హోటల్ బల్క్ RFPలు',
      AppLanguage.marathi: 'कॉर्पोरेट आणि हॉटेल मोठ्या प्रमाणात RFPs',
      AppLanguage.gujarati: 'કોર્પોરેટ અને હોટેલ જથ્થાબંધ RFPs',
    },
    'My Custom Quotes & Negotiations': {
      AppLanguage.english: 'My Custom Quotes & Negotiations',
      AppLanguage.hindi: 'मेरे कस्टम कोटेशन व बातचीत',
      AppLanguage.tamil: 'எனது தனிப்பயன் மேற்கோள்கள்',
      AppLanguage.bengali: 'আমার কাস্টম কোটস ও আলোচনা',
      AppLanguage.telugu: 'నా అనుకూల కొటేషన్లు & చర్చలు',
      AppLanguage.marathi: 'माझे कस्टम कोटेशन आणि बोलणी',
      AppLanguage.gujarati: 'મારા કસ્ટમ ક્વોટેશન્સ અને વાટાઘાટો',
    },
    'Direct DBT': {
      AppLanguage.english: 'Direct DBT',
      AppLanguage.hindi: 'सीधा बैंक अंतरण (DBT)',
      AppLanguage.tamil: 'நேரடி வங்கி பரிமாற்றம்',
      AppLanguage.bengali: 'সরাসরি ডিবিটি',
      AppLanguage.telugu: 'ప్రత్యక్ష డిబిటి',
      AppLanguage.marathi: 'थेट डीबीटी',
      AppLanguage.gujarati: 'ડાયરેક્ટ ડીબીટી',
    },
    'GI TAGGED': {
      AppLanguage.english: 'GI TAGGED',
      AppLanguage.hindi: 'जीआई प्रमाणित',
      AppLanguage.tamil: 'GI குறியிடப்பட்டது',
      AppLanguage.bengali: 'জিআই ট্যাগযুক্ত',
      AppLanguage.telugu: 'జిఐ ట్యాగ్ చేయబడింది',
      AppLanguage.marathi: 'जीआय प्रमाणित',
      AppLanguage.gujarati: 'જીઆઈ પ્રમાણિત',
    },
    '7-Day Escrow': {
      AppLanguage.english: '7-Day Escrow',
      AppLanguage.hindi: '7-दिवसीय सुरक्षित एस्क्रो',
      AppLanguage.tamil: '7-நாள் பாதுகாப்பான எஸ்க்ரோ',
      AppLanguage.bengali: '৭ দিনের সুরক্ষিত এসক্রো',
      AppLanguage.telugu: '7 రోజుల ఎస్క్రో రక్షణ',
      AppLanguage.marathi: '7 दिवसांची एस्क्रो सुरक्षा',
      AppLanguage.gujarati: '7-દિવસ એસ્ક્રો સુરક્ષા',
    },
    'Bank Offer': {
      AppLanguage.english: 'Bank Offer',
      AppLanguage.hindi: 'बैंक ऑफ़र',
      AppLanguage.tamil: 'வங்கி சலுகை',
      AppLanguage.bengali: 'ব্যাংক অফার',
      AppLanguage.telugu: 'బ్యాంక్ ఆఫర్',
      AppLanguage.marathi: 'बँक ऑफर',
      AppLanguage.gujarati: 'બેંક ઓફર',
    },
    'HERITAGE FLASH DROP': {
      AppLanguage.english: 'HERITAGE FLASH DROP',
      AppLanguage.hindi: 'धरोहर फ्लैश ड्रॉप',
      AppLanguage.tamil: 'பாரம்பரிய மின்னல் விற்பனை',
      AppLanguage.bengali: 'হেরিটেজ ফ্ল্যাশ ড্রপ',
      AppLanguage.telugu: 'హెరిటేజ్ ఫ్లాష్ డ్రాప్',
      AppLanguage.marathi: 'वारसा फ्लॅश सेल',
      AppLanguage.gujarati: 'હેરિટેજ ફ્લેશ ડ્રોપ',
    },
    'Claim Deal': {
      AppLanguage.english: 'Claim Deal',
      AppLanguage.hindi: 'डील प्राप्त करें',
      AppLanguage.tamil: 'சலுகையைப் பெறுங்கள்',
      AppLanguage.bengali: 'ডিল গ্রহণ করুন',
      AppLanguage.telugu: 'డీల్ పొందండి',
      AppLanguage.marathi: 'ऑफर मिळवा',
      AppLanguage.gujarati: 'ઓફર મેળવો',
    },
    'Meet the Living Legends': {
      AppLanguage.english: 'Meet the Living Legends',
      AppLanguage.hindi: 'शिल्प गुरुओं से मिलें',
      AppLanguage.tamil: 'வாழும் கைவினை மேதைகளை சந்தியுங்கள்',
      AppLanguage.bengali: 'জীবন্ত কিংবদন্তিদের সাথে পরিচিত হন',
      AppLanguage.telugu: 'జీవన కళా దిగ్గజాలను కలవండి',
      AppLanguage.marathi: 'शिल्पकारांना भेटा',
      AppLanguage.gujarati: 'શિલ્પ ગુરુઓને મળો',
    },
    'View All Stories': {
      AppLanguage.english: 'View All Stories',
      AppLanguage.hindi: 'सभी कथाएं देखें',
      AppLanguage.tamil: 'அனைத்து கதைகளையும் பார்க்கவும்',
      AppLanguage.bengali: 'সকল গল্প দেখুন',
      AppLanguage.telugu: 'అన్ని కథలను చూడండి',
      AppLanguage.marathi: 'सर्व गोष्टी पहा',
      AppLanguage.gujarati: 'બધી વાર્તાઓ જુઓ',
    },
    'Curated Heritage Crafts': {
      AppLanguage.english: 'Curated Heritage Crafts',
      AppLanguage.hindi: 'चयनित प्रामाणिक धरोहर शिल्प',
      AppLanguage.tamil: 'தேர்ந்தெடுக்கப்பட்ட பாரம்பரிய கைவினைகள்',
      AppLanguage.bengali: 'নির্বাচিত ঐতিহ্যবাহী কারুশিল্প',
      AppLanguage.telugu: 'ఎంపిక చేసిన వారసత్వ చేతిపనులు',
      AppLanguage.marathi: 'निवडक वारसा हस्तकला',
      AppLanguage.gujarati: 'પસંદગીની હેરિટેજ હસ્તકલા',
    },
    'Filter': {
      AppLanguage.english: 'Filter',
      AppLanguage.hindi: 'फ़िल्टर',
      AppLanguage.tamil: 'வடிகட்டி',
      AppLanguage.bengali: 'ফিল্টার',
      AppLanguage.telugu: 'ఫిల్టర్',
      AppLanguage.marathi: 'फिल्टर',
      AppLanguage.gujarati: 'ફિલ્ટર',
    },
    'CLEAR ALL': {
      AppLanguage.english: 'CLEAR ALL',
      AppLanguage.hindi: 'सभी हटाएं',
      AppLanguage.tamil: 'அனைத்தையும் அகற்று',
      AppLanguage.bengali: 'সব মুছুন',
      AppLanguage.telugu: 'అన్నీ తొలగించు',
      AppLanguage.marathi: 'सर्व काढा',
      AppLanguage.gujarati: 'બધા સાફ કરો',
    },
    'PRICE RANGE': {
      AppLanguage.english: 'PRICE RANGE',
      AppLanguage.hindi: 'मूल्य सीमा',
      AppLanguage.tamil: 'விலை வரம்பு',
      AppLanguage.bengali: 'দামের পরিসর',
      AppLanguage.telugu: 'ధర పరిధి',
      AppLanguage.marathi: 'किंमत श्रेणी',
      AppLanguage.gujarati: 'કિંમત શ્રેણી',
    },
    'All Prices': {
      AppLanguage.english: 'All Prices',
      AppLanguage.hindi: 'सभी मूल्य',
      AppLanguage.tamil: 'அனைத்து விலைகளும்',
      AppLanguage.bengali: 'সব দাম',
      AppLanguage.telugu: 'అన్ని ధరలు',
      AppLanguage.marathi: 'सर्व किमती',
      AppLanguage.gujarati: 'બધી કિંમતો',
    },
    'Under ₹1,500': {
      AppLanguage.english: 'Under ₹1,500',
      AppLanguage.hindi: '₹1,500 से कम',
      AppLanguage.tamil: '₹1,500 க்குள்',
      AppLanguage.bengali: '₹১,৫০০ এর নিচে',
      AppLanguage.telugu: '₹1,500 లోపు',
      AppLanguage.marathi: '₹1,500 च्या आत',
      AppLanguage.gujarati: '₹1,500 થી નીચે',
    },
    '₹1,500 - ₹5,000': {
      AppLanguage.english: '₹1,500 - ₹5,000',
      AppLanguage.hindi: '₹1,500 - ₹5,000',
      AppLanguage.tamil: '₹1,500 - ₹5,000',
      AppLanguage.bengali: '₹১,৫০০ - ₹৫,০০০',
      AppLanguage.telugu: '₹1,500 - ₹5,000',
      AppLanguage.marathi: '₹1,500 - ₹5,000',
      AppLanguage.gujarati: '₹1,500 - ₹5,000',
    },
    '₹5,000 - ₹12,000': {
      AppLanguage.english: '₹5,000 - ₹12,000',
      AppLanguage.hindi: '₹5,000 - ₹12,000',
      AppLanguage.tamil: '₹5,000 - ₹12,000',
      AppLanguage.bengali: '₹৫,০০০ - ₹১২,০০০',
      AppLanguage.telugu: '₹5,000 - ₹12,000',
      AppLanguage.marathi: '₹5,000 - ₹12,000',
      AppLanguage.gujarati: '₹5,000 - ₹12,000',
    },
    'Above ₹12,000': {
      AppLanguage.english: 'Above ₹12,000',
      AppLanguage.hindi: '₹12,000 से अधिक',
      AppLanguage.tamil: '₹12,000 க்கு மேல்',
      AppLanguage.bengali: '₹১২,০০০ এর উপরে',
      AppLanguage.telugu: '₹12,000 కంటే ఎక్కువ',
      AppLanguage.marathi: '₹12,000 पेक्षा जास्त',
      AppLanguage.gujarati: '₹12,000 થી વધુ',
    },
    'CRAFT CLUSTER & STATE': {
      AppLanguage.english: 'CRAFT CLUSTER & STATE',
      AppLanguage.hindi: 'शिल्प संकुल एवं राज्य',
      AppLanguage.tamil: 'கைவினைத் தொகுப்பு மற்றும் மாநிலம்',
      AppLanguage.bengali: 'শিল্প ক্লাস্টার ও রাজ্য',
      AppLanguage.telugu: 'క్రాఫ్ట్ క్లస్టర్ మరియు రాష్ట్రం',
      AppLanguage.marathi: 'हस्तकला समूह आणि राज्य',
      AppLanguage.gujarati: 'હસ્તકલા ક્લસ્ટર અને રાજ્ય',
    },
    'All Craft States': {
      AppLanguage.english: 'All Craft States',
      AppLanguage.hindi: 'सभी शिल्प राज्य',
      AppLanguage.tamil: 'அனைத்து மாநிலங்களும்',
      AppLanguage.bengali: 'সব রাজ্য',
      AppLanguage.telugu: 'అన్ని రాష్ట్రాలు',
      AppLanguage.marathi: 'सर्व राज्ये',
      AppLanguage.gujarati: 'બધા રાજ્યો',
    },
    'ARTISAN HONORS & GI': {
      AppLanguage.english: 'ARTISAN HONORS & GI',
      AppLanguage.hindi: 'कारीगर सम्मान व जीआई',
      AppLanguage.tamil: 'கைவினைஞர் கௌரவங்கள் மற்றும் GI',
      AppLanguage.bengali: 'কারিগর সম্মাননা ও জিআই',
      AppLanguage.telugu: 'ఆర్టిసన్ గౌరవాలు మరియు జిఐ',
      AppLanguage.marathi: 'कारागीर सन्मान आणि जीआय',
      AppLanguage.gujarati: 'કારીગર સન્માન અને જીઆઈ',
    },
    'All Certified Crafts': {
      AppLanguage.english: 'All Certified Crafts',
      AppLanguage.hindi: 'सभी प्रमाणित शिल्प',
      AppLanguage.tamil: 'அனைத்து சான்றளிக்கப்பட்ட கைவினைகள்',
      AppLanguage.bengali: 'সব প্রত্যয়িত শিল্পকলা',
      AppLanguage.telugu: 'అన్ని ధృవీకరించబడిన చేతిపనులు',
      AppLanguage.marathi: 'सर्व प्रमाणित हस्तकला',
      AppLanguage.gujarati: 'બધી પ્રમાણિત હસ્તકલા',
    },
    'Padma Shri Masters': {
      AppLanguage.english: 'Padma Shri Masters',
      AppLanguage.hindi: 'पद्म श्री शिल्प गुरु',
      AppLanguage.tamil: 'பத்மஸ்ரீ மேதைகள்',
      AppLanguage.bengali: 'পদ্মশ্রী মাস্টার্স',
      AppLanguage.telugu: 'పద్మశ్రీ మాస్టర్స్',
      AppLanguage.marathi: 'पद्मश्री शिल्पकार',
      AppLanguage.gujarati: 'પદ્મશ્રી શિલ્પકારો',
    },
    'National & State Awardees': {
      AppLanguage.english: 'National & State Awardees',
      AppLanguage.hindi: 'राष्ट्रीय व राज्य पुरस्कृत',
      AppLanguage.tamil: 'தேசிய மற்றும் மாநில விருது பெற்றவர்கள்',
      AppLanguage.bengali: 'জাতীয় ও রাজ্য পুরস্কারপ্রাপ্ত',
      AppLanguage.telugu: 'జాతీయ మరియు రాష్ట్ర అవార్డు గ్రహీతలు',
      AppLanguage.marathi: 'राष्ट्रीय आणि राज्य पुरस्कार विजेते',
      AppLanguage.gujarati: 'રાષ્ટ્રીય અને રાજ્ય પુરસ્કૃત',
    },
    'Govt GI Verified': {
      AppLanguage.english: 'Govt GI Verified',
      AppLanguage.hindi: 'सरकारी जीआई सत्यापित',
      AppLanguage.tamil: 'அரசு GI சரிபார்க்கப்பட்டது',
      AppLanguage.bengali: 'সরকারি জিআই যাচাইকৃত',
      AppLanguage.telugu: 'ప్రభుత్వ జిఐ ధృవీకరించబడింది',
      AppLanguage.marathi: 'शासकीय जीआय सत्यापित',
      AppLanguage.gujarati: 'સરકારી જીઆઈ પ્રમાણિત',
    },
    'Sort By: ': {
      AppLanguage.english: 'Sort By: ',
      AppLanguage.hindi: 'क्रमबद्ध: ',
      AppLanguage.tamil: 'வரிசைப்படுத்து: ',
      AppLanguage.bengali: 'সাজান: ',
      AppLanguage.telugu: 'క్రమబద్ధీకరించు: ',
      AppLanguage.marathi: 'क्रमवारी: ',
      AppLanguage.gujarati: 'ક્રમબદ્ધ: ',
    },
    'Showing ': {
      AppLanguage.english: 'Showing ',
      AppLanguage.hindi: 'प्रदर्शित ',
      AppLanguage.tamil: 'காண்பிக்கப்படுகிறது ',
      AppLanguage.bengali: 'দেখানো হচ্ছে ',
      AppLanguage.telugu: 'చూపిస్తోంది ',
      AppLanguage.marathi: 'दाखवत आहे ',
      AppLanguage.gujarati: 'દર્શાવી રહ્યું છે ',
    },
    'Masterpieces': {
      AppLanguage.english: 'Masterpieces',
      AppLanguage.hindi: 'कलाकृतियां',
      AppLanguage.tamil: 'தலைசிறந்த படைப்புகள்',
      AppLanguage.bengali: 'শিল্পকর্ম',
      AppLanguage.telugu: 'కళాఖండాలు',
      AppLanguage.marathi: 'कलाकृती',
      AppLanguage.gujarati: 'કલાકૃતિઓ',
    },
    'Reset All Filters': {
      AppLanguage.english: 'Reset All Filters',
      AppLanguage.hindi: 'फ़िल्टर रीसेट करें',
      AppLanguage.tamil: 'அனைத்து வடிகட்டிகளையும் மீட்டமை',
      AppLanguage.bengali: 'ফিল্টার পুনরায় সেট করুন',
      AppLanguage.telugu: 'అన్ని ఫిల్టర్లను రీసెట్ చేయండి',
      AppLanguage.marathi: 'सर्व फिल्टर्स रीसेट करा',
      AppLanguage.gujarati: 'બધા ફિલ્ટર્સ રીસેટ કરો',
    },
    'The Karighar Provenance Guarantee': {
      AppLanguage.english: 'The Karighar Provenance Guarantee',
      AppLanguage.hindi: 'कारीघर प्रामाणिकता गारंटी',
      AppLanguage.tamil: 'காரிகர் உண்மைத்தன்மை உத்தரவாதம்',
      AppLanguage.bengali: 'কারিঘর প্রামাণিকতার গ্যারান্টি',
      AppLanguage.telugu: 'కారిఘర్ ప్రామాణికత హామీ',
      AppLanguage.marathi: 'कारीघर सत्यता हमी',
      AppLanguage.gujarati: 'કારીઘર પ્રમાણિકતા ગેરંટી',
    },
    '100% Direct DBT': {
      AppLanguage.english: '100% Direct DBT',
      AppLanguage.hindi: '100% सीधा बैंक अंतरण',
      AppLanguage.tamil: '100% நேரடி DBT',
      AppLanguage.bengali: '১০০% সরাসরি ডিবিটি',
      AppLanguage.telugu: '100% ప్రత్యక్ష డిబిటి',
      AppLanguage.marathi: '100% थेट डीबीटी',
      AppLanguage.gujarati: '100% ડાયરેક્ટ ડીબીટી',
    },
    'Certified GI Tags': {
      AppLanguage.english: 'Certified GI Tags',
      AppLanguage.hindi: 'प्रमाणित जीआई टैग',
      AppLanguage.tamil: 'சான்றளிக்கப்பட்ட GI குறிச்சொற்கள்',
      AppLanguage.bengali: 'প্রত্যয়িত জিআই ট্যাগ',
      AppLanguage.telugu: 'ధృవీకరించబడిన జిఐ ట్యాగ్‌లు',
      AppLanguage.marathi: 'प्रमाणित जीआय टॅग',
      AppLanguage.gujarati: 'પ્રમાણિત જીઆઈ ટેગ',
    },
    'Blockchain Twin': {
      AppLanguage.english: 'Blockchain Twin',
      AppLanguage.hindi: 'ब्लॉकचेन डिजिटल ट्विन',
      AppLanguage.tamil: 'பிளாக்செயின் டிஜிட்டல் சான்று',
      AppLanguage.bengali: 'ব্লকচেইন ডিজিটাল টুইন',
      AppLanguage.telugu: 'బ్లాక్‌చెయిన్ ట్విన్',
      AppLanguage.marathi: 'ब्लॉकचेन डिजिटल ट्विन',
      AppLanguage.gujarati: 'બ્લોકચેઇન ડિજિટલ ટ્વિન',
    },
    'Karighar Account': {
      AppLanguage.english: 'Karighar Account',
      AppLanguage.hindi: 'कारीघर खाता',
      AppLanguage.tamil: 'காரிகர் கணக்கு',
      AppLanguage.bengali: 'কারিঘর অ্যাকাউন্ট',
      AppLanguage.telugu: 'కారిఘర్ ఖాతా',
      AppLanguage.marathi: 'कारीघर खाते',
      AppLanguage.gujarati: 'કારીઘર ખાતું',
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
    'Search GI crafts, silk sarees, pottery...': {
      AppLanguage.english: 'Search GI crafts, silk sarees, pottery...',
      AppLanguage.hindi: 'जीआई शिल्प, सिल्क साड़ियां, बर्तन खोजें...',
      AppLanguage.tamil: 'பாரம்பரிய கைவினை, புடவைகள், மண்பாண்டங்களைத் தேடுங்கள்...',
      AppLanguage.bengali: 'জিআই কারুশিল্প, রেশম শাড়ি, মৃৎশিল্প খুঁজুন...',
      AppLanguage.telugu: 'జిఐ చేతిపనులు, పట్టు చీరలు, కుండలను శోధించండి...',
      AppLanguage.marathi: 'जीआय हस्तकला, रेशीम साड्या, भांडी शोधा...',
      AppLanguage.gujarati: 'જીઆઈ હસ્તકલા, રેશમી સાડીઓ, માટીકામ શોધો...',
    },
    '100% Direct Artisan Sourced': {
      AppLanguage.english: '100% Direct Artisan Sourced',
      AppLanguage.hindi: '100% सीधे कारीगर से प्राप्त',
      AppLanguage.tamil: '100% கைவினைஞரிடமிருந்து நேரடி',
      AppLanguage.bengali: '১০০% সরাসরি কারিগরদের থেকে প্রাপ্ত',
      AppLanguage.telugu: '100% నేరుగా కళాకారుల నుండి సేకరించబడినవి',
      AppLanguage.marathi: '१००% थेट कारागिरांकडून मिळवलेले',
      AppLanguage.gujarati: '૧૦૦% સીધા કારીગરો પાસેથી મેળવેલ',
    },
    'All': {
      AppLanguage.english: 'All',
      AppLanguage.hindi: 'सभी',
      AppLanguage.tamil: 'அனைத்தும்',
      AppLanguage.bengali: 'সব',
      AppLanguage.telugu: 'అన్నీ',
      AppLanguage.marathi: 'सर्व',
      AppLanguage.gujarati: 'બધા',
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

class _LanguagePickerBottomSheet extends StatefulWidget {
  const _LanguagePickerBottomSheet();

  @override
  State<_LanguagePickerBottomSheet> createState() => _LanguagePickerBottomSheetState();
}

class _LanguagePickerBottomSheetState extends State<_LanguagePickerBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final currentLang = LocaleManager.currentLanguage.value;

    final bihariLanguages = [
      AppLanguage.hindi,
      AppLanguage.maithili,
      AppLanguage.bhojpuri,
      AppLanguage.magahi,
      AppLanguage.angika,
    ];

    final scheduledLanguages = [
      AppLanguage.bengali,
      AppLanguage.tamil,
      AppLanguage.telugu,
      AppLanguage.marathi,
      AppLanguage.gujarati,
      AppLanguage.kannada,
      AppLanguage.malayalam,
      AppLanguage.odia,
      AppLanguage.punjabi,
      AppLanguage.assamese,
      AppLanguage.urdu,
      AppLanguage.sanskrit,
      AppLanguage.kashmiri,
      AppLanguage.konkani,
      AppLanguage.sindhi,
      AppLanguage.nepali,
      AppLanguage.santali,
      AppLanguage.bodo,
      AppLanguage.dogri,
      AppLanguage.manipuri,
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Text('🌐 ', style: TextStyle(fontSize: 22)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Language / भाषा चुनें'.tr,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const Text(
                        '22 Indian Languages + Bihari Dialects (Maithili, Bhojpuri, Magahi)',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search language... / खोजें...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Bihari & Purvanchal section
                if (bihariLanguages.any(_filter)) ...[
                  _buildSectionHeader('🌾 बिहार एवं पूर्वांचल (Bihari Languages & Dialects)'),
                  ...bihariLanguages.where(_filter).map((lang) => _buildLangTile(lang, currentLang)),
                  const SizedBox(height: 12),
                ],

                // 22 Official Scheduled Indian Languages
                if (scheduledLanguages.any(_filter)) ...[
                  _buildSectionHeader('🇮🇳 22 Scheduled Indian Languages (भारतीय राजभाषाएं)'),
                  ...scheduledLanguages.where(_filter).map((lang) => _buildLangTile(lang, currentLang)),
                  const SizedBox(height: 12),
                ],

                // Global / English
                if (_filter(AppLanguage.english)) ...[
                  _buildSectionHeader('🌐 Global'),
                  _buildLangTile(AppLanguage.english, currentLang),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _filter(AppLanguage lang) {
    if (_searchQuery.isEmpty) return true;
    final name = LocaleManager.getLanguageName(lang).toLowerCase();
    final label = LocaleManager.getLanguageLabel(lang).toLowerCase();
    return name.contains(_searchQuery) || label.contains(_searchQuery);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE05A1B)),
      ),
    );
  }

  Widget _buildLangTile(AppLanguage lang, AppLanguage currentLang) {
    final isSelected = lang == currentLang;
    final isBihari = LocaleManager.isBihariLanguage(lang);

    return InkWell(
      onTap: () {
        LocaleManager.setLanguage(lang);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE05A1B) : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isBihari ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                LocaleManager.getLanguageLabel(lang),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isBihari ? const Color(0xFFB45309) : const Color(0xFF334155),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                LocaleManager.getLanguageName(lang),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFFE05A1B), size: 20),
          ],
        ),
      ),
    );
  }
}
