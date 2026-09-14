import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/artisan/bloc/artisan_bloc.dart';
import '../../features/buyer/bloc/buyer_bloc.dart';
import '../models/product.dart';
import '../services/bhashini_speech_service.dart';
import '../services/setu_didi_ai_engine.dart';
import '../services/speech/speech_service.dart';
import '../services/sync_client_service.dart';
import '../theme/app_theme.dart';
import 'vk_audio_waveform.dart';
import 'vk_badge.dart';

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

class _SetuDidiVoiceContentState extends State<_SetuDidiVoiceContent> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AppLanguage _currentLanguage;
  SetuDidiResponse? _lastResponse;
  String _liveTranscript = '';
  bool _isTranscriptFinal = false;
  bool _isPublishing = false;
  bool _publishedSuccess = false;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();
  late AnimationController _pulseController;

  // Quick dialect chips
  static const List<AppLanguage> _quickDialects = [
    AppLanguage.bhojpuri,
    AppLanguage.maithili,
    AppLanguage.magahi,
    AppLanguage.angika,
    AppLanguage.hindi,
    AppLanguage.tamil,
    AppLanguage.bengali,
    AppLanguage.telugu,
    AppLanguage.marathi,
    AppLanguage.english,
  ];

  // Quick action command chips
  static const List<_QuickCommand> _quickCommands = [
    _QuickCommand('🧶', 'बनारसी साड़ी लिस्ट करो', 'List Banarasi Saree'),
    _QuickCommand('🎨', 'मधुबनी पेंटिंग लिस्ट करो', 'List Madhubani Art'),
    _QuickCommand('🏺', 'ब्लू पॉटरी वेज़ लिस्ट करो', 'List Blue Pottery'),
    _QuickCommand('📦', 'आज के ऑर्डर दिखाओ', 'Show Orders'),
    _QuickCommand('💰', 'खाता बैलेंस बताओ', 'Check Balance'),
    _QuickCommand('💬', 'बायर चैट खोलो', 'Open Buyer Chat'),
  ];

  @override
  void initState() {
    super.initState();
    _currentLanguage = LocaleManager.currentLanguage.value;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    SpeechService.stop();
    SpeechService.stopListening();
    _textController.dispose();
    _textFocus.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getLangCode(AppLanguage lang) {
    final locale = LocaleManager.getLocale(lang);
    return '${locale.languageCode}-${locale.countryCode ?? 'IN'}';
  }

  /// Start real Web Speech Recognition
  void _startListening() {
    setState(() {
      _isListening = true;
      _liveTranscript = '';
      _isTranscriptFinal = false;
      _lastResponse = null;
      _publishedSuccess = false;
    });
    _pulseController.repeat(reverse: true);

    SpeechService.startListening(
      lang: _getLangCode(_currentLanguage),
      onResult: (text, isFinal) {
        setState(() {
          _liveTranscript = text;
          _isTranscriptFinal = isFinal;
        });
        if (isFinal && text.trim().isNotEmpty) {
          _stopListeningAndProcess(text.trim());
        }
      },
      onError: (error) {
        _stopListening();
      },
      onEnd: () {
        if (_isListening && _liveTranscript.isNotEmpty && !_isTranscriptFinal) {
          _stopListeningAndProcess(_liveTranscript.trim());
        } else if (_isListening) {
          _stopListening();
        }
      },
    );
  }

  void _stopListening() {
    SpeechService.stopListening();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _isListening = false;
    });
  }

  void _stopListeningAndProcess(String transcript) {
    _stopListening();
    _processCommand(transcript);
  }

  /// Process a voice or typed command through SetuDidiAiEngine
  void _processCommand(String input) {
    if (input.trim().isEmpty) return;

    final response = SetuDidiAiEngine.processVoiceCommand(input, lang: _currentLanguage);

    setState(() {
      _lastResponse = response;
      _publishedSuccess = false;
      _isPublishing = false;
    });

    // Speak the response
    SpeechService.speak(response.responseText, lang: _getLangCode(_currentLanguage));

    // Also send through Bhashini pipeline for telemetry
    final langCode = LocaleManager.getLocale(_currentLanguage).languageCode;
    BhashiniSpeechService.queryVoiceAssistant(
      query: response.userQuery,
      languageCode: langCode,
    ).then((result) {
      if (result.audioBase64 != null && result.audioBase64!.isNotEmpty) {
        SpeechService.playAudioBase64(result.audioBase64!);
      }
    }).catchError((_) {});
  }

  /// Handle text field submission
  void _onTextSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    _textFocus.unfocus();
    _processCommand(text.trim());
  }

  /// Publish product directly to marketplace from voice command
  void _publishDirectlyToMarketplace(ProductDraft draft) {
    setState(() {
      _isPublishing = true;
    });

    final product = Product(
      id: draft.id,
      artisanId: 'artisan_current',
      artisanName: 'Voice Listing',
      title: draft.title,
      category: draft.category,
      craftForm: draft.craftForm,
      description: '${draft.description}\n\n${draft.descriptionHindi}',
      images: [draft.previewImage],
      rawImage: draft.previewImage,
      price: draft.price,
      estimatedHours: draft.estimatedLoomHours,
      isGICertified: true,
      giTagNumber: draft.provenanceHash,
      clusterLocation: 'Artisan Cluster',
      stockQuantity: 1,
      status: 'active',
      tags: draft.tags,
      materialsUsed: ['Traditional Materials'],
      aiEnhancementsApplied: ['Setu Didi Voice AI', 'Fair Wage Analysis'],
      createdAt: DateTime.now(),
    );

    try {
      context.read<ArtisanBloc>().add(CreateProductEvent(product));
      context.read<BuyerBloc>().add(AddMarketplaceProductEvent(product));
      SyncClientService().broadcastNewProduct(product);

      setState(() {
        _isPublishing = false;
        _publishedSuccess = true;
      });

      SpeechService.speak(
        'बधाई हो! आपका प्रोडक्ट "${draft.title}" सफलतापूर्वक बाज़ार में लिस्ट हो गया है।',
        lang: _getLangCode(_currentLanguage),
      );
    } catch (_) {
      setState(() {
        _isPublishing = false;
      });
    }
  }

  /// Open Studio Wizard with pre-filled draft
  void _openInStudioWizard(ProductDraft draft) {
    Navigator.pop(context);
    context.go('/artisan/studio');
  }

  void _showAllLanguagesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, color: AppColors.saffron, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'भाषिणी (Bhashini) 26 Languages',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'All 22 Scheduled Indian Languages + Bihari Regional Dialects',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: AppLanguage.values.length,
                      separatorBuilder: (_, index) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final l = AppLanguage.values[idx];
                        final isSel = _currentLanguage == l;
                        final isBihari = LocaleManager.isBihariLanguage(l);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          leading: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isBihari ? AppColors.saffronLight : AppColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isBihari ? AppColors.saffron : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              LocaleManager.getLanguageLabel(l),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isBihari ? AppColors.saffronDark : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  LocaleManager.getLanguageName(l),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    color: isSel ? AppColors.saffronDark : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isBihari)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: VKBadge(label: 'BIHARI', type: VKBadgeType.verified),
                                ),
                            ],
                          ),
                          trailing: isSel
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.saffron)
                              : null,
                          onTap: () {
                            Navigator.pop(ctx);
                            LocaleManager.setLanguage(l);
                            setState(() {
                              _currentLanguage = l;
                              _lastResponse = null;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBihari = LocaleManager.isBihariLanguage(_currentLanguage);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ─── HEADER ───
                _buildHeader(isBihari),
                const SizedBox(height: 12),

                // ─── DIALECT SELECTION BAR ───
                _buildDialectBar(),
                const SizedBox(height: 14),

                // ─── LIVE TRANSCRIPT & WAVEFORM ───
                _buildListeningArea(),
                const SizedBox(height: 12),

                // ─── TEXT INPUT BAR ───
                _buildTextInputBar(),
                const SizedBox(height: 12),

                // ─── QUICK COMMAND CHIPS ───
                _buildQuickCommandChips(),
                const SizedBox(height: 12),

                // ─── RESPONSE / PRODUCT PREVIEW ───
                if (_lastResponse != null) ...[
                  if (_lastResponse!.isProductListing && _lastResponse!.productDraft != null)
                    _buildProductListingPreview(_lastResponse!.productDraft!)
                  else
                    _buildResponseCard(_lastResponse!),
                  const SizedBox(height: 12),
                ],

                // ─── BIG MIC TOGGLE ───
                _buildMicButton(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isBihari) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.saffron, Color(0xFFE65100)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.saffron.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.record_voice_over_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('सेतु दीदी', style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  const VKBadge(label: 'AI', type: VKBadgeType.ai),
                  const SizedBox(width: 4),
                  const VKBadge(label: 'VOICE', type: VKBadgeType.verified),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                isBihari
                    ? 'आवाज़ से क्राफ्ट लिस्ट करें • बायर चैट • बैलेंस'
                    : 'Voice-Powered Craft Listing & Artisan Assistant',
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildDialectBar() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickDialects.map((lang) {
                final isSel = _currentLanguage == lang;
                final isBihariDialect = LocaleManager.isBihariLanguage(lang);

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    avatar: isBihariDialect
                        ? const Text('🌾', style: TextStyle(fontSize: 11))
                        : null,
                    label: Text(
                      LocaleManager.getLanguageName(lang).split(' ')[0],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSel,
                    selectedColor: AppColors.saffron,
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: isSel ? AppColors.saffron : AppColors.cardBorder),
                    onSelected: (val) {
                      if (val) {
                        LocaleManager.setLanguage(lang);
                        setState(() {
                          _currentLanguage = lang;
                          _lastResponse = null;
                          _liveTranscript = '';
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: _showAllLanguagesSheet,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.tealLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune_rounded, size: 13, color: AppColors.tealDark),
                SizedBox(width: 4),
                Text('26', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListeningArea() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseVal = _isListening ? _pulseController.value : 0.0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _isListening
                ? AppColors.saffronLight.withValues(alpha: 0.2 + 0.15 * pulseVal)
                : AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isListening ? AppColors.saffron : AppColors.cardBorder,
              width: _isListening ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              VKAudioWaveform(isRecording: _isListening),
              const SizedBox(height: 8),

              // Live transcript display
              if (_liveTranscript.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isTranscriptFinal ? AppColors.teal : AppColors.saffron.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _isTranscriptFinal ? Icons.check_circle_rounded : Icons.hearing_rounded,
                        size: 16,
                        color: _isTranscriptFinal ? AppColors.teal : AppColors.saffron,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _liveTranscript,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isTranscriptFinal ? AppColors.textPrimary : AppColors.saffronDark,
                            fontStyle: _isTranscriptFinal ? FontStyle.normal : FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Text(
                _isListening
                    ? 'सुन रही हूँ... बोलिए! (${LocaleManager.getLanguageName(_currentLanguage).split(' ')[0]})'
                    : 'माइक दबाएँ या टाइप करें',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _isListening ? AppColors.saffronDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextInputBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.keyboard_rounded, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _textFocus,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'टाइप करें... "बनारसी साड़ी 7500 में लिस्ट करो"',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: 0.6)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: _onTextSubmitted,
              textInputAction: TextInputAction.send,
            ),
          ),
          InkWell(
            onTap: () => _onTextSubmitted(_textController.text),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCommandChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚡ Quick Commands:',
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _quickCommands.map((cmd) {
            return InkWell(
              onTap: () => _processCommand(cmd.hindiText),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cmd.emoji, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      cmd.label,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Product listing preview card with 1-tap publish
  Widget _buildProductListingPreview(ProductDraft draft) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: AppColors.saffron.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Stack(
              children: [
                Image.network(
                  draft.previewImage,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: AppColors.saffronLight,
                    child: const Center(child: Icon(Icons.image_rounded, size: 48, color: AppColors.saffron)),
                  ),
                ),
                // Category badge overlay
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      draft.category,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                // Voice AI badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.saffron,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mic_rounded, size: 11, color: Colors.white),
                        SizedBox(width: 3),
                        Text('Voice AI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        draft.title,
                        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${draft.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  draft.craftForm,
                  style: const TextStyle(fontSize: 11, color: AppColors.saffronDark, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Description (English)
                Text(
                  draft.description,
                  style: const TextStyle(fontSize: 11, height: 1.5, color: AppColors.textPrimary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Description (Hindi)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    draft.descriptionHindi,
                    style: const TextStyle(fontSize: 10, height: 1.4, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),

                // Fair wage breakdown
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified_rounded, size: 14, color: Color(0xFF1565C0)),
                          SizedBox(width: 4),
                          Text('MoSJE Fair Wage Analysis',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _wageItem('Raw Material', '₹${draft.rawMaterialCost.toStringAsFixed(0)}'),
                          const SizedBox(width: 12),
                          _wageItem('${draft.estimatedLoomHours}h × ₹${draft.hourlyRate.toStringAsFixed(0)}', '₹${draft.laborCost.toStringAsFixed(0)}'),
                          const SizedBox(width: 12),
                          _wageItem('Fair Floor', '₹${draft.fairWageFloor.toStringAsFixed(0)}'),
                        ],
                      ),
                      if (draft.price >= draft.fairWageFloor)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '✅ Price exceeds fair wage floor by ₹${(draft.price - draft.fairWageFloor).toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Tags
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: draft.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.saffronLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.saffron.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.saffronDark),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // ── ACTION BUTTONS ──
                if (_publishedSuccess)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8E6C9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 20, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text(
                          '🎉 Published to Marketplace!',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: _isPublishing ? null : () => _publishDirectlyToMarketplace(draft),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: _isPublishing
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.rocket_launch_rounded, size: 18),
                          label: Text(
                            _isPublishing ? 'Publishing...' : '🚀 Publish to Marketplace',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: () => _openInStudioWizard(draft),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.saffronDark,
                            side: const BorderSide(color: AppColors.saffron),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                          label: const Text('🎨 Studio', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wageItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
          Text(label, style: const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  /// Generic response card (non-product)
  Widget _buildResponseCard(SetuDidiResponse response) {
    return Container(
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
                  const Icon(Icons.smart_toy_rounded, color: AppColors.tealDark, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'सेतु दीदी:',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.tealDark),
                  ),
                ],
              ),
              InkWell(
                onTap: () => SpeechService.speak(response.responseText, lang: _getLangCode(_currentLanguage)),
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
                      Icon(Icons.volume_up_rounded, size: 13, color: AppColors.tealDark),
                      SizedBox(width: 4),
                      Text('🔊 Replay', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            response.responseText,
            style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
          if (response.englishTranslation != null && _currentLanguage != AppLanguage.english) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('EN: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  Expanded(
                    child: Text(
                      response.englishTranslation!,
                      style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          if (response.actionLabel != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.go(response.actionRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  response.actionLabel!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (_isListening) {
            if (_liveTranscript.isNotEmpty) {
              _stopListeningAndProcess(_liveTranscript.trim());
            } else {
              _stopListening();
            }
          } else {
            _startListening();
          }
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = _isListening ? 1.0 + 0.08 * _pulseController.value : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _isListening ? AppColors.error : AppColors.saffron,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? AppColors.error : AppColors.saffron).withValues(alpha: 0.4),
                      blurRadius: _isListening ? 20 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickCommand {
  final String emoji;
  final String hindiText;
  final String label;

  const _QuickCommand(this.emoji, this.hindiText, this.label);
}
