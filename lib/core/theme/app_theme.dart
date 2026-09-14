import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
export '../l10n/locale_manager.dart';

class AppColors {
  AppColors._();

  // Premium Indian Craft Heritage Palette
  static const Color saffron = Color(0xFFE05A1B);
  static const Color saffronDark = Color(0xFFB4380D);
  static const Color saffronLight = Color(0xFFFEF3C7);

  static const Color teal = Color(0xFF0D6E6E);
  static const Color tealDark = Color(0xFF094E4E);
  static const Color tealLight = Color(0xFFE6F7F5);

  static const Color gold = Color(0xFFD97706);
  static const Color goldLight = Color(0xFFFFFBEB);

  // Artisanal Luxury & Provenance Palette (Flipkart/Etsy Benchmark)
  static const Color terracotta = Color(0xFFD9531E);
  static const Color terracottaLight = Color(0xFFFEECE4);
  static const Color royalIndigo = Color(0xFF1A2B4C);
  static const Color royalIndigoDark = Color(0xFF0F1A2E);
  static const Color royalIndigoLight = Color(0xFFE9EDF5);
  static const Color zariGold = Color(0xFFD97706);
  static const Color zariGoldLight = Color(0xFFFEF3C7);
  static const Color emeraldDeep = Color(0xFF0D6E6E);

  // Warm Artisanal Parchment & Silk Canvas
  static const Color background = Color(0xFFFAF7F2);
  static const Color parchmentSilk = Color(0xFFFAF7F2);
  static const Color surface = Colors.white;
  static const Color surfaceWarm = Color(0xFFFBF8F3);
  static const Color surfaceDark = Color(0xFF1C1917);

  static const Color cardBorder = Color(0xFFEFE7DA);
  static const Color divider = Color(0xFFF5EFE6);

  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textLight = Color(0xFFA8A29E);

  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFF5F3FF);

  // Brand Heritage Gradients
  static const LinearGradient saffronGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0A4F4F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFFCFAF7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Soft Heritage Drop Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x082B1805),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x122B1805),
      blurRadius: 22,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x082B1805),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> saffronGlow = [
    BoxShadow(
      color: Color(0x35E05A1B),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> tealGlow = [
    BoxShadow(
      color: Color(0x350D6E6E),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.saffron,
        primary: AppColors.saffron,
        secondary: AppColors.teal,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
    );
  }
}
