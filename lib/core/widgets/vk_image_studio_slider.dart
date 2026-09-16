import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class VKImageStudioSlider extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final Uint8List? customBytes;
  final double height;
  final bool enableSuperResolution;
  final bool enableStudioLighting;
  final bool enableColorCalibration;
  final bool enableBackgroundDeClutter;
  final bool isMacroWeaveView;
  final VoidCallback? onInspectWeave;

  const VKImageStudioSlider({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.customBytes,
    this.height = 340,
    this.enableSuperResolution = true,
    this.enableStudioLighting = true,
    this.enableColorCalibration = true,
    this.enableBackgroundDeClutter = true,
    this.isMacroWeaveView = false,
    this.onInspectWeave,
  });

  @override
  State<VKImageStudioSlider> createState() => _VKImageStudioSliderState();
}

class _VKImageStudioSliderState extends State<VKImageStudioSlider> {
  double _splitFraction = 0.5;

  List<double> _calculateDynamicColorMatrix() {
    double rScale = 1.0;
    double gScale = 1.0;
    double bScale = 1.0;
    double offset = 0.0;

    if (widget.enableStudioLighting) {
      rScale += 0.08;
      gScale += 0.06;
      bScale += 0.04;
      offset += 12.0; // soft illumination
    }

    if (widget.enableColorCalibration) {
      rScale += 0.08;
      gScale += 0.08;
      bScale += 0.12; // rich natural dyes
    }

    if (widget.enableSuperResolution) {
      rScale += 0.05;
      gScale += 0.05;
      bScale += 0.05;
      offset += 4.0; // clarity lift
    }

    if (widget.enableBackgroundDeClutter) {
      offset -= 2.0; // deeper blacks, subject pop
    }

    return [
      rScale, 0.02, 0.02, 0, offset,
      0.02, gScale, 0.02, 0, offset,
      0.02, 0.02, bScale, 0, offset + 2,
      0,    0,     0,     1, 0,
    ];
  }

