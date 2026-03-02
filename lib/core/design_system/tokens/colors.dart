import 'package:flutter/material.dart';

/// Pinterest-inspired color system with rich gradients and overlay colors
/// Designed for award-quality visual aesthetics
class AppColors {
  AppColors._();

  // ============================================================
  // PRIMARY COLORS
  // ============================================================

  /// Primary emerald-teal for dark mode
  static const Color primaryGreen = Color(0xFF00D4A1);

  /// Primary green for light mode (slightly deeper)
  static const Color primaryGreenLight = Color(0xFF00B894);

  /// Primary green darker variant
  static const Color primaryGreenDark = Color(0xFF00A080);

  /// Accent gold
  static const Color accentGold = Color(0xFFFFCB45);

  /// Accent gold for light mode
  static const Color accentGoldLight = Color(0xFFF59E0B);

  /// Accent gold darker variant
  static const Color accentGoldDark = Color(0xFFD97706);

  // ============================================================
  // STATUS COLORS
  // ============================================================

  static const Color success = Color(0xFF00D4A1);
  static const Color successLight = Color(0xFF34EAC7);
  static const Color successDark = Color(0xFF00A080);

  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFF8A8A);
  static const Color errorDark = Color(0xFFE53E3E);

  static const Color warning = Color(0xFFFFCB45);
  static const Color warningLight = Color(0xFFFFD966);
  static const Color warningDark = Color(0xFFD97706);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  /// Alias for info blue
  static const Color infoBlue = info;

  /// Alias for error red
  static const Color errorRed = error;

  // ============================================================
  // DARK THEME PALETTE
  // ============================================================

  static const Color darkBackground = Color(0xFF0A0B0E);
  static const Color darkSurface = Color(0xFF12141A);
  static const Color darkCard = Color(0xFF1A1D24);
  static const Color darkCardHover = Color(0xFF22262F);
  static const Color darkBorder = Color(0xFF2A2F3A);
  static const Color darkBorderSubtle = Color(0xFF1F232B);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);
  static const Color darkTextDisabled = Color(0xFF4B5563);

  // ============================================================
  // LIGHT THEME PALETTE
  // ============================================================

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardHover = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightTextDisabled = Color(0xFFCBD5E1);

  // ============================================================
  // IMAGE OVERLAY COLORS
  // ============================================================

  /// Dark overlay for text on images (40% opacity)
  static const Color imageOverlayDark = Color(0x66000000);

  /// Darker overlay for better text contrast (60% opacity)
  static const Color imageOverlayDarker = Color(0x99000000);

  /// Gradient overlay for Pinterest-style cards
  static const Color imageOverlayGradientStart = Color(0x00000000);
  static const Color imageOverlayGradientEnd = Color(0xCC000000);

  /// Light overlay for dark images
  static const Color imageOverlayLight = Color(0x33FFFFFF);

  // ============================================================
  // GLASSMORPHISM COLORS
  // ============================================================

  /// Glass background for dark mode
  static const Color glassDark = Color(0x1AFFFFFF);

  /// Glass background for light mode
  static const Color glassLight = Color(0x80FFFFFF);

  /// Glass border for dark mode
  static const Color glassBorderDark = Color(0x33FFFFFF);

  /// Glass border for light mode
  static const Color glassBorderLight = Color(0x66FFFFFF);

  // ============================================================
  // GRADIENTS
  // ============================================================

  /// Primary gradient (emerald teal)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D4A1), Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient with glow effect
  static const LinearGradient primaryGradientVibrant = LinearGradient(
    colors: [Color(0xFF00F5B8), Color(0xFF00D4A1), Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gold/amber gradient
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD966), Color(0xFFFFCB45), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sunset gradient (for earnings/rewards)
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFCB45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ocean gradient (for navigation)
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF00D4A1), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark surface gradient
  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1A1D24), Color(0xFF12141A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Glass gradient for dark mode
  static const LinearGradient glassGradientDark = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Glass gradient for light mode
  static const LinearGradient glassGradientLight = LinearGradient(
    colors: [Color(0xB3FFFFFF), Color(0x80FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Image overlay gradient (bottom fade)
  static const LinearGradient imageOverlayGradient = LinearGradient(
    colors: [Color(0x00000000), Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Hero section gradient
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF00D4A1), Color(0xFF00B894), Color(0xFF009B7D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Shimmer gradient for loading states
  static LinearGradient shimmerGradient(bool isDark) => LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF1A1D24),
                const Color(0xFF2A2F3A),
                const Color(0xFF1A1D24),
              ]
            : [
                const Color(0xFFE2E8F0),
                const Color(0xFFF1F5F9),
                const Color(0xFFE2E8F0),
              ],
        stops: const [0.0, 0.5, 1.0],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
      );

  // ============================================================
  // LEGACY SUPPORT (for backwards compatibility)
  // ============================================================

  @Deprecated('Use glassGradientDark or glassGradientLight instead')
  static const LinearGradient glassGradient = glassGradientDark;

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Get theme-aware color
  static Color adaptive(
    BuildContext context, {
    required Color light,
    required Color dark,
  }) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  /// Get background color for current theme
  static Color background(BuildContext context) {
    return adaptive(context, light: lightBackground, dark: darkBackground);
  }

  /// Get surface color for current theme
  static Color surface(BuildContext context) {
    return adaptive(context, light: lightSurface, dark: darkSurface);
  }

  /// Get card color for current theme
  static Color card(BuildContext context) {
    return adaptive(context, light: lightCard, dark: darkCard);
  }

  /// Get primary text color for current theme
  static Color textPrimary(BuildContext context) {
    return adaptive(context, light: lightTextPrimary, dark: darkTextPrimary);
  }

  /// Get secondary text color for current theme
  static Color textSecondary(BuildContext context) {
    return adaptive(
        context, light: lightTextSecondary, dark: darkTextSecondary);
  }

  /// Get border color for current theme
  static Color border(BuildContext context) {
    return adaptive(context, light: lightBorder, dark: darkBorder);
  }

  /// Get glass gradient for current theme
  static LinearGradient glassGradientAdaptive(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? glassGradientDark
        : glassGradientLight;
  }
}
