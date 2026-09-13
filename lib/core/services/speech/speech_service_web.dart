// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

void speakText(String text, {String lang = 'hi-IN'}) {
  try {
    if (html.window.speechSynthesis == null) return;
    html.window.speechSynthesis!.cancel();
    final utterance = html.SpeechSynthesisUtterance(text);
    utterance.lang = lang;
    utterance.rate = 0.95;
    html.window.speechSynthesis!.speak(utterance);
  } catch (_) {}
}

void stopSpeaking() {
  try {
    html.window.speechSynthesis?.cancel();
  } catch (_) {}
}

bool isSpeechSupported() {
  try {
    return html.window.speechSynthesis != null;
  } catch (_) {
    return false;
  }
}
