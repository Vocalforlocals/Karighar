import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Your Heritage Cart',
        showBackButton: true,
        currentRole: 'buyer',
      ),
      body: BlocBuilder<BuyerBloc, BuyerState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('Explore GI-tagged masterpieces from local clusters', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 20),
                  VKButton(
                    label: 'Explore Marketplace',
                    onPressed: () => context.go('/buyer'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.cartItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return VKCard(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(item.images.first, width: 70, height: 70, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(height: 2),
                                Text('By ${item.artisanName}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                const SizedBox(height: 6),
                                Text('₹${item.price.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.teal, fontSize: 14)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                            onPressed: () {
                              context.read<BuyerBloc>().add(RemoveFromCartEvent(item.id));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Checkout Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.cardBorder)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Direct DBT Amount', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          Text(
                            '₹${state.cartTotal.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      VKButton(
                        label: 'Proceed to Secure Direct Checkout',
                        icon: Icons.qr_code_scanner_rounded,
                        variant: VKButtonVariant.primary,
                        onPressed: () => _showUpiPaymentModal(context, state.cartTotal),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showUpiPaymentModal(BuildContext context, double totalAmount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.tealLight, shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.teal, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text('Direct DBT Escrow Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Scan UPI QR Code to pay ₹${totalAmount.toStringAsFixed(0)} directly to Master Artisan Bank Account',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // Realistic Dynamic QR Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code_2_rounded, size: 160, color: AppColors.textPrimary),
                  const SizedBox(height: 6),
                  Text(
                    'UPI ID: karighar.dbt@sbi',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.teal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // MoSJE Escrow Guarantee
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tealLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: AppColors.teal, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Funds held under Ministry DBT Escrow. Released 100% directly to the artisan upon dispatch verification.',
                      style: TextStyle(fontSize: 11, color: AppColors.tealDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            VKButton(
              label: 'Simulate Successful UPI Payment',
              icon: Icons.check_circle_rounded,
              variant: VKButtonVariant.primary,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.teal,
                    content: Text('Payment confirmed! DBT notification dispatched to Master Artisan.'),
                  ),
                );
                context.go('/buyer/invoice?orderId=ORD-2026-${DateTime.now().millisecondsSinceEpoch % 10000}&title=Banarasi+Katan+Silk+Saree&price=${totalAmount.toStringAsFixed(0)}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
