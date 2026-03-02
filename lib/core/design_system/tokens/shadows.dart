import 'package:flutter/material.dart';

/// Pinterest-inspired shadow system with 8 elevation levels
/// Creates depth and visual hierarchy in the UI
class AppShadows {
  AppShadows._();

  // Shadow colors for light and dark modes
  static const Color _lightShadowColor = Color(0x1A000000);
  static const Color _darkShadowColor = Color(0x40000000);

  /// Level 0: No shadow (flat)
  static const List<BoxShadow> none = [];

  /// Level 0.5: Extra subtle lift - for minimal depth
  static List<BoxShadow> xs({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 2,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Level 1: Subtle lift - for resting cards
  static List<BoxShadow> sm({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 4,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Level 2: Light elevation - for interactive elements
  static List<BoxShadow> md({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: isDark
              ? _darkShadowColor.withOpacity(0.1)
              : _lightShadowColor.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Level 3: Medium elevation - for cards on hover
  static List<BoxShadow> lg({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: isDark
              ? _darkShadowColor.withOpacity(0.15)
              : _lightShadowColor.withOpacity(0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Level 4: High elevation - for floating elements
  static List<BoxShadow> xl({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: isDark
              ? _darkShadowColor.withOpacity(0.2)
              : _lightShadowColor.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Level 5: Modal elevation - for bottom sheets and dialogs
  static List<BoxShadow> xxl({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 32,
          offset: const Offset(0, 12),
          spreadRadius: -4,
        ),
        BoxShadow(
          color: isDark
              ? _darkShadowColor.withOpacity(0.25)
              : _lightShadowColor.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
      ];

  /// Level 6: Dramatic elevation - for popovers
  static List<BoxShadow> xxxl({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 48,
          offset: const Offset(0, 16),
          spreadRadius: -8,
        ),
        BoxShadow(
          color: isDark
              ? _darkShadowColor.withOpacity(0.3)
              : _lightShadowColor.withOpacity(0.15),
          blurRadius: 16,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ];

  /// Level 7: Maximum elevation - for overlay modals
  static List<BoxShadow> max({bool isDark = false}) => [
        BoxShadow(
          color: isDark ? _darkShadowColor : _lightShadowColor,
          blurRadius: 64,
          offset: const Offset(0, 24),
          spreadRadius: -12,
        ),
        BoxShadow(
          color: isDark
              ? _darkShadowColor.withOpacity(0.35)
              : _lightShadowColor.withOpacity(0.18),
          blurRadius: 24,
          offset: const Offset(0, 12),
          spreadRadius: 0,
        ),
      ];

  /// Glow shadow - for accent/CTA elements
  static List<BoxShadow> glow(Color color, {double intensity = 0.4}) => [
        BoxShadow(
          color: color.withOpacity(intensity),
          blurRadius: 20,
          offset: const Offset(0, 4),
          spreadRadius: -4,
        ),
        BoxShadow(
          color: color.withOpacity(intensity * 0.5),
          blurRadius: 40,
          offset: const Offset(0, 8),
          spreadRadius: -8,
        ),
      ];

  /// Inner shadow - for pressed/inset states
  static List<BoxShadow> inner({bool isDark = false}) => [
        BoxShadow(
          color: isDark
              ? const Color(0x40000000)
              : const Color(0x15000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -1,
        ),
      ];
}
