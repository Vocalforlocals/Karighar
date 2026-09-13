import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/credit_scoring_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class KarigharCreditScreen extends StatefulWidget {
  const KarigharCreditScreen({super.key});

  @override
  State<KarigharCreditScreen> createState() => _KarigharCreditScreenState();
}

class _KarigharCreditScreenState extends State<KarigharCreditScreen> {
  bool _isLoanDisbursed = false;
  final profile = CreditScoringService.getProfileForArtisan('art_ramdev_01');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Karighar Credit Financial Hub',
        showBackButton: true,
        currentRole: 'artisan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit Score Hero Box
            VKCard(
              color: const Color(0xFF0F172A),
              borderColor: const Color(0xFF1E293B),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ALTERNATIVE ARTISAN TRUST SCORE',
                        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                      ),
                      VKBadge(label: profile.ratingTier, type: VKBadgeType.verified),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${profile.creditScore}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.teal),
                  ),
                  const Text('Out of 900 (Excellent Creditworthiness)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (profile.creditScore - 300) / 600,
                      minHeight: 8,
                      backgroundColor: const Color(0xFF1E293B),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Alternative Pillars Breakdown
            Text(
              'Credit Trust Pillars (Collateral-Free)',
              style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildPillarCard('On-Time Loom Fulfillment Rate', '${profile.onTimeDeliveryRate}%', 'Based on 42 successfully delivered batch orders', Icons.timer_outlined, AppColors.teal),
            _buildPillarCard('Microscopic Weave Quality Index', '${profile.averageWeaveQuality}%', 'Verified via Computer Vision 120 EPI analysis', Icons.biotech_outlined, AppColors.saffron),
            _buildPillarCard('Verified Bank DBT Turnover', '₹${(profile.verifiedDbtTurnover / 1000).toStringAsFixed(0)}K', 'Audited direct benefit transfer flow to SBI account', Icons.account_balance_outlined, AppColors.purple),

            const SizedBox(height: 16),

            // Pre-Approved PM-Vishwakarma Loan Card
            VKCard(
              color: _isLoanDisbursed ? AppColors.tealLight.withValues(alpha: 0.4) : Colors.white,
              borderColor: _isLoanDisbursed ? AppColors.teal : AppColors.cardBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppColors.saffronLight, shape: BoxShape.circle),
                            child: const Icon(Icons.handshake_rounded, color: AppColors.saffronDark, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PM-Vishwakarma Working Capital', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('MoSJE Collateral-Free Artisan Credit', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      VKBadge(label: _isLoanDisbursed ? 'DISBURSED' : 'PRE-APPROVED', type: _isLoanDisbursed ? VKBadgeType.success : VKBadgeType.ai),
                    ],
                  ),
                  const Divider(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Loan Amount Available:', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text('₹${profile.preApprovedLoanAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.tealDark)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Subsidized Interest:', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text('${profile.interestRatePerAnnum}% p.a.', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.saffronDark)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Tenure: ${profile.tenureMonths} Months • EMI: ₹5,778/month auto-deducted from buyer escrows.', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),

                  if (!_isLoanDisbursed)
                    VKButton(
                      label: 'Claim ₹1,00,000 to Aadhaar Bank Account',
                      icon: Icons.flash_on_rounded,
                      variant: VKButtonVariant.primary,
                      onPressed: () {
                        setState(() => _isLoanDisbursed = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('₹1,00,000 credited to Ramdev Varma SBI Account via PFMS!'),
                            backgroundColor: AppColors.teal,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppColors.tealDark, size: 18),
                          SizedBox(width: 8),
                          Expanded(child: Text('Disbursement reference #PFMS-LOAN-2026-8910 verified.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarCard(String title, String score, String subtitle, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: VKCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text(score, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef ShilpCreditScreen = KarigharCreditScreen;
