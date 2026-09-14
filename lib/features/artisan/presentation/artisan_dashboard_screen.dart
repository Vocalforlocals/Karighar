import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../../../core/widgets/vk_conversational_mic.dart';
import '../bloc/artisan_bloc.dart';

class ArtisanDashboardScreen extends StatelessWidget {
  const ArtisanDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: const VKConversationalMic(),
      body: ValueListenableBuilder<AppLanguage>(
        valueListenable: LocaleManager.currentLanguage,
        builder: (context, currentLang, _) {
          return BlocBuilder<ArtisanBloc, ArtisanState>(
            builder: (context, state) {
              final activeOrders = state.orders.where((o) => o.status != 'delivered').length;
              final pendingQuotes = state.quotes.where((q) => q.status == 'pending').length;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Banner
                    _buildProfileBanner(context),
                    const SizedBox(height: 16),

                    // Metrics Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Total GMV'.tr,
                            value: '₹${state.totalRevenue.toStringAsFixed(0)}',
                            delta: '+38.4% Uplift'.tr,
                            isPositive: true,
                            icon: Icons.currency_rupee_rounded,
                            accentColor: AppColors.teal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Active Orders'.tr,
                            value: '$activeOrders ${'Units'.tr}',
                            delta: '2 in Loom Prep'.tr,
                            isPositive: true,
                            icon: Icons.precision_manufacturing_rounded,
                            accentColor: AppColors.saffron,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            title: 'Bulk Quotes'.tr,
                            value: '$pendingQuotes ${'Pending'.tr}',
                            delta: 'FabIndia, Oberoi'.tr,
                            isPositive: true,
                            icon: Icons.request_quote_rounded,
                            accentColor: AppColors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricCard(
                            title: 'GI Compliance'.tr,
                            value: '100% Certified'.tr,
                            delta: 'MoSJE Verified'.tr,
                            isPositive: true,
                            icon: Icons.verified_user_rounded,
                            accentColor: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Quick Action Bar
                    Row(
                      children: [
                        Expanded(
                          child: VKButton(
                            label: 'Add Product (AI)'.tr,
                            icon: Icons.auto_awesome,
                            variant: VKButtonVariant.primary,
                            onPressed: () => context.go('/artisan/add-product'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: VKButton(
                            label: '${'View Quotes'.tr} ($pendingQuotes)',
                            icon: Icons.handshake_outlined,
                            variant: VKButtonVariant.outline,
                            onPressed: () => context.go('/artisan/quotes'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),


                    // Recent Orders List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Loom Orders'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/artisan/orders'),
                          child: Text('View All'.tr),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (state.orders.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'No orders yet'.tr,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ...state.orders.take(3).map((order) {
                        final rawStatus = order.status.toUpperCase();
                        final statusLabel = rawStatus.tr;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: VKCard(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    order.productImage,
                                    width: 54,
                                    height: 54,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      width: 54,
                                      height: 54,
                                      color: AppColors.cardBorder,
                                      child: const Icon(Icons.image_not_supported_rounded, size: 20, color: AppColors.textLight),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.productTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${'Buyer'.tr}: ${order.buyerName} • ${'Qty'.tr}: ${order.quantity}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${order.totalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.teal),
                                      ),
                                    ],
                                  ),
                                ),
                                VKBadge(
                                  label: statusLabel,
                                  type: order.status.toLowerCase() == 'delivered' ? VKBadgeType.success : VKBadgeType.warning,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 24),

                    // My Cataloged Products Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'My Active Catalog'.tr} (${state.products.length})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.saffron),
                          label: Text(
                            'New Craft'.tr,
                            style: const TextStyle(color: AppColors.saffron, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => context.go('/artisan/add-product'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (state.products.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'No crafts cataloged yet'.tr,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ...state.products.map((prod) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: VKCard(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      prod.images.isNotEmpty
                                          ? prod.images.first
                                          : 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800',
                                      width: 54,
                                      height: 54,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => Container(
                                        width: 54,
                                        height: 54,
                                        color: AppColors.cardBorder,
                                        child: const Icon(Icons.image_not_supported_rounded, size: 20, color: AppColors.textLight),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prod.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${prod.craftForm} • ${prod.estimatedHours}h ${'loom craft'.tr}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${prod.price.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.teal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VKBadge(
                                    label: 'LIVE ON MARKET'.tr,
                                    type: VKBadgeType.verified,
                                  ),
                                ],
                              ),
                            ),
                          )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileBanner(BuildContext context) {
    final user = ApiClient.currentUser;
    final fullName = (user?.fullName != null && user!.fullName.isNotEmpty)
        ? user.fullName
        : 'Ramdev Varma'.tr;
    final cluster = (user?.cluster != null && user!.cluster!.isNotEmpty)
        ? user.cluster!
        : 'Banarasi Silk Weavers Guild • Varanasi, UP'.tr;

    final names = fullName.trim().split(' ');
    final initials = names.length >= 2
        ? '${names[0][0]}${names[1][0]}'.toUpperCase()
        : names.isNotEmpty && names[0].isNotEmpty
            ? names[0][0].toUpperCase()
            : 'RV';

    return VKCard(
      gradient: AppColors.cardGradient,
      customShadow: AppColors.cardShadow,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.saffronLight,
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.saffronDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        fullName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 8),
                    VKBadge(
                      label: 'GI Master'.tr,
                      type: VKBadgeType.verified,
                      icon: Icons.verified_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  cluster,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMetricCard({
    required String title,
    required String value,
    required String delta,
    required bool isPositive,
    required IconData icon,
    required Color accentColor,
  }) {
    return VKCard(
      padding: const EdgeInsets.all(14),
      gradient: LinearGradient(
        colors: [Colors.white, accentColor.withValues(alpha: 0.04)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: accentColor.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 14,
                color: isPositive ? AppColors.teal : AppColors.error,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  delta,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPositive ? AppColors.teal : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
