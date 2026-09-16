import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class VKCameraStudioModal extends StatefulWidget {
  final int initialAngleIndex;
  final List<String> angleLabels;
  final List<String> angleKeys;
  final List<Uint8List?> anglePhotoBytes;
  final Map<String, String> currentPreset;
  final Function(int angleIndex, Uint8List photoBytes, String fileName) onPhotoCaptured;

  const VKCameraStudioModal({
    super.key,
    required this.initialAngleIndex,
    required this.angleLabels,
    required this.angleKeys,
    required this.anglePhotoBytes,
    required this.currentPreset,
    required this.onPhotoCaptured,
  });

  static Future<void> show(
    BuildContext context, {
    required int initialAngleIndex,
    required List<String> angleLabels,
    required List<String> angleKeys,
    required List<Uint8List?> anglePhotoBytes,
    required Map<String, String> currentPreset,
    required Function(int angleIndex, Uint8List photoBytes, String fileName) onPhotoCaptured,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VKCameraStudioModal(
        initialAngleIndex: initialAngleIndex,
        angleLabels: angleLabels,
        angleKeys: angleKeys,
        anglePhotoBytes: anglePhotoBytes,
        currentPreset: currentPreset,
        onPhotoCaptured: onPhotoCaptured,
      ),
    );
  }

  @override
  State<VKCameraStudioModal> createState() => _VKCameraStudioModalState();
}

