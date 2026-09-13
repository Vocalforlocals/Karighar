import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum VKBadgeType { success, warning, info, verified, ai }

class VKBadge extends StatelessWidget {
  final String label;
  final VKBadgeType type;
  final IconData? icon;

  const VKBadge({
    super.key,
    required this.label,
    this.type = VKBadgeType.info,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case VKBadgeType.success:
      case VKBadgeType.verified:
        bg = AppColors.tealLight;
        fg = AppColors.tealDark;
        break;
      case VKBadgeType.warning:
        bg = const Color(0xFFFEF3C7);
        fg = AppColors.warning;
        break;
      case VKBadgeType.ai:
        bg = AppColors.saffronLight;
        fg = AppColors.saffronDark;
        break;
      case VKBadgeType.info:
        bg = const Color(0xFFF3F4F6);
        fg = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: fg.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
