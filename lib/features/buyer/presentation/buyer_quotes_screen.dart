import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class BuyerQuotesScreen extends StatelessWidget {
  const BuyerQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'My Bulk B2B Quotes',
        showBackButton: true,
        currentRole: 'buyer',
      ),
      body: BlocBuilder<BuyerBloc, BuyerState>(
        builder: (context, state) {
          if (state.submittedQuotes.isEmpty) {
            return const Center(child: Text('No bulk procurement requests submitted yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.submittedQuotes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final quote = state.submittedQuotes[index];
              return VKCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quote #${quote.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        VKBadge(
                          label: quote.status.toUpperCase(),
                          type: quote.status == 'accepted'
                              ? VKBadgeType.success
                              : quote.status == 'countered'
                                  ? VKBadgeType.ai
                                  : VKBadgeType.warning,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Text(quote.productTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text('Requested Quantity: ${quote.requestedQuantity} Units', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    Text('Offered Target: ₹${quote.targetPricePerUnit.toStringAsFixed(0)} / unit', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    if (quote.artisanCounterPrice != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(6)),
                        child: Text('Artisan Counter Response: ${quote.artisanCounterPrice}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                      ),
                    ],
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
