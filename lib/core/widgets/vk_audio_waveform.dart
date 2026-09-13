import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VKAudioWaveform extends StatefulWidget {
  final bool isRecording;
  final double height;

  const VKAudioWaveform({
    super.key,
    required this.isRecording,
    this.height = 60,
  });

  @override
  State<VKAudioWaveform> createState() => _VKAudioWaveformState();
}

class _VKAudioWaveformState extends State<VKAudioWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _baseHeights = List.generate(32, (i) => (sin(i * 0.4) * 0.4 + 0.5).clamp(0.15, 0.95));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VKAudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRecording && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_baseHeights.length, (index) {
              double scale = _baseHeights[index];
              if (widget.isRecording) {
                // Generate dynamic pulsing sine wave animation
                final phase = (_controller.value * 2 * pi) + (index * 0.3);
                final dynamicFactor = (sin(phase) * 0.35 + 0.65);
                scale = (scale * dynamicFactor).clamp(0.1, 1.0);
              } else {
                scale = scale * 0.4;
              }

              return Container(
                width: 3.5,
                height: widget.height * scale,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: widget.isRecording
                        ? [AppColors.saffron, AppColors.saffronDark]
                        : [AppColors.textLight.withValues(alpha: 0.3), AppColors.textLight.withValues(alpha: 0.5)],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
