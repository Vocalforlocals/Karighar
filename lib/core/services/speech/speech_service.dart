import 'speech_service_stub.dart'
    if (dart.library.html) 'speech_service_web.dart' as impl;

class SpeechService {
  static void speak(String text, {String lang = 'hi-IN'}) {
    impl.speakText(text, lang: lang);
  }

  static void playAudioBase64(String base64Audio, {String mimeType = 'audio/wav'}) {
    impl.playBase64Audio(base64Audio, mimeType: mimeType);
  }

  static void stop() {
    impl.stopSpeaking();
  }

  static bool get isSupported => impl.isSpeechSupported();

  static void startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
    required void Function() onEnd,
    String lang = 'hi-IN',
  }) {
    impl.startListening(onResult: onResult, onError: onError, onEnd: onEnd, lang: lang);
  }

  static void stopListening() {
    impl.stopListening();
  }

  static bool get isRecognitionSupported => impl.isRecognitionSupported();
}
