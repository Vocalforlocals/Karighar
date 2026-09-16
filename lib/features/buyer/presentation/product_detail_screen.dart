import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/quote.dart';
import '../../../core/services/chat_negotiation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../../../core/widgets/vk_image_studio_slider.dart';
import '../bloc/buyer_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  final TextEditingController _pincodeController = TextEditingController(text: '110001');
  bool _pincodeChecked = true;
  String _pincodeCity = 'Connaught Place, New Delhi';
  String _pincodeSla = 'Free Express Delivery by Friday, 2 PM';

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  String _formatInr(num amount) {
    final str = amount.round().toString();
    if (str.length <= 3) return '₹$str';
    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formattedRest = rest.replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(?!\d))'), (Match m) => '${m[1]},');
    return '₹$formattedRest,$lastThree';
  }

  void _open4KWeaveInspector({
    required BuildContext context,
    required List<String> images,
    required int initialIndex,
    required String productTitle,
    required String productId,
  }) {
    int activeIndex = initialIndex.clamp(0, images.length - 1);
    bool showThreadGrid = activeIndex == 1; // Default ON for Weave Texture
    final TransformationController transformController = TransformationController();

    final angleTitles = [
      'Angle 1/4: Full Craft View',
      'Angle 2/4: Microscopic Weave Texture (128 EPI)',
      'Angle 3/4: Border Motif & Zari Precision',
      'Angle 4/4: Traditional Loom & Artisan Provenance',
    ];

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return Dialog(
            backgroundColor: const Color(0xFF0F172A),
            insetPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Main Zoomable Area
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: InteractiveViewer(
                      transformationController: transformController,
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 6.0,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              images[activeIndex.clamp(0, images.length - 1)],
                              fit: BoxFit.contain,
                              loadingBuilder: (c, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
                              },
                              errorBuilder: (c, e, s) => const Center(
                                child: Icon(Icons.broken_image, color: Colors.white54, size: 64),
                              ),
                            ),
                            if (showThreadGrid)
                              const Positioned.fill(
                                child: CustomPaint(
                                  painter: VKWeaveThreadPainter(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top Header HUD
                  Positioned(
                    top: 12,
                    left: 14,
                    right: 60,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.saffron.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.biotech_rounded, size: 14, color: AppColors.saffron),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    angleTitles[activeIndex.clamp(0, angleTitles.length - 1)],
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),

                  // Bottom Controls HUD
                  Positioned(
                    bottom: 14,
                    left: 14,
                    right: 14,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Angle thumbnail selector bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (idx) {
                              final isSelected = idx == activeIndex;
                              final shortLabels = ['Full', 'Weave', 'Motif', 'Loom'];
                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    activeIndex = idx;
                                    showThreadGrid = idx == 1;
                                    transformController.value = Matrix4.identity();
                                  });
                                  setState(() => _selectedImageIndex = idx);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.saffron : Colors.white10,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    shortLabels[idx.clamp(0, shortLabels.length - 1)],
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.white70,
                                      fontSize: 10.5,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Action Chips Row
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // 128 EPI Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.teal),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded, size: 13, color: AppColors.teal),
                                  SizedBox(width: 5),
                                  Text(
                                    '128 EPI × 114 PPI Silk Gauge',
                                    style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ActionChip(
                                  avatar: Icon(
                                    showThreadGrid ? Icons.grid_on_rounded : Icons.grid_off_rounded,
                                    size: 14,
                                    color: showThreadGrid ? AppColors.saffron : Colors.white70,
                                  ),
                                  label: Text(
                                    showThreadGrid ? 'Thread Grid: ON' : 'Thread Grid: OFF',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: showThreadGrid ? AppColors.saffron : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.black87,
                                  side: BorderSide(
                                    color: showThreadGrid ? AppColors.saffron : Colors.white24,
                                  ),
                                  onPressed: () {
                                    setDialogState(() {
                                      showThreadGrid = !showThreadGrid;
                                    });
                                  },
                                ),
                                const SizedBox(width: 6),
                                ActionChip(
                                  avatar: const Icon(Icons.restart_alt_rounded, size: 14, color: Colors.white70),
                                  label: const Text(
                                    'Reset Zoom',
                                    style: TextStyle(fontSize: 10.5, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black87,
                                  side: const BorderSide(color: Colors.white24),
                                  onPressed: () {
                                    transformController.value = Matrix4.identity();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerBloc, BuyerState>(
      builder: (context, state) {
        final allProds = state.allProducts;
        if (allProds.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final product = allProds.firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => allProds.first,
        );

        final originalMrp = (product.price * 1.28).roundToDouble();
        final discountPercent = (((originalMrp - product.price) / originalMrp) * 100).round();

        // Right side content details
        Widget detailsContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (product.isGICertified) ...[
                  const VKBadge(label: 'GI Registered Craft', type: VKBadgeType.verified, icon: Icons.verified),
                  const SizedBox(width: 8),
                ],
                VKBadge(label: product.category, type: VKBadgeType.info),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.title,
              style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.emeraldDeep, borderRadius: BorderRadius.circular(4)),
                  child: const Row(
                    children: [
                      Text('4.9', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                      SizedBox(width: 3),
                      Icon(Icons.star_rounded, color: AppColors.zariGold, size: 14),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text('128 Ratings & 42 Authenticated Reviews', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),

            // Pricing Block
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.terracotta),
                ),
                const SizedBox(width: 10),
                Text(
                  '₹${originalMrp.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 15, color: AppColors.textLight, decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(width: 8),
                Text(
                  '$discountPercent% OFF',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Fair Value Price: 100% direct DBT bank rail release to artisan (${product.estimatedHours}h Handloom Crafting)',
              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Bank Offers Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Offers', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.local_offer_rounded, size: 14, color: AppColors.emeraldDeep),
                      SizedBox(width: 6),
                      Text('Bank Offer: 10% Instant Discount on SBI & ICICI Bank Cards', style: TextStyle(fontSize: 11.5)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.bolt_rounded, size: 14, color: AppColors.emeraldDeep),
                      SizedBox(width: 6),
                      Text('Free Express Delivery: Guaranteed by Thursday', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pincode SLA & COD Delivery Estimator (Google Maps GIS Platform)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 16, color: AppColors.terracotta),
                      const SizedBox(width: 6),
                      const Text('Delivery to: ', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          _pincodeChecked ? _pincodeCity : 'Enter Pincode',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: TextField(
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter 6-digit Pincode',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _pincodeChecked = true;
                              if (_pincodeController.text == '560001') {
                                _pincodeCity = 'Bengaluru, Karnataka';
                                _pincodeSla = 'Delivery by Saturday, 3 PM';
                              } else if (_pincodeController.text == '400001') {
                                _pincodeCity = 'Fort, Mumbai';
                                _pincodeSla = 'Delivery by Thursday, 11 AM';
                              } else {
                                _pincodeCity = 'Verified Delivery Zone (${_pincodeController.text})';
                                _pincodeSla = 'Free Express Delivery in 2-3 Days';
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.royalIndigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Check', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  if (_pincodeChecked) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_rounded, size: 14, color: AppColors.emeraldDeep),
                        const SizedBox(width: 6),
                        Text(_pincodeSla, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Row(
                      children: [
                        Icon(Icons.payments_rounded, size: 14, color: AppColors.terracotta),
                        SizedBox(width: 6),
                        Text('Cash on Delivery (COD) & UPI on Delivery Available', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Artisan Identity Card
            VKCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.terracottaLight,
                    child: Text(
                      product.artisanName[0],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.terracotta, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(product.artisanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: AppColors.emeraldDeep, size: 15),
                          ],
                        ),
                        Text(product.clusterLocation, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                        if (product.giTagNumber != null)
                          Text('GI Certificate: ${product.giTagNumber}',
                              style: const TextStyle(fontSize: 10.5, color: AppColors.emeraldDeep, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Fair Wage Transparency Card (Direct DBT to Master Artisan)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_rounded, color: AppColors.emeraldDeep, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '100% Fair Wage & Value Transparency'.tr,
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.emeraldDeep),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildWageRow('Artisan Direct Handloom Wage', product.price * 0.42, '42%'),
                  const SizedBox(height: 4),
                  _buildWageRow('Certified GI Raw Materials & Silk/Clay', product.price * 0.38, '38%'),
                  const SizedBox(height: 4),
                  _buildWageRow('GI Quality Audit & Authenticity Stamp', product.price * 0.05, '5%'),
                  const SizedBox(height: 4),
                  _buildWageRow('Sustainable Zero-Plastic Packaging', product.price * 0.05, '5%'),
                  const SizedBox(height: 4),
                  _buildWageRow('RBI Escrow Rails & Insured Transit', product.price * 0.10, '10%'),
                  const Divider(height: 14, color: Color(0xFFBBF7D0)),
                  Text(
                    '${_formatInr(product.price * 0.42)} direct DBT remittance releases automatically to ${product.artisanName}\'s Jan Dhan account upon order confirmation.',
                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF166534), height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text('Craft Heritage & Story'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Materials Used
            Text('Authentic Materials Used'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: product.materialsUsed
                  .map((m) => Chip(
                        label: Text(m, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.cardBorder),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

          ],
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sleek Mobile Back Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/buyer');
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.terracotta),
                        const SizedBox(width: 6),
                        Text(
                          'Back to Marketplace'.tr,
                          style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                // -------------------------------------------------
                // MULTI-ANGLE 4K CRAFT VIEWER & THUMBNAILS
                // -------------------------------------------------
                Builder(
                  builder: (context) {
                    final List<String> allImages = List<String>.from(product.images);
                    if (allImages.isEmpty) {
                      allImages.add(product.rawImage);
                    }
                    while (allImages.length < 4) {
                      if (allImages.length == 1) {
                        allImages.add('https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80');
                      } else if (allImages.length == 2) {
                        allImages.add('https://images.unsplash.com/photo-1607344645866-009c320c5ab8?w=800&auto=format&fit=crop&q=80');
                      } else if (allImages.length == 3) {
                        allImages.add('https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop&q=80');
                      }
                    }

                    final safeAngleIndex = _selectedImageIndex.clamp(0, allImages.length - 1);
                    final isMacroTexture = safeAngleIndex == 1;

                    final angleChips = [
                      {'title': 'Full Craft', 'subtitle': 'Master View', 'icon': Icons.panorama_wide_angle_rounded, 'badge': '4K'},
                      {'title': 'Weave Texture', 'subtitle': 'Microscopic', 'icon': Icons.biotech_rounded, 'badge': '128 EPI'},
                      {'title': 'Border Motif', 'subtitle': 'Zari Precision', 'icon': Icons.pattern_rounded, 'badge': '99% Sym'},
                      {'title': 'Artisan at Loom', 'subtitle': 'Provenance', 'icon': Icons.handyman_rounded, 'badge': 'Origin'},
                    ];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _open4KWeaveInspector(
                            context: context,
                            images: allImages,
                            initialIndex: _selectedImageIndex,
                            productTitle: product.title,
                            productId: product.id,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.network(
                                  allImages[safeAngleIndex],
                                  width: double.infinity,
                                  height: 330,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    height: 330,
                                    color: AppColors.terracottaLight,
                                    child: const Center(child: Icon(Icons.palette_rounded, color: AppColors.terracotta, size: 64)),
                                  ),
                                ),

                                // Microscopic thread grid overlay on texture angle
                                if (isMacroTexture)
                                  const Positioned.fill(
                                    child: CustomPaint(
                                      painter: VKWeaveThreadPainter(),
                                    ),
                                  ),

                                // Top Left: Current Angle Pill
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.72),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          angleChips[safeAngleIndex.clamp(0, angleChips.length - 1)]['icon'] as IconData,
                                          size: 13,
                                          color: AppColors.saffron,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Angle ${safeAngleIndex + 1}/4: ${angleChips[safeAngleIndex.clamp(0, angleChips.length - 1)]['title']}',
                                          style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Top Right: 4K Weave Inspector & AR View Pills
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _open4KWeaveInspector(
                                          context: context,
                                          images: allImages,
                                          initialIndex: _selectedImageIndex,
                                          productTitle: product.title,
                                          productId: product.id,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.78),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: AppColors.teal),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.biotech_rounded, color: AppColors.teal, size: 14),
                                              SizedBox(width: 4),
                                              Text('4K Weave', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => context.go('/buyer/ar/${product.id}'),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(colors: [AppColors.saffron, AppColors.terracotta]),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 6),
                                            ],
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 14),
                                              SizedBox(width: 4),
                                              Text('AR 3D', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bottom-Left Macro Thread Indicator
                                if (isMacroTexture)
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.teal),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.verified_rounded, size: 12, color: AppColors.teal),
                                          SizedBox(width: 4),
                                          Text(
                                            '128 EPI × 114 PPI Silk Weave Count',
                                            style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Bottom-Right Tap to Zoom Badge
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.zoom_in_rounded, color: Colors.white, size: 13),
                                        SizedBox(width: 4),
                                        Text('Tap for 4K Zoom', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Labeled 4-Angle Craft Gallery Bar
                        Row(
                          children: List.generate(allImages.length, (i) {
                            final selected = i == safeAngleIndex;
                            final info = angleChips[i.clamp(0, angleChips.length - 1)];

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedImageIndex = i),
                                child: Container(
                                  margin: EdgeInsets.only(right: i < allImages.length - 1 ? 6 : 0),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: selected ? AppColors.saffronLight.withValues(alpha: 0.35) : AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: selected ? AppColors.terracotta : AppColors.cardBorder,
                                      width: selected ? 2.0 : 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          allImages[i],
                                          height: 48,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        info['title'] as String,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                          color: selected ? AppColors.terracotta : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                detailsContent,
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: VKButton(
                        label: 'GI Passport'.tr,
                        icon: Icons.qr_code_scanner_rounded,
                        variant: VKButtonVariant.outline,
                        height: 38,
                        onPressed: () => context.go('/buyer/passport/${product.id}'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: VKButton(
                        label: 'View in AR 3D'.tr,
                        icon: Icons.view_in_ar_rounded,
                        variant: VKButtonVariant.secondary,
                        height: 38,
                        onPressed: () => context.go('/buyer/ar/${product.id}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                VKButton(
                  label: 'Global Export & Customs Clearance (DGFT)'.tr,
                  icon: Icons.public_rounded,
                  variant: VKButtonVariant.outline,
                  height: 38,
                  onPressed: () => context.go('/buyer/export-customs?title=${Uri.encodeComponent(product.title)}&price=${product.price}'),
                ),
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: VKButton(
                      label: 'B2B Bulk Quote'.tr,
                      icon: Icons.handshake_outlined,
                      variant: VKButtonVariant.outline,
                      onPressed: () => _showBulkQuoteModal(context, product.id, product.title, product.price),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VKButton(
                      label: 'Add to Cart'.tr,
                      icon: Icons.add_shopping_cart_rounded,
                      variant: VKButtonVariant.secondary,
                      onPressed: () {
                        context.read<BuyerBloc>().add(AddToCartEvent(product));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart!'),
                            backgroundColor: AppColors.teal,
                          ),
                        );
                        context.go('/buyer/cart');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBulkQuoteModal(BuildContext context, String prodId, String prodTitle, double unitPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _BulkQuoteModalSheet(
        prodId: prodId,
        prodTitle: prodTitle,
        unitPrice: unitPrice,
      ),
    );
  }

  Widget _buildWageRow(String label, double amount, String percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF166534), fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          '${_formatInr(amount)} ($percentage)',
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF166534), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _BulkQuoteModalSheet extends StatefulWidget {
  final String prodId;
  final String prodTitle;
  final double unitPrice;

  const _BulkQuoteModalSheet({
    required this.prodId,
    required this.prodTitle,
    required this.unitPrice,
  });

  @override
  State<_BulkQuoteModalSheet> createState() => _BulkQuoteModalSheetState();
}

class _BulkQuoteModalSheetState extends State<_BulkQuoteModalSheet> {
  late final TextEditingController _qtyController;
  late final TextEditingController _targetPriceController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: '20');
    _targetPriceController = TextEditingController(text: (widget.unitPrice * 0.85).toStringAsFixed(0));
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _targetPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Request B2B Bulk Quote', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Negotiate directly with the master artisan for institutional or boutique procurement.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          TextField(
            controller: _qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Requested Quantity (Units)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _targetPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Target Offered Price (₹ / Unit)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Procurement Requirements / Timeline', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          VKButton(
            label: 'Submit Quote to Artisan',
            icon: Icons.send_rounded,
            variant: VKButtonVariant.primary,
            onPressed: () {
              final quote = BulkQuote(
                id: 'quote_${DateTime.now().millisecondsSinceEpoch}',
                productId: widget.prodId,
                productTitle: widget.prodTitle,
                buyerName: 'Institutional Buyer',
                buyerOrg: 'Ethnic Luxury Retails',
                requestedQuantity: int.tryParse(_qtyController.text) ?? 20,
                targetPricePerUnit: double.tryParse(_targetPriceController.text) ?? (widget.unitPrice * 0.85),
                status: 'pending',
                requestedAt: DateTime.now(),
                notes: _notesController.text.trim(),
              );
              context.read<BuyerBloc>().add(SubmitBuyerQuoteEvent(quote));
              ChatNegotiationService.instance.addThreadFromBulkQuote(quote);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quote submitted to artisan successfully!'), backgroundColor: AppColors.teal),
              );
            },
          ),
        ],
      ),
    );
  }
}
