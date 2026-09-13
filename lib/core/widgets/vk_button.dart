import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum VKButtonVariant { primary, secondary, outline, ghost }

class VKButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final VKButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const VKButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = VKButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 48,
  });

  @override
  State<VKButton> createState() => _VKButtonState();
}

class _VKButtonState extends State<VKButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Gradient? get _gradient {
    if (widget.onPressed == null) return null;
    switch (widget.variant) {
      case VKButtonVariant.primary:
        return AppColors.saffronGradient;
      case VKButtonVariant.secondary:
        return AppColors.tealGradient;
      case VKButtonVariant.outline:
      case VKButtonVariant.ghost:
        return null;
    }
  }

  Color get _backgroundColor {
    if (widget.onPressed == null) return AppColors.divider;
    switch (widget.variant) {
      case VKButtonVariant.primary:
        return AppColors.saffron;
      case VKButtonVariant.secondary:
        return AppColors.teal;
      case VKButtonVariant.outline:
        return Colors.transparent;
      case VKButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    if (widget.onPressed == null) return AppColors.textLight;
    switch (widget.variant) {
      case VKButtonVariant.primary:
      case VKButtonVariant.secondary:
        return Colors.white;
      case VKButtonVariant.outline:
        return AppColors.textPrimary;
      case VKButtonVariant.ghost:
        return AppColors.textSecondary;
    }
  }

  Border? get _border {
    if (widget.variant == VKButtonVariant.outline) {
      return Border.all(color: AppColors.cardBorder, width: 1.5);
    }
    return null;
  }

  List<BoxShadow>? get _boxShadow {
    if (widget.onPressed == null) return null;
    if (widget.variant == VKButtonVariant.primary) {
      return AppColors.saffronGlow;
    } else if (widget.variant == VKButtonVariant.secondary) {
      return AppColors.tealGlow;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null && !widget.isLoading
          ? (_) => _controller.forward()
          : null,
      onTapUp: widget.onPressed != null && !widget.isLoading
          ? (_) => _controller.reverse()
          : null,
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: _gradient == null ? _backgroundColor : null,
              gradient: _gradient,
              borderRadius: BorderRadius.circular(12),
              border: _border,
              boxShadow: _boxShadow,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 18, color: _textColor),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.plusJakartaSans(
                              color: _textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
