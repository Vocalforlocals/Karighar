import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'vk_badge.dart';
import 'vk_button.dart';
import 'vk_card.dart';

class TourStep {
  final String title;
  final String category;
  final String problemSolved;
  final String innovation;
  final String actionLabel;
  final String targetRoute;
  final IconData icon;
  final Color accentColor;

  const TourStep({
    required this.title,
    required this.category,
    required this.problemSolved,
    required this.innovation,
    required this.actionLabel,
    required this.targetRoute,
    required this.icon,
    required this.accentColor,
  });
}

class VKGuidedTourModal extends StatefulWidget {
  const VKGuidedTourModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const VKGuidedTourModal(),
    );
  }

  @override
  State<VKGuidedTourModal> createState() => _VKGuidedTourModalState();
}

class _VKGuidedTourModalState extends State<VKGuidedTourModal> {
  int _currentStepIndex = 0;

  final List<TourStep> _steps = const [
    TourStep(
      title: 'Rural Artisan Studio & Neural Weave Inspection',
      category: 'ARTISAN INCLUSIVITY & AI',
      problemSolved: 'Illiterate artisans cannot create e-commerce catalogs or prove handloom authenticity.',
      innovation: 'Tap-to-speak Bhashini dialect recorder, 4K studio lighting enhancement, and computer vision thread density analysis (120 EPI × 110 PPI, Grade A+ GI).',
      actionLabel: 'Explore Artisan Studio',
      targetRoute: '/artisan/add-product',
      icon: Icons.auto_awesome,
      accentColor: AppColors.saffron,
    ),
    TourStep(
      title: 'Institutional B2B Tenders & Cluster Pooling',
      category: 'ECONOMIC FAIR TRADE',
      problemSolved: 'Small village looms are excluded from large corporate tenders (Taj Hotels, FabIndia).',
      innovation: 'SHG Cluster Work Pooling splits 500+ unit contracts across multiple looms with MoSJE minimum wage floor guarantees.',
      actionLabel: 'View Cluster Pooling',
      targetRoute: '/artisan/cluster-pooling',
      icon: Icons.groups_rounded,
      accentColor: AppColors.teal,
    ),
    TourStep(
      title: 'Cryptographic GI Passport & AR 3D Viewer',
      category: 'BUYER TRUST & IMMERSION',
      problemSolved: 'Urban and overseas buyers cannot distinguish genuine GI handloom from cheap synthetic mill copies.',
      innovation: 'SHA-256 cryptographic provenance ledger with QR verification and true 1:1 scale AR living room placement with lighting simulation.',
      actionLabel: 'View GI Craft Passport',
      targetRoute: '/buyer/passport/prod_01',
      icon: Icons.qr_code_scanner_rounded,
      accentColor: AppColors.purple,
    ),
    TourStep(
      title: 'Varta-AI Negotiation & Smart Escrow Release',
      category: 'ECONOMIC DEFENSE & FINTECH',
      problemSolved: 'Artisans get lowballed in negotiations and face payment delays from urban middlemen.',
      innovation: 'Varta-AI autonomous wage-defense sentry and Polygon smart contract delivery escrow with instant direct DBT bank release via PFMS.',
      actionLabel: 'Test Varta-AI in Chat',
      targetRoute: '/buyer/chat',
      icon: Icons.gavel_rounded,
      accentColor: AppColors.saffronDark,
    ),
    TourStep(
      title: 'Sovereign Blockchain Ledger & Smart Contracts',
      category: 'IMMUTABLE TRUST & PROOF',
      problemSolved: 'Evaluators and institutional buyers need cryptographically tamper-proof transparency.',
      innovation: 'Decentralized Proof-of-Authority ledger verifying GI provenance, smart contract escrow locks, and direct PFMS bank disbursements with SHA-256 Merkle proofs.',
      actionLabel: 'Explore Blockchain Ledger',
      targetRoute: '/buyer/ledger',
      icon: Icons.link_rounded,
      accentColor: AppColors.tealDark,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final current = _steps[_currentStepIndex];

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: current.accentColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: Icon(current.icon, color: current.accentColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SIH 2026 EVALUATOR TOUR', style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.1, color: AppColors.textLight)),
                        Text('Step ${_currentStepIndex + 1} of ${_steps.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),

            // Stepper Progress Line
            Row(
              children: List.generate(_steps.length, (idx) {
                final isPassed = idx <= _currentStepIndex;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isPassed ? AppColors.teal : AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Category Badge & Title
            VKBadge(label: current.category, type: VKBadgeType.info),
            const SizedBox(height: 8),
            Text(
              current.title,
              style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 14),

            // Problem & Innovation Cards
            VKCard(
              color: const Color(0xFFFEF2F2),
              borderColor: const Color(0xFFFCA5A5),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Challenge Addressed:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error)),
                        const SizedBox(height: 2),
                        Text(current.problemSolved, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            VKCard(
              color: AppColors.tealLight.withValues(alpha: 0.35),
              borderColor: AppColors.teal.withValues(alpha: 0.4),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded, color: AppColors.tealDark, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Karighar AI Innovation:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                        const SizedBox(height: 2),
                        Text(current.innovation, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Direct Jump Button
            VKButton(
              label: '${current.actionLabel} ➔',
              icon: Icons.launch_rounded,
              variant: VKButtonVariant.primary,
              onPressed: () {
                Navigator.pop(context);
                context.go(current.targetRoute);
              },
            ),
            const SizedBox(height: 14),

            // Navigation Stepper Buttons
            Row(
              children: [
                if (_currentStepIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text('Previous'),
                      onPressed: () => setState(() => _currentStepIndex--),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 12),
                Expanded(
                  child: _currentStepIndex < _steps.length - 1
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('Next Pillar'),
                          onPressed: () => setState(() => _currentStepIndex++),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.saffron,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Finish Tour'),
                        ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
