import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VKCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final double borderRadius;
  final List<BoxShadow>? customShadow;
  final VoidCallback? onTap;

  const VKCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.gradient,
    this.borderRadius = 16,
    this.customShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = BorderRadius.circular(borderRadius);

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: borderColor ?? AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: customShadow ?? AppColors.cardShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          splashColor: AppColors.saffron.withValues(alpha: 0.1),
          highlightColor: AppColors.saffron.withValues(alpha: 0.05),
          child: content,
        ),
      );
    }

    return content;
  }
}
