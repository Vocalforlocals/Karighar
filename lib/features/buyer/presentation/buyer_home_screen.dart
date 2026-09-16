import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/product.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/buyer_bloc.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  final Set<String> _wishlist = <String>{};

  // Faceted Search & Filter States
  String _selectedPriceRange = 'All'; // 'All', '<1500', '1500-5000', '5000-12000', '>12000'
  String _selectedState = 'All';
  String _selectedHonor = 'All';
  final String _selectedSort = 'popularity'; // 'popularity', 'price_asc', 'price_desc', 'rating'

  String _formatInr(num amount) {
    final str = amount.round().toString();
    if (str.length <= 3) return '₹$str';
    final lastThree = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formattedRest = rest.replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+(?!\d))'), (Match m) => '${m[1]},');
    return '₹$formattedRest,$lastThree';
  }

  // Timers for live animations & counters
  Timer? _countdownTimer;
  Timer? _searchHintTimer;

  // Flash Sale Countdown (Hours, Minutes, Seconds)
  Duration _flashTimeLeft = const Duration(hours: 4, minutes: 28, seconds: 45);

  // Rotating Search Hints
  int _searchHintIndex = 0;
  final List<String> _searchHints = const [
    'Search "Madhubani Saree"...',
    'Search "Banarasi Katan Silk"...',
    'Search "Jaipur Blue Pottery"...',
    'Search "Gorakhpur Terracotta"...',
    'Search "Channapatna Wooden Toys"...',
    'Search "Bhagalpuri Wild Tussar"...',
  ];

  // Visual Category Circles (Flipkart Benchmark)
  final List<Map<String, dynamic>> _visualCategories = const [
    {
      'name': 'All Crafts',
      'category': 'All',
      'icon': Icons.auto_awesome_rounded,
      'image': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=300&auto=format&fit=crop&q=80',
      'count': '21+',
    },
    {
      'name': 'Silk Sarees',
      'category': 'Textiles & Weaves',
      'icon': Icons.dry_cleaning_rounded,
      'image': 'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=300&auto=format&fit=crop&q=80',
      'count': '14',
    },
    {
      'name': 'Folk Art',
      'category': 'Folk Art & Paintings',
      'icon': Icons.palette_rounded,
      'image': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=300&auto=format&fit=crop&q=80',
      'count': '9',
    },
    {
      'name': 'Terracotta',
      'category': 'Ceramics & Pottery',
      'icon': Icons.interests_rounded,
      'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=300&auto=format&fit=crop&q=80',
      'count': '12',
    },
    {
      'name': 'Brass & Metal',
      'category': 'Textiles & Weaves',
      'icon': Icons.shield_rounded,
      'image': 'https://images.unsplash.com/photo-1582738411706-bfc8e691d1c2?w=300&auto=format&fit=crop&q=80',
      'count': '6',
    },
    {
      'name': 'Wooden Crafts',
      'category': 'Ceramics & Pottery',
      'icon': Icons.toys_rounded,
      'image': 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=300&auto=format&fit=crop&q=80',
      'count': '8',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Start Live Countdown Timer (Ticks every second)
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_flashTimeLeft.inSeconds > 0) {
            _flashTimeLeft = _flashTimeLeft - const Duration(seconds: 1);
          }
        });
      }
    });

    // Start Auto-Cycling Search Hint (Changes every 3 seconds)
    _searchHintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _searchHintIndex = (_searchHintIndex + 1) % _searchHints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _searchHintTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LocaleManager.currentLanguage,
      builder: (context, currentLang, _) {
        // Format countdown timer: 04h : 28m : 45s
        final hours = _flashTimeLeft.inHours.toString().padLeft(2, '0');
        final minutes = (_flashTimeLeft.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (_flashTimeLeft.inSeconds % 60).toString().padLeft(2, '0');

        return Scaffold(
          backgroundColor: AppColors.background,
          body: BlocBuilder<BuyerBloc, BuyerState>(
        builder: (context, state) {
          // Apply active category and faceted filters
          List<Product> displayedProducts = List.from(state.filteredProducts);
          if (_selectedCategory != 'All') {
            final catLower = _selectedCategory.toLowerCase();
            displayedProducts = displayedProducts.where((p) => p.category.toLowerCase().contains(catLower)).toList();
          }

          if (_selectedPriceRange == '<1500') {
            displayedProducts = displayedProducts.where((p) => p.price < 1500).toList();
          } else if (_selectedPriceRange == '1500-5000') {
            displayedProducts = displayedProducts.where((p) => p.price >= 1500 && p.price <= 5000).toList();
          } else if (_selectedPriceRange == '5000-12000') {
            displayedProducts = displayedProducts.where((p) => p.price >= 5000 && p.price <= 12000).toList();
          } else if (_selectedPriceRange == '>12000') {
            displayedProducts = displayedProducts.where((p) => p.price > 12000).toList();
          }

          if (_selectedState != 'All') {
            displayedProducts = displayedProducts.where((p) => p.clusterLocation.toLowerCase().contains(_selectedState.toLowerCase())).toList();
          }

          if (_selectedHonor == 'Padma Shri') {
            displayedProducts = displayedProducts.where((p) => p.artisanName.toLowerCase().contains('padma shri') || p.tags.any((t) => t.toLowerCase().contains('padma shri'))).toList();
          } else if (_selectedHonor == 'Awardee') {
            displayedProducts = displayedProducts.where((p) => p.artisanName.toLowerCase().contains('award') || p.artisanName.toLowerCase().contains('shilp guru') || p.artisanName.toLowerCase().contains('master')).toList();
          }

          if (_selectedSort == 'price_asc') {
            displayedProducts.sort((a, b) => a.price.compareTo(b.price));
          } else if (_selectedSort == 'price_desc') {
            displayedProducts.sort((a, b) => b.price.compareTo(a.price));
          } else if (_selectedSort == 'rating') {
            displayedProducts.sort((a, b) => (b.isGICertified ? 1 : 0).compareTo(a.isGICertified ? 1 : 0));
          }

          return CustomScrollView(
            slivers: [
                  // ================================================================
                  // 1. TIER-1 TOP HEADER / TICKER (DESKTOP) OR SLIVER APP BAR (MOBILE)
                  // ================================================================
                  // 1. TIER-1 TOP BANNER TICKER (DESKTOP & MOBILE)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 14, right: 14, bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.credit_card_rounded, color: AppColors.zariGold, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${'Bank Offer'.tr}: 10% Instant Discount on SBI & ICICI Bank Cards',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

              // ================================================================
              // 2. VISUAL CIRCULAR CATEGORIES (FLIPKART BENCHMARK)
              // ================================================================
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: _visualCategories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 14),
                      itemBuilder: (context, idx) {
                        final cat = _visualCategories[idx];
                        final isSelected = _selectedCategory == cat['category'];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat['category'] as String;
                            });
                            context.read<BuyerBloc>().add(CategorySelectedEvent(cat['category'] as String));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [AppColors.terracotta, AppColors.zariGold],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  border: Border.all(
                                    color: isSelected ? Colors.transparent : AppColors.cardBorder,
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    cat['image'] as String,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Container(
                                      color: AppColors.terracottaLight,
                                      child: Icon(cat['icon'] as IconData, color: AppColors.terracotta, size: 24),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                (cat['name'] as String).tr,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.terracotta : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ================================================================
              // 4. "HERITAGE FLASH DROP" / DEAL OF THE DAY WITH LIVE COUNTDOWN
              // ================================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.elevatedShadow,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    'HERITAGE FLASH DROP'.tr,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Ticking Clock Badges
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 14, color: AppColors.zariGold),
                                const SizedBox(width: 4),
                                _buildTimerBlock(hours),
                                const Text(' : ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                _buildTimerBlock(minutes),
                                const Text(' : ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                _buildTimerBlock(seconds),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400&auto=format&fit=crop&q=80',
                                width: 85,
                                height: 85,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade900.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('🔥 Only 2 Pieces Remaining on Loom!', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 9.5, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Varanasi Pure Mulberry Katan Silk Saree',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text('By Master Ramdev • GI Tag #GI-IN-0012', style: TextStyle(color: Colors.white70, fontSize: 10.5)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text(
                                        '₹6,499',
                                        style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        '₹9,500',
                                        style: TextStyle(color: Colors.white38, decoration: TextDecoration.lineThrough, fontSize: 11),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.terracotta,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          if (state.allProducts.isNotEmpty) {
                                            context.read<BuyerBloc>().add(AddToCartEvent(state.allProducts.first));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Flash Drop item claimed and added to cart!'),
                                                backgroundColor: AppColors.emeraldDeep,
                                              ),
                                            );
                                          }
                                        },
                                         child: Text('Claim Deal'.tr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================================================================
              // 7. PRODUCT SHOWCASE: UNIFIED MOBILE 2-COLUMN GRID
              // ================================================================
              // Mobile Grid Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'Curated Heritage Crafts'.tr} (${displayedProducts.length})',
                            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '100% Certified GI • Direct DBT Bank Rails'.tr,
                            style: const TextStyle(fontSize: 10.5, color: AppColors.emeraldDeep, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.tune_rounded, size: 16, color: AppColors.terracotta),
                        label: Text('Filter'.tr, style: const TextStyle(color: AppColors.terracotta, fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () => context.go('/buyer/explore'),
                      ),
                    ],
                  ),
                ),
              ),
              if (displayedProducts.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = displayedProducts[index];
                        final isFavorite = _wishlist.contains(product.id);
                        return _buildProductCard(context, product, isFavorite);
                      },
                      childCount: displayedProducts.length,
                    ),
                  ),
                ),

              // ================================================================
              // 9. THE KARIGHAR PROVENANCE PROMISE (TRUST PILLARS)
              // ================================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.parchmentSilk,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_rounded, color: AppColors.emeraldDeep, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'The Karighar Provenance Guarantee'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Expanded(
                              child: _TrustItem(
                                icon: Icons.account_balance_rounded,
                                title: '100% Direct DBT',
                                desc: 'Funds directly reach weaver Aadhaar bank account',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _TrustItem(
                                icon: Icons.lock_clock_rounded,
                                title: '7-Day Escrow',
                                desc: 'Protected by RBI Nodal Escrow until you inspect',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Expanded(
                              child: _TrustItem(
                                icon: Icons.verified_user_rounded,
                                title: 'Certified GI Tags',
                                desc: 'Authenticity verified by Ministry of Textiles',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _TrustItem(
                                icon: Icons.qr_code_2_rounded,
                                title: 'Blockchain Twin',
                                desc: 'SHA-256 tamper-proof provenance passport',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Padding for smooth scrolling past Navigation Bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          );
        },
      ),
    );
    },
  );
}

  Widget _buildTimerBlock(String digits) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        digits,
        style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.terracotta.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded, size: 48, color: AppColors.terracotta),
          ),
          const SizedBox(height: 16),
          Text(
            'No Handcrafted Treasures Found'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting or resetting your category, state, or price filters.'.tr,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text('Reset All Filters'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.terracotta,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() {
                _selectedCategory = 'All';
                _selectedPriceRange = 'All';
                _selectedState = 'All';
                _selectedHonor = 'All';
              });
              context.read<BuyerBloc>().add(const CategorySelectedEvent('All'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, bool isFavorite) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/buyer/product/${product.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with GI Tag & Wishlist
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.images.isNotEmpty ? product.images.first : product.rawImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.parchmentSilk,
                        child: const Center(
                          child: Icon(Icons.palette_outlined, size: 36, color: AppColors.terracotta),
                        ),
                      ),
                    ),
                    // GI Certified Badge
                    if (product.isGICertified)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldDeep.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, size: 10, color: Colors.white),
                              const SizedBox(width: 3),
                              Text(
                                'GI TAGGED'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Wishlist Toggle Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_wishlist.contains(product.id)) {
                              _wishlist.remove(product.id);
                            } else {
                              _wishlist.add(product.id);
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _wishlist.contains(product.id)
                                    ? 'Saved "${product.title}" to Wishlist.'
                                    : 'Removed from Wishlist.',
                              ),
                              backgroundColor: AppColors.royalIndigo,
                              duration: const Duration(milliseconds: 900),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 15,
                            color: isFavorite ? Colors.red : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                    // Cluster Location Tag at bottom-left of image
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded, size: 9, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              product.clusterLocation.split(',').first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Product Info & Price
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Artisan Byline
                    Text(
                      'By ${product.artisanName}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Title
                    Text(
                      product.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating & DBT Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldDeep,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.star_rounded, size: 10, color: Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '(128)',
                          style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldDeep.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Direct DBT'.tr,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.emeraldDeep,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Price & MRP & Discount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _formatInr(product.price),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatInr((product.price * 1.35).round()),
                          style: const TextStyle(
                            fontSize: 10.5,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '25% OFF',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.emeraldDeep,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Free Delivery Note
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 11, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          '${'Free Delivery'.tr} • ${'7-Day Escrow'.tr}',
                          style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_bag_outlined, size: 12),
                        label: Text(
                          'Add to Cart'.tr,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.terracotta,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          context.read<BuyerBloc>().add(AddToCartEvent(product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added "${product.title}" to cart.'),
                              backgroundColor: AppColors.terracotta,
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                textColor: Colors.white,
                                onPressed: () => context.go('/buyer/cart'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.terracotta),
          const SizedBox(height: 4),
          Text(title.tr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(desc.tr, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, height: 1.25)),
        ],
      ),
    );
  }
}
