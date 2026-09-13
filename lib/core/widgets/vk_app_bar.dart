import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'vk_guided_tour_modal.dart';

class VKAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final String currentRole; // 'artisan', 'buyer', 'admin'

  const VKAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.currentRole = 'artisan',
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LocaleManager.currentLanguage,
      builder: (context, currentLang, _) {
        return AppBar(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(color: AppColors.cardBorder, width: 1),
          ),
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/role-selection');
                    }
                  },
                )
              : null,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/karighar_logo.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title.tr,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ...?actions,

            // SIH 2026 Jury Tour Quick-Access
            IconButton(
              tooltip: 'Start 60s Evaluator Tour'.tr,
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.saffron.withAlpha(80)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded, size: 15, color: AppColors.saffron),
                    const SizedBox(width: 4),
                    Text(
                      'Tour'.tr,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffron,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () => VKGuidedTourModal.show(context),
            ),

            // Instant Language Selector
            PopupMenuButton<AppLanguage>(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cardBorder),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language_rounded, size: 14, color: AppColors.teal),
                    const SizedBox(width: 4),
                    Text(
                      LocaleManager.getLanguageLabel(currentLang),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              onSelected: (lang) => LocaleManager.setLanguage(lang),
              itemBuilder: (context) => const [
                PopupMenuItem(value: AppLanguage.english, child: Text('English (EN)')),
                PopupMenuItem(value: AppLanguage.hindi, child: Text('हिंदी (Hindi)')),
                PopupMenuItem(value: AppLanguage.tamil, child: Text('தமிழ் (Tamil)')),
              ],
            ),
            const SizedBox(width: 6),

            // Global Role Switcher Pill
            PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: currentRole == 'artisan'
                      ? AppColors.saffronLight
                      : currentRole == 'buyer'
                          ? AppColors.tealLight
                          : const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentRole == 'artisan'
                          ? '🎨 ${'Artisan'.tr}'
                          : currentRole == 'buyer'
                              ? '🛍️ ${'Buyer'.tr}'
                              : '🛡️ ${'Admin'.tr}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: currentRole == 'artisan'
                            ? AppColors.saffronDark
                            : currentRole == 'buyer'
                                ? AppColors.tealDark
                                : AppColors.purple,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'artisan':
                    context.go('/artisan');
                    break;
                  case 'buyer':
                    context.go('/buyer');
                    break;
                  case 'admin':
                    context.go('/admin');
                    break;
                  case 'switch':
                    context.go('/role-selection');
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'artisan',
                  child: Row(
                    children: [
                      const Icon(Icons.palette_rounded, color: AppColors.saffron, size: 18),
                      const SizedBox(width: 10),
                      Text('Artisan Studio'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'buyer',
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_rounded, color: AppColors.teal, size: 18),
                      const SizedBox(width: 10),
                      Text('Buyer Marketplace'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'admin',
                  child: Row(
                    children: [
                      const Icon(Icons.admin_panel_settings_rounded, color: AppColors.purple, size: 18),
                      const SizedBox(width: 10),
                      Text('MoSJE Admin Panel'.tr),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'switch',
                  child: Row(
                    children: [
                      const Icon(Icons.swap_horiz_rounded, size: 18),
                      const SizedBox(width: 10),
                      Text('Switch Role / Logout'.tr),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        );
      },
    );
  }
}
