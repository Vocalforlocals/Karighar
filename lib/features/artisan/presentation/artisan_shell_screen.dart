import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/chat_negotiation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_conversational_mic.dart';

class ArtisanShellScreen extends StatefulWidget {
  final Widget child;
  const ArtisanShellScreen({super.key, required this.child});

  @override
  State<ArtisanShellScreen> createState() => _ArtisanShellScreenState();
}

class _ArtisanShellScreenState extends State<ArtisanShellScreen> {
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/artisan/orders')) return 1;
    if (location.startsWith('/artisan/add-product') || location.startsWith('/artisan/studio')) return 2;
    if (location.startsWith('/artisan/chat') || location.startsWith('/artisan/quotes')) return 3;
    if (location.startsWith('/artisan/earnings') || location.startsWith('/artisan/credit')) return 4;
    return 0; // Home / Dashboard
  }


  Widget _buildBrandLogo({bool isCompact = false}) {
    return InkWell(
      onTap: () => context.go('/artisan'),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.zariGold, AppColors.saffron],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.saffron.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/karighar_emblem.jpg',
                height: isCompact ? 32 : 38,
                width: isCompact ? 32 : 38,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.handshake_rounded, color: AppColors.saffron, size: 26),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isCompact ? 110 : 155,
            ),
            child: Image.asset(
              'assets/images/karighar_logo.png',
              height: isCompact ? 24 : 30,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                'Karighar',
                style: GoogleFonts.rozhaOne(
                  fontSize: isCompact ? 18 : 22,
                  color: AppColors.saffronDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector({bool isCompact = false}) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LocaleManager.currentLanguage,
      builder: (context, currentLang, _) {
        return InkWell(
          onTap: () => LocaleManager.showLanguagePicker(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.translate_rounded, color: AppColors.saffron, size: 16),
                if (!isCompact) ...[
                  const SizedBox(width: 6),
                  Text(
                    LocaleManager.getLanguageName(currentLang),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
                const SizedBox(width: 2),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final user = ApiClient.currentUser;
    final artisanName = user?.fullName ?? 'Master Ramdev Varma';
    final cluster = user?.clusterLocation ?? 'Varanasi Cluster #370';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ================================================================
          // UNIFIED SELLER HEADER (MATCHING BUYER STANDARD)
          // ================================================================
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
              boxShadow: AppColors.cardShadow,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 12, vertical: 10),
                child: Row(
                  children: [
                    // Brand Logo with Studio Badge
                    _buildBrandLogo(isCompact: !isDesktop),
                    const SizedBox(width: 12),

                    // Cluster indicator (Desktop)
                    if (isDesktop) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: AppColors.saffron, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              cluster,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Language Selector Dropdown
                    _buildLanguageSelector(isCompact: !isDesktop),
                    const SizedBox(width: 8),

                    // 1-TAP SWITCH TO BUYER MARKETPLACE (SELLERS CAN ACCESS BOTH)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldDeep,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 14 : 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.storefront_rounded, size: 16),
                      label: Text(
                        isDesktop ? 'Buyer Marketplace'.tr : 'Buyer Shop'.tr,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => context.go('/buyer'),
                    ),
                    const SizedBox(width: 6),

                    // Artisan Profile & Logout Dropdown
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.account_circle_rounded, color: AppColors.saffronDark, size: 26),
                      tooltip: 'Artisan Account'.tr,
                      onSelected: (val) {
                        if (val == 'buyer') {
                          context.go('/buyer');
                        } else if (val == 'logout') {
                          ApiClient.logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logged out of Artisan Studio'.tr), backgroundColor: AppColors.textPrimary),
                          );
                          context.go('/buyer/profile');
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(artisanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(cluster, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const SizedBox(height: 2),
                              const Text('Shilp Guru / National Awardee', style: TextStyle(fontSize: 10, color: AppColors.saffronDark, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'buyer',
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_bag_rounded, color: AppColors.emeraldDeep, size: 18),
                              const SizedBox(width: 10),
                              Text('View Buyer Marketplace'.tr),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                              const SizedBox(width: 10),
                              Text('Log Out'.tr, style: const TextStyle(color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main View (Child Screen)
          Expanded(child: widget.child),
        ],
      ),

      // Bottom Navigation Bar with Center + FAB
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
          boxShadow: AppColors.cardShadow,
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: ChatNegotiationService.instance,
            builder: (context, _) {
              final unreadCount = ChatNegotiationService.instance.threads.fold<int>(
                0,
                (sum, t) => sum + t.unreadCountArtisan,
              );

              return SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Dashboard
                    _buildNavItem(
                      icon: selectedIndex == 0 ? Icons.dashboard_rounded : Icons.dashboard_outlined,
                      label: 'Dashboard'.tr,
                      isSelected: selectedIndex == 0,
                      onTap: () => context.go('/artisan'),
                    ),
                    // Orders
                    _buildNavItem(
                      icon: selectedIndex == 1 ? Icons.precision_manufacturing_rounded : Icons.precision_manufacturing_outlined,
                      label: 'Orders'.tr,
                      isSelected: selectedIndex == 1,
                      onTap: () => context.go('/artisan/orders'),
                    ),
                    // Center + FAB (AI Studio / Add Product)
                    Tooltip(
                      message: 'Add Craft (AI Studio)'.tr,
                      child: GestureDetector(
                        onTap: () => context.go('/artisan/add-product'),
                        onLongPress: () => _showAddMenu(context),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.saffron, Color(0xFFE65100)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: selectedIndex == 2
                                ? Border.all(color: AppColors.zariGold, width: 2.5)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.saffron.withValues(alpha: selectedIndex == 2 ? 0.6 : 0.35),
                                blurRadius: selectedIndex == 2 ? 16 : 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                    // Buyer Chat
                    _buildNavItem(
                      icon: selectedIndex == 3 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline_rounded,
                      label: 'Buyer Chat'.tr,
                      isSelected: selectedIndex == 3,
                      onTap: () => context.go('/artisan/chat'),
                      badgeCount: unreadCount,
                    ),
                    // Earnings
                    _buildNavItem(
                      icon: selectedIndex == 4 ? Icons.account_balance_wallet_rounded : Icons.account_balance_wallet_outlined,
                      label: 'Earnings'.tr,
                      isSelected: selectedIndex == 4,
                      onTap: () => context.go('/artisan/earnings'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text('$badgeCount', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
              backgroundColor: AppColors.terracotta,
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.saffron : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? AppColors.saffronDark : AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Quick Actions'.tr,
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildAddMenuTile(
                        icon: Icons.add_photo_alternate_rounded,
                        label: 'Add Product'.tr,
                        subtitle: 'AI Studio'.tr,
                        color: AppColors.saffron,
                        onTap: () {
                          Navigator.pop(ctx);
                          context.go('/artisan/add-product');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAddMenuTile(
                        icon: Icons.swap_horiz_rounded,
                        label: 'Buyer Shop'.tr,
                        subtitle: 'Switch Mode'.tr,
                        color: AppColors.emeraldDeep,
                        onTap: () {
                          Navigator.pop(ctx);
                          context.go('/buyer');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAddMenuTile(
                        icon: Icons.mic_rounded,
                        label: 'Setu Didi'.tr,
                        subtitle: 'Voice AI'.tr,
                        color: const Color(0xFFE65100),
                        onTap: () {
                          Navigator.pop(ctx);
                          VKConversationalMic.showSetuDidiVoiceSheet(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAddMenuTile(
                        icon: Icons.request_quote_rounded,
                        label: 'Quotes'.tr,
                        subtitle: 'B2B Orders'.tr,
                        color: AppColors.purple,
                        onTap: () {
                          Navigator.pop(ctx);
                          context.go('/artisan/quotes');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddMenuTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
