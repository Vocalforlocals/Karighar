import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/product.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class BuyerExploreScreen extends StatefulWidget {
  const BuyerExploreScreen({super.key});

  @override
  State<BuyerExploreScreen> createState() => _BuyerExploreScreenState();
}

class _BuyerExploreScreenState extends State<BuyerExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRegion = 'All Regions';

  final List<String> _regions = const [
    'All Regions',
    'Varanasi / UP',
    'Mithila / Bihar',
    'Jaipur / Rajasthan',
    'Kashmir Valley',
    'Channapatna / Karnataka',
  ];

  String _formatInr(num amount) {
    final str = amount.round().toString();
    if (str.length <= 3) return '₹$str';
    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formattedRest = rest.replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(?!\d))'), (Match m) => '${m[1]},');
    return '₹$formattedRest,$lastThree';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BuyerBloc, BuyerState>(
        builder: (context, state) {
          final products = state.filteredProducts;
          final cols = screenWidth < 600 ? 2 : (screenWidth < 960 ? 3 : (screenWidth < 1280 ? 4 : 5));

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Input with Google Gemini Multimodal Craft Lens & AI trigger
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<BuyerBloc>().add(SearchQueryChangedEvent(val));
                      },
                      decoration: InputDecoration(
                        hintText: 'Search GI crafts, artisan clusters, materials...'.tr,
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.terracotta, size: 22),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 📸 Google Gemini Multimodal Craft Lens Button
                            IconButton(
                              icon: const Icon(Icons.camera_alt_rounded, color: AppColors.terracotta, size: 20),
                              tooltip: 'Google Gemini Multimodal Craft Lens',
                              onPressed: () => _showGeminiCraftLensModal(context),
                            ),
                            // ✨ Google Gemini Conversational Search Prompt
                            IconButton(
                              icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.zariGold, size: 20),
                              tooltip: 'Ask Gemini AI',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('✨ Gemini AI Smart Search activated. Try: "Wedding silk under 12000"'),
                                    backgroundColor: AppColors.royalIndigo,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.terracotta, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Regional GI Filters + GIS Cluster Map Trigger
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Interactive GIS Radar Action Button
                          ActionChip(
                            avatar: const Icon(Icons.map_rounded, color: AppColors.emeraldDeep, size: 16),
                            label: const Text(
                              'National GIS Cluster Radar',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep),
                            ),
                            backgroundColor: AppColors.emeraldDeep.withValues(alpha: 0.1),
                            side: BorderSide(color: AppColors.emeraldDeep.withValues(alpha: 0.3)),
                            onPressed: () => _showGisClusterMapModal(context),
                          ),
                          const SizedBox(width: 8),

                          // Region Choice Chips
                          ..._regions.map((region) {
                            final isSelected = _selectedRegion == region;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(region.tr),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedRegion = region;
                                  });
                                  if (region == 'All Regions') {
                                    context.read<BuyerBloc>().add(const SearchQueryChangedEvent(''));
                                  } else {
                                    final filterWord = region.split(' ').first;
                                    context.read<BuyerBloc>().add(SearchQueryChangedEvent(filterWord));
                                  }
                                },
                                selectedColor: AppColors.royalIndigo,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 11.5,
                                ),
                                backgroundColor: AppColors.surface,
                                side: BorderSide(color: isSelected ? AppColors.royalIndigo : AppColors.cardBorder),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Google Gemini Multimodal Craft Lens Promo Card
                    InkWell(
                      onTap: () => _showGeminiCraftLensModal(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.document_scanner_rounded, color: Color(0xFFFBBF24), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Google Gemini Multimodal Craft Lens',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBBF24),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('LIVE AI', style: TextStyle(color: Colors.black, fontSize: 8.5, fontWeight: FontWeight.w900)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Upload or point your camera at any craft to identify its authentic GI cluster, weaver history, and fair wage.',
                                    style: TextStyle(fontSize: 11, color: Color(0xFFE0E7FF), height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                // Product Count Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'Discovered Crafts'.tr} (${products.length})',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(
                      '100% Certified GI',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.emeraldDeep),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Grid of items
                if (products.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No crafts found matching this search.',
                            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _selectedRegion = 'All Regions');
                              context.read<BuyerBloc>().add(const SearchQueryChangedEvent(''));
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Reset All Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.royalIndigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: isDesktop ? 0.62 : 0.53,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildExploreProductCard(context, product);
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);
  }

  Widget _buildExploreProductCard(BuildContext context, Product product) {
    return VKCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go('/buyer/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Craft Image + Badges
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    product.images.isNotEmpty ? product.images.first : '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.terracottaLight,
                      child: const Center(
                        child: Icon(Icons.palette_rounded, color: AppColors.terracotta, size: 36),
                      ),
                    ),
                  ),
                ),
                // GI Tag Badge
                if (product.isGICertified)
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: VKBadge(label: 'GI Tag', type: VKBadgeType.verified, icon: Icons.verified),
                  ),
                // Discount Pill
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.terracotta,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4),
                      ],
                    ),
                    child: const Text(
                      '15% OFF',
                      style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                // Cluster Location Tag overlay
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 10, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 3),
                        Text(
                          product.clusterLocation.split(',').first,
                          style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Craft Info Body
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.25),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'By ${product.artisanName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      // Rating & certified tag
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.emeraldDeep,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, size: 10, color: Colors.white),
                                SizedBox(width: 2),
                                Text('4.8', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text('(142)', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          const Spacer(),
                          Text('Free Delivery', style: TextStyle(fontSize: 9.5, color: AppColors.emeraldDeep, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),

                  // Price Row & Quick Cart Action
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fair Wage Guarantee micro-tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.zariGold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${_formatInr(product.price * 0.42)} (42%) Direct Artisan Wage',
                          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatInr(product.price),
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                  color: AppColors.terracotta,
                                ),
                              ),
                              Text(
                                _formatInr(product.price * 1.2),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 9.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              context.read<BuyerBloc>().add(AddToCartEvent(product));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text('${product.title} added to bag!')),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppColors.emeraldDeep,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.terracottaLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.terracotta.withValues(alpha: 0.4), width: 0.8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.terracotta),
                                  SizedBox(width: 4),
                                  Text('Add', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.terracotta)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Google Gemini Multimodal Craft Lens Modal
  // ---------------------------------------------------------------------------
  void _showGeminiCraftLensModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        bool isAnalyzing = false;
        Map<String, dynamic>? detectedCraft;

        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Modal Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Google Gemini Multimodal Craft Lens',
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                              const Text(
                                'Vision AI • Authentic GI Registry • Artisan Lineage',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Body Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Interactive Camera Simulation Viewport
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFF334155), width: 1.5),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isAnalyzing)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 42,
                                        height: 42,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBBF24)),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Gemini 1.5 Flash Multimodal Vision Processing...',
                                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Extracting warp-weft density, natural dye signatures & GI mark',
                                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5),
                                      ),
                                    ],
                                  )
                                else if (detectedCraft != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      detectedCraft!['image'] as String,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                else
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 36),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Point Camera or Upload Craft Artifact',
                                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Supports Silk, Madhubani, Terracotta, Blue Pottery & Lacquer',
                                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                                      ),
                                    ],
                                  ),

                                // Corner scan guides
                                Positioned(
                                  top: 14,
                                  left: 14,
                                  child: Container(width: 22, height: 22, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFFBBF24), width: 3), left: BorderSide(color: Color(0xFFFBBF24), width: 3)))),
                                ),
                                Positioned(
                                  top: 14,
                                  right: 14,
                                  child: Container(width: 22, height: 22, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFFBBF24), width: 3), right: BorderSide(color: Color(0xFFFBBF24), width: 3)))),
                                ),
                                Positioned(
                                  bottom: 14,
                                  left: 14,
                                  child: Container(width: 22, height: 22, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFFBBF24), width: 3), left: BorderSide(color: Color(0xFFFBBF24), width: 3)))),
                                ),
                                Positioned(
                                  bottom: 14,
                                  right: 14,
                                  child: Container(width: 22, height: 22, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFFBBF24), width: 3), right: BorderSide(color: Color(0xFFFBBF24), width: 3)))),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Sample Triggers
                          Text(
                            'Or Test with Sample GI Crafts:',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildPresetChip(
                                label: '👘 Varanasi Silk Brocade',
                                onTap: () {
                                  setModalState(() {
                                    isAnalyzing = true;
                                    detectedCraft = null;
                                  });
                                  Future.delayed(const Duration(milliseconds: 900), () {
                                    setModalState(() {
                                      isAnalyzing = false;
                                      detectedCraft = {
                                        'craft': 'Varanasi Pure Silk Brocade',
                                        'image': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=600',
                                        'giTag': 'GI-AP-0028 (Certified 2009)',
                                        'cluster': 'Varanasi Weavers Cooperative, UP',
                                        'score': '99.4% Authentic Handloom',
                                        'materials': '100% Mulberry Silk, Zari Threads',
                                        'fairWage': '₹4,200 (42%) Guaranteed to Weaver',
                                        'searchKeyword': 'Varanasi',
                                      };
                                    });
                                  });
                                },
                              ),
                              _buildPresetChip(
                                label: '🎨 Madhubani Painting',
                                onTap: () {
                                  setModalState(() {
                                    isAnalyzing = true;
                                    detectedCraft = null;
                                  });
                                  Future.delayed(const Duration(milliseconds: 900), () {
                                    setModalState(() {
                                      isAnalyzing = false;
                                      detectedCraft = {
                                        'craft': 'Mithila / Madhubani Folk Art',
                                        'image': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600',
                                        'giTag': 'GI-BH-0002 (Certified 2007)',
                                        'cluster': 'Jitwarpur & Ranti Clusters, Madhubani, Bihar',
                                        'score': '98.8% Natural Mineral Pigment Match',
                                        'materials': 'Handmade Paper, Bamboo Twig, Cow Dung Wash',
                                        'fairWage': '₹1,850 (44%) Direct to Artisan',
                                        'searchKeyword': 'Madhubani',
                                      };
                                    });
                                  });
                                },
                              ),
                              _buildPresetChip(
                                label: '🪵 Channapatna Lacquer Toy',
                                onTap: () {
                                  setModalState(() {
                                    isAnalyzing = true;
                                    detectedCraft = null;
                                  });
                                  Future.delayed(const Duration(milliseconds: 900), () {
                                    setModalState(() {
                                      isAnalyzing = false;
                                      detectedCraft = {
                                        'craft': 'Channapatna Wooden Lacquer Toy',
                                        'image': 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600',
                                        'giTag': 'GI-KT-0012 (Certified 2006)',
                                        'cluster': 'Gombe Nagara, Channapatna, Karnataka',
                                        'score': '99.1% Natural Vegetable Dye Verified',
                                        'materials': 'Wrightia Tinctoria (Ivory Wood), Lac Resin',
                                        'fairWage': '₹620 (45%) Direct to Woodturner',
                                        'searchKeyword': 'Channapatna',
                                      };
                                    });
                                  });
                                },
                              ),
                            ],
                          ),

                          // Analysis Result View
                          if (detectedCraft != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.emeraldDeep.withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.verified_rounded, color: AppColors.emeraldDeep, size: 22),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          detectedCraft!['craft'] as String,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.emeraldDeep.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          detectedCraft!['score'] as String,
                                          style: const TextStyle(color: AppColors.emeraldDeep, fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  _buildLensDetailRow(Icons.account_balance_rounded, 'GI Registry ID', detectedCraft!['giTag'] as String),
                                  const SizedBox(height: 6),
                                  _buildLensDetailRow(Icons.place_rounded, 'Certified Cluster', detectedCraft!['cluster'] as String),
                                  const SizedBox(height: 6),
                                  _buildLensDetailRow(Icons.eco_rounded, 'Raw Materials', detectedCraft!['materials'] as String),
                                  const SizedBox(height: 6),
                                  _buildLensDetailRow(Icons.monetization_on_rounded, 'Fair Wage Escrow', detectedCraft!['fairWage'] as String),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        final keyword = detectedCraft!['searchKeyword'] as String;
                                        Navigator.pop(sheetContext);
                                        _searchController.text = keyword;
                                        context.read<BuyerBloc>().add(SearchQueryChangedEvent(keyword));
                                      },
                                      icon: const Icon(Icons.search_rounded, size: 18),
                                      label: Text('Explore Verified ${detectedCraft!['craft']} Crafts'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.royalIndigo,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildLensDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.terracotta),
        const SizedBox(width: 8),
        Text('$title: ', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // National GIS Craft Cluster Radar Modal (Google Maps Platform)
  // ---------------------------------------------------------------------------
  void _showGisClusterMapModal(BuildContext context) {
    final List<Map<String, dynamic>> clusters = [
      {
        'name': 'Varanasi Brocade & Silk Cluster',
        'state': 'Uttar Pradesh',
        'lat': '25.3176° N',
        'lng': '82.9739° E',
        'artisans': 1240,
        'gi': 'GI-AP-0028',
        'search': 'Varanasi',
        'specialty': 'Zari brocade, Katan silk, Pit loom weaving',
      },
      {
        'name': 'Mithila / Madhubani Folk Art Hub',
        'state': 'Bihar',
        'lat': '26.3534° N',
        'lng': '86.0717° E',
        'artisans': 860,
        'gi': 'GI-BH-0002',
        'search': 'Madhubani',
        'specialty': 'Kohbar, Kachni & Bharni natural pigment paintings',
      },
      {
        'name': 'Jaipur Blue Pottery & Block Prints',
        'state': 'Rajasthan',
        'lat': '26.9124° N',
        'lng': '75.7873° E',
        'artisans': 2100,
        'gi': 'GI-RJ-0034',
        'search': 'Jaipur',
        'specialty': 'Quartz clay pottery, Dabu mud-resist printing',
      },
      {
        'name': 'Kashmir Valley Pashmina & Walnut Wood',
        'state': 'Jammu & Kashmir',
        'lat': '34.0837° N',
        'lng': '74.7973° E',
        'artisans': 950,
        'gi': 'GI-JK-0046',
        'search': 'Kashmir',
        'specialty': 'Changthangi goat pashmina, Chinar carving',
      },
      {
        'name': 'Channapatna Lacquer Toy Town',
        'state': 'Karnataka',
        'lat': '12.6518° N',
        'lng': '77.2089° E',
        'artisans': 620,
        'gi': 'GI-KT-0012',
        'search': 'Channapatna',
        'specialty': 'Turned wood lacquercraft, natural dyes',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldDeep.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.radar_rounded, color: AppColors.emeraldDeep, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'National GIS Craft Cluster Radar',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          const Text(
                            'Google Maps GIS Platform • Real-time Artisan Geolocation',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(sheetContext)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: clusters.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cluster = clusters[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.royalIndigo.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  cluster['gi'] as String,
                                  style: const TextStyle(color: AppColors.royalIndigo, fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.emeraldDeep.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.people_alt_rounded, size: 12, color: AppColors.emeraldDeep),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${cluster['artisans']} Artisans Active',
                                      style: const TextStyle(color: AppColors.emeraldDeep, fontWeight: FontWeight.bold, fontSize: 10.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cluster['name'] as String,
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${cluster['state']} • GPS: ${cluster['lat']}, ${cluster['lng']}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cluster['specialty'] as String,
                            style: const TextStyle(fontSize: 11, color: AppColors.terracotta, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                final keyword = cluster['search'] as String;
                                _searchController.text = keyword;
                                context.read<BuyerBloc>().add(SearchQueryChangedEvent(keyword));
                              },
                              icon: const Icon(Icons.filter_alt_rounded, size: 16),
                              label: Text('Filter Crafts from ${cluster['state']}'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.royalIndigo,
                                side: const BorderSide(color: AppColors.royalIndigo),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
