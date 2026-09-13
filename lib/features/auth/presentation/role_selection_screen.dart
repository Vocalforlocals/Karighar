import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.saffronLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'KARIGHAR PORTAL',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.saffronDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select Your Experience',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Seamlessly navigate between Artisan Studio, Buyer Marketplace, or Ministry Admin',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // CARD 1: ARTISAN
              _buildRoleCard(
                context,
                title: 'Artisan Studio',
                subtitle: 'AI Smart Cataloging, Fair Pricing, Orders & DBT Payouts',
                icon: Icons.palette_rounded,
                accentColor: AppColors.saffron,
                tagText: 'SELL & GROW',
                route: '/artisan',
                features: [
                  'Interactive AI Photo Studio (4K Enhancer)',
                  'Voice-to-Catalog with Bhashini AI in regional dialects',
                  'Fair Wage & Margin Calculator (MoSJE Protected)',
                  'Direct B2B Procurement Quote Negotiation',
                ],
              ),
              const SizedBox(height: 16),

              // CARD 2: BUYER
              _buildRoleCard(
                context,
                title: 'Buyer Marketplace',
                subtitle: 'Discover Authentic GI-Certified Crafts Directly from Artisans',
                icon: Icons.shopping_bag_rounded,
                accentColor: AppColors.teal,
                tagText: 'EXPLORE & BUY',
                route: '/buyer',
                features: [
                  'Traceable artisan provenance & GI tags',
                  'Request bulk wholesale procurement quotes',
                  'Transparent artisan compensation breakdown',
                  'Multi-vendor cart & express dispatch',
                ],
              ),
              const SizedBox(height: 16),

              // CARD 3: ADMIN / IMPACT
              _buildRoleCard(
                context,
                title: 'MoSJE Admin Panel',
                subtitle: 'Ministry Supervision, Cluster Analytics & DBT Impact',
                icon: Icons.admin_panel_settings_rounded,
                accentColor: AppColors.purple,
                tagText: 'GOVERNMENT OVERSIGHT',
                route: '/admin',
                features: [
                  '14,280+ marginalized artisan welfare tracking',
                  '+38.4% verified income uplift telemetry',
                  'Regional craft cluster heatmaps & GI compliance',
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required String tagText,
    required String route,
    required List<String> features,
  }) {
    return VKCard(
      onTap: () => context.go(route),
      gradient: LinearGradient(
        colors: [Colors.white, accentColor.withValues(alpha: 0.04)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: accentColor.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor.withValues(alpha: 0.18), accentColor.withValues(alpha: 0.08)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accentColor.withValues(alpha: 0.25), width: 1.2),
                ),
                child: Icon(icon, color: accentColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 0.8),
                      ),
                      child: Text(
                        tagText,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.arrow_forward_rounded, size: 16, color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
          ),
          const Divider(height: 20),
          ...features.map((feat) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 15, color: accentColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feat,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
