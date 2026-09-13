class BhashiniRecognitionResult {
  final String recognizedText;
  final String englishTranslation;
  final double confidenceScore;
  final String dialectIdentified;
  final List<String> extractedCraftEntities;

  const BhashiniRecognitionResult({
    required this.recognizedText,
    required this.englishTranslation,
    required this.confidenceScore,
    required this.dialectIdentified,
    required this.extractedCraftEntities,
  });
}

class BhashiniSpeechService {
  static final Map<String, BhashiniRecognitionResult> _mockKnowledgeBase = {
    'hindi_saree': const BhashiniRecognitionResult(
      recognizedText: 'यह शुद्ध बनारसी कतान सिल्क साड़ी है, जिसमें असली जरी का काम है और 14 दिन की हथकरघा बुनाई है।',
      englishTranslation: 'This is a pure Banarasi Katan silk saree, featuring real zari work crafted over 14 days on a traditional handloom.',
      confidenceScore: 0.984,
      dialectIdentified: 'Bhojpuri-Hindi (Eastern UP)',
      extractedCraftEntities: ['Banarasi Katan Silk', 'Zari Gold Weave', '14 Days Looming'],
    ),
    'tamil_pottery': const BhashiniRecognitionResult(
      recognizedText: 'இது பாரம்பரிய சுடுமண் பானை, இயற்கை களிமண்ணால் கையால் செய்யப்பட்டது.',
      englishTranslation: 'This is a traditional terracotta pot, handcrafted using natural riverbed clay and fired in a low-smoke kiln.',
      confidenceScore: 0.965,
      dialectIdentified: 'Tamil (Madurai Regional)',
      extractedCraftEntities: ['Terracotta Clay', 'Hand-turned', 'Low-smoke Kiln'],
    ),
  };

  static Future<BhashiniRecognitionResult> processSpeechQuery({
    required String rawInput,
    String languageCode = 'hi',
  }) async {
    // Simulate neural processing latency
    await Future.delayed(const Duration(milliseconds: 600));

    final lower = rawInput.toLowerCase();
    if (lower.contains('pottery') || lower.contains('मिट्टी') || lower.contains('பானை')) {
      return _mockKnowledgeBase['tamil_pottery']!;
    }
    return _mockKnowledgeBase['hindi_saree']!;
  }
}
