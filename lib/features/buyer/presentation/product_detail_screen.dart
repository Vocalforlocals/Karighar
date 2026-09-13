import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/quote.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerBloc, BuyerState>(
      builder: (context, state) {
        final product = state.allProducts.firstWhere(
          (p) => p.id == productId,
          orElse: () => state.allProducts.first,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: VKAppBar(
            title: product.craftForm,
            showBackButton: true,
            currentRole: 'buyer',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Hero Image
                Image.network(
                  product.images.first,
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
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
                        style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.teal),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${product.estimatedHours}h Handloom Crafting)',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Artisan Identity Card
                      VKCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.saffronLight,
                              child: Text(
                                product.artisanName[0],
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.saffronDark),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.artisanName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(product.clusterLocation, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  if (product.giTagNumber != null)
                                    Text('Reg: ${product.giTagNumber}', style: const TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Phase 4 Heritage Verification & AR Actions
                      Row(
                        children: [
                          Expanded(
                            child: VKButton(
                              label: 'GI Passport',
                              icon: Icons.qr_code_scanner_rounded,
                              variant: VKButtonVariant.outline,
                              height: 38,
                              onPressed: () => context.go('/buyer/passport/${product.id}'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: VKButton(
                              label: 'View in AR 3D',
                              icon: Icons.view_in_ar_rounded,
                              variant: VKButtonVariant.secondary,
                              height: 38,
                              onPressed: () => context.go('/buyer/ar/${product.id}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Phase 6 Cross-Border Global Export Clearance Action
                      VKButton(
                        label: 'Global Export & Customs Clearance (DGFT)',
                        icon: Icons.public_rounded,
                        variant: VKButtonVariant.outline,
                        height: 38,
                        onPressed: () => context.go('/buyer/export-customs?title=${Uri.encodeComponent(product.title)}&price=${product.price}'),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text('Craft Heritage & Story', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // Materials Used
                      const Text('Authentic Materials Used', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                    ],
                  ),
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
                      label: 'B2B Bulk Quote',
                      icon: Icons.handshake_outlined,
                      variant: VKButtonVariant.outline,
                      onPressed: () => _showBulkQuoteModal(context, product.id, product.title, product.price),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VKButton(
                      label: 'Add to Cart',
                      icon: Icons.add_shopping_cart_rounded,
                      variant: VKButtonVariant.secondary,
                      onPressed: () {
                        context.read<BuyerBloc>().add(AddToCartEvent(product));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Craft item added to your cart!'),
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
}
