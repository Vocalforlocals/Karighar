class VoiceQueryResponse {
  final String query;
  final String responseText;
  final String actionRoute;
  final String audioTone;

  const VoiceQueryResponse({
    required this.query,
    required this.responseText,
    required this.actionRoute,
    required this.audioTone,
  });
}

class VoiceAssistantService {
  static final List<VoiceQueryResponse> defaultSuggestions = [
    const VoiceQueryResponse(
      query: 'दीदी, मेरा बैंक खाता बैलेंस बताओ',
      responseText: 'नमस्ते रामदेव जी! आपके आधार-लिंक्ड भारतीय स्टेट बैंक खाते में कुल ₹48,500 की सीधी डीबीटी राशि सफलतापूर्वक ट्रांसफर हो चुकी है।',
      actionRoute: '/artisan/earnings',
      audioTone: 'friendly_hindi',
    ),
    const VoiceQueryResponse(
      query: 'आज कितने नए लूम ऑर्डर आए हैं?',
      responseText: 'आज आपके पास 1 नया हैंडलूम सिल्क साड़ी का ऑर्डर आया है। कुल 2 ऑर्डर लूम पर बुनाई प्रक्रिया में हैं।',
      actionRoute: '/artisan/orders',
      audioTone: 'informative_hindi',
    ),
    const VoiceQueryResponse(
      query: 'FabIndia वाले थोक कोटेशन का क्या हुआ?',
      responseText: 'FabIndia ने 25 साड़ियों के लिए ₹7,200 का ऑफर भेजा था। आपने ₹7,600 का काउंटर ऑफर भेजा है जो अभी पेंडिंग है।',
      actionRoute: '/artisan/quotes',
      audioTone: 'business_hindi',
    ),
    const VoiceQueryResponse(
      query: 'What is the government tooling subsidy status?',
      responseText: 'Under PM-Vishwakarma, your ₹6,800 raw material tooling grant has been cleared by MoSJE.',
      actionRoute: '/artisan/earnings',
      audioTone: 'official_english',
    ),
  ];

  static VoiceQueryResponse processQuery(String rawInput) {
    final lower = rawInput.toLowerCase();
    if (lower.contains('balance') || lower.contains('बैंक') || lower.contains('पैसा') || lower.contains('earning')) {
      return defaultSuggestions[0];
    } else if (lower.contains('order') || lower.contains('ऑर्डर') || lower.contains('loom')) {
      return defaultSuggestions[1];
    } else if (lower.contains('quote') || lower.contains('कोटेशन') || lower.contains('fabindia')) {
      return defaultSuggestions[2];
    }
    return defaultSuggestions[0];
  }
}
