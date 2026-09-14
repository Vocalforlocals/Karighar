// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

void speakText(String text, {String lang = 'hi-IN'}) {
  try {
    if (html.window.speechSynthesis == null) return;
    html.window.speechSynthesis!.cancel();
    final utterance = html.SpeechSynthesisUtterance(text);

    // Normalization: If browser lacks regional dialect voices (Bhojpuri/Maithili/Magahi/Angika),
    // route to standard Indian Devanagari voice (hi-IN) for accurate phonetic articulation.
    String effectiveLang = lang;
    final lower = lang.toLowerCase();
    if (lower.startsWith('bho') ||
        lower.startsWith('mai') ||
        lower.startsWith('mag') ||
        lower.startsWith('anp') ||
        lower.startsWith('sa')) {
      effectiveLang = 'hi-IN';
    }

    utterance.lang = effectiveLang;
    utterance.rate = 0.95;
    html.window.speechSynthesis!.speak(utterance);
  } catch (_) {}
}

void playBase64Audio(String base64Audio, {String mimeType = 'audio/wav'}) {
  try {
    final audio = html.AudioElement('data:$mimeType;base64,$base64Audio');
    audio.play();
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

html.SpeechRecognition? _recognition;

void startListening({
  required void Function(String text, bool isFinal) onResult,
  required void Function(String error) onError,
  required void Function() onEnd,
  String lang = 'hi-IN',
}) {
  try {
    if (!html.SpeechRecognition.supported) {
      onError('Speech recognition not supported in this browser.');
      return;
    }
    _recognition?.stop();
    _recognition = html.SpeechRecognition()
      ..continuous = true
      ..interimResults = true
      ..lang = lang;

    _recognition!.onResult.listen((event) {
      final results = event.results;
      if (results != null && results.isNotEmpty) {
        final last = results.last;
        final alt = last.item(0);
        final transcript = alt.transcript ?? '';
        final isFinal = last.isFinal ?? false;
        onResult(transcript, isFinal);
      }
    });

    _recognition!.onError.listen((event) {
      onError(event.error?.toString() ?? 'Speech recognition error');
    });

    _recognition!.onEnd.listen((_) {
      onEnd();
    });

    _recognition!.start();
  } catch (e) {
    onError(e.toString());
  }
}

void stopListening() {
  try {
    _recognition?.stop();
  } catch (_) {}
}

bool isRecognitionSupported() {
  try {
    return html.SpeechRecognition.supported;
  } catch (_) {
    return false;
  }
}
