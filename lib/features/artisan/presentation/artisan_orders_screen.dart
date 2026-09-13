import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/artisan_bloc.dart';

class ArtisanOrdersScreen extends StatelessWidget {
  const ArtisanOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Loom Orders',
        showBackButton: true,
        currentRole: 'artisan',
      ),
      body: BlocBuilder<ArtisanBloc, ArtisanState>(
        builder: (context, state) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return VKCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        VKBadge(
                          label: order.status.toUpperCase(),
                          type: order.status == 'delivered'
                              ? VKBadgeType.success
                              : order.status == 'in_loom'
                                  ? VKBadgeType.ai
                                  : VKBadgeType.warning,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            order.productImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.productTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text('Customer: ${order.buyerName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              Text('Address: ${order.deliveryAddress}', style: const TextStyle(fontSize: 11, color: AppColors.textLight), maxLines: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹${order.totalPrice.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.teal)),
                        PopupMenuButton<String>(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.tealLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text('Update Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_drop_down, size: 16, color: AppColors.tealDark),
                              ],
                            ),
                          ),
                          onSelected: (newStatus) {
                            context.read<ArtisanBloc>().add(UpdateOrderStatusEvent(order.id, newStatus));
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'confirmed', child: Text('Mark Confirmed')),
                            const PopupMenuItem(value: 'in_loom', child: Text('Move to In-Loom Crafting')),
                            const PopupMenuItem(value: 'shipped', child: Text('Mark Shipped (Post/Courier)')),
                            const PopupMenuItem(value: 'delivered', child: Text('Mark Delivered')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
