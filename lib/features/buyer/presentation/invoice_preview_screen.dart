import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/invoice_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final String orderId;
  final String productTitle;
  final double totalPrice;

  const InvoicePreviewScreen({
    super.key,
    required this.orderId,
    required this.productTitle,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final invoice = InvoiceService.generateInvoiceForOrder(
      orderId: orderId,
      productTitle: productTitle,
      totalPrice: totalPrice,
      buyerName: 'Ananya Sharma',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Official Invoice Document Card
            VKCard(
              color: Colors.white,
              borderColor: AppColors.cardBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Government Tax Invoice Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TAX INVOICE & DBT RECEIPT',
                            style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          const Text('Ministry of Social Justice & Empowerment', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          const Text('Karighar Direct Handloom Gateway', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const VKBadge(label: 'GST EXEMPT', type: VKBadgeType.verified),
                    ],
                  ),
                  const Divider(height: 20),

                  // Metadata Matrix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Invoice Number:', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                          Text(invoice.invoiceNumber, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('E-Way Bill No:', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                          Text(invoice.eWayBillNumber, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Date of Issue:', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                          Text('${invoice.issuedAt.day}/${invoice.issuedAt.month}/${invoice.issuedAt.year}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('DBT Escrow Ref:', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                          Text(invoice.dbtEscrowRef, style: const TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Parties
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Billed To (Buyer):', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(invoice.buyerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(invoice.buyerOrg, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Master Artisan (Seller):', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(invoice.artisanName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(invoice.clusterName, textAlign: TextAlign.end, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Line Items Table
                  Container(
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 3, child: Text('Item & Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('HSN Code', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.end, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(invoice.productTitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(invoice.hsnCode, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'monospace')),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('${invoice.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('₹${invoice.totalAmount.toStringAsFixed(0)}', textAlign: TextAlign.end, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.teal)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Totals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text('₹${invoice.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GST Rate (0% Handloom GI Exemption):', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text('₹0.00 (Exempt)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Net Settled:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(
                        '₹${invoice.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Digital Seal
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.tealLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_rounded, color: AppColors.teal, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Digitally Signed & Validated via National Artisan DBT Portal (Public Financial Management System - PFMS).',
                            style: TextStyle(fontSize: 10, color: AppColors.tealDark, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: VKButton(
                    label: 'Export for GeM Portal',
                    icon: Icons.corporate_fare_rounded,
                    variant: VKButtonVariant.secondary,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order data packaged in GeM XML/JSON format for institutional procurement!'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VKButton(
                    label: 'Download Invoice',
                    icon: Icons.download_rounded,
                    variant: VKButtonVariant.primary,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('GST E-Way Tax Invoice downloaded successfully!'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Phase 6 Smart Delivery Escrow Release Action
            VKButton(
              label: 'Verify Delivery & Release Smart Escrow',
              icon: Icons.lock_open_rounded,
              variant: VKButtonVariant.outline,
              onPressed: () {
                context.go('/buyer/delivery-verification/${invoice.orderId}?amount=${invoice.totalAmount}&title=${Uri.encodeComponent(invoice.productTitle)}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
