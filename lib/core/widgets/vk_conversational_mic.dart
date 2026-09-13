import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/speech/speech_service.dart';
import '../services/voice_assistant_service.dart';
import '../theme/app_theme.dart';
import 'vk_audio_waveform.dart';
import 'vk_badge.dart';
import 'vk_button.dart';

class VKConversationalMic extends StatelessWidget {
  const VKConversationalMic({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LocaleManager.currentLanguage,
      builder: (context, currentLang, _) {
        return FloatingActionButton.extended(
          heroTag: 'setu_didi_fab',
          onPressed: () => showSetuDidiVoiceSheet(context),
          backgroundColor: AppColors.saffron,
          icon: const Icon(Icons.mic_rounded, color: Colors.white, size: 24),
          label: Text(
            'Setu Didi (Voice)'.tr,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        );
      },
    );
  }

  static void showSetuDidiVoiceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => const _SetuDidiVoiceContent(),
    );
  }
}

class _SetuDidiVoiceContent extends StatefulWidget {
  const _SetuDidiVoiceContent();

  @override
  State<_SetuDidiVoiceContent> createState() => _SetuDidiVoiceContentState();
}

class _SetuDidiVoiceContentState extends State<_SetuDidiVoiceContent> {
  bool _isListening = false;
  String _currentLanguage = 'हिंदी';
  VoiceQueryResponse? _lastResponse;

  @override
  void dispose() {
    SpeechService.stop();
    super.dispose();
  }

  String _getLangCode() {
    switch (_currentLanguage) {
      case 'தமிழ்':
        return 'ta-IN';
      case 'বাংলা':
        return 'bn-IN';
      case 'English':
        return 'en-IN';
      default:
        return 'hi-IN';
    }
  }

  void _speakResponse(VoiceQueryResponse response) {
    setState(() {
      _isListening = false;
      _lastResponse = response;
    });
    SpeechService.speak(response.responseText, lang: _getLangCode());
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.saffronLight, shape: BoxShape.circle),
                child: const Icon(Icons.record_voice_over_rounded, color: AppColors.saffronDark, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Setu Didi (सेतु दीदी)', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const VKBadge(label: '100% VOICE UI', type: VKBadgeType.ai),
                      ],
                    ),
                    const Text('Rural Artisan Mother-Tongue Assistant', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),

          // Language Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['हिंदी', 'தமிழ்', 'বাংলা', 'English'].map((lang) {
                final isSel = _currentLanguage == lang;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(lang, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.bold : FontWeight.normal, color: isSel ? Colors.white : AppColors.textPrimary)),
                    selected: isSel,
                    selectedColor: AppColors.saffron,
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: isSel ? AppColors.saffron : AppColors.cardBorder),
                    onSelected: (val) => setState(() => _currentLanguage = lang),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Waveform Animation Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: _isListening ? AppColors.saffronLight.withValues(alpha: 0.3) : AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _isListening ? AppColors.saffron : AppColors.cardBorder),
            ),
            child: Column(
              children: [
                VKAudioWaveform(isRecording: _isListening),
                const SizedBox(height: 12),
                Text(
                  _isListening ? 'सुन रही हूँ... अपनी भाषा में बोलिए' : 'माइक दबाकर बोलें या नीचे दिए गए सुझाव चुनें',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _isListening ? AppColors.saffronDark : AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Suggested Queries Chips
          const Text('सुझाए गए सवाल (Tap to Ask):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 8),
          ...VoiceAssistantService.defaultSuggestions.take(3).map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: () => _speakResponse(s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mic_none_rounded, size: 16, color: AppColors.teal),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s.query, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                        const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.teal),
                      ],
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 12),

          // Response Box if any
          if (_lastResponse != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tealLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.volume_up_rounded, color: AppColors.tealDark, size: 18),
                          const SizedBox(width: 6),
                          Text('Setu Didi speaks:', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                        ],
                      ),
                      InkWell(
                        onTap: () => SpeechService.speak(_lastResponse!.responseText, lang: _getLangCode()),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.replay_rounded, size: 13, color: AppColors.tealDark),
                              SizedBox(width: 4),
                              Text('Replay Audio', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _lastResponse!.responseText,
                    style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  VKButton(
                    label: 'Open Screen',
                    icon: Icons.arrow_forward_rounded,
                    variant: VKButtonVariant.secondary,
                    height: 36,
                    onPressed: () {
                      final route = _lastResponse!.actionRoute;
                      Navigator.pop(context);
                      context.go(route);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Big Mic Toggle Button
          Center(
            child: InkWell(
              onTap: () {
                if (_isListening) {
                  _speakResponse(VoiceAssistantService.defaultSuggestions[0]);
                } else {
                  setState(() {
                    _isListening = true;
                    _lastResponse = null;
                  });
                }
              },

              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isListening ? AppColors.error : AppColors.saffron,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: (_isListening ? AppColors.error : AppColors.saffron).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 4)),
                  ],
                ),
                child: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
