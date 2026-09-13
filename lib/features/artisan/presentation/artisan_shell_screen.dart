import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class ArtisanShellScreen extends StatelessWidget {
  final Widget child;
  const ArtisanShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/artisan/add-product')) return 1;
    if (location.startsWith('/artisan/orders')) return 2;
    if (location.startsWith('/artisan/quotes')) return 3;
    if (location.startsWith('/artisan/earnings')) return 4;
    return 0; // Home / Dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/artisan');
        break;
      case 1:
        context.go('/artisan/add-product');
        break;
      case 2:
        context.go('/artisan/orders');
        break;
      case 3:
        context.go('/artisan/quotes');
        break;
      case 4:
        context.go('/artisan/earnings');
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
              indicatorColor: AppColors.saffronLight,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final isSelected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? AppColors.saffronDark : AppColors.textSecondary,
                );
              }),
            ),
            child: NavigationBar(
              elevation: 0,
              selectedIndex: selectedIndex,
              onDestinationSelected: (idx) => _onItemTapped(idx, context),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.dashboard_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.dashboard_rounded, color: AppColors.saffron),
                  label: 'Dashboard'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.auto_awesome_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.auto_awesome, color: AppColors.saffron),
                  label: 'AI Studio'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.precision_manufacturing_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.precision_manufacturing_rounded, color: AppColors.saffron),
                  label: 'Orders'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.request_quote_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.request_quote_rounded, color: AppColors.saffron),
                  label: 'Quotes'.tr,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.textSecondary),
                  selectedIcon: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.saffron),
                  label: 'Earnings'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
