import '../l10n/locale_manager.dart';

class VoiceQueryResponse {
  final String query;
  final String responseText;
  final String actionRoute;
  final String audioTone;
  final String? englishTranslation;
  final String? languageName;
  final bool isBihari;

  const VoiceQueryResponse({
    required this.query,
    required this.responseText,
    required this.actionRoute,
    required this.audioTone,
    this.englishTranslation,
    this.languageName,
    this.isBihari = false,
  });
}

class VoiceAssistantService {
  // Multilingual & Bihari suggestions catalog
  static final Map<AppLanguage, List<VoiceQueryResponse>> languageSuggestions = {
    // 1. Bhojpuri (भोजपुरी - बिहार व पूर्वांचल)
    AppLanguage.bhojpuri: [
      const VoiceQueryResponse(
        query: 'हमार बैंक खाता के बैलेंस केतना बा?',
        responseText: 'प्रणाम काका/दीदी! रउआ के आधार-लिंक्ड भारतीय स्टेट बैंक खाता में ₹48,500 के सीधी डीबीटी राशि जमा हो गइल बा। सब पईसा एकदम सुरक्षित बा।',
        actionRoute: '/artisan/earnings',
        audioTone: 'bhojpuri_rural',
        englishTranslation: 'Greetings! In your Aadhaar-linked State Bank of India account, ₹48,500 direct DBT funds have been credited safely.',
        languageName: 'भोजपुरी (Bhojpuri)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'आज कउनो नया हथकरघा ऑर्डर आइल बा का?',
        responseText: 'हाँ काका! आज रउआ खातिर 1 गो नया बनारसी कतान सिल्क साड़ी के ऑर्डर आइल बा। कुल 2 गो ऑर्डर अभी करघा पर बुनाई में बा।',
        actionRoute: '/artisan/orders',
        audioTone: 'bhojpuri_rural',
        englishTranslation: 'Yes! Today 1 new Banarasi Katan silk saree order has arrived for you. 2 orders are currently on the loom.',
        languageName: 'भोजपुरी (Bhojpuri)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'थोक व्यापारी के कोटेशन के का हाल बा?',
        responseText: 'FabIndia 25 गो साड़ी खातिर ₹7,200 के ऑफर देले बा। रउआ ₹7,600 के काउंटर ऑफर भेजले बानी, जवन अभी समीक्षा में बा।',
        actionRoute: '/artisan/quotes',
        audioTone: 'bhojpuri_rural',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You sent a counter-offer of ₹7,600 which is under review.',
        languageName: 'भोजपुरी (Bhojpuri)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'सरकारी योजना आ टूलकिट सब्सिडी के लाभ कब मिली?',
        responseText: 'पीएम-विश्वकर्मा योजना तहत, रउआ के ₹6,800 के कच्चा माल आ औजार अनुदान MoSJE से पास हो चुकल बा। 5% ब्याज पर ₹1,00,000 के लोन भी मंजूर बा।',
        actionRoute: '/artisan/earnings',
        audioTone: 'bhojpuri_rural',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 tool grant is approved by MoSJE with ₹1,00,000 loan at 5%.',
        languageName: 'भोजपुरी (Bhojpuri)',
        isBihari: true,
      ),
    ],

    // 2. Maithili (मैथिली - मिथिला, बिहार)
    AppLanguage.maithili: [
      const VoiceQueryResponse(
        query: 'हमार बैंक खाता मे कतेक टका अछि?',
        responseText: 'प्रणाम! अपनेक आधार-सँ जुड़ल भारतीय स्टेट बैंक खाता मे कुल ₹48,500 के डीबीटी राशि सफलतापूर्वक जमा भ’ गेल अछि। सभ किछु सुरक्षित अछि।',
        actionRoute: '/artisan/earnings',
        audioTone: 'maithili_sweet',
        englishTranslation: 'Greetings! A total of ₹48,500 DBT funds has been successfully credited to your Aadhaar-linked SBI account.',
        languageName: 'मैथिली (Maithili)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'आई कतेक नब हैंडलूम ऑर्डर आयल अछि?',
        responseText: 'हँ! आई अपनेक लेल 1 टा नब कतान सिल्क साड़ी के ऑर्डर आयल अछि। कुल 2 टा ऑर्डर करघा पर बुनाई मे अछि।',
        actionRoute: '/artisan/orders',
        audioTone: 'maithili_sweet',
        englishTranslation: 'Yes! Today 1 new Katan silk saree order has arrived for you. 2 orders are weaving on the loom.',
        languageName: 'मैथिली (Maithili)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'थोक कोटेशन के की समाचार अछि?',
        responseText: 'FabIndia 25 टा साड़ी लेल ₹7,200 के प्रस्ताव देलक अछि। अपने ₹7,600 के प्रति-प्रस्ताव पठेने छी, जे अखन समीक्षाधीन अछि।',
        actionRoute: '/artisan/quotes',
        audioTone: 'maithili_sweet',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You submitted a counter-proposal of ₹7,600, which is under review.',
        languageName: 'मैथिली (Maithili)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'पीएम विश्वकर्मा योजना के टूलकिट सब्सिडी कखन भेटत?',
        responseText: 'पीएम-विश्वकर्मा योजना अंतर्गत, अपनेक ₹6,800 के उपकरण अनुदान MoSJE द्वारा स्वीकृत भ’ गेल अछि। 5% ब्याज पर ₹1,00,000 के ऋण सेहो उपलब्ध अछि।',
        actionRoute: '/artisan/earnings',
        audioTone: 'maithili_sweet',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 tool grant has been approved by MoSJE with ₹1,00,000 credit at 5% interest.',
        languageName: 'मैथिली (Maithili)',
        isBihari: true,
      ),
    ],

    // 3. Magahi (मगही - मगध, बिहार)
    AppLanguage.magahi: [
      const VoiceQueryResponse(
        query: 'हमार बैंक खाता में केतना पईसा हई?',
        responseText: 'प्रणाम भैया! तोहार आधार-लिंक्ड एसबीआई खाता में ₹48,500 के डीबीटी पईसा आ गेलो हे। एकदम सुरक्षित रूप से ट्रांसफर भेल हे।',
        actionRoute: '/artisan/earnings',
        audioTone: 'magahi_friendly',
        englishTranslation: 'Greetings brother! In your Aadhaar-linked SBI account, ₹48,500 DBT money has arrived safely.',
        languageName: 'मगही (Magahi)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'आज नया ऑर्डर अइलो हे का?',
        responseText: 'हँ भैया! आज तोरा ला 1 गो नया हैंडलूम साड़ी के ऑर्डर अइलो हे। कुल 2 गो ऑर्डर अभी लूम पर चालू हे।',
        actionRoute: '/artisan/orders',
        audioTone: 'magahi_friendly',
        englishTranslation: 'Yes! Today 1 new handloom saree order has arrived for you. 2 orders are active on the loom.',
        languageName: 'मगही (Magahi)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'बड़ा व्यापारी के कोटेशन का भेलई?',
        responseText: 'FabIndia 25 गो साड़ी ला ₹7,200 के भाव देलको हे। रउआ ₹7,600 भेजले हिया, जे अभी पेंडिंग हे।',
        actionRoute: '/artisan/quotes',
        audioTone: 'magahi_friendly',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You sent ₹7,600 which is pending.',
        languageName: 'मगही (Magahi)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'सरकारी योजना वाला पईसा कब मिलतौ?',
        responseText: 'पीएम-विश्वकर्मा योजना में तोरा ₹6,800 के टूल अनुदान मिल गेलो हे। 5% ब्याज पर लोन भी मिल सकौ हे।',
        actionRoute: '/artisan/earnings',
        audioTone: 'magahi_friendly',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 tool subsidy is granted.',
        languageName: 'मगही (Magahi)',
        isBihari: true,
      ),
    ],

    // 4. Angika (अंगिका - अंग क्षेत्र, बिहार)
    AppLanguage.angika: [
      const VoiceQueryResponse(
        query: 'हमार बैंक बैलेंस कते छै?',
        responseText: 'प्रणाम! अहां के आधार-लिंक स्टेट बैंक खाता म॑ ₹48,500 के डीबीटी राशि जमा होय गेलौ छै। कोनो चिंता के बात नय छै।',
        actionRoute: '/artisan/earnings',
        audioTone: 'angika_warm',
        englishTranslation: 'Greetings! In your Aadhaar-linked SBI account, ₹48,500 DBT amount has been deposited.',
        languageName: 'अंगिका (Angika)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'आई नया लूम ऑर्डर आयल छै की?',
        responseText: 'हँ! आई अहां लेली 1 नया हैंडलूम सिल्क साड़ी के ऑर्डर आयल छै। कुल 2 ऑर्डर करघा पर बुनाय रहलौ छै।',
        actionRoute: '/artisan/orders',
        audioTone: 'angika_warm',
        englishTranslation: 'Yes! Today 1 new handloom saree order arrived. 2 orders are weaving on the loom.',
        languageName: 'अंगिका (Angika)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'थोक कोटेशन के स्थिति की छै?',
        responseText: 'FabIndia 25 साड़ी लेली ₹7,200 के ऑफर देलकै। अहां ₹7,600 के काउंटर ऑफर भेजलियै छै, जे अखनी पेंडिंग छै।',
        actionRoute: '/artisan/quotes',
        audioTone: 'angika_warm',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You submitted a counter-offer of ₹7,600.',
        languageName: 'अंगिका (Angika)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'सरकारी सब्सिडी योजना के की हाल छै?',
        responseText: 'पीएम-विश्वकर्मा योजना म॑ अहां के ₹6,800 के टूलकिट अनुदान मंजूर होय गेलौ छै।',
        actionRoute: '/artisan/earnings',
        audioTone: 'angika_warm',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 toolkit grant has been sanctioned.',
        languageName: 'अंगिका (Angika)',
        isBihari: true,
      ),
    ],

    // 5. Hindi (हिंदी - राष्ट्रीय व राज्य भाषा)
    AppLanguage.hindi: [
      const VoiceQueryResponse(
        query: 'दीदी, मेरा बैंक खाता बैलेंस बताओ',
        responseText: 'नमस्ते रामदेव जी! आपके आधार-लिंक्ड भारतीय स्टेट बैंक खाते में कुल ₹48,500 की सीधी डीबीटी राशि सफलतापूर्वक ट्रांसफर हो चुकी है।',
        actionRoute: '/artisan/earnings',
        audioTone: 'friendly_hindi',
        englishTranslation: 'Namaste! In your Aadhaar-linked State Bank of India account, ₹48,500 DBT has been transferred successfully.',
        languageName: 'हिंदी (Hindi)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'आज कितने नए लूम ऑर्डर आए हैं?',
        responseText: 'आज आपके पास 1 नया हैंडलूम सिल्क साड़ी का ऑर्डर आया है। कुल 2 ऑर्डर लूम पर बुनाई प्रक्रिया में हैं।',
        actionRoute: '/artisan/orders',
        audioTone: 'informative_hindi',
        englishTranslation: 'Today you have 1 new handloom silk saree order. A total of 2 orders are on the loom.',
        languageName: 'हिंदी (Hindi)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'FabIndia वाले थोक कोटेशन का क्या हुआ?',
        responseText: 'FabIndia ने 25 साड़ियों के लिए ₹7,200 का ऑफर भेजा था। आपने ₹7,600 का काउंटर ऑफर भेजा है जो अभी पेंडिंग है।',
        actionRoute: '/artisan/quotes',
        audioTone: 'business_hindi',
        englishTranslation: 'FabIndia sent an offer of ₹7,200 for 25 sarees. You sent a counter-offer of ₹7,600.',
        languageName: 'हिंदी (Hindi)',
        isBihari: true,
      ),
      const VoiceQueryResponse(
        query: 'सरकारी टूलकिट और पीएम-विश्वकर्मा सब्सिडी की स्थिति क्या है?',
        responseText: 'पीएम-विश्वकर्मा योजना के तहत आपका ₹6,800 का टूलकिट अनुदान MoSJE द्वारा स्वीकृत हो चुका है और 5% ब्याज पर ₹1,00,000 का ऋण उपलब्ध है।',
        actionRoute: '/artisan/earnings',
        audioTone: 'official_hindi',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 toolkit grant is approved by MoSJE.',
        languageName: 'हिंदी (Hindi)',
        isBihari: true,
      ),
    ],

    // 6. Tamil (தமிழ்)
    AppLanguage.tamil: [
      const VoiceQueryResponse(
        query: 'எனது வங்கி கணக்கு இருப்பு என்ன?',
        responseText: 'வணக்கம்! உங்கள் ஆதார் இணைக்கப்பட்ட எஸ்பிஐ வங்கிக் கணக்கில் ₹48,500 நேரடி டிபிடி தொகை வெற்றிகரமாக வரவு வைக்கப்பட்டுள்ளது.',
        actionRoute: '/artisan/earnings',
        audioTone: 'tamil_polite',
        englishTranslation: 'Greetings! In your Aadhaar-linked SBI account, ₹48,500 DBT has been credited successfully.',
        languageName: 'தமிழ் (Tamil)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'இன்று எத்தனை புதிய தறி ஆர்டர்கள் வந்துள்ளன?',
        responseText: 'இன்று உங்களுக்கு 1 புதிய கைத்தறி பட்டுப் புடவை ஆர்டர் வந்துள்ளது. மொத்தம் 2 ஆர்டர்கள் தறியில் நெசவுப் பணியில் உள்ளன.',
        actionRoute: '/artisan/orders',
        audioTone: 'tamil_polite',
        englishTranslation: 'Today 1 new handloom silk saree order has arrived. Total 2 orders in weaving.',
        languageName: 'தமிழ் (Tamil)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'மொத்த கொள்முதல் மேற்கோள் நிலை என்ன?',
        responseText: 'FabIndia 25 புடவைகளுக்கு ₹7,200 சலுகை அளித்துள்ளது. நீங்கள் ₹7,600 எதிர்-சலுகை அனுப்பியுள்ளீர்கள்.',
        actionRoute: '/artisan/quotes',
        audioTone: 'tamil_polite',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You submitted a counter-offer of ₹7,600.',
        languageName: 'தமிழ் (Tamil)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'அரசு மானியம் மற்றும் பிஎம் விஸ்வகர்மா நிலை என்ன?',
        responseText: 'பிஎம்-விஸ்வகர்மா திட்டத்தின் கீழ், உங்கள் ₹6,800 கருவி மானியம் MoSJE ஆல் அங்கீகரிக்கப்பட்டுள்ளது.',
        actionRoute: '/artisan/earnings',
        audioTone: 'tamil_polite',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 toolkit subsidy has been approved by MoSJE.',
        languageName: 'தமிழ் (Tamil)',
        isBihari: false,
      ),
    ],

    // 7. Bengali (বাংলা)
    AppLanguage.bengali: [
      const VoiceQueryResponse(
        query: 'আমার ব্যাংক একাউন্টে কত ব্যালেন্স আছে?',
        responseText: 'নমস্কার! আপনার আধার-সংযুক্ত স্টেট ব্যাংক অ্যাকাউন্টে মোট ₹48,500 সরাসরি ডিবিটি সফলভাবে জমা হয়েছে।',
        actionRoute: '/artisan/earnings',
        audioTone: 'bengali_sweet',
        englishTranslation: 'Namaste! In your Aadhaar-linked SBI account, ₹48,500 DBT has been deposited successfully.',
        languageName: 'বাংলা (Bengali)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'আজ কতগুলো নতুন তাঁতের অর্ডার এসেছে?',
        responseText: 'আজ আপনার জন্য ১টি নতুন তাঁতের সিল্ক শাড়ির অর্ডার এসেছে। মোট ২টি অর্ডার বর্তমানে তাঁতে বুনন প্রক্রিয়ায় রয়েছে।',
        actionRoute: '/artisan/orders',
        audioTone: 'bengali_sweet',
        englishTranslation: 'Today 1 new handloom silk saree order arrived for you. Total 2 orders are in progress.',
        languageName: 'বাংলা (Bengali)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'পাইকারি কোটেশনের কী খবর?',
        responseText: 'FabIndia ২৫টি শাড়ির জন্য ₹৭,২০০ অফার দিয়েছে। আপনি ₹৭,৬০০ কাউন্টার অফার পাঠিয়েছেন যা এখন বিবেচনাধীন।',
        actionRoute: '/artisan/quotes',
        audioTone: 'bengali_sweet',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You submitted a counter-offer of ₹7,600.',
        languageName: 'বাংলা (Bengali)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'সরকারি টুলকিট ভর্তুকির অবস্থা কী?',
        responseText: 'পিএম-বিশ্বকর্মা যোজনার অধীনে আপনার ₹৬,৮০০ টুলকিট অনুদান MoSJE দ্বারা অনুমোদিত হয়েছে।',
        actionRoute: '/artisan/earnings',
        audioTone: 'bengali_sweet',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 toolkit grant has been approved by MoSJE.',
        languageName: 'বাংলা (Bengali)',
        isBihari: false,
      ),
    ],

    // 8. Telugu (తెలుగు)
    AppLanguage.telugu: [
      const VoiceQueryResponse(
        query: 'నా బ్యాంకు ఖాతా బ్యాలెన్స్ ఎంత?',
        responseText: 'నమస్కారం! మీ ఆధార్-లింక్డ్ ఎస్‌బీఐ ఖాతాలో ₹48,500 నేరుగా డీబీటీ మొత్తం విజయవంతంగా జమ చేయబడింది.',
        actionRoute: '/artisan/earnings',
        audioTone: 'telugu_warm',
        englishTranslation: 'Namaste! In your Aadhaar-linked SBI account, ₹48,500 DBT amount has been deposited.',
        languageName: 'తెలుగు (Telugu)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'ఈరోజు ఎన్ని కొత్త మగ్గం ఆర్డర్లు వచ్చాయి?',
        responseText: 'ఈరోజు మీకు 1 కొత్త చేనేత పట్టు చీర ఆర్డర్ వచ్చింది. మొత్తం 2 ఆర్డర్లు మగ్గంపై నేత పనిలో ఉన్నాయి.',
        actionRoute: '/artisan/orders',
        audioTone: 'telugu_warm',
        englishTranslation: 'Today you received 1 new handloom silk saree order. Total 2 orders are on the loom.',
        languageName: 'తెలుగు (Telugu)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'హోల్‌సేల్ కొటేషన్ పరిస్థితి ఏమిటి?',
        responseText: 'FabIndia 25 చీరలకు ₹7,200 ఆఫర్ చేసింది. మీరు ₹7,600 కౌంటర్ ఆఫర్ పంపారు, అది సమీక్షలో ఉంది.',
        actionRoute: '/artisan/quotes',
        audioTone: 'telugu_warm',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You sent a counter offer of ₹7,600.',
        languageName: 'తెలుగు (Telugu)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'ప్రభుత్వ సబ్సిడీ మరియు పీఎం విశ్వకర్మ స్థితి ఏమిటి?',
        responseText: 'పీఎం-విశ్వకర్మ పథకం కింద మీ ₹6,800 పరికరాల గ్రాంట్ MoSJE చేత ఆమోదించబడింది.',
        actionRoute: '/artisan/earnings',
        audioTone: 'telugu_warm',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 equipment grant has been approved by MoSJE.',
        languageName: 'తెలుగు (Telugu)',
        isBihari: false,
      ),
    ],

    // 9. Marathi (मराठी)
    AppLanguage.marathi: [
      const VoiceQueryResponse(
        query: 'माझ्या बँक खात्यात किती शिल्लक आहे?',
        responseText: 'नमस्कार! तुमच्या आधार-लिंक केलेल्या एसबीआय खात्यात ₹48,500 थेट डीबीटी रक्कम यशस्वीरित्या जमा झाली आहे.',
        actionRoute: '/artisan/earnings',
        audioTone: 'marathi_polite',
        englishTranslation: 'Namaste! In your Aadhaar-linked SBI account, ₹48,500 DBT amount has been credited.',
        languageName: 'मराठी (Marathi)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'आज किती नवीन हातमाग ऑर्डर्स आल्या आहेत?',
        responseText: 'आज तुमच्यासाठी १ नवीन हातमाग सिल्क साडीची ऑर्डर आली आहे. एकूण २ ऑर्डर्स मागवर विणकाम प्रक्रियेत आहेत.',
        actionRoute: '/artisan/orders',
        audioTone: 'marathi_polite',
        englishTranslation: 'Today 1 new handloom silk saree order arrived for you. Total 2 orders are in weaving.',
        languageName: 'मराठी (Marathi)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'घाऊक कोटेशनची स्थिती काय आहे?',
        responseText: 'FabIndia ने २५ साड्यांसाठी ₹७,२०० ची ऑफर दिली आहे. आपण ₹७,६०० ची काउंटर ऑफर पाठवली आहे जी प्रलंबित आहे.',
        actionRoute: '/artisan/quotes',
        audioTone: 'marathi_polite',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You sent a counter offer of ₹7,600.',
        languageName: 'मराठी (Marathi)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'सरकारी टूलकिट सबसिडीची स्थिती काय आहे?',
        responseText: 'पीएम-विश्वकर्मा योजनेअंतर्गत तुमचे ₹६,८०० चे टूलकिट अनुदान MoSJE द्वारे मंजूर झाले आहे.',
        actionRoute: '/artisan/earnings',
        audioTone: 'marathi_polite',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 toolkit grant has been approved by MoSJE.',
        languageName: 'मराठी (Marathi)',
        isBihari: false,
      ),
    ],

    // 10. Gujarati (ગુજરાતી)
    AppLanguage.gujarati: [
      const VoiceQueryResponse(
        query: 'મારા બેંક ખાતામાં કેટલું બેલેન્સ છે?',
        responseText: 'નમસ્તે! તમારા આધાર-લિંક્ડ સ્ટેટ બેંક ખાતામાં કુલ ₹48,500 ની સીધી DBT રકમ સફળતાપૂર્વક જમા થઈ ગઈ છે.',
        actionRoute: '/artisan/earnings',
        audioTone: 'gujarati_warm',
        englishTranslation: 'Namaste! In your Aadhaar-linked SBI account, ₹48,500 DBT has been credited successfully.',
        languageName: 'ગુજરાતી (Gujarati)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'આજે કેટલા નવા સાળ ઓર્ડર આવ્યા છે?',
        responseText: 'આજે તમારા માટે 1 નવો હેન્ડલૂમ સિલ્ક સાડીનો ઓર્ડર આવ્યો છે. કુલ 2 ઓર્ડર સાળ પર ચાલુ છે.',
        actionRoute: '/artisan/orders',
        audioTone: 'gujarati_warm',
        englishTranslation: 'Today 1 new handloom silk saree order has arrived for you.',
        languageName: 'ગુજરાતી (Gujarati)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'જથ્થાબંધ કોટેશનની સ્થિતિ શું છે?',
        responseText: 'FabIndia એ 25 સાડીઓ માટે ₹7,200 ની ઓફર આપી છે. તમે ₹7,600 ની કાઉન્ટર ઓફર મોકલી છે.',
        actionRoute: '/artisan/quotes',
        audioTone: 'gujarati_warm',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You sent a counter-offer of ₹7,600.',
        languageName: 'ગુજરાતી (Gujarati)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'સરકારી યોજના અને સબસિડીનું શું થયું?',
        responseText: 'પીએમ-વિશ્વકર્મા યોજના હેઠળ તમારી ₹6,800 ની ટૂલકિટ સહાય MoSJE દ્વારા મંજૂર કરવામાં આવી છે.',
        actionRoute: '/artisan/earnings',
        audioTone: 'gujarati_warm',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 toolkit grant is approved by MoSJE.',
        languageName: 'ગુજરાતી (Gujarati)',
        isBihari: false,
      ),
    ],

    // 11. English (Global Linkage)
    AppLanguage.english: [
      const VoiceQueryResponse(
        query: 'Tell me my bank account balance',
        responseText: 'Namaste! In your Aadhaar-linked State Bank of India account, a total DBT sum of ₹48,500 has been credited successfully.',
        actionRoute: '/artisan/earnings',
        audioTone: 'official_english',
        englishTranslation: 'Namaste! In your Aadhaar-linked State Bank of India account, a total DBT sum of ₹48,500 has been credited successfully.',
        languageName: 'English (Global)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'How many new loom orders arrived today?',
        responseText: 'Today you have 1 new handloom silk saree order. A total of 2 orders are in active weaving on the loom.',
        actionRoute: '/artisan/orders',
        audioTone: 'official_english',
        englishTranslation: 'Today you have 1 new handloom silk saree order. A total of 2 orders are in active weaving on the loom.',
        languageName: 'English (Global)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'What is the status of wholesale B2B quotation?',
        responseText: 'FabIndia offered ₹7,200 for 25 sarees. You submitted a counter-offer of ₹7,600 which is currently under review.',
        actionRoute: '/artisan/quotes',
        audioTone: 'official_english',
        englishTranslation: 'FabIndia offered ₹7,200 for 25 sarees. You submitted a counter-offer of ₹7,600 which is currently under review.',
        languageName: 'English (Global)',
        isBihari: false,
      ),
      const VoiceQueryResponse(
        query: 'What is the government tooling subsidy status?',
        responseText: 'Under PM-Vishwakarma, your ₹6,800 raw material tooling grant has been cleared by MoSJE with ₹1,00,000 credit at 5% interest.',
        actionRoute: '/artisan/earnings',
        audioTone: 'official_english',
        englishTranslation: 'Under PM-Vishwakarma, your ₹6,800 raw material tooling grant has been cleared by MoSJE with ₹1,00,000 credit at 5% interest.',
        languageName: 'English (Global)',
        isBihari: false,
      ),
    ],
  };

