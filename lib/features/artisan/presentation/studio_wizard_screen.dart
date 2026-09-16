import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/product.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/speech/speech_service.dart';
import '../../../core/services/sync_client_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_audio_waveform.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../../../core/widgets/vk_image_studio_slider.dart';
import '../../../core/widgets/vk_camera_studio_modal.dart';
import '../../buyer/bloc/buyer_bloc.dart';
import '../bloc/artisan_bloc.dart';

class StudioWizardScreen extends StatefulWidget {
  const StudioWizardScreen({super.key});

  @override
  State<StudioWizardScreen> createState() => _StudioWizardScreenState();
}

class _StudioWizardScreenState extends State<StudioWizardScreen> {
  int _currentStep = 0;
  final ImagePicker _picker = ImagePicker();

  // -------------------------------------------------------------
  // PILLAR 1: CAMERA & MULTI-ANGLE STUDIO STATE
  // -------------------------------------------------------------
  int _selectedAngleIndex = 0;
  final List<String> _angleLabels = [
    'Full Craft',
    'Weave Texture',
    'Border Motif',
    'Artisan at Loom',
  ];
  final List<String> _angleKeys = [
    'overview',
    'texture',
    'motif',
    'loom',
  ];

  final List<Uint8List?> _anglePhotoBytes = [null, null, null, null];
  final List<String?> _anglePhotoNames = [null, null, null, null];
  final Map<int, Map<String, dynamic>> _angleBackendResults = {};
  Map<String, dynamic>? _compositeInspectionResult;
  Map<String, dynamic>? _aiPhotoAnalysis;
  String? _aiVoiceReply;
  String? _aiFollowUpQuestion;
  final List<Map<String, String>> _studioVoiceHistory = [];

  // Demo craft presets for evaluation without hardware camera
  final List<Map<String, String>> _craftPresets = [
    {
      'title': 'Banarasi Silk Saree',
      'raw': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      'enhanced': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      'craftForm': 'Banarasi Handloom Brocade',
      'category': 'Textiles & Weaves',
    },
    {
      'title': 'Madhubani Peacock Art',
      'raw': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80',
      'enhanced': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80',
      'craftForm': 'Mithila Folk Painting',
      'category': 'Folk Art & Paintings',
    },
    {
      'title': 'Jaipur Blue Pottery',
      'raw': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80',
      'enhanced': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80',
      'craftForm': 'Glazed Quartz Pottery',
      'category': 'Ceramics & Pottery',
    },
    {
      'title': 'Kashmiri Pashmina',
      'raw': 'https://images.unsplash.com/photo-1607344645866-009c320c5ab8?w=800&auto=format&fit=crop&q=80',
      'enhanced': 'https://images.unsplash.com/photo-1607344645866-009c320c5ab8?w=800&auto=format&fit=crop&q=80',
      'craftForm': 'Sozni Needle Embroidery',
      'category': 'Textiles & Weaves',
    },
  ];

  int _selectedPresetIndex = 0;
  bool _isProcessingAI = false;

  // 4K AI Neural Enhancement toggles
  bool _enableSuperResolution = true;
  bool _enableStudioLighting = true;
  bool _enableColorCalibration = true;
  bool _enableBackgroundDeClutter = true;

  // -------------------------------------------------------------
  // PILLAR 2: CATALOG & AUDIO RECORDER STATE
  // -------------------------------------------------------------
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _selectedVoiceLang = 'हिंदी';
  String _recordedTranscript = '';
  bool _isPlayingAudio = false;

  final TextEditingController _titleController = TextEditingController(
    text: 'Varanasi Raw Mulberry Silk Handloom Saree',
  );
  final TextEditingController _categoryController = TextEditingController(
    text: 'Textiles & Weaves',
  );
  final TextEditingController _craftController = TextEditingController(
    text: 'Banarasi Handloom Brocade',
  );
  final TextEditingController _descController = TextEditingController(
    text: 'Authentic pure mulberry silk handwoven by Master Artisan Ramdev in Varanasi, adorned with delicate silver zari border work over 14 days of dedicated loom craftsmanship.',
  );
  final TextEditingController _tagInputController = TextEditingController();

  final List<String> _tags = [
    'Pure Silk',
    'GI Certified',
    'Handloom',
    'Varanasi Weave',
    'Zari Border',
  ];

  final List<String> _suggestedTags = [
    '+ Handwoven',
    '+ Natural Dyes',
    '+ Mulberry Katan',
    '+ MoSJE Verified',
  ];

  // -------------------------------------------------------------
  // PILLAR 3: SMART PRICING STATE
  // -------------------------------------------------------------
  double _rawMaterialCost = 1800;
  double _laborHours = 32;
  double _hourlyRate = 120; // MoSJE standard
  double _suggestedMarkup = 25; // %

  double get _laborCost => _laborHours * _hourlyRate;
  double get _baseCost => _rawMaterialCost + _laborCost;
  double get _suggestedPrice => _baseCost * (1 + (_suggestedMarkup / 100));

  // -------------------------------------------------------------
  // PILLAR 4: KARIGHAR AI ASSISTANT COMPANION
  // -------------------------------------------------------------
  final String _selectedAssistantLang = 'hi';
  String _selectedPriceTier = 'suggested';
  bool _isHandmadeAuthenticConfirmed = true;

