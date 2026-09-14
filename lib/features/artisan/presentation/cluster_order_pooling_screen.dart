import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/rfp_tender.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class ClusterOrderPoolingScreen extends StatefulWidget {
  const ClusterOrderPoolingScreen({super.key});

  @override
  State<ClusterOrderPoolingScreen> createState() => _ClusterOrderPoolingScreenState();
}

class _ClusterOrderPoolingScreenState extends State<ClusterOrderPoolingScreen> {
  final List<RfpTender> _clusterTenders = [
    RfpTender(
      id: 'TND-2026-081',
      buyerOrg: 'The Taj Mahal Palace & Resorts',
      buyerContact: 'Vikram Sethi (VP Procurement)',
      craftCategory: 'Textiles & Weaves',
      title: '500 Pure Mulberry Silk Stoles with Zari Border',
      description: 'Requirement for BRICS Summit delegates. High demand handloom brocade weave.',
      totalQuantityRequested: 500,
      maxBudgetPerUnit: 3800.0,
      targetCluster: 'Varanasi Brocade Guild (UP)',
      deadline: DateTime.now().add(const Duration(days: 45)),
      status: 'allocating',
      allocatedArtisansCount: 22,
      guaranteedFairWage: 2800.0,
    ),
    RfpTender(
      id: 'TND-2026-074',
      buyerOrg: 'FabIndia Heritage Boutiques',
      buyerContact: 'Anita Roy (Sourcing Head)',
      craftCategory: 'Ceramics & Pottery',
      title: '1,200 Cobalt Blue Floral Serving Bowls',
      description: 'Nationwide festive catalogue. Split across Kot Jewar blue pottery cluster.',
      totalQuantityRequested: 1200,
      maxBudgetPerUnit: 1450.0,
      targetCluster: 'Kot Jewar Blue Pottery Guild (Rajasthan)',
      deadline: DateTime.now().add(const Duration(days: 30)),
      status: 'allocating',
      allocatedArtisansCount: 35,
      guaranteedFairWage: 1050.0,
    ),
  ];

  final Map<String, int> _committedQuantities = {
    'TND-2026-081': 20,
    'TND-2026-074': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Navigation Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  tooltip: 'Back'.tr,
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/artisan');
                    }
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  'Cluster Order Pooling'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // MoSJE Cluster Cooperative Header
            VKCard(
              color: AppColors.saffronLight.withValues(alpha: 0.4),
              borderColor: AppColors.saffron.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColors.saffron, shape: BoxShape.circle),
                    child: const Icon(Icons.groups_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SHG Cluster Work Sharing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.saffronDark)),
                        SizedBox(height: 2),
                        Text(
                          'Large corporate bulk orders are distributed across multiple village looms. Select how many pieces your loom can craft to claim guaranteed MoSJE DBT fair wages.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Institutional Bulk Tenders Open for Pooling',
              style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ..._clusterTenders.map((tender) {
              final myCommitment = _committedQuantities[tender.id] ?? 0;
              final committedUnitsOverall = (tender.allocatedArtisansCount * 16) + myCommitment;
              final progressPct = (committedUnitsOverall / tender.totalQuantityRequested).clamp(0.0, 1.0);
              final projectedEarning = myCommitment * tender.guaranteedFairWage;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: VKCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tender.buyerOrg,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.tealDark),
                            ),
                          ),
                          const VKBadge(label: 'GOVT ESCROW PROTECTED', type: VKBadgeType.verified),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(tender.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(tender.targetCluster, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 12),

                      // Progress Bar of Cluster capacity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cluster Fulfillment: $committedUnitsOverall / ${tender.totalQuantityRequested} Units', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          Text('${(progressPct * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.teal)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPct,
                          minHeight: 6,
                          backgroundColor: AppColors.surface,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                        ),
                      ),
                      const Divider(height: 24),

                      // Capacity Slider for Artisan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Your Loom Capacity Commitment:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.saffronLight, borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              '$myCommitment Units',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.saffronDark),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: myCommitment.toDouble(),
                        min: 0,
                        max: 50,
                        divisions: 10,
                        activeColor: AppColors.saffron,
                        inactiveColor: AppColors.saffronLight,
                        onChanged: (val) {
                          setState(() {
                            _committedQuantities[tender.id] = val.round();
                          });
                        },
                      ),

                      // Wage Guarantee Calculation Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Guaranteed MoSJE Fair Wage', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                const SizedBox(height: 2),
                                Text('₹${tender.guaranteedFairWage.toStringAsFixed(0)} / unit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Your Estimated Bank DBT', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${projectedEarning.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.teal),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      VKButton(
                        label: myCommitment > 0 ? 'Confirm $myCommitment Units to Loom' : 'Select Capacity Above',
                        variant: myCommitment > 0 ? VKButtonVariant.primary : VKButtonVariant.outline,
                        height: 40,
                        onPressed: myCommitment > 0
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Successfully committed $myCommitment units! MoSJE escrow allocation reserved.'),
                                    backgroundColor: AppColors.teal,
                                  ),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
