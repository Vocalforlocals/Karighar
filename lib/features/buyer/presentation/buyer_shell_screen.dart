import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_conversational_mic.dart';
import '../bloc/buyer_bloc.dart';

class BuyerShellScreen extends StatefulWidget {
  final Widget child;
  const BuyerShellScreen({super.key, required this.child});

  @override
  State<BuyerShellScreen> createState() => _BuyerShellScreenState();
}

class _BuyerShellScreenState extends State<BuyerShellScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _searchHintIndex = 0;
  Timer? _searchHintTimer;

  final List<String> _searchHints = const [
    'Search "Banarasi Katan Silk"...',
    'Search "Madhubani Wall Painting"...',
    'Search "Gorakhpur Terracotta"...',
    'Search "Channapatna Wooden Toys"...',
    'Search "Bhagalpuri Wild Tussar"...',
    'Search "Chanderi Brocade Zari"...',
  ];

  final List<Map<String, String>> _quickCategories = const [
    {'name': 'All Crafts', 'path': '/buyer', 'category': 'All'},
    {'name': 'Silk Sarees', 'path': '/buyer', 'category': 'Textiles & Weaves'},
    {'name': 'Mithila Art', 'path': '/buyer', 'category': 'Folk Art & Paintings'},
    {'name': 'Clay Terracotta', 'path': '/buyer', 'category': 'Ceramics & Pottery'},
    {'name': 'Wooden Toys', 'path': '/buyer', 'category': 'Woodcraft & Toys'},
    {'name': 'Metal & Bell Craft', 'path': '/buyer', 'category': 'Metal & Bell Craft'},
    {'name': '💬 Artisan Chat', 'path': '/buyer/chat'},
    {'name': 'B2B RFP Tenders', 'path': '/buyer/tenders'},
    {'name': 'Blockchain Ledger', 'path': '/buyer/ledger'},
  ];

  @override
  void initState() {
    super.initState();
    _searchHintTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _searchHintIndex = (_searchHintIndex + 1) % _searchHints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchHintTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/buyer/explore' || location.startsWith('/buyer/explore')) return 1;
    if (location == '/buyer/stories' || location.startsWith('/buyer/stories')) return 2;
    if (location == '/buyer/cart' || location.startsWith('/buyer/cart')) return 3;
    if (location == '/buyer/profile' || location.startsWith('/buyer/profile')) return 4;
    return 0; // Home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/buyer');
        break;
      case 1:
        context.go('/buyer/explore');
        break;
      case 2:
        context.go('/buyer/stories');
        break;
      case 3:
        context.go('/buyer/cart');
        break;
      case 4:
        context.go('/buyer/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LocaleManager.currentLanguage,
      builder: (context, currentLang, _) {
        final width = MediaQuery.of(context).size.width;
        final selectedIndex = _calculateSelectedIndex(context);

        // Official Brand Logo (Medallion + Wordmark)
        Widget buildBrandLogo() {
          return InkWell(
            onTap: () => context.go('/buyer'),
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
                      colors: [AppColors.zariGold, AppColors.terracotta],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.terracotta.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/karighar_emblem.jpg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.saffronLight,
                        child: Icon(Icons.handshake_rounded, color: AppColors.terracotta, size: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 130),
                  child: Image.asset(
                    'assets/images/karighar_logo.png',
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(
                      'Karighar',
                      style: GoogleFonts.rozhaOne(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.saffronDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Language Switcher Pill
        Widget buildLanguageSelector() {
          return InkWell(
            onTap: () => LocaleManager.showLanguagePicker(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.translate_rounded, size: 13, color: AppColors.terracotta),
                  const SizedBox(width: 4),
                  Text(
                    LocaleManager.getLanguageLabel(currentLang),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        Widget buildShellContent() {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                // ================================================================
                // CANONICAL UNIFIED MOBILE HEADER (ACTIVE ACROSS WEB & MOBILE)
                // ================================================================
                Container(
                  padding: const EdgeInsets.only(top: 8, left: 14, right: 14, bottom: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Logo + Language + Chat + Cart
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: buildBrandLogo()),
                            buildLanguageSelector(),
                            const SizedBox(width: 4),
                            IconButton(
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textPrimary, size: 21),
                              tooltip: 'Artisan Chat'.tr,
                              onPressed: () => context.go('/buyer/chat'),
                            ),
                            const SizedBox(width: 4),
                            BlocBuilder<BuyerBloc, BuyerState>(
                              builder: (context, state) {
                                final cartCount = state.cartItems.length;
                                return IconButton(
                                  padding: const EdgeInsets.all(6),
                                  constraints: const BoxConstraints(),
                                  icon: Badge(
                                    isLabelVisible: cartCount > 0,
                                    label: Text('$cartCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                    backgroundColor: AppColors.terracotta,
                                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary, size: 22),
                                  ),
                                  onPressed: () => context.go('/buyer/cart'),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Row 2: Search Input with rotating hint & Voice
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.search_rounded, color: AppColors.terracotta, size: 18),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) {
                                    context.read<BuyerBloc>().add(SearchQueryChangedEvent(val));
                                  },
                                  decoration: InputDecoration(
                                    hintText: _searchHints[_searchHintIndex],
                                    hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.mic_rounded, color: AppColors.terracotta, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Bhashini Voice Search'.tr,
                                onPressed: () => VKConversationalMic.showSetuDidiVoiceSheet(context),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Row 3: Horizontal Category Strip
                        SizedBox(
                          height: 32,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _quickCategories.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final item = _quickCategories[index];
                              final currentCat = context.watch<BuyerBloc>().state.selectedCategory;
                              final isSelected = item['category'] != null &&
                                  (item['category'] == currentCat || (item['category'] == 'All' && (currentCat == 'All' || currentCat.isEmpty)));

                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (item['category'] != null) {
                                    context.read<BuyerBloc>().add(CategorySelectedEvent(item['category']!));
                                    if (GoRouterState.of(context).matchedLocation != '/buyer') {
                                      context.go('/buyer');
                                    }
                                  } else {
                                    context.go(item['path']!);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.terracottaLight : AppColors.background,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? AppColors.terracotta : AppColors.cardBorder,
                                      width: isSelected ? 1.2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item['name']!.tr,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? AppColors.terracotta : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // The child route body
                Expanded(child: widget.child),
              ],
            ),

            // Persistent Mobile Bottom Navigation Bar on ALL platforms
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
                boxShadow: AppColors.cardShadow,
              ),
              child: SafeArea(
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    height: 64,
                    backgroundColor: AppColors.surface,
                    indicatorColor: AppColors.terracottaLight,
                    labelTextStyle: WidgetStateProperty.resolveWith((states) {
                      final isSelected = states.contains(WidgetState.selected);
                      return TextStyle(
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected ? AppColors.terracotta : AppColors.textSecondary,
                      );
                    }),
                  ),
                  child: BlocBuilder<BuyerBloc, BuyerState>(
                    builder: (context, state) {
                      final cartCount = state.cartItems.length;

                      return NavigationBar(
                        elevation: 0,
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (idx) => _onItemTapped(idx, context),
                        destinations: [
                          NavigationDestination(
                            icon: const Icon(Icons.home_outlined, color: AppColors.textSecondary),
                            selectedIcon: const Icon(Icons.home_rounded, color: AppColors.terracotta),
                            label: 'Home'.tr,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.explore_outlined, color: AppColors.textSecondary),
                            selectedIcon: const Icon(Icons.explore_rounded, color: AppColors.terracotta),
                            label: 'Explore'.tr,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.auto_stories_outlined, color: AppColors.textSecondary),
                            selectedIcon: const Icon(Icons.auto_stories_rounded, color: AppColors.terracotta),
                            label: 'Stories'.tr,
                          ),
                          NavigationDestination(
                            icon: Badge(
                              isLabelVisible: cartCount > 0,
                              label: Text('$cartCount', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.terracotta,
                              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
                            ),
                            selectedIcon: Badge(
                              isLabelVisible: cartCount > 0,
                              label: Text('$cartCount', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.terracotta,
                              child: const Icon(Icons.shopping_bag_rounded, color: AppColors.terracotta),
                            ),
                            label: 'Cart'.tr,
                          ),
                          NavigationDestination(
                            icon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
                            selectedIcon: const Icon(Icons.person_rounded, color: AppColors.terracotta),
                            label: 'Profile'.tr,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }

        // On desktop/wide screens, present the app centered in a mobile viewport container
        if (width > 520) {
          return Scaffold(
            backgroundColor: const Color(0xFFEFE9E0),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.symmetric(
                    vertical: BorderSide(color: AppColors.cardBorder.withValues(alpha: 0.8), width: 1),
                  ),
                ),
                child: buildShellContent(),
              ),
            ),
          );
        }

        return buildShellContent();
      },
    );
  }
}
