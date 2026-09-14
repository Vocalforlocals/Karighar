import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/buyer_bloc.dart';

class BuyerPaymentScreen extends StatefulWidget {
  const BuyerPaymentScreen({super.key});

  @override
  State<BuyerPaymentScreen> createState() => _BuyerPaymentScreenState();
}

class _BuyerPaymentScreenState extends State<BuyerPaymentScreen> {
  String _selectedMethod = 'gpay';
  bool _qrVisible = false;
  bool _verifying = false;
  bool _paymentSuccess = false;
  Timer? _webhookTimer;

  final List<Map<String, dynamic>> _upiApps = [
    {'id': 'gpay', 'name': 'Google Pay', 'color': const Color(0xFF4285F4), 'icon': Icons.g_mobiledata_rounded},
    {'id': 'phonepe', 'name': 'PhonePe', 'color': const Color(0xFF5F259F), 'icon': Icons.phone_android_rounded},
    {'id': 'paytm', 'name': 'Paytm', 'color': const Color(0xFF002970), 'icon': Icons.account_balance_wallet_rounded},
    {'id': 'bhim', 'name': 'BHIM UPI', 'color': const Color(0xFF138808), 'icon': Icons.flag_rounded},
    {'id': 'cred', 'name': 'CRED', 'color': const Color(0xFF1A1A1A), 'icon': Icons.credit_card_rounded},
    {'id': 'qr', 'name': 'Scan QR', 'color': const Color(0xFF0F172A), 'icon': Icons.qr_code_2_rounded},
  ];

  String _formatInr(num amount) {
    final str = amount.round().toString();
    if (str.length <= 3) return '\u20B9$str';
    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formattedRest = rest.replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(?!\d))'), (m) => '${m[1]},');
    return '\u20B9$formattedRest,$lastThree';
  }

  void _initiatePayment(double total) {
    if (_selectedMethod == 'qr') {
      setState(() => _qrVisible = true);
      return;
    }
    setState(() => _verifying = true);
    _webhookTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() { _verifying = false; _paymentSuccess = true; });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        final orderId = 'ORD-2026-${DateTime.now().millisecondsSinceEpoch % 100000}';
        context.go('/buyer/track/$orderId');
      });
    });
  }

  @override
  void dispose() { _webhookTimer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerBloc, BuyerState>(
      builder: (context, state) {
        final total = state.cartTotal > 0 ? state.cartTotal : 8500.0;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF86EFAC))),
                      child: const Row(children: [
                        Icon(Icons.verified_user_rounded, color: AppColors.emeraldDeep, size: 20),
                        SizedBox(width: 10),
                        Expanded(child: Text('RBI Nodal Escrow: Funds held securely and released directly to artisan Jan Dhan account upon verified dispatch. 100% DBT compliant.', style: TextStyle(fontSize: 11.5, color: Color(0xFF166534), height: 1.3))),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder), boxShadow: AppColors.cardShadow),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Order Summary', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14)),
                        const Divider(height: 16),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${state.cartItems.isNotEmpty ? state.cartItems.length : 1} Artisan Craft Item(s)', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          Text(_formatInr(total), style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 22, color: AppColors.terracotta)),
                        ]),
                        const SizedBox(height: 4),
                        const Text('Free Express Delivery Included \u2022 No Hidden Charges', style: TextStyle(fontSize: 11, color: AppColors.emeraldDeep, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                    const SizedBox(height: 22),
                    Text('Select Payment Method', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemCount: _upiApps.length,
                      itemBuilder: (ctx, i) {
                        final app = _upiApps[i];
                        final isSelected = _selectedMethod == app['id'];
                        return GestureDetector(
                          onTap: () => setState(() { _selectedMethod = app['id'] as String; _qrVisible = false; }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            decoration: BoxDecoration(
                              color: isSelected ? (app['color'] as Color).withValues(alpha: 0.08) : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? app['color'] as Color : AppColors.cardBorder, width: isSelected ? 2 : 1),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(app['icon'] as IconData, color: app['color'] as Color, size: 20),
                              const SizedBox(height: 3),
                              Text(app['name'] as String, textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.5, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? app['color'] as Color : AppColors.textPrimary)),
                            ]),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_qrVisible && _selectedMethod == 'qr') ...[
                      Center(child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.cardBorder, width: 2), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 18)]),
                        child: Column(children: [
                          const Icon(Icons.qr_code_2_rounded, size: 180, color: Color(0xFF0F172A)),
                          const SizedBox(height: 8),
                          Text('UPI ID: karighar.artisan@sbi', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep)),
                          const SizedBox(height: 3),
                          Text('Scan with any UPI App \u2022 Pay ${_formatInr(total)}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () {
                              final router = GoRouter.of(context);
                              setState(() => _verifying = true);
                              Future.delayed(const Duration(seconds: 2), () {
                                if (!mounted) return;
                                setState(() { _verifying = false; _paymentSuccess = true; });
                                Future.delayed(const Duration(milliseconds: 600), () {
                                  if (!mounted) return;
                                  router.go('/buyer/track/ORD-2026-${DateTime.now().millisecondsSinceEpoch % 100000}');
                                });
                              });
                            },
                            icon: const Icon(Icons.check_circle_rounded, size: 18),
                            label: const Text('Simulate QR Scan Payment'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emeraldDeep, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ]),
                      )),
                      const SizedBox(height: 20),
                    ],
                    if (_paymentSuccess)
                      Center(child: Column(children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.emeraldDeep, size: 60),
                        const SizedBox(height: 10),
                        Text('Payment Successful!', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.emeraldDeep)),
                        const SizedBox(height: 4),
                        const Text('Redirecting to Order Tracking...', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ]))
                    else if (_verifying)
                      Center(child: Column(children: [
                        const SizedBox(width: 48, height: 48, child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.royalIndigo)),
                        const SizedBox(height: 14),
                        Text('Verifying UPI payment via SSE webhook...', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 4),
                        const Text('Confirming DBT transfer to artisan bank account', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      ]))
                    else
                      Column(children: [
                        SizedBox(
                          width: double.infinity, height: 54,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.terracotta, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                            icon: Icon(_upiApps.firstWhere((a) => a['id'] == _selectedMethod)['icon'] as IconData, size: 22),
                            label: Text('Pay ${_formatInr(total)} via ${_upiApps.firstWhere((a) => a['id'] == _selectedMethod)['name']}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.3)),
                            onPressed: () => _initiatePayment(total),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.lock_rounded, size: 13, color: AppColors.textLight),
                          SizedBox(width: 5),
                          Text('256-bit SSL Encrypted \u2022 RBI Regulated \u2022 Zero-fee DBT Transfer', style: TextStyle(fontSize: 10.5, color: AppColors.textLight)),
                        ]),
                      ]),
                    const SizedBox(height: 30),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _trustBadge(Icons.account_balance_rounded, 'NPCI\nCertified'),
                      _trustBadge(Icons.security_rounded, 'PCI DSS\nCompliant'),
                      _trustBadge(Icons.verified_rounded, 'RBI\nRegulated'),
                      _trustBadge(Icons.shield_rounded, '100%\nAuthentic'),
                    ]),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _trustBadge(IconData icon, String label) => Column(children: [
    Icon(icon, size: 22, color: AppColors.textSecondary),
    const SizedBox(height: 4),
    Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
  ]);
}
