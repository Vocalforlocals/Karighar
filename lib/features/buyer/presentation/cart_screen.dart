import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Timer? _countdownTimer;
  int _secondsLeft = 15 * 60; // 15 minutes
  bool _gstToggle = false;
  String _selectedAddress = '📍 Home — 14, Lodhi Road, New Delhi 110003';
  final TextEditingController _gstController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          t.cancel();
        }
      });
    });
  }

  String get _countdownDisplay {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatInr(num amount) {
    final str = amount.round().toString();
    if (str.length <= 3) return '₹$str';
    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formattedRest = rest.replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(?!\d))'), (m) => '${m[1]},');
    return '₹$formattedRest,$lastThree';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BuyerBloc, BuyerState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  Text('Your cart is empty'.tr, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text('Explore GI-tagged masterpieces from artisan clusters'.tr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 20),
                  VKButton(label: 'Explore Marketplace'.tr, onPressed: () => context.go('/buyer')),
                ],
              ),
            );
          }

          final totalMrp = state.cartItems.fold<double>(0, (sum, i) => sum + (i.price * 1.28).roundToDouble());
          final totalSavings = totalMrp - state.cartTotal;
          final gstAmount = _gstToggle ? state.cartTotal * 0.18 : 0.0;

          // ---- Cart Items List ----
          Widget itemsList = Column(
            children: [
              // 15-Minute Soft-Lock Countdown Banner
              if (_secondsLeft > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _secondsLeft < 120 ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _secondsLeft < 120 ? AppColors.error : AppColors.zariGold, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        size: 18,
                        color: _secondsLeft < 120 ? AppColors.error : AppColors.zariGold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Soft-Lock Reservation expires in $_countdownDisplay',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                color: _secondsLeft < 120 ? AppColors.error : const Color(0xFF92400E),
                              ),
                            ),
                            Text(
                              'Items are reserved for you. Complete checkout to confirm your artisan order.',
                              style: TextStyle(fontSize: 10.5, color: _secondsLeft < 120 ? AppColors.error : AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // GPS Delivery Address Selector
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppColors.terracotta, size: 16),
                        const SizedBox(width: 6),
                        Text('Deliver To:'.tr, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 12.5)),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _showAddressSelector(context),
                          child: Text('Change'.tr, style: const TextStyle(color: AppColors.royalIndigo, fontSize: 11.5, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedAddress,
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              // Cart Items
              ...state.cartItems.map((item) {
                final itemMrp = (item.price * 1.28).roundToDouble();
                final discountPercent = (((itemMrp - item.price) / itemMrp) * 100).round();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: VKCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.images.isNotEmpty ? item.images.first : item.rawImage,
                            width: 85,
                            height: 85,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              width: 85, height: 85,
                              color: AppColors.terracottaLight,
                              child: const Icon(Icons.palette_rounded, color: AppColors.terracotta, size: 32),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text('By ${item.artisanName} • ${item.clusterLocation}',
                                  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(_formatInr(item.price),
                                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: AppColors.terracotta, fontSize: 15)),
                                  const SizedBox(width: 6),
                                  Text(_formatInr(itemMrp),
                                      style: const TextStyle(fontSize: 11, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
                                  const SizedBox(width: 5),
                                  Text('$discountPercent% OFF',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep)),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text('🚚 ${'Free Express Delivery'.tr}',
                                  style: const TextStyle(fontSize: 10.5, color: AppColors.emeraldDeep, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22),
                          onPressed: () {
                            context.read<BuyerBloc>().add(RemoveFromCartEvent(item.id));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // B2B GST Invoice Toggle
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business_rounded, size: 16, color: AppColors.royalIndigo),
                        const SizedBox(width: 8),
                        Text('B2B Corporate GST Tax Invoice'.tr,
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 12.5)),
                        const Spacer(),
                        Switch(
                          value: _gstToggle,
                          onChanged: (v) => setState(() => _gstToggle = v),
                          activeThumbColor: AppColors.royalIndigo,
                          activeTrackColor: AppColors.royalIndigo.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    if (_gstToggle) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _gstController,
                        decoration: InputDecoration(
                          hintText: 'Enter 15-digit GSTIN (e.g. 27AAPFU0939F1ZV)',
                          prefixIcon: const Icon(Icons.receipt_long_rounded, size: 18),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'GST (18%) included: ${_formatInr(gstAmount)} • Invoice emailed to company GSTIN',
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );

          // ---- Price Summary Card ----
          Widget priceDetailsCard = Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRICE DETAILS'.tr,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.8)),
                const Divider(height: 24),
                _summaryRow('${'Price'.tr} (${state.cartItems.length} items)', _formatInr(totalMrp), bold: false),
                const SizedBox(height: 8),
                _summaryRow('Fair-Value Craft Discount'.tr, '- ${_formatInr(totalSavings)}',
                    valueColor: AppColors.emeraldDeep, bold: true),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charges'.tr, style: const TextStyle(fontSize: 13)),
                    Row(children: [
                      Text(_formatInr(150), style: const TextStyle(fontSize: 12, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
                      const SizedBox(width: 4),
                      Text('FREE'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep)),
                    ]),
                  ],
                ),
                if (_gstToggle) ...[
                  const SizedBox(height: 8),
                  _summaryRow('GST (18%) Corporate Invoice', _formatInr(gstAmount), bold: false),
                ],
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Payable Amount'.tr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(_formatInr(state.cartTotal + gstAmount),
                        style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.terracotta)),
                  ],
                ),
                const Divider(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldDeep.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.savings_rounded, color: AppColors.emeraldDeep, size: 16),
                      const SizedBox(width: 8),
                      Text('You save ${_formatInr(totalSavings)} on this artisan order!',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.emeraldDeep, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_rounded, size: 13, color: AppColors.textLight),
                    const SizedBox(width: 5),
                    Text('100% Secure • RBI Nodal Escrow Certified'.tr, style: const TextStyle(fontSize: 10.5, color: AppColors.textLight)),
                  ],
                ),
              ],
            ),
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemsList,
                      const SizedBox(height: 16),
                      priceDetailsCard,
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
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
                          Text('Total Payable'.tr, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          Text(_formatInr(state.cartTotal + gstAmount),
                              style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.terracotta)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.terracotta,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.payment_rounded),
                          label: Text('PROCEED TO PAYMENT'.tr, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                          onPressed: () => context.go('/buyer/payment'),
                        ),
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

  Widget _summaryRow(String label, String value, {bool bold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: valueColor)),
      ],
    );
  }

  void _showAddressSelector(BuildContext context) {
    final addresses = [
      '📍 Home — 14, Lodhi Road, New Delhi 110003',
      '🏢 Office — Tower B, Cyber City, Gurugram 122002',
      '🏠 Add New Address via GPS Auto-Detect',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.terracotta),
                const SizedBox(width: 8),
                Text('Select Delivery Address'.tr, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...addresses.map((addr) => ListTile(
                leading: const Icon(Icons.radio_button_checked_rounded, color: AppColors.royalIndigo, size: 20),
                title: Text(addr, style: const TextStyle(fontSize: 13)),
                onTap: () {
                  Navigator.pop(ctx);
                  if (addr.contains('GPS')) {
                    setState(() => _selectedAddress = '📍 GPS — Detected: Connaught Place, New Delhi 110001');
                  } else {
                    setState(() => _selectedAddress = addr);
                  }
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

