import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Private constructor
  AppTypography._();

  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme();
  }

  // Font Sizes
  static const double displaySize = 48.0;
  static const double h1Size = 32.0;
  static const double h2Size = 24.0;
  static const double bodySize = 16.0;
  static const double captionSize = 14.0;

  // Text Styles
  static TextStyle get display => GoogleFonts.inter(
    fontSize: displaySize,
    fontWeight: FontWeight.w500, // Medium
    height: 1.2,
  );

  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: h1Size,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: h2Size,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: bodySize,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: captionSize,
    fontWeight: FontWeight.w500, // Medium
    height: 1.4,
  );
  
  static TextStyle get button => GoogleFonts.inter(
    fontSize: bodySize,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.0,
  );
}