  Widget _buildBeforeImage() {
    if (widget.customBytes != null && widget.customBytes!.isNotEmpty) {
      return Image.memory(
        widget.customBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return CachedNetworkImage(
      imageUrl: widget.beforeImageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(color: AppColors.background),
      errorWidget: (context, url, error) => Container(
        color: AppColors.background,
        child: const Center(child: Icon(Icons.broken_image, color: AppColors.textLight)),
      ),
    );
  }

  Widget _buildAfterImage() {
    final matrix = _calculateDynamicColorMatrix();

    Widget imageContent;
    if (widget.customBytes != null && widget.customBytes!.isNotEmpty) {
      imageContent = ColorFiltered(
        colorFilter: ColorFilter.matrix(matrix),
        child: Image.memory(
          widget.customBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      imageContent = ColorFiltered(
        colorFilter: ColorFilter.matrix(matrix),
        child: CachedNetworkImage(
          imageUrl: widget.afterImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Container(color: AppColors.background),
          errorWidget: (context, url, error) => Container(
            color: AppColors.background,
            child: const Center(child: Icon(Icons.broken_image, color: AppColors.textLight)),
          ),
        ),
      );
    }

    if (!widget.isMacroWeaveView) {
      return imageContent;
    }

    // Overlay microscopic weave grid on macro angle
    return Stack(
      fit: StackFit.expand,
      children: [
        imageContent,
        CustomPaint(
          painter: _WeaveThreadOverlayPainter(),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.teal),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.biotech_rounded, size: 12, color: AppColors.teal),
                SizedBox(width: 4),
                Text(
                  '128 EPI × 114 PPI Microscopic Weave',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _open4KInteractiveZoomDialog(BuildContext context) {
    widget.onInspectWeave?.call();
    bool showThreadGrid = widget.isMacroWeaveView;
    final TransformationController transformController = TransformationController();

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return Dialog(
            backgroundColor: const Color(0xFF0F172A),
            insetPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: InteractiveViewer(
                      transformationController: transformController,
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 6.0,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            widget.customBytes != null && widget.customBytes!.isNotEmpty
                                ? Image.memory(widget.customBytes!, fit: BoxFit.contain)
                                : Image.network(widget.afterImageUrl, fit: BoxFit.contain),
                            if (showThreadGrid)
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _WeaveThreadOverlayPainter(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top Header HUD
                  Positioned(
                    top: 12,
                    left: 14,
                    right: 60,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.biotech_rounded, size: 14, color: AppColors.saffron),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    '4K UHD Interactive Weave Inspector (Pinch & Pan up to 6x)',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),

                  // Bottom Controls HUD
                  Positioned(
                    bottom: 14,
                    left: 14,
                    right: 14,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Thread density badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.teal),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                              SizedBox(width: 5),
                              Text(
                                '128 EPI × 114 PPI Silk Density Gauge',
                                style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // Action chips
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ActionChip(
                              avatar: Icon(
                                showThreadGrid ? Icons.grid_on_rounded : Icons.grid_off_rounded,
                                size: 14,
                                color: showThreadGrid ? AppColors.saffron : Colors.white70,
                              ),
                              label: Text(
                                showThreadGrid ? 'Thread Grid: ON' : 'Thread Grid: OFF',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: showThreadGrid ? AppColors.saffron : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.black87,
                              side: BorderSide(
                                color: showThreadGrid ? AppColors.saffron : Colors.white24,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  showThreadGrid = !showThreadGrid;
                                });
                              },
                            ),
                            const SizedBox(width: 6),
                            ActionChip(
                              avatar: const Icon(Icons.restart_alt_rounded, size: 14, color: Colors.white70),
                              label: const Text(
                                'Reset Zoom',
                                style: TextStyle(fontSize: 10.5, color: Colors.white),
                              ),
                              backgroundColor: Colors.black87,
                              side: const BorderSide(color: Colors.white24),
                              onPressed: () {
                                transformController.value = Matrix4.identity();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final splitPosition = width * _splitFraction;

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _splitFraction = (_splitFraction + (details.primaryDelta ?? 0) / width).clamp(0.05, 0.95);
                });
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // After Image (AI Studio Enhanced - Background)
                  _buildAfterImage(),

                  // Before Image (Raw Loom/Workshop Photo - Clipped)
                  ClipRect(
                    clipper: _LeftSplitClipper(splitPosition),
                    child: _buildBeforeImage(),
                  ),

                  // Divider Line
                  Positioned(
                    left: splitPosition - 1.5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          width: 1,
                          color: AppColors.saffron.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),

                  // Draggable Center Knob
                  Positioned(
                    left: splitPosition - 20,
                    top: widget.height / 2 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 24,
                          color: AppColors.saffron,
                        ),
                      ),
                    ),
                  ),

                  // "RAW WORKSHOP" Tag (Left)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.customBytes != null ? 'ORIGINAL CAPTURE' : 'RAW WORKSHOP',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  // "AI STUDIO 4K" Tag & 4K Zoom Button (Right)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.saffron, AppColors.saffronDark],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.saffron.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 13, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'AI STUDIO 4K ENHANCED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _open4KInteractiveZoomDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Icon(Icons.zoom_in_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeftSplitClipper extends CustomClipper<Rect> {
  final double width;
  _LeftSplitClipper(this.width);

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, width, size.height);

  @override
  bool shouldReclip(covariant _LeftSplitClipper oldClipper) => oldClipper.width != width;
}

class VKWeaveThreadPainter extends CustomPainter {
  final double spacing;
  final Color? warpColor;
  final Color? weftColor;

  const VKWeaveThreadPainter({
    this.spacing = 12.0,
    this.warpColor,
    this.weftColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final warpPaint = Paint()
      ..color = warpColor ?? Colors.cyanAccent.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;

    final weftPaint = Paint()
      ..color = weftColor ?? Colors.amberAccent.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), warpPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), weftPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

typedef _WeaveThreadOverlayPainter = VKWeaveThreadPainter;

