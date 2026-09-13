import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/rfp_tender.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class RfpTenderBoardScreen extends StatefulWidget {
  const RfpTenderBoardScreen({super.key});

  @override
  State<RfpTenderBoardScreen> createState() => _RfpTenderBoardScreenState();
}

class _RfpTenderBoardScreenState extends State<RfpTenderBoardScreen> {
  final List<RfpTender> _tenders = [
    RfpTender(
      id: 'TND-2026-081',
      buyerOrg: 'The Taj Mahal Palace & Resorts',
      buyerContact: 'Vikram Sethi (Procurement VP)',
      craftCategory: 'Textiles & Weaves',
      title: '500 Pure Mulberry Silk Stoles with Zari Border',
      description: 'Requirement for upcoming BRICS Summit hospitality delegates. Must include certified GI tag and bespoke handloom wooden keepsake box.',
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
      buyerContact: 'Anita Roy (Head of Sourcing)',
      craftCategory: 'Ceramics & Pottery',
      title: '1,200 Cobalt Blue Floral Serving Bowls',
      description: 'Lead-free, low-temperature glazed authentic Jaipur Blue Pottery for nationwide Diwali seasonal catalog.',
      totalQuantityRequested: 1200,
      maxBudgetPerUnit: 1450.0,
      targetCluster: 'Kot Jewar Blue Pottery Guild (Rajasthan)',
      deadline: DateTime.now().add(const Duration(days: 30)),
      status: 'in_loom',
      allocatedArtisansCount: 35,
      guaranteedFairWage: 1050.0,
    ),
    RfpTender(
      id: 'TND-2026-068',
      buyerOrg: 'Ministry of External Affairs (Govt of India)',
      buyerContact: 'Joint Secretary (Protocol)',
      craftCategory: 'Folk Art & Paintings',
      title: '150 Mithila Kalpavriksha Canvas Diplomatic Gifts',
      description: 'Tree of life natural mineral pigment folk painting on handmade rag paper with brass seal.',
      totalQuantityRequested: 150,
      maxBudgetPerUnit: 5200.0,
      targetCluster: 'Jitwarpur Madhubani Artists Guild (Bihar)',
      deadline: DateTime.now().add(const Duration(days: 20)),
      status: 'open',
      allocatedArtisansCount: 12,
      guaranteedFairWage: 4100.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Institutional B2B Tenders',
        showBackButton: true,
        currentRole: 'buyer',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Explanation Card
            VKCard(
              color: AppColors.tealLight.withValues(alpha: 0.4),
              borderColor: AppColors.teal.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                    child: const Icon(Icons.corporate_fare_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Institutional Work Allocation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.tealDark)),
                        SizedBox(height: 2),
                        Text(
                          'Large corporate tenders are split collaboratively across small artisan SHGs in the cluster, preventing exploitation and ensuring MoSJE guaranteed fair wages.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Procurement Tenders (${_tenders.length})',
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                VKButton(
                  label: '+ Post New RFP',
                  height: 36,
                  variant: VKButtonVariant.secondary,
                  onPressed: () => _showPostRfpModal(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._tenders.map((tender) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: VKCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tender.buyerOrg, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                                  Text('Contact: ${tender.buyerContact}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            VKBadge(
                              label: tender.status.toUpperCase(),
                              type: tender.status == 'in_loom'
                                  ? VKBadgeType.ai
                                  : tender.status == 'allocating'
                                      ? VKBadgeType.verified
                                      : VKBadgeType.info,
                            ),
                          ],
                        ),
                        const Divider(height: 18),
                        Text(tender.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(tender.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
                        const SizedBox(height: 12),

                        // Stats bar
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Requested Qty', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                  Text('${tender.totalQuantityRequested} Units', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Budget / Unit', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                  Text('₹${tender.maxBudgetPerUnit.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.teal)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Artisan Fair Wage', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                  Text('₹${tender.guaranteedFairWage.toStringAsFixed(0)} (Min)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.saffronDark)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pooled Artisans', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                  Text('${tender.allocatedArtisansCount} Weavers', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.purple)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showPostRfpModal(BuildContext context) {
    final titleController = TextEditingController(text: '300 Hand-Painted Terracotta Planters');
    final qtyController = TextEditingController(text: '300');
    final budgetController = TextEditingController(text: '850');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Publish Institutional Bulk Tender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Tenders will be distributed to verified artisan cluster SHGs under MoSJE supervision.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Tender Title & Scope', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: budgetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max Budget (₹/unit)', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 16),
            VKButton(
              label: 'Broadcast to Craft Clusters',
              icon: Icons.send_rounded,
              variant: VKButtonVariant.primary,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tender published to Varanasi, Jaipur & Madhubani cluster guilds!'), backgroundColor: AppColors.teal),
                );
              },
            ),
          ],
        ),
      ),
    ).then((_) {
      titleController.dispose();
      qtyController.dispose();
      budgetController.dispose();
    });
  }
}
