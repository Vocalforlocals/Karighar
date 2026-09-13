import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/artisan_bloc.dart';

class ArtisanQuotesScreen extends StatelessWidget {
  const ArtisanQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'B2B Bulk Quotes',
        showBackButton: true,
        currentRole: 'artisan',
      ),
      body: BlocBuilder<ArtisanBloc, ArtisanState>(
        builder: (context, state) {
          if (state.quotes.isEmpty) {
            return const Center(child: Text('No bulk quotes received yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.quotes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final quote = state.quotes[index];
              return VKCard(
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
                              Text(quote.buyerOrg, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('Requested by: ${quote.buyerName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
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
                    Text(quote.productTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Quantity', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                              Text('${quote.requestedQuantity} Units', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Offered Unit Price', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                              Text('₹${quote.targetPricePerUnit.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.teal)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Value', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                              Text('₹${(quote.requestedQuantity * quote.targetPricePerUnit).toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.saffronDark)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (quote.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Note: "${quote.notes}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                    ],
                    if (quote.artisanCounterPrice != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(6)),
                        child: Text('Your Counter Offer: ${quote.artisanCounterPrice}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                      ),
                    ],
                    const SizedBox(height: 14),
                    if (quote.status == 'pending') ...[
                      Row(
                        children: [
                          Expanded(
                            child: VKButton(
                              label: 'Accept Offer',
                              variant: VKButtonVariant.secondary,
                              onPressed: () {
                                context.read<ArtisanBloc>().add(RespondToQuoteEvent(quoteId: quote.id, responseStatus: 'accepted'));
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: VKButton(
                              label: 'Counter Offer',
                              variant: VKButtonVariant.outline,
                              onPressed: () {
                                context.read<ArtisanBloc>().add(RespondToQuoteEvent(
                                      quoteId: quote.id,
                                      responseStatus: 'countered',
                                      counterPrice: '₹${(quote.targetPricePerUnit * 1.1).toStringAsFixed(0)} / unit with certified seal',
                                    ));
                              },
                            ),
                          ),
                        ],
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