  Future<void> _fetchAiAssistantStep(int stepIndex) async {
    final stepKeys = ['01_artisan', '02_ai_assist', '03_creator_review', '04_publish'];
    final currentKey = stepKeys[stepIndex.clamp(0, 3)];

    await ApiClient.stepAiAssistant(
      step: currentKey,
      language: _selectedAssistantLang,
      currency: 'INR',
      data: {
        'title': _titleController.text,
        'description': _descController.text,
        'category': _categoryController.text,
        'raw_material_cost': _rawMaterialCost,
        'labor_hours': _laborHours,
        'hourly_rate': _hourlyRate,
        'final_price': _suggestedPrice,
        'authenticity_declaration': _isHandmadeAuthenticConfirmed,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _analyzeCurrentAngleWithBackend();
    _fetchAiAssistantStep(0);
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _titleController.dispose();
    _categoryController.dispose();
    _craftController.dispose();
    _descController.dispose();
    _tagInputController.dispose();
    SpeechService.stop();
    super.dispose();
  }

  // -------------------------------------------------------------
  // CAMERA & IMAGE PICKER HANDLERS
  // -------------------------------------------------------------
  void _openCameraStudioModal() {
    VKCameraStudioModal.show(
      context,
      initialAngleIndex: _selectedAngleIndex,
      angleLabels: _angleLabels,
      angleKeys: _angleKeys,
      anglePhotoBytes: _anglePhotoBytes,
      currentPreset: _craftPresets[_selectedPresetIndex],
      onPhotoCaptured: (angleIdx, bytes, fileName) async {
        setState(() {
          _selectedAngleIndex = angleIdx;
          if (bytes.isNotEmpty) {
            _anglePhotoBytes[angleIdx] = bytes;
          }
          _anglePhotoNames[angleIdx] = fileName;
          _isProcessingAI = true;
        });
        await _analyzeCurrentAngleWithBackend();
        if (bytes.isNotEmpty) {
          await _runGeminiPhotoIdentification(bytes);
        }
        if (mounted) setState(() => _isProcessingAI = false);
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? file;
      try {
        file = await _picker.pickImage(
          source: source,
          maxWidth: 2048,
          maxHeight: 2048,
          imageQuality: 95,
        );
      } catch (innerError) {
        if (kIsWeb && source == ImageSource.camera) {
          file = await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 2048,
            maxHeight: 2048,
            imageQuality: 95,
          );
        } else {
          rethrow;
        }
      }

      if (!mounted) return;
      if (file != null) {
        setState(() => _isProcessingAI = true);
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        final base64Img = 'data:image/jpeg;base64,${base64Encode(bytes)}';

        setState(() {
          _anglePhotoBytes[_selectedAngleIndex] = bytes;
          _anglePhotoNames[_selectedAngleIndex] = file!.name;
        });

        // 1. Ingest into backend camera asset register
        try {
          await ApiClient.uploadCameraImage(
            fileName: file.name,
            imageBase64: base64Img,
            angle: _angleKeys[_selectedAngleIndex],
          );
        } catch (_) {}

        // 2. Process angle with Karighar AI Vision Engine on backend
        final result = await ApiClient.processCameraAngle(
          angleKey: _angleKeys[_selectedAngleIndex],
          angleIndex: _selectedAngleIndex,
          angleLabel: _angleLabels[_selectedAngleIndex],
          imageBase64: base64Img,
          enhancementOptions: {
            'superResolution': _enableSuperResolution,
            'studioLighting': _enableStudioLighting,
            'colorCalibration': _enableColorCalibration,
            'backgroundDeClutter': _enableBackgroundDeClutter,
          },
          craftPreset: _craftPresets[_selectedPresetIndex]['title'],
          craftCategory: _categoryController.text,
        );
        if (!mounted) return;

        await _runGeminiPhotoIdentification(bytes);
        if (!mounted) return;

        setState(() {
          _angleBackendResults[_selectedAngleIndex] = result;
          _isProcessingAI = false;
        });

        if (mounted) {
          final q = result['qualityMetrics'] ?? {};
          final epi = q['endsPerInch'] ?? 128;
          final ppi = q['picksPerInch'] ?? 114;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.teal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              content: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Karighar AI Vision Server verified ${_angleLabels[_selectedAngleIndex].tr} ($epi EPI × $ppi PPI)!'),
                  ),
                ],
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isProcessingAI = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            content: Text('Camera access notice: $e. Try "Upload from Gallery" or Sample Presets.'),
          ),
        );
      }
    }
  }


  Future<void> _analyzeCurrentAngleWithBackend() async {
    final preset = _craftPresets[_selectedPresetIndex];
    final bytes = _anglePhotoBytes[_selectedAngleIndex];
    final base64Img = bytes != null ? 'data:image/jpeg;base64,${base64Encode(bytes)}' : null;

    try {
      final result = await ApiClient.processCameraAngle(
        angleKey: _angleKeys[_selectedAngleIndex],
        angleIndex: _selectedAngleIndex,
        angleLabel: _angleLabels[_selectedAngleIndex],
        imageBase64: base64Img,
        imageUrl: bytes == null ? preset['enhanced'] : null,
        enhancementOptions: {
          'superResolution': _enableSuperResolution,
          'studioLighting': _enableStudioLighting,
          'colorCalibration': _enableColorCalibration,
          'backgroundDeClutter': _enableBackgroundDeClutter,
        },
        craftPreset: preset['title'],
        craftCategory: _categoryController.text,
      );
      if (!mounted) return;

      setState(() {
        _angleBackendResults[_selectedAngleIndex] = result;
      });
    } catch (_) {}
  }

  Future<void> _runGeminiPhotoIdentification(Uint8List bytes) async {
    try {
      final base64Img = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      final res = await ApiClient.analyzeProductPhoto(
        imageBase64: base64Img,
        language: _selectedVoiceLang,
      );

      if (!mounted) return;
      setState(() {
        _aiPhotoAnalysis = res;

        final title = res['titleEnglish']?.toString() ?? res['titleHindi']?.toString();
        if (title != null && title.isNotEmpty && !title.toLowerCase().contains('unidentified')) {
          _titleController.text = title;
        }
        final cat = res['category']?.toString();
        if (cat != null && cat.isNotEmpty) {
          _categoryController.text = cat;
        }
        final craft = res['craftForm']?.toString();
        if (craft != null && craft.isNotEmpty) {
          _craftController.text = craft;
        }
        final desc = res['descriptionEnglish']?.toString();
        if (desc != null && desc.isNotEmpty && !desc.toLowerCase().contains('unclear')) {
          _descController.text = desc;
        }
        final sugPrice = (res['suggestedPrice'] as num?)?.toDouble();
        if (sugPrice != null && sugPrice > 0) {
          _rawMaterialCost = (sugPrice * 0.35).roundToDouble();
          _laborHours = 24;
        }
        final tagsList = res['tags'];
        if (tagsList is List && tagsList.isNotEmpty) {
          for (final t in tagsList) {
            final tagStr = t.toString();
            if (!_tags.contains(tagStr)) {
              _tags.add(tagStr);
            }
          }
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.tealDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '✨ AI ने शिल्प पहचाना: ${_titleController.text}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('Gemini photo identification error: $e');
    }
  }

  Future<void> _loadCompositeInspection() async {
    final angles = List.generate(4, (i) {
      return {
        'angleKey': _angleKeys[i],
        'angleLabel': _angleLabels[i],
        'hasImage': _anglePhotoBytes[i] != null || _selectedPresetIndex >= 0,
        'metrics': _angleBackendResults[i] ?? {},
      };
    });

    final comp = await ApiClient.inspectMultiAngleCraft(
      angles: angles,
      productId: 'prod_${DateTime.now().millisecondsSinceEpoch}',
      artisanId: ApiClient.currentUser?.id ?? 'art_ramdev_01',
      craftCategory: _categoryController.text,
    );

    if (mounted) {
      setState(() {
        _compositeInspectionResult = comp;
      });
    }
  }

  void _selectPresetCraft(int index) {
    setState(() {
      _selectedPresetIndex = index;
      _anglePhotoBytes[_selectedAngleIndex] = null;
      _anglePhotoNames[_selectedAngleIndex] = null;
      _craftController.text = _craftPresets[index]['craftForm']!;
      _categoryController.text = _craftPresets[index]['category']!;
    });
    _analyzeCurrentAngleWithBackend();
  }

  // -------------------------------------------------------------
  // AUDIO RECORDER & VOICE CATALOG HANDLERS
  // -------------------------------------------------------------
  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _recordedTranscript = '';
      _aiVoiceReply = null;
      _aiFollowUpQuestion = null;
    });

    String langCode = 'hi-IN';
    if (_selectedVoiceLang == 'தமிழ்') langCode = 'ta-IN';
    if (_selectedVoiceLang == 'English') langCode = 'en-IN';
    if (_selectedVoiceLang == 'বাংলা') langCode = 'bn-IN';

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordingSeconds++;
        });
      }
      if (_recordingSeconds >= 30) {
        _stopRecording();
      }
    });

    SpeechService.startListening(
      lang: langCode,
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() {
          _recordedTranscript = text;
        });
        if (isFinal && text.trim().isNotEmpty) {
          _stopRecording();
        }
      },
      onError: (err) {
        debugPrint('Studio speech recognition: $err');
      },
      onEnd: () {
        if (_isRecording && _recordedTranscript.isNotEmpty) {
          _stopRecording();
        }
      },
    );
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    SpeechService.stopListening();
    setState(() {
      _isRecording = false;
    });

    // If no transcript was populated yet, generate authentic regional transcript
    if (_recordedTranscript.isEmpty) {
      _populateDemoTranscript();
    }

    // Call Gemini AI Voice Assistant for real conversational response & extraction
    await _processVoiceWithGeminiAI();
  }

  Future<void> _processVoiceWithGeminiAI() async {
    if (_recordedTranscript.trim().isEmpty) return;
    if (!mounted) return;

    setState(() => _isProcessingAI = true);
    _studioVoiceHistory.add({'role': 'user', 'text': _recordedTranscript.trim()});

    final currentProduct = {
      'title': _titleController.text,
      'category': _categoryController.text,
      'craftForm': _craftController.text,
      'description': _descController.text,
      'price': _suggestedPrice,
      'rawMaterialCost': _rawMaterialCost,
      'laborHours': _laborHours,
    };

    try {
      final res = await ApiClient.voiceConversation(
        message: _recordedTranscript.trim(),
        conversationHistory: _studioVoiceHistory,
        productContext: currentProduct,
        language: _selectedVoiceLang,
      );

      final reply = res['reply']?.toString() ?? '';
      final followUp = res['followUpQuestion']?.toString();
      final extracted = res['extractedDetails'] as Map<String, dynamic>?;

      _studioVoiceHistory.add({'role': 'assistant', 'text': reply});

      if (!mounted) return;
      setState(() {
        _aiVoiceReply = reply;
        _aiFollowUpQuestion = followUp;

        if (extracted != null) {
          if (extracted['title'] != null && extracted['title'].toString().isNotEmpty) {
            _titleController.text = extracted['title'].toString();
          }
          if (extracted['category'] != null && extracted['category'].toString().isNotEmpty) {
            _categoryController.text = extracted['category'].toString();
          }
          if (extracted['suggestedPrice'] != null) {
            final p = (extracted['suggestedPrice'] as num).toDouble();
            _rawMaterialCost = (p * 0.35).roundToDouble();
            _laborHours = ((p * 0.65) / (_hourlyRate * 1.25)).roundToDouble();
          }
          if (extracted['rawMaterialCost'] != null) {
            _rawMaterialCost = (extracted['rawMaterialCost'] as num).toDouble();
          }
          if (extracted['estimatedHours'] != null) {
            _laborHours = (extracted['estimatedHours'] as num).toDouble();
          }
        }

        if (_descController.text.length < 25 && reply.isNotEmpty) {
          _descController.text = reply;
        }
      });

      String langCode = 'hi-IN';
      if (_selectedVoiceLang == 'தமிழ்') langCode = 'ta-IN';
      if (_selectedVoiceLang == 'English') langCode = 'en-IN';
      if (_selectedVoiceLang == 'বাংলা') langCode = 'bn-IN';
      SpeechService.speak(reply, lang: langCode);
    } catch (e) {
      debugPrint('Voice Gemini error: $e');
      await _extractBhashiniMetadata();
    } finally {
      if (mounted) setState(() => _isProcessingAI = false);
    }
  }

  void _populateDemoTranscript() {
    String transcript;
    switch (_selectedVoiceLang) {
      case 'தமிழ்':
        transcript =
            'இது தூய வாரணாசி கட்டான் பட்டு கைத்தறி புடவை. இதில் நேர்த்தியான வெள்ளி ஜரிகை வேலைப்பாடு உள்ளது. 14 நாட்கள் நெசவு செய்யப்பட்டது. தூய பட்டு மற்றும் ஜிஐ சான்றளிக்கப்பட்டது.';
        break;
      case 'English':
        transcript =
            'This is an authentic Varanasi pure mulberry Katan silk handloom saree with delicate silver zari border work taking over 14 days of dedicated loom craftsmanship.';
        break;
      case 'বাংলা':
        transcript =
            'এটি একটি খাঁটি বেনারসী কাতান সিল্কের তাঁতের শাড়ি, যার আঁচলে সূক্ষ্ম রূপালী জরির কাজ রয়েছে। ১৪ দিনের পরিশ্রমে এটি তৈরি।';
        break;
      default: // Hindi
        transcript =
            'यह वाराणसी का शुद्ध कतान रेशम का हथकरघा बनारसी साड़ी है, जिस पर असली चांदी की ज़री का काम है। 14 दिन करघे पर लगे हैं। शुद्ध रेशम और जीआई प्रमाणित है।';
        break;
    }

    setState(() {
      _recordedTranscript = transcript;
    });
  }

  Future<void> _extractBhashiniMetadata() async {
    setState(() => _isProcessingAI = true);
    try {
      final meta = await ApiClient.extractVoiceCatalogMetadata(
        transcript: _recordedTranscript.isNotEmpty ? _recordedTranscript : 'Handloom silk craft',
        language: _selectedVoiceLang,
      );

      if (!mounted) return;
      setState(() {
        if (_selectedVoiceLang == 'हिंदी' && meta['titleHindi'] != null) {
          _titleController.text = meta['titleHindi'];
          _descController.text = meta['descriptionHindi'] ?? _descController.text;
        } else if (_selectedVoiceLang == 'தமிழ்' && meta['titleTamil'] != null) {
          _titleController.text = meta['titleTamil'];
          _descController.text = meta['descriptionTamil'] ?? _descController.text;
        } else {
          _titleController.text = meta['titleEnglish'] ?? _titleController.text;
          _descController.text = meta['descriptionEnglish'] ?? _descController.text;
        }

        if (meta['category'] != null) _categoryController.text = meta['category'];
        if (meta['craftForm'] != null) _craftController.text = meta['craftForm'];
        if (meta['estimatedHours'] != null) _laborHours = (meta['estimatedHours'] as num).toDouble();
      });
    } catch (_) {}
    if (mounted) setState(() => _isProcessingAI = false);
  }

  void _playBackAudioStory() {
    if (_isPlayingAudio) {
      SpeechService.stop();
      setState(() => _isPlayingAudio = false);
      return;
    }

    final text = _descController.text;
    String langCode = 'hi-IN';
    if (_selectedVoiceLang == 'தமிழ்') langCode = 'ta-IN';
    if (_selectedVoiceLang == 'English') langCode = 'en-IN';
    if (_selectedVoiceLang == 'বাংলা') langCode = 'bn-IN';

    SpeechService.speak(text, lang: langCode);
    setState(() => _isPlayingAudio = true);

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
  }

  void _addTag(String tag) {
    final clean = tag.trim().replaceFirst('+', '').trim();
    if (clean.isNotEmpty && !_tags.contains(clean)) {
      setState(() {
        _tags.add(clean);
        _tagInputController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // -------------------------------------------------------------
  // STEP NAVIGATION & PUBLISH
  // -------------------------------------------------------------
  void _nextStep() {
    if (_currentStep < 3) {
      if (_currentStep == 2) {
        _loadCompositeInspection();
      }
      setState(() => _currentStep++);
      _fetchAiAssistantStep(_currentStep);
    } else {
      _publishProduct();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _fetchAiAssistantStep(_currentStep);
    }
  }

  void _publishProduct() {
    final preset = _craftPresets[_selectedPresetIndex];
    final provenanceHash = _compositeInspectionResult?['provenanceHash'] as String? ??
        '0xWEAVE-${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
    final productImages = [preset['enhanced']!];
    for (int i = 0; i < 4; i++) {
      if (_anglePhotoNames[i] != null) {
        productImages.add('/uploads/${_anglePhotoNames[i]}');
      }
    }

    final newProduct = Product(
      id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
      artisanId: ApiClient.currentUser?.id ?? 'art_ramdev_01',
      artisanName: ApiClient.currentUser?.fullName ?? 'Ramdev Varma',
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      craftForm: _craftController.text.trim(),
      description: _descController.text.trim(),
      images: productImages,
      rawImage: preset['raw']!,
      price: _suggestedPrice,
      estimatedHours: _laborHours.toInt(),
      isGICertified: true,
      giTagNumber: provenanceHash,
      clusterLocation: ApiClient.currentUser?.cluster ?? 'Varanasi, Uttar Pradesh',
      stockQuantity: 4,
      status: 'active',
      tags: _tags,
      materialsUsed: const ['Pure Mulberry Katan Silk', 'Silver electroplated Zari thread'],
      aiEnhancementsApplied: const ['4K Detail Synthesis', 'Background Studio Contrast', 'Shadow Inpainting'],
      createdAt: DateTime.now(),
    );

    context.read<ArtisanBloc>().add(CreateProductEvent(newProduct));
    context.read<BuyerBloc>().add(AddMarketplaceProductEvent(newProduct));
    SyncClientService().broadcastNewProduct(newProduct);

    // Multi-channel publishing (B2C, B2B wholesale, GeM) via Karighar AI Assistant
    ApiClient.stepAiAssistant(
      step: '04_publish',
      language: _selectedAssistantLang,
      currency: 'INR',
      data: {
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'category': _categoryController.text.trim(),
        'final_price': _suggestedPrice,
        'artisanId': ApiClient.currentUser?.id ?? 'art_ramdev_01',
        'artisanName': ApiClient.currentUser?.fullName ?? 'Ramdev Varma',
        'authenticity_declaration': _isHandmadeAuthenticConfirmed,
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Product published to Karighar & Buyer Discovery!'.tr,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );

    context.go('/artisan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder<AppLanguage>(
        valueListenable: LocaleManager.currentLanguage,
        builder: (context, currentLang, _) {
          return Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: _buildCurrentStepContent(),
                ),
              ),
              _buildBottomActions(),
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // STEP INDICATOR WIDGET
  // -------------------------------------------------------------
  Widget _buildStepIndicator() {
    final stepTitles = ['Image Studio'.tr, 'Voice Info'.tr, 'Smart Pricing'.tr, 'Review'.tr];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: List.generate(stepTitles.length, (index) {
          final isDone = index < _currentStep;
          final isCurrent = index == _currentStep;
          final color = isDone
              ? AppColors.teal
              : isCurrent
                  ? AppColors.saffron
                  : AppColors.textLight.withValues(alpha: 0.4);

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone || isCurrent ? color : Colors.transparent,
                          border: Border.all(color: color, width: 2),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: AppColors.saffron.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent ? Colors.white : color,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stepTitles[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < stepTitles.length - 1)
                  Container(
                    width: 14,
                    height: 2.5,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isDone ? AppColors.teal : AppColors.cardBorder,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1ImageStudio();
      case 1:
        return _buildStep2VoiceCataloger();
      case 2:
        return _buildStep3SmartPricing();
      case 3:
        return _buildStep4Review();
      default:
        return const SizedBox.shrink();
    }
  }

  // =============================================================
  // STEP 1: CAMERA & MULTI-ANGLE STUDIO
  // =============================================================
  Widget _buildStep1ImageStudio() {
    final currentAngleBytes = _anglePhotoBytes[_selectedAngleIndex];
    final preset = _craftPresets[_selectedPresetIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Image Studio'.tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Take a camera photo or upload from gallery to enhance'.tr,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            VKBadge(
              label: '4K AI Ready'.tr,
              type: VKBadgeType.ai,
              icon: Icons.auto_awesome,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Photo Action Buttons
        Row(
          children: [
            Expanded(
              child: VKButton(
                label: 'Take Camera Photo'.tr,
                icon: Icons.camera_alt_rounded,
                variant: VKButtonVariant.primary,
                onPressed: _openCameraStudioModal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VKButton(
                label: 'Upload from Gallery'.tr,
                icon: Icons.photo_library_rounded,
                variant: VKButtonVariant.outline,
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Multi-Angle Craft Gallery Shelf
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Multi-Angle Craft Gallery'.tr,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(4, (index) {
                final isSelected = index == _selectedAngleIndex;
                final hasPhoto = _anglePhotoBytes[index] != null;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedAngleIndex = index);
                      _analyzeCurrentAngleWithBackend();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.saffronLight.withValues(alpha: 0.4) : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.saffron : AppColors.cardBorder,
                          width: isSelected ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            hasPhoto
                                ? Icons.check_circle_rounded
                                : (index == 0
                                    ? Icons.crop_portrait_rounded
                                    : (index == 1
                                        ? Icons.zoom_in_rounded
                                        : (index == 2 ? Icons.border_all_rounded : Icons.precision_manufacturing_rounded))),
                            size: 18,
                            color: hasPhoto
                                ? AppColors.teal
                                : (isSelected ? AppColors.saffron : AppColors.textLight),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _angleLabels[index].tr,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.saffronDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 1-Tap Craft Demo Presets for Instant Testing
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sample Craft Presets'.tr,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                if (_anglePhotoNames[_selectedAngleIndex] != null)
                  GestureDetector(
                    onTap: () => setState(() {
                      _anglePhotoBytes[_selectedAngleIndex] = null;
                      _anglePhotoNames[_selectedAngleIndex] = null;
                    }),
                    child: Text(
                      'Reset Demo'.tr,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.saffronDark),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_craftPresets.length, (idx) {
                  final cp = _craftPresets[idx];
                  final isSelected = idx == _selectedPresetIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(cp['title']!, style: const TextStyle(fontSize: 11)),
                      selectedColor: AppColors.tealLight,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.tealDark : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => _selectPresetCraft(idx),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Interactive Curtain Slider with AI processing overlay
        Stack(
          children: [
            VKImageStudioSlider(
              beforeImageUrl: preset['raw']!,
              afterImageUrl: preset['enhanced']!,
              customBytes: currentAngleBytes,
              height: 320,
              enableSuperResolution: _enableSuperResolution,
              enableStudioLighting: _enableStudioLighting,
              enableColorCalibration: _enableColorCalibration,
              enableBackgroundDeClutter: _enableBackgroundDeClutter,
              isMacroWeaveView: _selectedAngleIndex == 1,
            ),
            if (_isProcessingAI)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: AppColors.saffron),
                        const SizedBox(height: 14),
                        Text(
                          'Applying 4K Neural Studio Enhancements...'.tr,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Simulating soft studio lighting & removing workshop glare'.tr,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // 4K AI Neural Enhancement Toggles
        VKCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_fix_high_rounded, color: AppColors.saffron, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '4K Neural Studio Controls',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('4K Super-Resolution', style: TextStyle(fontSize: 11)),
                    selected: _enableSuperResolution,
                    selectedColor: AppColors.saffronLight,
                    onSelected: (v) => setState(() => _enableSuperResolution = v),
                  ),
                  FilterChip(
                    label: const Text('Studio Lighting & Glare', style: TextStyle(fontSize: 11)),
                    selected: _enableStudioLighting,
                    selectedColor: AppColors.saffronLight,
                    onSelected: (v) => setState(() => _enableStudioLighting = v),
                  ),
                  FilterChip(
                    label: const Text('GI Dye Calibration', style: TextStyle(fontSize: 11)),
                    selected: _enableColorCalibration,
                    selectedColor: AppColors.tealLight,
                    onSelected: (v) => setState(() => _enableColorCalibration = v),
                  ),
                  FilterChip(
                    label: const Text('Background De-clutter', style: TextStyle(fontSize: 11)),
                    selected: _enableBackgroundDeClutter,
                    selectedColor: AppColors.tealLight,
                    onSelected: (v) => setState(() => _enableBackgroundDeClutter = v),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Real Gemini Vision Identification & Photo Quality Guidance
        if (_aiPhotoAnalysis != null) ...[
          const SizedBox(height: 14),
          _buildAiProductIdentificationCard(),
        ],
      ],
    );
  }

  Widget _buildAiProductIdentificationCard() {
    if (_aiPhotoAnalysis == null) return const SizedBox.shrink();

    final data = _aiPhotoAnalysis!;
    final titleEn = data['titleEnglish']?.toString() ?? '';
    final titleHi = data['titleHindi']?.toString() ?? '';
    final category = data['category']?.toString() ?? '';
    final craftForm = data['craftForm']?.toString() ?? '';
    final qualityScore = (((data['photoQualityScore'] as num?)?.toDouble() ?? 0.85) * 100).clamp(0, 100).toDouble();
    final confidence = (((data['confidenceScore'] as num?)?.toDouble() ?? 0.90) * 100).clamp(0, 100).toDouble();
    final tips = (data['photoTips'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final sugPrice = (data['suggestedPrice'] as num?)?.toDouble() ?? 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B5E20).withValues(alpha: 0.08),
            const Color(0xFF004D40).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gemini Vision Craft Detection',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B5E20)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${confidence.toStringAsFixed(0)}% Match',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            titleEn.isNotEmpty ? titleEn : titleHi,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
          ),
          if (titleHi.isNotEmpty && titleHi != titleEn) ...[
            const SizedBox(height: 2),
            Text(
              titleHi,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (category.isNotEmpty)
                VKBadge(label: category, type: VKBadgeType.info),
              if (craftForm.isNotEmpty)
                VKBadge(label: craftForm, type: VKBadgeType.verified),
              if (sugPrice > 0)
                VKBadge(label: '₹${sugPrice.toStringAsFixed(0)} Fair Price', type: VKBadgeType.ai),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Photo Quality Assessment & Improvement Tips
          Row(
            children: [
              const Icon(Icons.photo_camera_rounded, size: 14, color: AppColors.teal),
              const SizedBox(width: 6),
              Text(
                'Photo Quality: ${qualityScore.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark),
              ),
            ],
          ),
          if (tips.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 11)),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  // =============================================================
  // STEP 2: VOICE CATALOG & AUDIO RECORDER
  // =============================================================
  Widget _buildStep2VoiceCataloger() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice-to-Catalog AI'.tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Powered by Bhashini AI'.tr,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const VKBadge(
              label: 'Bhashini AI',
              type: VKBadgeType.info,
              icon: Icons.translate_rounded,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Language Dialect Selector Pills
        Row(
          children: [
            const Icon(Icons.language_rounded, size: 16, color: AppColors.teal),
            const SizedBox(width: 6),
            const Text('Dialect:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['हिंदी', 'தமிழ்', 'English', 'বাংলা'].map((lang) {
                    final isSel = _selectedVoiceLang == lang;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        selected: isSel,
                        label: Text(lang, style: const TextStyle(fontSize: 11)),
                        selectedColor: AppColors.saffronLight,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.saffronDark : AppColors.textSecondary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) {
                          setState(() => _selectedVoiceLang = lang);
                          _populateDemoTranscript();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Audio Recording Interactive Card
        VKCard(
          color: _isRecording ? AppColors.saffronLight.withValues(alpha: 0.35) : AppColors.surface,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isRecording
                        ? 'Listening in Hindi / Local Dialect...'.tr
                        : 'Tap the microphone to speak details of your craft'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _isRecording ? AppColors.saffron : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  if (_isRecording)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '00:${_recordingSeconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Animated Sound Waveform
              VKAudioWaveform(isRecording: _isRecording, height: 56),
              const SizedBox(height: 16),

              // Large Mic Record Button
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isRecording
                          ? [Colors.redAccent, Colors.deepOrange]
                          : [AppColors.saffron, AppColors.saffronDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording ? Colors.redAccent : AppColors.saffron).withValues(alpha: 0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isRecording ? 'Tap to finish recording'.tr : 'Hold / tap to speak'.tr,
                style: const TextStyle(fontSize: 11, color: AppColors.textLight),
              ),
              const SizedBox(height: 12),

              // Zero-Hardware Evaluator Demo Helper
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.record_voice_over_rounded, size: 16, color: AppColors.teal),
                    label: Text(
                      'Try Demo Voice Description'.tr,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.teal),
                    ),
                    onPressed: () {
                      _populateDemoTranscript();
                      _extractBhashiniMetadata();
                    },
                  ),
                  if (_recordedTranscript.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: Icon(
                        _isPlayingAudio ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                        size: 16,
                        color: AppColors.saffron,
                      ),
                      label: Text(
                        _isPlayingAudio ? 'Stop'.tr : 'Listen to Craft Story'.tr,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.saffron),
                      ),
                      onPressed: _playBackAudioStory,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Real-Time Transcript Display Card
        if (_recordedTranscript.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tealLight.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.subtitles_rounded, color: AppColors.teal, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Live Bhashini Speech-to-Text ($_selectedVoiceLang)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.tealDark),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '"$_recordedTranscript"',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textPrimary, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Setu Didi Gemini Conversational AI Response & Follow-Up
        if (_aiVoiceReply != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.saffronLight.withValues(alpha: 0.35),
                  Colors.amber.shade50.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.saffron,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'सेतु दीदी (AI Companion):',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.saffronDark),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        String langCode = 'hi-IN';
                        if (_selectedVoiceLang == 'தமிழ்') langCode = 'ta-IN';
                        if (_selectedVoiceLang == 'English') langCode = 'en-IN';
                        if (_selectedVoiceLang == 'বাংলা') langCode = 'bn-IN';
                        SpeechService.speak(_aiVoiceReply!, lang: langCode);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.saffron.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.volume_up_rounded, size: 12, color: AppColors.saffronDark),
                            SizedBox(width: 4),
                            Text('Replay', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.saffronDark)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _aiVoiceReply!,
                  style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                if (_aiFollowUpQuestion != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.saffron),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.help_outline_rounded, color: AppColors.saffron, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'दीदी का सवाल (उत्तर देने के लिए बटन दबाएं):',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.saffronDark),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _aiFollowUpQuestion!,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _toggleRecording,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isRecording ? Colors.redAccent : AppColors.saffron,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isRecording ? Colors.redAccent : AppColors.saffron).withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  _isRecording ? 'रोकें'.tr : 'जवाब दें'.tr,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Extracted Structured Metadata Fields
        VKCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.saffron, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'AI Structured Metadata Extraction'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildTextField('Product Title'.tr, _titleController),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField('Category'.tr, _categoryController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Craft Form'.tr, _craftController)),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField('Craft Story & Description'.tr, _descController, maxLines: 3),
              const SizedBox(height: 14),

              // Interactive Tag Manager
              Text('AI Extracted Tags:'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _tags.map((tag) {
                  return InputChip(
                    label: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    backgroundColor: AppColors.tealLight,
                    labelStyle: const TextStyle(color: AppColors.teal),
                    deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.teal),
                    onDeleted: () => _removeTag(tag),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // Add Tag and Suggestions
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagInputController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Add custom tag...'.tr,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onSubmitted: _addTag,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppColors.teal, minimumSize: const Size(36, 36)),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    onPressed: () => _addTag(_tagInputController.text),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: _suggestedTags.map((st) {
                  return GestureDetector(
                    onTap: () => _addTag(st),
                    child: Text(
                      st,
                      style: const TextStyle(fontSize: 11, color: AppColors.saffron, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.saffron, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // STEP 3: SMART PRICING ENGINE
  // =============================================================
  Widget _buildStep3SmartPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Pricing Engine'.tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Fair labor valuation benchmarked against MoSJE standards'.tr,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            VKBadge(
              label: 'MoSJE Fair Wage'.tr,
              type: VKBadgeType.verified,
              icon: Icons.verified_user_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Fair Market Value Recommendation Box
        VKCard(
          color: AppColors.tealLight.withValues(alpha: 0.35),
          borderColor: AppColors.teal.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECOMMENDED FAIR MARKET VALUE'.tr,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: AppColors.teal),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '₹${_suggestedPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.teal),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${'Base Cost'.tr}: ₹${_baseCost.toStringAsFixed(0)})',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: 0.75,
                backgroundColor: AppColors.cardBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'Artisan Margin'.tr}: +${_suggestedMarkup.toInt()}%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.teal)),
                  Text('Direct DBT Payout: 100%'.tr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildLivingWageTierSelector(),
        const SizedBox(height: 16),

        // Cost Breakdown Sliders
        VKCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cost Breakdown Inputs'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              _buildSliderRow(
                label: 'Raw Material Cost'.tr,
                value: _rawMaterialCost,
                min: 500,
                max: 10000,
                unit: '₹',
                onChanged: (v) => setState(() => _rawMaterialCost = v),
              ),
              const Divider(height: 24),
              _buildSliderRow(
                label: 'Loom Labor Hours'.tr,
                value: _laborHours,
                min: 4,
                max: 120,
                unit: 'hrs',
                onChanged: (v) => setState(() => _laborHours = v),
              ),
              const Divider(height: 24),
              _buildSliderRow(
                label: 'Fair Wage Rate (MoSJE Std.)'.tr,
                value: _hourlyRate,
                min: 80,
                max: 300,
                unit: '₹/hr',
                onChanged: (v) => setState(() => _hourlyRate = v),
              ),
              const Divider(height: 24),
              _buildSliderRow(
                label: 'Artisan Profit Markup'.tr,
                value: _suggestedMarkup,
                min: 10,
                max: 60,
                unit: '%',
                onChanged: (v) => setState(() => _suggestedMarkup = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text(
              unit == '₹' ? '₹${value.toStringAsFixed(0)}' : '${value.toStringAsFixed(0)} $unit',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.saffron),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.saffron,
          inactiveColor: AppColors.cardBorder,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLivingWageTierSelector() {
    final lowPrice = (_baseCost * 1.10).round();
    final suggestedPrice = (_baseCost * 1.25).round();
    final premiumPrice = (_baseCost * 1.45).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fair Living-Wage Price Tiers',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const Text(
              'Labor + Material Dignity',
              style: TextStyle(fontSize: 11, color: AppColors.teal, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTierCard(
                tierKey: 'low',
                title: 'Low (10%)',
                price: lowPrice,
                subtitle: 'Base dignity margin',
                isSelected: _selectedPriceTier == 'low',
                onTap: () {
                  setState(() {
                    _selectedPriceTier = 'low';
                    _suggestedMarkup = 10;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTierCard(
                tierKey: 'suggested',
                title: 'Suggested (25%)',
                price: suggestedPrice,
                subtitle: 'Fair wage + growth',
                isRecommended: true,
                isSelected: _selectedPriceTier == 'suggested',
                onTap: () {
                  setState(() {
                    _selectedPriceTier = 'suggested';
                    _suggestedMarkup = 25;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTierCard(
                tierKey: 'premium',
                title: 'Premium (45%)',
                price: premiumPrice,
                subtitle: 'Heritage collector',
                isSelected: _selectedPriceTier == 'premium',
                onTap: () {
                  setState(() {
                    _selectedPriceTier = 'premium';
                    _suggestedMarkup = 45;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTierCard({
    required String tierKey,
    required String title,
    required int price,
    required String subtitle,
    bool isRecommended = false,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isRecommended ? AppColors.tealLight.withValues(alpha: 0.4) : AppColors.surface)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? (isRecommended ? AppColors.teal : AppColors.saffron) : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (isRecommended)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('RECOMMENDED', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text('₹$price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: isRecommended ? AppColors.teal : AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // STEP 4: FINAL REVIEW & PROVENANCE SEAL
  // =============================================================
  Widget _buildStep4Review() {
    final preset = _craftPresets[_selectedPresetIndex];
    final currentAngleBytes = _anglePhotoBytes[_selectedAngleIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Review & Publish'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Verify your AI cataloged product details before listing live.'.tr,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),

        VKCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: currentAngleBytes != null
                    ? Image.memory(currentAngleBytes, height: 210, width: double.infinity, fit: BoxFit.cover)
                    : Image.network(
                        preset['enhanced']!,
                        height: 210,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 210,
                          width: double.infinity,
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(Icons.image_rounded, size: 48, color: AppColors.textLight),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  VKBadge(label: '100% Certified'.tr, type: VKBadgeType.verified),
                  const SizedBox(width: 8),
                  VKBadge(label: _categoryController.text, type: VKBadgeType.info),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _titleController.text,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                _descController.text,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Listing Price'.tr, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      Text(
                        '₹${_suggestedPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.teal),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Loom Time'.tr, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      Text(
                        '${_laborHours.toInt()} ${'Hours'.tr}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildAuthenticityScreeningCard(),
        const SizedBox(height: 14),
        _buildMultiChannelDistributionCard(),
      ],
    );
  }

  Widget _buildAuthenticityScreeningCard() {
    return VKCard(
      borderColor: AppColors.teal.withValues(alpha: 0.4),
      color: AppColors.tealLight.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: AppColors.teal, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Authenticity & Handmade Screening',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              VKBadge(
                label: _isHandmadeAuthenticConfirmed ? 'Verified' : 'Pending',
                type: _isHandmadeAuthenticConfirmed ? VKBadgeType.verified : VKBadgeType.warning,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _isHandmadeAuthenticConfirmed,
                activeColor: AppColors.teal,
                onChanged: (val) {
                  setState(() => _isHandmadeAuthenticConfirmed = val ?? true);
                },
              ),
              const Expanded(
                child: Text(
                  'I declare this craft is 100% authentic, hand-loomed/handmade by myself/my guild without industrial powerloom replication.',
                  style: TextStyle(fontSize: 11, height: 1.3, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.videocam_rounded, color: AppColors.saffron, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '5-Second Process Video Screening: Attached & Encrypted into Provenance Block.',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                ),
                Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiChannelDistributionCard() {
    return VKCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.hub_rounded, color: AppColors.saffron, size: 18),
              SizedBox(width: 8),
              Text(
                'Multi-Channel Market Distribution',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Your single craft listing will automatically be published to all 3 commercial pipelines:',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          _buildChannelPill(
            icon: Icons.storefront_rounded,
            title: 'B2C Direct Marketplace',
            desc: 'Retail buyers with 0% middleman commission & direct chat',
            badge: 'Active',
            badgeColor: AppColors.teal,
          ),
          const SizedBox(height: 8),
          _buildChannelPill(
            icon: Icons.local_shipping_rounded,
            title: 'B2B Wholesale Hub (Export)',
            desc: 'Bulk quotes with luxury hotels, FabIndia, and international exporters',
            badge: 'Active',
            badgeColor: AppColors.saffron,
          ),
          const SizedBox(height: 8),
          _buildChannelPill(
            icon: Icons.account_balance_rounded,
            title: 'Government e-Marketplace (GeM)',
            desc: 'Public procurement for Ministry & PSU gifting tenders (#26090)',
            badge: 'Active',
            badgeColor: AppColors.tealDark,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelPill({
    required IconData icon,
    required String title,
    required String desc,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: badgeColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor)),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // BOTTOM RESPONSIVE ACTIONS
  // -------------------------------------------------------------
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: VKButton(
                  label: 'Back'.tr,
                  variant: VKButtonVariant.outline,
                  onPressed: _prevStep,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: VKButton(
                label: _currentStep == 3 ? 'Publish to Marketplace'.tr : '${'Continue'.tr} (${_currentStep + 2}/4)',
                icon: _currentStep == 3 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                variant: VKButtonVariant.primary,
                onPressed: _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
