import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';

class GisClusterInfo {
  final String id;
  final String clusterName;
  final String craftType;
  final String state;
  final String coordinates;
  final int activeLooms;
  final int registeredArtisans;
  final double monthlyGmv;
  final double dbtClearanceRate;
  final bool giCertified;

  const GisClusterInfo({
    required this.id,
    required this.clusterName,
    required this.craftType,
    required this.state,
    required this.coordinates,
    required this.activeLooms,
    required this.registeredArtisans,
    required this.monthlyGmv,
    required this.dbtClearanceRate,
    required this.giCertified,
  });
}

class GisClusterMapScreen extends StatefulWidget {
  const GisClusterMapScreen({super.key});

  @override
  State<GisClusterMapScreen> createState() => _GisClusterMapScreenState();
}

class _GisClusterMapScreenState extends State<GisClusterMapScreen> {
  String _selectedState = 'All India';

  final List<GisClusterInfo> _clusters = const [
    GisClusterInfo(
      id: 'cluster_up_01',
      clusterName: 'Varanasi Mulberry Silk Weaving Guild',
      craftType: 'Banarasi Brocade Silk',
      state: 'Uttar Pradesh',
      coordinates: '25.3176° N, 82.9739° E',
      activeLooms: 1420,
      registeredArtisans: 3450,
      monthlyGmv: 18200000,
      dbtClearanceRate: 100.0,
      giCertified: true,
    ),
    GisClusterInfo(
      id: 'cluster_rj_02',
      clusterName: 'Kot Jewar Blue Pottery Guild',
      craftType: 'Jaipur Blue Pottery',
      state: 'Rajasthan',
      coordinates: '26.9124° N, 75.7873° E',
      activeLooms: 680,
      registeredArtisans: 1890,
      monthlyGmv: 7640000,
      dbtClearanceRate: 99.8,
      giCertified: true,
    ),
    GisClusterInfo(
      id: 'cluster_br_03',
      clusterName: 'Jitwarpur Folk Artists Collective',
      craftType: 'Mithila / Madhubani Art',
      state: 'Bihar',
      coordinates: '26.3541° N, 86.0718° E',
      activeLooms: 890,
      registeredArtisans: 2140,
      monthlyGmv: 9420000,
      dbtClearanceRate: 100.0,
      giCertified: true,
    ),
    GisClusterInfo(
      id: 'cluster_mp_04',
      clusterName: 'Pranpur Handloom Weavers Guild',
      craftType: 'Chanderi Silk & Cotton',
      state: 'Madhya Pradesh',
      coordinates: '24.7118° N, 78.1326° E',
      activeLooms: 740,
      registeredArtisans: 1560,
      monthlyGmv: 6810000,
      dbtClearanceRate: 100.0,
      giCertified: true,
    ),
    GisClusterInfo(
      id: 'cluster_tg_05',
      clusterName: 'Pochampally Tie & Dye Guild',
      craftType: 'Pochampally Ikat',
      state: 'Telangana',
      coordinates: '17.3457° N, 78.8354° E',
      activeLooms: 910,
      registeredArtisans: 2280,
      monthlyGmv: 11200000,
      dbtClearanceRate: 100.0,
      giCertified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedState == 'All India'
        ? _clusters
        : _clusters.where((c) => c.state == _selectedState).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'MoSJE GIS Cluster Map',
        showBackButton: true,
        currentRole: 'admin',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zero Leakage Telemetry Card
            VKCard(
              color: const Color(0xFF0F172A),
              borderColor: const Color(0xFF1E293B),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.radar_rounded, color: AppColors.teal, size: 20),
                          SizedBox(width: 8),
                          Text('NATIONAL LOOM TELEMETRY RADAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.1)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                        child: const Text('LIVE FEED', style: TextStyle(color: AppColors.teal, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRadarMetric('Active Looms', '4,640', AppColors.saffron),
                      _buildRadarMetric('Verified Artisans', '11,320', Colors.white),
                      _buildRadarMetric('DBT Leakage', '0.00%', AppColors.teal),
                      _buildRadarMetric('Total Clusters', '42 Hubs', AppColors.purple),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // State Selector Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'All India',
                  'Uttar Pradesh',
                  'Rajasthan',
                  'Bihar',
                  'Madhya Pradesh',
                  'Telangana',
                ].map((st) {
                  final isSelected = _selectedState == st;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(st, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textPrimary)),
                      selected: isSelected,
                      selectedColor: AppColors.teal,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: isSelected ? AppColors.teal : AppColors.cardBorder),
                      onSelected: (val) {
                        setState(() {
                          _selectedState = st;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Visual GIS Map View Simulation
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Stack(
                children: [
                  // Grid Pattern
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: GridPaper(
                        color: Colors.tealAccent,
                        interval: 40,
                        divisions: 2,
                        subdivisions: 1,
                      ),
                    ),
                  ),

                  // Center Pin Map Overlay
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.public_rounded, color: AppColors.teal, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'Geo-Spatial Satellite Grid: $_selectedState',
                          style: GoogleFonts.cinzel(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${filtered.length} Clusters Monitoring Direct DBT Flow',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                  // Floating Cluster Coordinate Badges
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(6)),
                      child: const Text('20°N – 30°N / 75°E – 88°E', style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Monitored Craft Clusters (${filtered.length})',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            ...filtered.map((cluster) => Padding(
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
                                  Text(cluster.clusterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text('${cluster.craftType} • ${cluster.state}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            const VKBadge(label: 'GI REGISTERED', type: VKBadgeType.verified),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.teal),
                            const SizedBox(width: 4),
                            Text(cluster.coordinates, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontFamily: 'monospace')),
                          ],
                        ),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Active Looms', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                Text('${cluster.activeLooms}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Artisans Enrolled', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                Text('${cluster.registeredArtisans}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Monthly GMV', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                Text('₹${(cluster.monthlyGmv / 100000).toStringAsFixed(1)}L', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.teal)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('DBT Clearance', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                Text('${cluster.dbtClearanceRate}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.success)),
                              ],
                            ),
                          ],
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

  Widget _buildRadarMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}
