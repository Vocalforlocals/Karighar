import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class BuyerShellScreen extends StatelessWidget {
  final Widget child;
  const BuyerShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/buyer/cart')) return 1;
    if (location.startsWith('/buyer/quotes')) return 2;
    if (location.startsWith('/buyer/chat')) return 3;
    return 0; // Explore
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/buyer');
        break;
      case 1:
        context.go('/buyer/cart');
        break;
      case 2:
        context.go('/buyer/quotes');
        break;
      case 3:
        context.go('/buyer/chat');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
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
              indicatorColor: AppColors.tealLight,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final isSelected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? AppColors.tealDark : AppColors.textSecondary,
                );
              }),
            ),
            child: NavigationBar(
              elevation: 0,
              selectedIndex: selectedIndex,
              onDestinationSelected: (idx) => _onItemTapped(idx, context),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.explore_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.explore_rounded, color: AppColors.teal),
                  label: 'Explore'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.shopping_bag_rounded, color: AppColors.teal),
                  label: 'Cart'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.handshake_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.handshake_rounded, color: AppColors.teal),
                  label: 'Quotes'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.chat_bubble_rounded, color: AppColors.teal),
                  label: 'Chat'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
