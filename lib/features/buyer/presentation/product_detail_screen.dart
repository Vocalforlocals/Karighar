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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

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

            // B2B Quote Action Button on Desktop
            if (isDesktop)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.royalIndigo),
                    foregroundColor: AppColors.royalIndigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.handshake_outlined),
                  label: Text('Request B2B Bulk / Corporate Quote'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => _showBulkQuoteModal(context, product.id, product.title, product.price),
                ),
              ),
          ],
        );

        Widget desktopGallery = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image Viewer (4K Zoom / interactive)
            GestureDetector(
              onTap: () {
                final allImages = product.images.isNotEmpty ? product.images : [product.rawImage];
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    backgroundColor: Colors.black,
                    insetPadding: const EdgeInsets.all(12),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: InteractiveViewer(
                            panEnabled: true,
                            minScale: 0.8,
                            maxScale: 5.0,
                            child: Image.network(
                              allImages[_selectedImageIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),
                        const Positioned(
                          bottom: 14,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'Pinch to zoom • Pan to explore 4K detail',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      product.images.isNotEmpty ? product.images[_selectedImageIndex.clamp(0, product.images.length - 1)] : product.rawImage,
                      width: double.infinity,
                      height: 440,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 440,
                        color: AppColors.terracottaLight,
                        child: const Center(child: Icon(Icons.palette_rounded, color: AppColors.terracotta, size: 64)),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_in_rounded, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Tap to zoom 4K', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Thumbnail Strip
            if (product.images.length > 1) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.images.length,
                  separatorBuilder: (context, unused) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final selected = i == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedImageIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? AppColors.terracotta : AppColors.cardBorder,
                            width: selected ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.network(product.images[i], fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Two primary CTA buttons side-by-side (Flipkart style)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.terracotta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: Text('ADD TO CART'.tr, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
                    onPressed: () {
                      context.read<BuyerBloc>().add(AddToCartEvent(product));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart!'),
                          backgroundColor: AppColors.emeraldDeep,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      context.go('/buyer/cart');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.zariGold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.flash_on_rounded),
                    label: Text('BUY NOW'.tr, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
                    onPressed: () {
                      context.read<BuyerBloc>().add(AddToCartEvent(product));
                      context.go('/buyer/cart');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Fast utility actions
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
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: isDesktop ? 40 : 90),
                child: isDesktop
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sleek Flipkart/Amazon Breadcrumb
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => context.go('/buyer'),
                                  child: Text('Home'.tr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                ),
                                const Text('  /  ', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                                InkWell(
                                  onTap: () {
                                    context.read<BuyerBloc>().add(CategorySelectedEvent(product.category));
                                    context.go('/buyer');
                                  },
                                  child: Text(product.category.tr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                ),
                                const Text('  /  ', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                                Expanded(
                                  child: Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: desktopGallery),
                              const SizedBox(width: 36),
                              Expanded(flex: 6, child: detailsContent),
                            ],
                          ),
                        ],
                      )
                    : Column(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: product.images.isNotEmpty
                                ? Image.network(
                                    product.images[_selectedImageIndex.clamp(0, product.images.length - 1)],
                                    width: double.infinity,
                                    height: 320,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      height: 320,
                                      color: AppColors.terracottaLight,
                                      child: const Center(child: Icon(Icons.palette_rounded, color: AppColors.terracotta, size: 64)),
                                    ),
                                  )
                                : Container(
                                    height: 320,
                                    color: AppColors.terracottaLight,
                                    child: const Center(child: Icon(Icons.palette_rounded, color: AppColors.terracotta, size: 64)),
                                  ),
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
            ),
          ),
          bottomSheet: isDesktop
              ? null
              : Container(
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
    final qtyController = TextEditingController(text: '20');
    final targetPriceController = TextEditingController(text: (unitPrice * 0.85).toStringAsFixed(0));
    final notesController = TextEditingController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Request B2B Bulk Quote', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Negotiate directly with the master artisan for institutional or boutique procurement.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Requested Quantity (Units)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Offered Price (₹ / Unit)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
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
                  productId: prodId,
                  productTitle: prodTitle,
                  buyerName: 'Institutional Buyer',
                  buyerOrg: 'Ethnic Luxury Retails',
                  requestedQuantity: int.tryParse(qtyController.text) ?? 20,
                  targetPricePerUnit: double.tryParse(targetPriceController.text) ?? (unitPrice * 0.85),
                  status: 'pending',
                  requestedAt: DateTime.now(),
                  notes: notesController.text.trim(),
                );
                context.read<BuyerBloc>().add(SubmitBuyerQuoteEvent(quote));
                ChatNegotiationService.instance.addThreadFromBulkQuote(quote);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quote submitted to artisan successfully!'), backgroundColor: AppColors.teal),
                );
              },
            ),
          ],
        ),
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
