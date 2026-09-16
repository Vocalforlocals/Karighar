import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';
import '../bloc/buyer_bloc.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  bool _isLoggedIn = ApiClient.currentUser != null;
  String _selectedLoginRole = 'BUYER'; // 'BUYER' or 'ARTISAN'
  bool _isOtpMode = true;
  bool _isLoading = false;
  bool _otpSent = false;
  int _countdown = 0;
  Timer? _timer;

  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');
  final TextEditingController _otpController = TextEditingController(text: '7829');
  final TextEditingController _emailController = TextEditingController(text: 'buyer@karighar.gov.in');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = ApiClient.currentUser != null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _otpSent = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _countdown = 0);
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid mobile number'.tr), backgroundColor: Colors.red.shade700),
      );
      return;
    }

    setState(() => _isLoading = true);
    await ApiClient.sendOtp(phone);
    if (!mounted) return;
    setState(() => _isLoading = false);
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'OTP sent to'.tr} $phone. ${'Use demo OTP: 7829'.tr}'),
        backgroundColor: AppColors.emeraldDeep,
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      if (_isOtpMode) {
        final phone = _phoneController.text.trim();
        final otp = _otpController.text.trim();
        if (phone.isEmpty || otp.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter mobile number and OTP'.tr), backgroundColor: Colors.red.shade700),
          );
          setState(() => _isLoading = false);
          return;
        }
        await ApiClient.verifyOtp(phone, otp);
        if (!mounted) return;
      } else {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter email and password'.tr), backgroundColor: Colors.red.shade700),
          );
          setState(() => _isLoading = false);
          return;
        }
        await ApiClient.login(
          email: email,
          password: password,
          role: _selectedLoginRole,
        );
        if (!mounted) return;
      }

      // If user selected role, ensure currentUser role reflects their choice
      if (ApiClient.currentUser != null) {
        if (_selectedLoginRole == 'ARTISAN') {
          // Artisan login
          await ApiClient.login(role: 'ARTISAN');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged in as Master Artisan Seller! Opening Studio...'.tr),
              backgroundColor: AppColors.saffronDark,
            ),
          );
          context.go('/artisan');
          return;
        } else {
          // Buyer login
          await ApiClient.login(role: 'BUYER');
          if (!mounted) return;
          setState(() {
            _isLoggedIn = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back to Karighar Marketplace!'.tr),
              backgroundColor: AppColors.emeraldDeep,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red.shade700),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _quickLogin(String role) async {
    setState(() => _isLoading = true);
    await ApiClient.login(role: role);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (role == 'ARTISAN') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in as Master Artisan Seller! Welcome to Studio.'.tr),
          backgroundColor: AppColors.saffronDark,
        ),
      );
      context.go('/artisan');
    } else {
      setState(() {
        _isLoggedIn = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in as Verified Buyer! Welcome back.'.tr),
          backgroundColor: AppColors.emeraldDeep,
        ),
      );
    }
  }

  void _handleLogout() {
    ApiClient.logout();
    setState(() {
      _isLoggedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully. Please select role to log in again.'.tr),
        backgroundColor: AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: _isLoggedIn ? _buildLoggedInProfile(context) : _buildLoginForm(context),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // 1. EMBEDDED LOGIN FORM IN PROFILE SECTION (BUYER OR SELLER)
  // ============================================================================
  Widget _buildLoginForm(BuildContext context) {
    final isBuyer = _selectedLoginRole == 'BUYER';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Brand Header
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/karighar_logo.png',
                height: 48,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.handshake_rounded, size: 48, color: AppColors.terracotta),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to Karighar'.tr,
                style: GoogleFonts.rozhaOne(fontSize: 24, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Sign in to access your direct artisan orders or seller studio'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // PRIMARY ROLE SELECTION: "LOGIN AS A BUYER OR AS A SELLER"
        VKCard(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.terracottaLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.switch_account_rounded, color: AppColors.terracotta, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How would you like to log in?'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Select whether you are buying crafts or selling as an artisan'.tr,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Two Interactive Role Choice Cards
              Row(
                children: [
                  // Option 1: Buyer
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLoginRole = 'BUYER';
                          _emailController.text = 'buyer@karighar.gov.in';
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isBuyer ? AppColors.terracottaLight.withValues(alpha: 0.6) : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isBuyer ? AppColors.terracotta : AppColors.cardBorder,
                            width: isBuyer ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isBuyer ? AppColors.terracotta : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.shopping_bag_rounded, color: isBuyer ? Colors.white : AppColors.textSecondary, size: 20),
                                ),
                                if (isBuyer)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.terracotta, size: 18),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Login as Buyer'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isBuyer ? AppColors.terracotta : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Shop GI handlooms, track orders & verified escrow'.tr,
                              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Option 2: Seller
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLoginRole = 'ARTISAN';
                          _emailController.text = 'ramdev@karighar.gov.in';
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: !isBuyer ? AppColors.saffronLight.withValues(alpha: 0.6) : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: !isBuyer ? AppColors.saffronDark : AppColors.cardBorder,
                            width: !isBuyer ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: !isBuyer ? AppColors.saffronDark : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.palette_rounded, color: !isBuyer ? Colors.white : AppColors.textSecondary, size: 20),
                                ),
                                if (!isBuyer)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.saffronDark, size: 18),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Login as Seller'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: !isBuyer ? AppColors.saffronDark : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Studio cataloging, orders & 100% direct DBT bank rails'.tr,
                              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Auth Method Selector (OTP / Email)
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _isOtpMode = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _isOtpMode ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _isOtpMode ? AppColors.terracotta : Colors.transparent),
                    boxShadow: _isOtpMode ? AppColors.cardShadow : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android_rounded, size: 16, color: _isOtpMode ? AppColors.terracotta : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Mobile OTP'.tr,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: _isOtpMode ? FontWeight.bold : FontWeight.w500,
                          color: _isOtpMode ? AppColors.terracotta : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _isOtpMode = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !_isOtpMode ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: !_isOtpMode ? AppColors.terracotta : Colors.transparent),
                    boxShadow: !_isOtpMode ? AppColors.cardShadow : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email_outlined, size: 16, color: !_isOtpMode ? AppColors.terracotta : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Email & Password'.tr,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: !_isOtpMode ? FontWeight.bold : FontWeight.w500,
                          color: !_isOtpMode ? AppColors.terracotta : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Credential Form
        VKCard(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isOtpMode) ...[
                Text('Mobile Number'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.terracotta, size: 18),
                    suffixIcon: TextButton(
                      onPressed: _countdown > 0 ? null : _handleSendOtp,
                      child: Text(
                        _countdown > 0 ? '$_countdown s' : (_otpSent ? 'Resend OTP'.tr : 'Send OTP'.tr),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _countdown > 0 ? AppColors.textLight : AppColors.terracotta,
                        ),
                      ),
                    ),
                    hintText: '+91 98765 43210',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                Text('4-Digit OTP'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_clock_rounded, color: AppColors.terracotta, size: 18),
                    hintText: 'Enter 7829 (Demo OTP)',
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ] else ...[
                Text('Email Address'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.terracotta, size: 18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Password'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.terracotta, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Main Login Button
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBuyer ? AppColors.terracotta : AppColors.saffronDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  icon: _isLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Icon(isBuyer ? Icons.shopping_bag_rounded : Icons.palette_rounded, size: 18),
                  label: Text(
                    isBuyer ? 'Login as Buyer'.tr : 'Login as Seller'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                ),
              ),
              const SizedBox(height: 14),

              // 1-Tap Quick Demo Login (Judges & Testers)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isBuyer ? AppColors.terracotta : AppColors.saffronDark),
                  foregroundColor: isBuyer ? AppColors.terracotta : AppColors.saffronDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.flash_on_rounded, size: 16),
                label: Text(
                  isBuyer ? '⚡ 1-Tap Quick Login as Buyer (FabIndia)'.tr : '⚡ 1-Tap Quick Login as Seller (Ramdev)'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
                onPressed: _isLoading ? null : () => _quickLogin(_selectedLoginRole),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // 2. LOGGED-IN PROFILE DASHBOARD
  // ============================================================================
  Widget _buildLoggedInProfile(BuildContext context) {
    final user = ApiClient.currentUser;
    final displayName = user?.fullName ?? 'Conscious Craft Connoisseur';
    final email = user?.email ?? 'buyer@karighar.gov.in';
    final phone = user?.phone ?? '+91 98765 43210';
    final isArtisan = user?.role == 'ARTISAN';

    return BlocBuilder<BuyerBloc, BuyerState>(
      builder: (context, state) {
        final orders = state.buyerOrders;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            VKCard(
              color: isArtisan ? AppColors.saffronDark : AppColors.royalIndigo,
              borderColor: isArtisan ? AppColors.saffron : AppColors.royalIndigoDark,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.zariGold,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: isArtisan ? AppColors.saffron : AppColors.royalIndigoDark,
                      child: Icon(
                        isArtisan ? Icons.palette_rounded : Icons.person_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$email • $phone',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            VKBadge(
                              label: isArtisan ? 'Verified Artisan Seller' : 'MoSJE Verified Buyer',
                              type: VKBadgeType.verified,
                              icon: Icons.verified_user_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Account & Role Switch Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArtisan ? 'Currently in Seller Mode'.tr : 'Want to Sell as an Artisan?'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isArtisan
                              ? 'Manage craft catalog, orders, and DBT in Studio'.tr
                              : 'Open your Artisan Studio to sell crafts with AI photo studio'.tr,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isArtisan ? AppColors.terracotta : AppColors.saffronDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (isArtisan) {
                        context.go('/buyer');
                      } else {
                        context.go('/artisan');
                      }
                    },
                    child: Text(
                      isArtisan ? 'Buyer Shop'.tr : 'Seller Studio'.tr,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Language & Vernacular Preferences
            Text(
              'Language & Bhashini Voice Assistant'.tr,
              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<AppLanguage>(
              valueListenable: LocaleManager.currentLanguage,
              builder: (context, currentLang, _) {
                return VKCard(
                  child: Row(
                    children: [
                      const Icon(Icons.translate_rounded, color: AppColors.terracotta, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active App Language'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              '${LocaleManager.getLanguageName(currentLang)} (22 Constitutional + 4 Bihari Dialects)',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => LocaleManager.showLanguagePicker(context),
                        child: Text('Change'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.terracotta)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Order History & Tracking
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order History & Escrow Tracking'.tr,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${orders.length} orders',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (orders.isEmpty)
              VKCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.receipt_long_outlined, color: AppColors.textLight, size: 36),
                        const SizedBox(height: 8),
                        const Text('No recent orders yet.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.terracotta,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => context.go('/buyer'),
                          child: Text('Start Exploring Crafts'.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return VKCard(
                    onTap: () => context.go('/buyer/delivery-verification/${order.id}'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.terracottaLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.local_shipping_outlined, color: AppColors.terracotta, size: 22),
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
                                'Order #${order.id} • ₹${order.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldDeep.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            order.status.toUpperCase(),
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.emeraldDeep),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            // Quick Navigation & Logout Hub
            Text(
              'Buyer Hub & Portals'.tr,
              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            VKCard(
              padding: EdgeInsets.zero,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.account_balance_outlined, color: AppColors.royalIndigo),
                      title: Text('Corporate & Hotel Bulk RFPs'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Tenders pooled across certified artisan SHGs', style: TextStyle(fontSize: 11)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () => context.go('/buyer/tenders'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.terracotta),
                      title: Text('Artisan Chat & Direct Negotiations'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Live chat with master weavers & pottery clusters', style: TextStyle(fontSize: 11)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () => context.go('/buyer/chat'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      title: Text('Log Out / Switch Account'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                      subtitle: Text('Switch between Buyer and Seller accounts'.tr, style: const TextStyle(fontSize: 11)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.redAccent),
                      onTap: _handleLogout,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
