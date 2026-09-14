import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final int _currentStage = 2; // 0-5

  final List<Map<String, dynamic>> _stages = [
    {'icon': Icons.check_circle_rounded, 'label': 'Order Confirmed', 'desc': 'DBT escrow payment received. Artisan notified.', 'time': 'Today, 3:42 PM'},
    {'icon': Icons.handshake_rounded, 'label': 'Artisan Crafting', 'desc': 'Master artisan has begun weaving your piece.', 'time': 'Today, 4:10 PM'},
    {'icon': Icons.verified_rounded, 'label': 'GI Quality Check', 'desc': 'Cluster GI officer inspecting authenticity.', 'time': 'Tomorrow, 11:00 AM'},
    {'icon': Icons.local_shipping_rounded, 'label': 'Dispatched', 'desc': 'Handed to courier. Tracking: BD2026GNPL', 'time': ''},
    {'icon': Icons.delivery_dining_rounded, 'label': 'Out for Delivery', 'desc': 'Your artisan piece is on its way!', 'time': ''},
    {'icon': Icons.home_rounded, 'label': 'Delivered', 'desc': 'Delivered successfully. Rate your artisan.', 'time': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order #${widget.orderId}', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                            const Text('Banarasi Katan Silk Saree | GI Tag Verified', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          _stages[_currentStage]['label'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 6-Stage Timeline
                Text('Delivery Timeline', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 14),
                ...List.generate(_stages.length, (i) {
                  final isDone = i <= _currentStage;
                  final isCurrent = i == _currentStage;
                  final stage = _stages[i];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? AppColors.emeraldDeep : AppColors.cardBorder,
                            border: isCurrent ? Border.all(color: AppColors.emeraldDeep, width: 3) : null,
                          ),
                          child: Icon(stage['icon'] as IconData, color: isDone ? Colors.white : AppColors.textLight, size: 18),
                        ),
                        if (i < _stages.length - 1)
                          Container(width: 2, height: 52, color: isDone && i < _currentStage ? AppColors.emeraldDeep : AppColors.cardBorder),
                      ]),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stage['label'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                  fontSize: isCurrent ? 14 : 13,
                                  color: isDone ? AppColors.textPrimary : AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(stage['desc'] as String, style: TextStyle(fontSize: 11.5, color: isDone ? AppColors.textSecondary : AppColors.textLight, height: 1.3)),
                              if ((stage['time'] as String).isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(stage['time'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.emeraldDeep, fontWeight: FontWeight.w600)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 8),

                // Digital Provenance Passport Quick-Viewer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.terracotta.withValues(alpha: 0.08), AppColors.zariGold.withValues(alpha: 0.04)]),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.terracotta.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.workspace_premium_rounded, color: AppColors.terracotta, size: 20),
                        const SizedBox(width: 8),
                        Text('Digital Provenance Passport', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.terracotta)),
                      ]),
                      const SizedBox(height: 10),
                      _passportRow(Icons.tag_rounded, 'GI Tag Number', 'GI/TN/2024/00089'),
                      _passportRow(Icons.person_rounded, 'Master Artisan', 'Ramesh Kumar Yadav'),
                      _passportRow(Icons.location_on_rounded, 'Craft Cluster', 'Varanasi Handloom, UP'),
                      _passportRow(Icons.category_rounded, 'Craft Form', 'Banarasi Katan Silk Weaving'),
                      _passportRow(Icons.schedule_rounded, 'Craft Hours', '~120 hours by hand'),
                      _passportRow(Icons.eco_rounded, 'Materials', 'Pure silk, Zari (gold-wrapped thread)'),
                      _passportRow(Icons.savings_rounded, 'Artisan Wage Share', '42% Direct DBT Transfer'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/buyer/passport/${widget.orderId}'),
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: const Text('View Full Craft Passport & Blockchain Ledger'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.terracotta,
                            side: const BorderSide(color: AppColors.terracotta),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Actions
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_rounded, size: 16),
                      label: const Text('Chat with Artisan'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.royalIndigo, side: const BorderSide(color: AppColors.royalIndigo), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/buyer'),
                      icon: const Icon(Icons.shopping_bag_rounded, size: 16),
                      label: const Text('Continue Shopping'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.terracotta, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passportRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: RichText(text: TextSpan(
            text: '$label: ',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'PlusJakartaSans'),
            children: [TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary))],
          ))),
        ],
      ),
    );
  }
}
