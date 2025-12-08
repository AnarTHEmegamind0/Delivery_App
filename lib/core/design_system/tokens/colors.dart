import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Primary Colors
  static const Color primaryGreen = Color(0xFF00D4A1); // Emerald-teal
  static const Color primaryGreenLight = Color(0xFF00B894); // Deeper hue for light mode
  static const Color accentGold = Color(0xFFFFCB45);
  static const Color accentGoldLight = Color(0xF59E0B);

  // Status Colors
  static const Color success = Color(0xFF00D4A1);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFCB45);
  static const Color info = Color(0xFF2196F3);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F1116);
  static const Color darkSurface = Color(0xFF16181D);
  static const Color darkCard = Color(0xFF1E2128);
  static const Color darkBorder = Color(0xFF272B35);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE4E4E7);
  static const Color lightTextPrimary = Color(0xFF0F1116);
  static const Color lightTextSecondary = Color(0xFF52525B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF), // White with 10% opacity
      Color(0x0DFFFFFF), // White with 5% opacity
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
