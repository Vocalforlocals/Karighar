void speakText(String text, {String lang = 'hi-IN'}) {
  // No-op on unit test runner or non-web environment
}

void playBase64Audio(String base64Audio, {String mimeType = 'audio/wav'}) {
  // No-op on non-web environment
}

void stopSpeaking() {}

bool isSpeechSupported() => false;

void startListening({
  required void Function(String text, bool isFinal) onResult,
  required void Function(String error) onError,
  required void Function() onEnd,
  String lang = 'hi-IN',
}) {}

void stopListening() {}

bool isRecognitionSupported() => false;