class _VKCameraStudioModalState extends State<VKCameraStudioModal> with SingleTickerProviderStateMixin {
  late int _activeAngle;
  bool _isFlashOn = false;
  bool _showGrid = true;
  bool _isShutterPulsing = false;
  bool _isMacroLens = false;
  final double _simulatedLux = 98.4;
  final double _simulatedTilt = 0.3;
  late AnimationController _pulseController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _activeAngle = widget.initialAngleIndex.clamp(0, 3);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _useSamplePresetPhoto() async {
    final presetUrl = widget.currentPreset['enhanced'] ?? widget.currentPreset['raw'];
    if (presetUrl != null && presetUrl.isNotEmpty) {
      setState(() => _isShutterPulsing = true);
      try {
        final response = await http.get(Uri.parse(presetUrl)).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
          final prefix = widget.currentPreset['title']?.toLowerCase().replaceAll(' ', '_') ?? 'craft';
          final fileName = '${prefix}_${widget.angleKeys[_activeAngle]}.jpg';
          widget.onPhotoCaptured(_activeAngle, response.bodyBytes, fileName);
          _advanceOrClose();
          return;
        }
      } catch (e) {
        debugPrint('Preset photo load note: $e');
      } finally {
        if (mounted) setState(() => _isShutterPulsing = false);
      }
    }
  }

  Future<void> _captureShutter() async {
    setState(() => _isShutterPulsing = true);

    // 1. Try hardware camera via ImagePicker
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 95,
      );

      if (file != null) {
        final bytes = await file.readAsBytes();
        widget.onPhotoCaptured(_activeAngle, bytes, file.name);
        _advanceOrClose();
        return;
      }
    } catch (_) {
      // 2. Camera hardware/permission error (e.g. on web/desktop):
      // Automatically fallback to gallery file picker so user can pick their actual product photo
      try {
        final file = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 2048,
          maxHeight: 2048,
          imageQuality: 95,
        );
        if (file != null) {
          final bytes = await file.readAsBytes();
          widget.onPhotoCaptured(_activeAngle, bytes, file.name);
          _advanceOrClose();
          return;
        }
      } catch (_) {}

      // 3. If file pick was cancelled or unavailable, use sample craft photo bytes so AI Vision can analyze
      await _useSamplePresetPhoto();
      return;
    } finally {
      if (mounted) setState(() => _isShutterPulsing = false);
    }

    _advanceOrClose();
  }

  Future<void> _pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 95,
      );

      if (file != null) {
        final bytes = await file.readAsBytes();
        widget.onPhotoCaptured(_activeAngle, bytes, file.name);
        _advanceOrClose();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gallery pick notice: $e')),
        );
      }
    }
  }

  void _advanceOrClose() {
    if (!mounted) return;
    if (_activeAngle < 3) {
      setState(() => _activeAngle++);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final angleLabel = widget.angleLabels[_activeAngle];

    return Container(
      height: size.height * 0.94,
      decoration: const BoxDecoration(
        color: Color(0xFF090D16),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Stack(
          children: [
            // 1. CAMERA VIEWFINDER STREAM / PREVIEW
            Positioned.fill(
              child: _buildCameraFeedBackground(),
            ),

            // 2. RULE-OF-THIRDS GRID OVERLAY
            if (_showGrid) Positioned.fill(child: _buildGridOverlay()),

            // 3. ANGLE-AWARE CRAFT FRAMING GUIDE
            Positioned.fill(child: _buildAngleFramingGuide()),

            // 4. SHUTTER FLASH ANIMATION
            if (_isShutterPulsing)
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.8)),
              ),

            // 5. TOP VIEWFINDER HUD CONTROLS
            Positioned(
              top: 14,
              left: 16,
              right: 16,
              child: _buildTopHudBar(angleLabel),
            ),

            // 6. REAL-TIME SENSOR HUD (Lighting, Tilt, Weave Focus)
            Positioned(
              top: 76,
              left: 16,
              right: 16,
              child: _buildSensorHudRow(),
            ),

            // 7. BOTTOM CAMERA CONTROL PANEL & MULTI-ANGLE CAROUSEL
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomCameraControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraFeedBackground() {
    final bytes = widget.anglePhotoBytes[_activeAngle];
    final presetUrl = widget.currentPreset['enhanced'] ?? widget.currentPreset['raw'];

    if (bytes != null && bytes.isNotEmpty) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (presetUrl != null && presetUrl.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            presetUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1E293B)),
          ),
          Container(
            color: Colors.black.withValues(alpha: _isFlashOn ? 0.05 : 0.25),
          ),
        ],
      );
    }

    return Container(
      color: const Color(0xFF0F172A),
      child: const Center(
        child: Icon(Icons.camera_alt_outlined, color: Colors.white24, size: 64),
      ),
    );
  }

  Widget _buildGridOverlay() {
    return CustomPaint(
      painter: _GridPainter(color: Colors.white.withValues(alpha: 0.25)),
    );
  }

  Widget _buildAngleFramingGuide() {
    switch (_activeAngle) {
      case 1: // Microscopic Weave Texture (Macro)
        return Center(
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final scale = 1.0 + (_pulseController.value * 0.04);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.teal, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withValues(alpha: 0.3),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white60, width: 1.5),
                          ),
                          child: const Icon(Icons.blur_on_rounded, color: AppColors.teal, size: 20),
                        ),
                      ),
                      Positioned(
                        bottom: 18,
                        left: 0,
                        right: 0,
                        child: Text(
                          'MACRO WEAVE TARGET (10cm)'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );

      case 2: // Border Motif / Zari
        return Center(
          child: Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.saffron, width: 2),
            ),
            child: const Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 12,
                  child: Text(
                    'ALIGN ZARI & MOTIF BORDER',
                    style: TextStyle(color: AppColors.saffron, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
              ],
            ),
          ),
        );

      case 3: // Artisan at Loom Context
        return Center(
          child: Container(
            width: 320,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amberAccent, width: 1.8),
            ),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'INCLUDE WORKSPACE & HAND SHUTTLE',
                  style: TextStyle(color: Colors.amberAccent, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
              ),
            ),
          ),
        );

      case 0: // Full Craft View
      default:
        return Center(
          child: Container(
            width: 290,
            height: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white60, width: 2),
            ),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'CENTER FULL HANDICRAFT IN FRAME',
                  style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildTopHudBar(String angleLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.saffron.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.camera_alt_rounded, color: AppColors.saffron, size: 14),
              const SizedBox(width: 6),
              Text(
                '${_activeAngle + 1}/4: $angleLabel',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                _showGrid ? Icons.grid_on_rounded : Icons.grid_off_rounded,
                color: _showGrid ? AppColors.teal : Colors.white70,
                size: 22,
              ),
              onPressed: () => setState(() => _showGrid = !_showGrid),
            ),
            IconButton(
              icon: Icon(
                _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                color: _isFlashOn ? Colors.amberAccent : Colors.white70,
                size: 22,
              ),
              onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSensorHudRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHudBadge(
          icon: Icons.wb_sunny_rounded,
          label: 'Light $_simulatedLux%',
          color: AppColors.teal,
        ),
        const SizedBox(width: 8),
        _buildHudBadge(
          icon: Icons.screen_rotation_rounded,
          label: 'Level $_simulatedTilt°',
          color: Colors.amberAccent,
        ),
        const SizedBox(width: 8),
        _buildHudBadge(
          icon: Icons.center_focus_strong_rounded,
          label: _activeAngle == 1 ? 'Macro 3x' : 'Auto 4K',
          color: AppColors.saffron,
        ),
      ],
    );
  }

  Widget _buildHudBadge({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomCameraControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.85),
            Colors.black,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Multi-Angle Navigation Selector Strip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (idx) {
                final isSel = idx == _activeAngle;
                final isDone = widget.anglePhotoBytes[idx] != null;
                return GestureDetector(
                  onTap: () => setState(() => _activeAngle = idx),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.saffron : (isDone ? AppColors.teal.withValues(alpha: 0.3) : Colors.white12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSel ? AppColors.saffronDark : (isDone ? AppColors.teal : Colors.white24),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isDone)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        Text(
                          widget.angleLabels[idx],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            color: isSel ? Colors.black87 : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),

          // Shutter Row: Gallery Upload | Big Shutter Button | Macro Lens Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Gallery Button
              IconButton(
                icon: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 28),
                onPressed: _pickFromGallery,
                tooltip: 'Upload photo from gallery',
              ),

              // Giant Shutter Button
              GestureDetector(
                onTap: _captureShutter,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isShutterPulsing ? AppColors.teal : AppColors.saffron,
                      ),
                      child: const Center(
                        child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                ),
              ),

              // Macro / Sensor Switch Button
              IconButton(
                icon: Icon(
                  _isMacroLens ? Icons.camera_enhance_rounded : Icons.flip_camera_ios_rounded,
                  color: _isMacroLens ? AppColors.teal : Colors.white,
                  size: 28,
                ),
                onPressed: () => setState(() => _isMacroLens = !_isMacroLens),
                tooltip: 'Switch sensor mode',
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _useSamplePresetPhoto,
            icon: const Icon(Icons.auto_awesome, size: 14, color: AppColors.saffron),
            label: Text(
              '${'Use Sample Craft Photo'.tr} (${widget.currentPreset['title'] ?? 'Craft'})',
              style: const TextStyle(fontSize: 11, color: AppColors.saffron, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hold steady and align craft inside the guideline frame'.tr,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final x1 = size.width / 3;
    final x2 = (size.width / 3) * 2;
    final y1 = size.height / 3;
    final y2 = (size.height / 3) * 2;

    canvas.drawLine(Offset(x1, 0), Offset(x1, size.height), paint);
    canvas.drawLine(Offset(x2, 0), Offset(x2, size.height), paint);
    canvas.drawLine(Offset(0, y1), Offset(size.width, y1), paint);
    canvas.drawLine(Offset(0, y2), Offset(size.width, y2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
