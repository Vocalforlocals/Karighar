import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  final List<String> _categories = const [
    'All',
    'Textiles & Weaves',
    'Ceramics & Pottery',
    'Folk Art & Paintings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Karighar Marketplace',
        currentRole: 'buyer',
      ),
      body: BlocBuilder<BuyerBloc, BuyerState>(
        builder: (context, state) {
          final cartCount = state.cartItems.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Search Bar with Cart Link
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          context.read<BuyerBloc>().add(SearchQueryChangedEvent(val));
                        },
                        decoration: InputDecoration(
                          hintText: 'Search GI crafts, silk sarees, pottery...'.tr,
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.teal, size: 20),
                          filled: true,
                          fillColor: AppColors.surface,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.teal, size: 28),
                          onPressed: () => context.go('/buyer/cart'),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: AppColors.saffron, shape: BoxShape.circle),
                              child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // MoSJE Provenance Guarantee Banner
                VKCard(
                  color: AppColors.tealLight.withValues(alpha: 0.4),
                  borderColor: AppColors.teal.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: AppColors.teal, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '100% Direct Artisan Sourced'.tr,
                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.tealDark),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Every rupee goes directly to marginalized craft weavers via DBT bank rails. Zero middlemen markups.',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Phase 4 Institutional B2B Procurement Card
                InkWell(
                  onTap: () => context.go('/buyer/tenders'),
                  child: VKCard(
                    color: const Color(0xFF1E293B),
                    borderColor: const Color(0xFF334155),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.saffron.withValues(alpha: 0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.account_balance_rounded, color: AppColors.saffron, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Corporate & Hotel Bulk RFPs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                              SizedBox(height: 2),
                              Text('Corporate & hotel bulk procurement pooled across certified artisan SHGs.', style: TextStyle(fontSize: 11, color: Colors.white70)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.saffron),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final cat = _categories[idx];
                      final isSelected = state.selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat.tr),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<BuyerBloc>().add(CategorySelectedEvent(cat));
                        },
                        selectedColor: AppColors.teal,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        backgroundColor: AppColors.surface,
                        side: BorderSide(color: isSelected ? AppColors.teal : AppColors.cardBorder),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Products Grid Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'Curated Heritage Crafts'.tr} (${state.filteredProducts.length})',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.handshake_outlined, size: 16, color: AppColors.saffron),
                      label: const Text('My Quotes', style: TextStyle(color: AppColors.saffron, fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => context.go('/buyer/quotes'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Products Grid
                if (state.filteredProducts.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No matching craft treasures found.')))
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.66,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.filteredProducts[index];
                      return VKCard(
                        padding: EdgeInsets.zero,
                        onTap: () => context.go('/buyer/product/${product.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: Image.network(
                                    product.images.first,
                                    height: 135,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 135,
                                      color: AppColors.saffronLight.withValues(alpha: 0.4),
                                      child: const Center(
                                        child: Icon(Icons.palette_rounded, color: AppColors.saffron, size: 36),
                                      ),
                                    ),
                                  ),
                                ),
                                if (product.isGICertified)
                                  const Positioned(
                                    top: 8,
                                    left: 8,
                                    child: VKBadge(label: 'GI Tag', type: VKBadgeType.verified, icon: Icons.verified),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.25),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'By ${product.artisanName}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${product.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14.5,
                                          color: AppColors.teal,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(8),
                                          onTap: () {
                                            context.read<BuyerBloc>().add(AddToCartEvent(product));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${product.title} added to cart!'),
                                                duration: const Duration(seconds: 1),
                                                backgroundColor: AppColors.teal,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6.5),
                                            decoration: BoxDecoration(
                                              color: AppColors.tealLight,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: AppColors.teal.withValues(alpha: 0.2), width: 0.8),
                                            ),
                                            child: const Icon(Icons.add_shopping_cart_rounded, size: 16, color: AppColors.tealDark),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