  // Backward-compatible fallback suggestions
  static List<VoiceQueryResponse> get defaultSuggestions =>
      languageSuggestions[AppLanguage.hindi] ?? [];

  // Get suggestions tailored for the specified language
  static List<VoiceQueryResponse> getSuggestionsForLanguage(AppLanguage lang) {
    if (languageSuggestions.containsKey(lang)) {
      return languageSuggestions[lang]!;
    }
    // Fallback for any of the 22 Indian scheduled languages without custom overrides
    if (LocaleManager.isBihariLanguage(lang)) {
      return languageSuggestions[AppLanguage.bhojpuri] ?? defaultSuggestions;
    }
    return defaultSuggestions;
  }

  // Resolve query based on content and language
  static VoiceQueryResponse processQuery(String rawInput, {AppLanguage? language}) {
    final lang = language ?? AppLanguage.hindi;
    final suggestions = getSuggestionsForLanguage(lang);

    if (suggestions.isEmpty) return defaultSuggestions.first;

    final lower = rawInput.toLowerCase();

    // 1. Orders / Loom
    if (lower.contains('order') || lower.contains('ऑर्डर') || lower.contains('loom') ||
        lower.contains('लूम') || lower.contains('करघा') || lower.contains('தறி') ||
        lower.contains('তাঁত') || lower.contains('మగ్గం') || lower.contains('माग') ||
        lower.contains('સાળ') || lower.contains('మగ్గము') || lower.contains('ఖడ్డ')) {
      return suggestions.length > 1 ? suggestions[1] : suggestions.first;
    }

    // 2. Quotation / Wholesale
    if (lower.contains('quote') || lower.contains('कोटेशन') || lower.contains('fabindia') ||
        lower.contains('भाव') || lower.contains('थोक') || lower.contains('व्यापारी') ||
        lower.contains('மேற்கோள்') || lower.contains('পাইকারি') || lower.contains('घाऊक') ||
        lower.contains('જથ્થાબંધ') || lower.contains('కొటేషన్')) {
      return suggestions.length > 2 ? suggestions[2] : (suggestions.length > 1 ? suggestions[1] : suggestions.first);
    }

    // 3. Subsidy / PM-Vishwakarma
    if (lower.contains('subsidy') || lower.contains('सब्सिडी') || lower.contains('grant') ||
        lower.contains('अनुदान') || lower.contains('vishwakarma') || lower.contains('विश्वकर्मा') ||
        lower.contains('सरकारी') || lower.contains('योजना') || lower.contains('மானியம்') ||
        lower.contains('ভর্তুকি') || lower.contains('સબસિડી')) {
      return suggestions.length > 3 ? suggestions[3] : (suggestions.length > 1 ? suggestions[1] : suggestions.first);
    }

    // 4. Default: Bank balance / DBT
    return suggestions.first;
  }
}
