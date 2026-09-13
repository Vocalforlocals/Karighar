import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isOtpMode = true;
  String _registerRole = 'ARTISAN';
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _otpSent = false;
  int _countdownSeconds = 0;
  Timer? _timer;

  // Controllers
  final _loginPhoneController = TextEditingController(text: '+91 98765 43210');
  final _loginOtpController = TextEditingController(text: '7829');
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _regNameController = TextEditingController();
  final _regPhoneController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regClusterController = TextEditingController(text: 'Varanasi, Uttar Pradesh');
  final _regOrgController = TextEditingController();
  final _regAadhaarController = TextEditingController();

  final List<String> _craftCategories = [
    'Textiles & Weaves',
    'Ceramics & Pottery',
    'Folk Art & Paintings',
    'Metal Crafts',
    'Wood & Cane'
  ];
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    LocaleManager.currentLanguage.addListener(_onLocaleChanged);
    _selectedCategory = _craftCategories.first;
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    LocaleManager.currentLanguage.removeListener(_onLocaleChanged);
    _timer?.cancel();
    _tabController.dispose();
    _loginPhoneController.dispose();
    _loginOtpController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regPhoneController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _regClusterController.dispose();
    _regOrgController.dispose();
    _regAadhaarController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdownSeconds = 30;
      _otpSent = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdownSeconds <= 1) {
        t.cancel();
        setState(() => _countdownSeconds = 0);
      } else {
        setState(() => _countdownSeconds--);
      }
    });
  }

  Future<void> _handleSendOtp() async {
    final phone = _loginPhoneController.text.trim();
    if (phone.isEmpty || phone.length < 8) {
      _showSnackbar('Enter a valid 10-digit mobile number'.tr, isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final res = await ApiClient.sendOtp(phone);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      _startCountdown();
      final devOtp = res['devOtp'];
      if (devOtp != null) {
        _loginOtpController.text = devOtp.toString();
      }
      _showSnackbar('${'Send OTP'.tr}: ${res['message'] ?? 'OTP Sent!'}');
    } else {
      _showSnackbar(res['error'] ?? 'Failed to send OTP'.tr, isError: true);
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      if (_isOtpMode) {
        final phone = _loginPhoneController.text.trim();
        final otp = _loginOtpController.text.trim();
        if (phone.isEmpty || otp.isEmpty) {
          _showSnackbar('Please enter mobile number and OTP'.tr, isError: true);
          setState(() => _isLoading = false);
          return;
        }

        final user = await ApiClient.verifyOtp(phone, otp);
        if (!mounted) return;
        if (user != null) {
          _navigateForUser(user.role);
          return;
        }
      } else {
        final emailOrPhone = _loginEmailController.text.trim();
        final password = _loginPasswordController.text.trim();
        if (emailOrPhone.isEmpty || password.isEmpty) {
          _showSnackbar('Please enter email/phone and password'.tr, isError: true);
          setState(() => _isLoading = false);
          return;
        }

        final user = await ApiClient.login(
          email: emailOrPhone.contains('@') ? emailOrPhone : null,
          phone: !emailOrPhone.contains('@') ? emailOrPhone : null,
          password: password,
        );
        if (!mounted) return;
        if (user != null) {
          _navigateForUser(user.role);
          return;
        }
      }

      _showSnackbar('Authentication failed. Please verify your credentials.'.tr, isError: true);
    } catch (e) {
      _showSnackbar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    final name = _regNameController.text.trim();
    final phone = _regPhoneController.text.trim();
    final email = _regEmailController.text.trim();
    final password = _regPasswordController.text.trim();

    if (name.isEmpty) {
      _showSnackbar('Please enter your full name'.tr, isError: true);
      return;
    }
    if (phone.isEmpty || phone.length < 8) {
      _showSnackbar('Please enter a valid mobile number'.tr, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await ApiClient.register(
        fullName: name,
        phone: phone,
        role: _registerRole,
        email: email.isNotEmpty ? email : null,
        password: password.isNotEmpty ? password : null,
        craftCategory: _registerRole == 'ARTISAN' ? _selectedCategory : null,
        clusterLocation: _registerRole == 'ARTISAN' ? _regClusterController.text.trim() : null,
        aadhaarNumber: _registerRole == 'ARTISAN' ? _regAadhaarController.text.trim() : null,
        organization: _registerRole == 'BUYER' ? _regOrgController.text.trim() : null,
      );

      if (user != null && mounted) {
        _showSnackbar('Account created successfully! Welcome to Karighar.'.tr);
        _navigateForUser(user.role);
        return;
      }
      _showSnackbar('Registration failed. Please try again.'.tr, isError: true);
    } catch (e) {
      _showSnackbar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _quickLogin(String role) async {
    setState(() => _isLoading = true);
    final user = await ApiClient.login(role: role);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (user != null) {
      _navigateForUser(user.role);
    }
  }

  void _navigateForUser(String role) {
    switch (role.toUpperCase()) {
      case 'BUYER':
        context.go('/buyer');
        break;
      case 'MOSJE_OFFICER':
      case 'ADMIN':
        context.go('/admin');
        break;
      case 'ARTISAN':
      default:
        context.go('/artisan');
        break;
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.teal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // Karighar Brand Insignia
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.45), width: 2.5),
                        boxShadow: AppColors.saffronGlow,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/karighar_logo.png',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.saffronGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.home_repair_service_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'KARIGHAR',
                      style: GoogleFonts.cinzel(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A HOME FOR ARTISANS • कारीघर',
                      style: GoogleFonts.rozhaOne(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.saffronDark,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'CRAFT • CULTURE • COMMUNITY • OPPORTUNITY'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Auth Card with Segmented Tabs
                    VKCard(
                      gradient: AppColors.cardGradient,
                      customShadow: AppColors.elevatedShadow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Modern Animated Dual Selection Button (Login / Register)
                          _buildTabSelector(),
                          const SizedBox(height: 18),

                          // Tab Content
                          AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, _) {
                              return _tabController.index == 0
                                  ? _buildLoginView()
                                  : _buildRegisterView();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ministry of Social Justice & Empowerment Verified Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.tealLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user_rounded, color: AppColors.teal, size: 16),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Protected by Ministry of Social Justice & Empowerment'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tealDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back to Marketplace Button (Placed AFTER Center for topmost hit-testing)
            Positioned(
              top: 14,
              left: 18,
              child: Tooltip(
                message: 'Back to Marketplace'.tr,
                child: InkWell(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/buyer');
                    }
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.cardBorder, width: 1.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 17, color: AppColors.textPrimary),
                  ),
                ),
              ),
            ),

            // Top Language Switcher Pill (Placed AFTER Center for topmost hit-testing)
            Positioned(
              top: 14,
              right: 18,
              child: ValueListenableBuilder<AppLanguage>(
                valueListenable: LocaleManager.currentLanguage,
                builder: (context, currentLang, _) {
                  return PopupMenuButton<AppLanguage>(
                    tooltip: 'Change Language'.tr,
                    offset: const Offset(0, 40),
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    onSelected: (lang) {
                      LocaleManager.setLanguage(lang);
                      if (mounted) setState(() {});
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: AppLanguage.english,
                        child: Row(
                          children: [
                            Text('🇬🇧  English (EN)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: AppLanguage.hindi,
                        child: Row(
                          children: [
                            Text('🇮🇳  हिंदी (Hindi)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: AppLanguage.tamil,
                        child: Row(
                          children: [
                            Text('🇮🇳  தமிழ் (Tamil)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.cardBorder, width: 1.2),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language_rounded, size: 16, color: AppColors.teal),
                          const SizedBox(width: 5),
                          Text(
                            LocaleManager.getLanguageLabel(currentLang),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Icons.arrow_drop_down_rounded, size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ANIMATED DUAL TAB SELECTOR (LOGIN VS REGISTER)
  // ---------------------------------------------------------------------------
  Widget _buildTabSelector() {
    final isLogin = _tabController.index == 0;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          // LOGIN SELECTION BUTTON
          Expanded(
            child: InkWell(
              onTap: () {
                if (_tabController.index != 0) {
                  _tabController.animateTo(0);
                  setState(() {});
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: isLogin ? AppColors.saffronGradient : null,
                  color: isLogin ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isLogin ? AppColors.saffronGlow : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 17,
                        color: isLogin ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Login'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isLogin ? FontWeight.bold : FontWeight.w600,
                          color: isLogin ? Colors.white : AppColors.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // REGISTER SELECTION BUTTON
          Expanded(
            child: InkWell(
              onTap: () {
                if (_tabController.index != 1) {
                  _tabController.animateTo(1);
                  setState(() {});
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: !isLogin ? AppColors.saffronGradient : null,
                  color: !isLogin ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !isLogin ? AppColors.saffronGlow : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 17,
                        color: !isLogin ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Register'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: !isLogin ? FontWeight.bold : FontWeight.w600,
                          color: !isLogin ? Colors.white : AppColors.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOGIN VIEW
  // ---------------------------------------------------------------------------
  Widget _buildLoginView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode Switcher: Mobile OTP vs Email/Password
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
            ),
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => setState(() => _isOtpMode = true),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isOtpMode ? AppColors.saffronLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _isOtpMode ? AppColors.saffron : Colors.transparent),
                      boxShadow: _isOtpMode
                          ? [BoxShadow(color: AppColors.saffron.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1))]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone_iphone_rounded, size: 14, color: _isOtpMode ? AppColors.saffronDark : AppColors.textSecondary),
                        const SizedBox(width: 5),
                        Text(
                          'Mobile OTP'.tr,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: _isOtpMode ? FontWeight.bold : FontWeight.w500,
                            color: _isOtpMode ? AppColors.saffronDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => setState(() => _isOtpMode = false),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: !_isOtpMode ? AppColors.tealLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: !_isOtpMode ? AppColors.teal : Colors.transparent),
                      boxShadow: !_isOtpMode
                          ? [BoxShadow(color: AppColors.teal.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1))]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 14, color: !_isOtpMode ? AppColors.tealDark : AppColors.textSecondary),
                        const SizedBox(width: 5),
                        Text(
                          'Email & Password'.tr,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: !_isOtpMode ? FontWeight.bold : FontWeight.w500,
                            color: !_isOtpMode ? AppColors.tealDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (_isOtpMode) ...[
          // MOBILE OTP FLOW
          Text('Mobile Number'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _loginPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.saffron, size: 20),
                    hintText: '+91 98765 43210',
                    filled: true,
                    fillColor: AppColors.background,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: (_isLoading || _countdownSeconds > 0) ? null : _handleSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    _countdownSeconds > 0 ? '${_countdownSeconds}s' : (_otpSent ? 'Resend OTP'.tr : 'Send OTP'.tr),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text('One Time Password (OTP)'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _loginOtpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: const Icon(Icons.lock_clock_rounded, color: AppColors.teal, size: 20),
              hintText: 'Enter 4-digit OTP'.tr,
              filled: true,
              fillColor: AppColors.background,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            ),
          ),
        ] else ...[
          // EMAIL & PASSWORD FLOW
          Text('Email Address'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.teal, size: 20),
              hintText: 'ramdev@karighar.gov.in',
              filled: true,
              fillColor: AppColors.background,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            ),
          ),
          const SizedBox(height: 14),

          Text('Password'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _loginPasswordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.saffron, size: 20),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18, color: AppColors.textSecondary),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              hintText: '••••••••',
              filled: true,
              fillColor: AppColors.background,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Submit Button
        VKButton(
          label: _isLoading ? 'Authenticating...' : 'Sign In & Continue'.tr,
          icon: Icons.login_rounded,
          onPressed: _isLoading ? null : _handleLogin,
        ),

        const SizedBox(height: 20),

        // 1-Tap Evaluator Quick Access (Hackathon & Demo Accelerator)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceWarm,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on_rounded, size: 15, color: AppColors.gold),
                  const SizedBox(width: 4),
                  Text(
                    '1-Tap Evaluator Quick Access'.tr,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(color: AppColors.saffron, width: 0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _quickLogin('ARTISAN'),
                      child: const Text('🎨 Artisan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.saffronDark)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(color: AppColors.teal, width: 0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _quickLogin('BUYER'),
                      child: const Text('🛍️ Buyer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: const BorderSide(color: AppColors.purple, width: 0.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _quickLogin('MOSJE_OFFICER'),
                      child: const Text('🛡️ Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.purple)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Quick Switch to Register Selection Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.saffronLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.saffron.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, size: 16, color: AppColors.saffronDark),
                  const SizedBox(width: 8),
                  Text(
                    "Don't have an account?".tr,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _tabController.animateTo(1);
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Register Now'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.saffronDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.saffronDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // REGISTER VIEW
  // ---------------------------------------------------------------------------
  Widget _buildRegisterView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Role Selector: Artisan vs Buyer
        Text('I am registering as'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _registerRole = 'ARTISAN'),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _registerRole == 'ARTISAN' ? AppColors.saffronLight : AppColors.background,
                    border: Border.all(
                      color: _registerRole == 'ARTISAN' ? AppColors.saffron : AppColors.cardBorder,
                      width: _registerRole == 'ARTISAN' ? 1.6 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _registerRole == 'ARTISAN'
                        ? [BoxShadow(color: AppColors.saffron.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.palette_rounded, size: 16, color: _registerRole == 'ARTISAN' ? AppColors.saffronDark : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Artisan / Weaver'.tr,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: _registerRole == 'ARTISAN' ? AppColors.saffronDark : AppColors.textSecondary,
                        ),
                      ),
                      if (_registerRole == 'ARTISAN') ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.saffronDark),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _registerRole = 'BUYER'),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _registerRole == 'BUYER' ? AppColors.tealLight : AppColors.background,
                    border: Border.all(
                      color: _registerRole == 'BUYER' ? AppColors.teal : AppColors.cardBorder,
                      width: _registerRole == 'BUYER' ? 1.6 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _registerRole == 'BUYER'
                        ? [BoxShadow(color: AppColors.teal.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_rounded, size: 16, color: _registerRole == 'BUYER' ? AppColors.tealDark : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Buyer / Enterprise'.tr,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: _registerRole == 'BUYER' ? AppColors.tealDark : AppColors.textSecondary,
                        ),
                      ),
                      if (_registerRole == 'BUYER') ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.tealDark),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Full Name
        Text('Full Name'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _regNameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.saffron, size: 20),
            hintText: 'Enter your full name'.tr,
            filled: true,
            fillColor: AppColors.background,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
          ),
        ),
        const SizedBox(height: 14),

        // Mobile Number
        Text('Mobile Number'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _regPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.saffron, size: 20),
            hintText: '+91 98765 43210',
            filled: true,
            fillColor: AppColors.background,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
          ),
        ),
        const SizedBox(height: 14),

        // Role-Specific Fields
        if (_registerRole == 'ARTISAN') ...[
          // Craft Category
          Text('Craft Category'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.saffron),
                items: _craftCategories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.tr, style: const TextStyle(fontSize: 12.5)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // State / Cluster Location
          Text('State / Cluster'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _regClusterController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.saffron, size: 20),
              hintText: 'Varanasi, Uttar Pradesh',
              filled: true,
              fillColor: AppColors.background,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            ),
          ),
          const SizedBox(height: 14),

          // Aadhaar / PM-Vishwakarma ID (Optional)
          Text('Aadhaar / PM-Vishwakarma ID'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _regAadhaarController,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: const Icon(Icons.fingerprint_rounded, color: AppColors.teal, size: 20),
              hintText: '12-digit Aadhaar / PMV ID',
              filled: true,
              fillColor: AppColors.background,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            ),
          ),
        ] else ...[
          // Buyer Organization
          Text('Organization / Business Name'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _regOrgController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.corporate_fare_rounded, color: AppColors.teal, size: 20),
              hintText: 'FabIndia, Oberoi Hotels, or Independent',
              filled: true,
              fillColor: AppColors.background,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            ),
          ),
        ],
        const SizedBox(height: 14),

        // Optional Email & Password
        Text('Password'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _regPasswordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.saffron, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18, color: AppColors.textSecondary),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            hintText: 'Create 6+ character password',
            filled: true,
            fillColor: AppColors.background,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
          ),
        ),

        const SizedBox(height: 22),

        // Register Button
        VKButton(
          label: _isLoading ? 'Registering...' : 'Create Account'.tr,
          icon: Icons.person_add_rounded,
          onPressed: _isLoading ? null : _handleRegister,
        ),

        const SizedBox(height: 16),

        // Quick Switch to Login Selection Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.tealLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.teal.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.login_rounded, size: 16, color: AppColors.tealDark),
                  const SizedBox(width: 8),
                  Text(
                    'Already have an account?'.tr,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _tabController.animateTo(0);
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In here'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.tealDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
