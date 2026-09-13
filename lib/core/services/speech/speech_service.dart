import 'speech_service_stub.dart'
    if (dart.library.html) 'speech_service_web.dart' as impl;

class SpeechService {
  static void speak(String text, {String lang = 'hi-IN'}) {
    impl.speakText(text, lang: lang);
  }

  static void stop() {
    impl.stopSpeaking();
  }

  static bool get isSupported => impl.isSpeechSupported();
}
