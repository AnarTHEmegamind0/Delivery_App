import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pinterest-inspired typography system
/// Clean, modern type scale with excellent readability
class AppTypography {
  AppTypography._();

  // ============================================================
  // FONT FAMILIES
  // ============================================================

  /// Primary font for UI text
  static String get fontFamily => GoogleFonts.inter().fontFamily!;

  /// Display font for large headlines (optional: use a display font)
  static String get displayFontFamily => GoogleFonts.inter().fontFamily!;

  /// Monospace font for numbers and code
  static String get monoFontFamily => GoogleFonts.jetBrainsMono().fontFamily!;

  // ============================================================
  // FONT SIZES (modular scale: 1.25 ratio)
  // ============================================================

  static const double sizeXxs = 10.0;
  static const double sizeXs = 12.0;
  static const double sizeSm = 14.0;
  static const double sizeMd = 16.0;
  static const double sizeLg = 18.0;
  static const double sizeXl = 20.0;
  static const double sizeXxl = 24.0;
  static const double sizeDisplay3 = 28.0;
  static const double sizeDisplay2 = 32.0;
  static const double sizeDisplay1 = 40.0;
  static const double sizeHero = 48.0;
  static const double sizeMega = 56.0;

  // ============================================================
  // FONT WEIGHTS
  // ============================================================

  static const FontWeight weightThin = FontWeight.w100;
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  // ============================================================
  // LINE HEIGHTS
  // ============================================================

  static const double lineHeightTight = 1.1;
  static const double lineHeightSnug = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.625;
  static const double lineHeightLoose = 2.0;

  // ============================================================
  // LETTER SPACING
  // ============================================================

  static const double letterSpacingTighter = -0.05;
  static const double letterSpacingTight = -0.025;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.025;
  static const double letterSpacingWider = 0.05;
  static const double letterSpacingWidest = 0.1;

  // ============================================================
  // DISPLAY STYLES (for hero sections, large numbers)
  // ============================================================

  /// Mega display - 56px, for dramatic hero numbers
  static TextStyle get mega => GoogleFonts.inter(
        fontSize: sizeMega,
        fontWeight: weightBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTighter,
      );

  /// Hero display - 48px, for main headlines
  static TextStyle get hero => GoogleFonts.inter(
        fontSize: sizeHero,
        fontWeight: weightBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTighter,
      );

  /// Display 1 - 40px
  static TextStyle get display1 => GoogleFonts.inter(
        fontSize: sizeDisplay1,
        fontWeight: weightBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  /// Display 2 - 32px
  static TextStyle get display2 => GoogleFonts.inter(
        fontSize: sizeDisplay2,
        fontWeight: weightBold,
        height: lineHeightSnug,
        letterSpacing: letterSpacingTight,
      );

  /// Display 3 - 28px
  static TextStyle get display3 => GoogleFonts.inter(
        fontSize: sizeDisplay3,
        fontWeight: weightSemiBold,
        height: lineHeightSnug,
        letterSpacing: letterSpacingTight,
      );

  // ============================================================
  // HEADING STYLES
  // ============================================================

  /// H1 - 24px bold
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: sizeXxl,
        fontWeight: weightBold,
        height: lineHeightSnug,
      );

  /// H2 - 20px semibold
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: sizeXl,
        fontWeight: weightSemiBold,
        height: lineHeightSnug,
      );

  /// H3 - 18px semibold
  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: sizeLg,
        fontWeight: weightSemiBold,
        height: lineHeightSnug,
      );

  /// H4 - 16px semibold
  static TextStyle get h4 => GoogleFonts.inter(
        fontSize: sizeMd,
        fontWeight: weightSemiBold,
        height: lineHeightNormal,
      );

  // ============================================================
  // BODY STYLES
  // ============================================================

  /// Body large - 18px
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: sizeLg,
        fontWeight: weightRegular,
        height: lineHeightRelaxed,
      );

  /// Body - 16px (default)
  static TextStyle get body => GoogleFonts.inter(
        fontSize: sizeMd,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  /// Body medium - 16px medium weight
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: sizeMd,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  /// Body small - 14px
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: sizeSm,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  // ============================================================
  // UI STYLES
  // ============================================================

  /// Button text - 16px semibold
  static TextStyle get button => GoogleFonts.inter(
        fontSize: sizeMd,
        fontWeight: weightSemiBold,
        height: 1.0,
        letterSpacing: letterSpacingWide,
      );

  /// Button small - 14px semibold
  static TextStyle get buttonSmall => GoogleFonts.inter(
        fontSize: sizeSm,
        fontWeight: weightSemiBold,
        height: 1.0,
        letterSpacing: letterSpacingWide,
      );

  /// Label large - 16px medium
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: sizeMd,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  /// Label - 14px medium
  static TextStyle get label => GoogleFonts.inter(
        fontSize: sizeSm,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  /// Label small - 12px medium
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: sizeXs,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  /// Caption - 12px
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: sizeXs,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  /// Overline - 10px uppercase
  static TextStyle get overline => GoogleFonts.inter(
        fontSize: sizeXxs,
        fontWeight: weightSemiBold,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWidest,
      );

  // ============================================================
  // NUMERIC STYLES (for earnings, stats, counters)
  // ============================================================

  /// Large number display - 48px mono
  static TextStyle get numberHero => GoogleFonts.jetBrainsMono(
        fontSize: sizeHero,
        fontWeight: weightBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  /// Medium number display - 32px mono
  static TextStyle get numberLarge => GoogleFonts.jetBrainsMono(
        fontSize: sizeDisplay2,
        fontWeight: weightBold,
        height: lineHeightTight,
      );

  /// Standard number - 24px mono
  static TextStyle get number => GoogleFonts.jetBrainsMono(
        fontSize: sizeXxl,
        fontWeight: weightSemiBold,
        height: lineHeightSnug,
      );

  /// Small number - 16px mono
  static TextStyle get numberSmall => GoogleFonts.jetBrainsMono(
        fontSize: sizeMd,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  // ============================================================
  // LEGACY SUPPORT
  // ============================================================

  @Deprecated('Use hero instead')
  static TextStyle get display => hero;

  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  static const double displaySize = sizeHero;
  static const double h1Size = sizeXxl;
  static const double h2Size = sizeXl;
  static const double bodySize = sizeMd;
  static const double captionSize = sizeXs;
}
