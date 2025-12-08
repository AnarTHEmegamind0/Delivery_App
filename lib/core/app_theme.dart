import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_system/tokens/colors.dart';
import 'design_system/tokens/typography.dart';

class AppTheme {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Compatibility Colors (Bridging to new AppColors)
  static const Color primaryColor = AppColors.primaryGreen;
  static const Color secondaryColor = AppColors.primaryGreenLight;
  static const Color accentColor = AppColors.accentGold;
  static const Color backgroundColor = AppColors.lightBackground;
  static const Color surfaceColor = AppColors.lightSurface;
  static const Color errorColor = AppColors.error;
  static const Color successColor = AppColors.success;
  static const Color warningColor = AppColors.warning;

  // Compatibility Text Colors
  static const Color textPrimary = AppColors.lightTextPrimary;
  static const Color textSecondary = AppColors.lightTextSecondary;
  static const Color textLight = Color(
    0xFFB2BEC3,
  ); // Original value or close approximation
  static const Color textDark = AppColors.darkTextPrimary;

  // Compatibility Gradients
  static const LinearGradient primaryGradient = AppColors.primaryGradient;

  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accentGoldLight, AppColors.accentGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.primaryGreenLight, AppColors.primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreenLight,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreenLight,
        secondary: AppColors.accentGoldLight,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        onError: Colors.white,
        outline: AppColors.lightBorder,
      ),
      textTheme: _buildTextTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2, // Subtle shadow for light mode
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: AppTypography.h2.copyWith(
          color: AppColors.lightTextPrimary,
        ),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.lightSurface,
        borderColor: AppColors.lightBorder,
        focusedColor: AppColors.primaryGreenLight,
        textColor: AppColors.lightTextPrimary,
        hintColor: AppColors.lightTextSecondary,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        AppColors.primaryGreenLight,
        Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.accentGold,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.error,
        onPrimary: Colors.black, // Better contrast on bright green
        onSecondary: Colors.black,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
        outline: AppColors.darkBorder,
      ),
      textTheme: _buildTextTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: AppTypography.h2.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: AppColors.darkSurface,
        borderColor: AppColors.darkBorder,
        focusedColor: AppColors.primaryGreen,
        textColor: AppColors.darkTextPrimary,
        hintColor: AppColors.darkTextSecondary,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        AppColors.primaryGreen,
        Colors.black,
      ), // Black text on green
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
    );
  }

  // Helpers
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayMedium: AppTypography.display.copyWith(color: primary),
      headlineLarge: AppTypography.h1.copyWith(color: primary),
      headlineMedium: AppTypography.h2.copyWith(color: primary),
      bodyLarge: AppTypography.body.copyWith(color: primary),
      bodyMedium: AppTypography.body.copyWith(
        color: secondary,
      ), // Usually secondary text
      labelLarge: AppTypography.button.copyWith(color: primary),
      bodySmall: AppTypography.caption.copyWith(color: secondary),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedColor,
    required Color textColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusedColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: TextStyle(color: hintColor),
      hintStyle: TextStyle(color: hintColor),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    Color bgColor,
    Color fgColor,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.button,
      ),
    );
  }
}
