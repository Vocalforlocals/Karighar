import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/escrow_contract_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class DeliveryVerificationScreen extends StatefulWidget {
  final String orderId;
  final double amount;
  final String productTitle;

  const DeliveryVerificationScreen({
    super.key,
    this.orderId = 'ORD-2026-9041',
    this.amount = 8500.0,
    this.productTitle = 'Banarasi Katan Silk Handloom Saree',
  });

  @override
  State<DeliveryVerificationScreen> createState() => _DeliveryVerificationScreenState();
}

class _DeliveryVerificationScreenState extends State<DeliveryVerificationScreen> {
  bool _isVerifying = false;
  EscrowSettlementResult? _settlementResult;

  void _triggerInstantEscrowRelease() async {
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _isVerifying = false;
      _settlementResult = EscrowContractService.releaseEscrow(
        orderId: widget.orderId,
        amount: widget.amount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Explanation
            VKCard(
              color: AppColors.tealLight.withValues(alpha: 0.4),
              borderColor: AppColors.teal.withValues(alpha: 0.3),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                    child: const Icon(Icons.lock_open_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Programmable Delivery Escrow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.tealDark)),
                        SizedBox(height: 2),
                        Text(
                          'Funds are locked safely in the MoSJE Smart Contract until the craft box QR is scanned upon physical delivery.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Card
            VKCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID: ${widget.orderId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      VKBadge(
                        label: _settlementResult != null ? 'SETTLED' : 'ESCROW LOCKED',
                        type: _settlementResult != null ? VKBadgeType.success : VKBadgeType.warning,
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Text(widget.productTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Locked Escrow Amount:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('₹${widget.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.teal)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QR Code Scan Simulation Box
            if (_settlementResult == null) ...[
              VKCard(
                child: Center(
                  child: Column(
                    children: [
                      const Text('Simulate Physical Package QR Scan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 6),
                      const Text(
                        'Delivery agent or buyer scans tamper-evident box label upon receiving the parcel.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.cardBorder)),
                        child: const Icon(Icons.qr_code_scanner_rounded, size: 120, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      VKButton(
                        label: _isVerifying ? 'Verifying Smart Contract...' : 'Confirm Delivery & Release Escrow',
                        icon: Icons.check_circle_outline_rounded,
                        variant: VKButtonVariant.primary,
                        onPressed: _isVerifying ? null : _triggerInstantEscrowRelease,
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Settled State Receipt Card
              VKCard(
                color: const Color(0xFF0F172A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PFMS DBT Direct Release Executed!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('Settled via Polygon Smart Contract', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Colors.white24),
                    _buildWhiteDetailRow('PFMS Reference:', _settlementResult!.pfmsTransactionId),
                    _buildWhiteDetailRow('Amount Credited:', '₹${_settlementResult!.amountSettled.toStringAsFixed(0)} (100% Direct)'),
                    _buildWhiteDetailRow('Artisan Beneficiary:', _settlementResult!.artisanBankAadhaar),
                    _buildWhiteDetailRow('Smart Contract:', _settlementResult!.contractAddress),
                    _buildWhiteDetailRow('Gas Fee:', _settlementResult!.gasUsed),
                    _buildWhiteDetailRow('Settlement Time:', '${_settlementResult!.settledAt.hour}:${_settlementResult!.settledAt.minute}:${_settlementResult!.settledAt.second} UTC'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              VKButton(
                label: 'View Master Artisan Bank Ledger',
                icon: Icons.account_balance_wallet_rounded,
                variant: VKButtonVariant.secondary,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              VKButton(
                label: '⛓️ Inspect Escrow on Sovereign Blockchain Ledger',
                icon: Icons.link_rounded,
                variant: VKButtonVariant.outline,
                onPressed: () => context.push('/buyer/ledger?q=PFMS_PAYOUT_RELEASE'),
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildWhiteDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(title, style: const TextStyle(fontSize: 11, color: Colors.white60)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }
}
