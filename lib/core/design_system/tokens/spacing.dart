import 'package:flutter/material.dart';

/// Pinterest-inspired spacing system
/// Based on 4px grid with generous whitespace for visual breathing room
class AppSpacing {
  AppSpacing._();

  // ============================================================
  // BASE SPACING SCALE (4px grid)
  // ============================================================

  /// 0px - No spacing
  static const double zero = 0;

  /// 2px - Hairline spacing
  static const double xxxs = 2;

  /// 4px - Micro spacing
  static const double xxs = 4;

  /// 8px - Extra small spacing
  static const double xs = 8;

  /// 12px - Small spacing
  static const double sm = 12;

  /// 16px - Medium spacing (base)
  static const double md = 16;

  /// 20px - Medium-large spacing
  static const double lg = 20;

  /// 24px - Large spacing
  static const double xl = 24;

  /// 32px - Extra large spacing
  static const double xxl = 32;

  /// 40px - 2X extra large spacing
  static const double xxxl = 40;

  /// 48px - Section spacing
  static const double section = 48;

  /// 56px - Large section spacing
  static const double sectionLg = 56;

  /// 64px - Page spacing
  static const double page = 64;

  /// 80px - Hero spacing
  static const double hero = 80;

  /// 96px - Maximum spacing
  static const double max = 96;

  // ============================================================
  // SEMANTIC SPACING
  // ============================================================

  /// Padding inside cards
  static const double cardPadding = md;

  /// Padding inside cards (large)
  static const double cardPaddingLg = xl;

  /// Gap between list items
  static const double listGap = sm;

  /// Gap between grid items
  static const double gridGap = md;

  /// Page horizontal padding
  static const double pageHorizontal = lg;

  /// Page vertical padding
  static const double pageVertical = xl;

  /// Section vertical spacing
  static const double sectionGap = xxxl;

  /// Icon to text gap
  static const double iconGap = xs;

  /// Button internal padding horizontal
  static const double buttonPaddingH = xl;

  /// Button internal padding vertical
  static const double buttonPaddingV = md;

  /// Input field padding
  static const double inputPadding = md;

  /// Modal padding
  static const double modalPadding = xl;

  /// Bottom sheet padding
  static const double sheetPadding = xl;

  // ============================================================
  // EDGE INSETS PRESETS
  // ============================================================

  /// No padding
  static const EdgeInsets insetZero = EdgeInsets.zero;

  /// All sides xs (8px)
  static const EdgeInsets insetXs = EdgeInsets.all(xs);

  /// All sides sm (12px)
  static const EdgeInsets insetSm = EdgeInsets.all(sm);

  /// All sides md (16px)
  static const EdgeInsets insetMd = EdgeInsets.all(md);

  /// All sides lg (20px)
  static const EdgeInsets insetLg = EdgeInsets.all(lg);

  /// All sides xl (24px)
  static const EdgeInsets insetXl = EdgeInsets.all(xl);

  /// All sides xxl (32px)
  static const EdgeInsets insetXxl = EdgeInsets.all(xxl);

  /// Page padding (horizontal: 20, vertical: 24)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: pageHorizontal,
    vertical: pageVertical,
  );

  /// Screen inset padding (horizontal only)
  static const EdgeInsets screenInset = EdgeInsets.symmetric(
    horizontal: pageHorizontal,
  );

  /// Card padding (all: 16)
  static const EdgeInsets cardInset = EdgeInsets.all(cardPadding);

  /// Card padding large (all: 24)
  static const EdgeInsets cardInsetLg = EdgeInsets.all(cardPaddingLg);

  /// Horizontal only padding (md)
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal only padding (lg)
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal only padding (xl)
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  /// Vertical only padding (md)
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Vertical only padding (lg)
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  /// Vertical only padding (xl)
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  /// Bottom sheet padding
  static const EdgeInsets sheetInset = EdgeInsets.fromLTRB(
    sheetPadding,
    sm,
    sheetPadding,
    sheetPadding,
  );

  /// Safe area with page padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.fromLTRB(
      pageHorizontal,
      mediaQuery.padding.top + md,
      pageHorizontal,
      mediaQuery.padding.bottom + md,
    );
  }

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  /// No radius
  static const double radiusNone = 0;

  /// Extra small radius (4px)
  static const double radiusXs = 4;

  /// Small radius (8px)
  static const double radiusSm = 8;

  /// Medium radius (12px)
  static const double radiusMd = 12;

  /// Large radius (16px)
  static const double radiusLg = 16;

  /// Extra large radius (20px)
  static const double radiusXl = 20;

  /// 2X extra large radius (24px)
  static const double radiusXxl = 24;

  /// 3X extra large radius (32px)
  static const double radiusXxxl = 32;

  /// Full/pill radius (999px)
  static const double radiusFull = 999;

  // ============================================================
  // BORDER RADIUS PRESETS
  // ============================================================

  /// Small border radius
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );

  /// Medium border radius
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );

  /// Large border radius
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );

  /// Extra large border radius
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  /// 2X extra large border radius
  static const BorderRadius borderRadiusXxl = BorderRadius.all(
    Radius.circular(radiusXxl),
  );

  /// Full/pill border radius
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  /// Top only large radius (for bottom sheets)
  static const BorderRadius borderRadiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(radiusXl),
    topRight: Radius.circular(radiusXl),
  );

  /// Top only extra large radius
  static const BorderRadius borderRadiusTopXl = BorderRadius.only(
    topLeft: Radius.circular(radiusXxl),
    topRight: Radius.circular(radiusXxl),
  );
}
