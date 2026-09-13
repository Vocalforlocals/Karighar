import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class VKImageStudioSlider extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final Uint8List? customBytes;
  final double height;

  const VKImageStudioSlider({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.customBytes,
    this.height = 340,
  });

  @override
  State<VKImageStudioSlider> createState() => _VKImageStudioSliderState();
}

class _VKImageStudioSliderState extends State<VKImageStudioSlider> {
  double _splitFraction = 0.5;

  Widget _buildBeforeImage() {
    if (widget.customBytes != null) {
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
    if (widget.customBytes != null) {
      // Apply professional AI studio lighting filter over the user's custom photo
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          1.15, 0.05, 0.05, 0, 10,   // Red boost & lift
          0.05, 1.15, 0.05, 0, 10,   // Green boost & lift
          0.05, 0.05, 1.20, 0, 12,   // Blue clarity & contrast
          0,    0,    0,    1, 0,    // Alpha
        ]),
        child: Image.memory(
          widget.customBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: widget.afterImageUrl,
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

                  // "AI STUDIO 4K" Tag (Right)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
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
