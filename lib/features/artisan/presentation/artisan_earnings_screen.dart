import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class ArtisanEarningsScreen extends StatelessWidget {
  const ArtisanEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank DBT status badge card
            VKCard(
              color: AppColors.tealLight.withValues(alpha: 0.4),
              borderColor: AppColors.teal.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Aadhaar-Linked Bank DBT Status',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.tealDark),
                      ),
                      const VKBadge(label: 'ACTIVE & VERIFIED', type: VKBadgeType.verified),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹48,500.00',
                    style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.teal),
                  ),
                  const SizedBox(height: 4),
                  const Text('Total Net Transferred directly to State Bank of India •••• 9012', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Subsidy and margin summary
            Row(
              children: [
                Expanded(
                  child: VKCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MoSJE Subsidy', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        Text('₹6,800', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.saffron)),
                        const SizedBox(height: 2),
                        const Text('Raw Material Aid', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VKCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pending Settlement', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        Text('₹8,499', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        const Text('Releases on Delivery', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Direct Transfer History',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildPayoutRow('Direct DBT Settlement #TXN-9021', 'Banarasi Silk Saree Order', '₹8,499.00', 'Success', '10 Sep 2026'),
            _buildPayoutRow('Bulk Advance Payout #TXN-8840', 'Jaipur Blue Pottery 50 units', '₹35,100.00', 'Success', '04 Sep 2026'),
            _buildPayoutRow('MoSJE Tooling Grant #GOV-4102', 'Loom Modernization Incentive', '₹4,901.00', 'Success', '28 Aug 2026'),
            const SizedBox(height: 20),

            VKButton(
              label: 'Download GST & DBT Tax Statement',
              icon: Icons.download_rounded,
              variant: VKButtonVariant.outline,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutRow(String title, String subtitle, String amount, String status, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: VKCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text('$subtitle • $date', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.teal)),
                const SizedBox(height: 2),
                Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
