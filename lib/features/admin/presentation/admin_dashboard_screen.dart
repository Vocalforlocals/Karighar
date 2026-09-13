import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'MoSJE National Admin',
        currentRole: 'admin',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MoSJE Scheme Header
            VKCard(
              color: const Color(0xFFFAF5FF),
              borderColor: const Color(0xFFDDD6FE),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.purple.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.shield_outlined, color: AppColors.purple, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ministry of Social Justice & Empowerment',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.purple),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'PM-Vishwakarma Marginalized Artisan Telemetry & DBT Monitoring',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard('Beneficiaries', '14,280+', '+18% this month', AppColors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard('Income Uplift', '+38.4%', 'Avg. verified gain', AppColors.saffron),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard('GI Clusters', '42 Clusters', 'Across 18 States', AppColors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard('Direct DBT', '₹4.82 Cr', 'Zero leakage audited', AppColors.success),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phase 4 GIS Satellite Cluster Map Navigation Card
            InkWell(
              onTap: () => context.go('/admin/gis-map'),
              child: VKCard(
                color: const Color(0xFF0F172A),
                borderColor: const Color(0xFF1E293B),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.public_rounded, color: AppColors.teal, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MoSJE National GIS Cluster Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                          SizedBox(height: 2),
                          Text('Satellite telemetry across 42 state clusters with real-time DBT flow audits.', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cluster Distribution
            Text(
              'Active Artisan Geographic Hubs',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildClusterRow('Varanasi Silk Weaving Cluster', 'Uttar Pradesh', '3,450 Artisans', '₹1.82 Cr GMV', AppColors.teal),
            _buildClusterRow('Jaipur Blue Pottery Cluster', 'Rajasthan', '1,890 Artisans', '₹76.4 Lakh GMV', AppColors.saffron),
            _buildClusterRow('Mithila Madhubani Folk Art Guild', 'Bihar', '2,140 Artisans', '₹94.2 Lakh GMV', AppColors.purple),
            _buildClusterRow('Chanderi Handloom Weavers', 'Madhya Pradesh', '1,560 Artisans', '₹68.1 Lakh GMV', AppColors.success),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color) {
    return VKCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _buildClusterRow(String clusterName, String state, String artisans, String gmv, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: VKCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clusterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(state, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                VKBadge(label: artisans, type: VKBadgeType.info),
                const SizedBox(height: 4),
                Text(gmv, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
