import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class NotFoundScreen extends StatelessWidget {
  final String path;

  const NotFoundScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Karighar',
        showBackButton: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Warning Icon Badge
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.saffronLight.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.travel_explore_rounded,
                      size: 44,
                      color: AppColors.saffron,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 404 Title
                Text(
                  '404 — Page Not Found',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'पृष्ठ नहीं मिला • பக்கம் கிடைக்கவில்லை',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Path details chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.link_off_rounded, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          path,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Navigation Hub
                VKCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select a Destination',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const VKBadge(label: 'Quick Access', type: VKBadgeType.info),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Destination 1: AI Studio Wizard
                      _buildDestItem(
                        context,
                        icon: Icons.auto_fix_high_rounded,
                        color: AppColors.saffron,
                        title: 'AI Studio Wizard (Camera & Voice)',
                        subtitle: 'Upload craft photos, audio cataloging & 4K AI',
                        route: '/studio',
                      ),
                      const Divider(height: 16),

                      // Destination 2: Artisan Dashboard
                      _buildDestItem(
                        context,
                        icon: Icons.palette_rounded,
                        color: AppColors.teal,
                        title: 'Artisan Dashboard',
                        subtitle: 'Orders, quotes, earnings & credit profiles',
                        route: '/artisan',
                      ),
                      const Divider(height: 16),

                      // Destination 3: Buyer Marketplace
                      _buildDestItem(
                        context,
                        icon: Icons.shopping_bag_rounded,
                        color: AppColors.purple,
                        title: 'Buyer Marketplace',
                        subtitle: 'GI crafts, institutional tenders & AR viewer',
                        route: '/buyer',
                      ),
                      const Divider(height: 16),

                      // Destination 4: Admin Portal
                      _buildDestItem(
                        context,
                        icon: Icons.admin_panel_settings_rounded,
                        color: AppColors.gold,
                        title: 'MoSJE Admin Panel',
                        subtitle: 'National GIS clusters & regulatory telemetry',
                        route: '/admin',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Primary Return Home Button
                VKButton(
                  label: 'Return to Home / Login',
                  icon: Icons.home_rounded,
                  variant: VKButtonVariant.primary,
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}
