import 'package:flutter/material.dart';

/// Pinterest-inspired animation system
/// Smooth, natural-feeling motion with custom easing curves
class AppAnimations {
  AppAnimations._();

  // ============================================================
  // DURATION TOKENS
  // ============================================================

  /// Instant - for micro-interactions (50ms)
  static const Duration instant = Duration(milliseconds: 50);

  /// Fast - for button states, toggles (150ms)
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal - for standard transitions (250ms)
  static const Duration normal = Duration(milliseconds: 250);

  /// Medium - for page transitions, modals (350ms)
  static const Duration medium = Duration(milliseconds: 350);

  /// Slow - for complex animations (500ms)
  static const Duration slow = Duration(milliseconds: 500);

  /// Slower - for staggered list animations (650ms)
  static const Duration slower = Duration(milliseconds: 650);

  /// Slowest - for dramatic effects (800ms)
  static const Duration slowest = Duration(milliseconds: 800);

  // ============================================================
  // CUSTOM EASING CURVES (Pinterest-inspired)
  // ============================================================

  /// Pinterest ease out - smooth deceleration
  /// Great for elements entering the viewport
  static const Curve pinterestEaseOut = Cubic(0.16, 1, 0.3, 1);

  /// Pinterest ease in - smooth acceleration
  /// Great for elements leaving the viewport
  static const Curve pinterestEaseIn = Cubic(0.6, 0, 0.84, 0);

  /// Pinterest ease in-out - smooth both ways
  /// Great for state changes and toggles
  static const Curve pinterestEaseInOut = Cubic(0.4, 0, 0.2, 1);

  /// Overshoot - bouncy entrance
  /// Great for playful UI elements
  static const Curve overshoot = Cubic(0.34, 1.56, 0.64, 1);

  /// Smooth spring - natural bounce
  /// Great for interactive feedback
  static const Curve smoothSpring = Cubic(0.175, 0.885, 0.32, 1.275);

  /// Decelerate - strong slow-down
  /// Great for hero animations
  static const Curve decelerate = Curves.decelerate;

  /// Anticipate - slight pull-back before moving
  /// Great for swipe actions
  static const Curve anticipate = Cubic(0.36, 0, 0.66, -0.56);

  // ============================================================
  // STAGGER DELAYS
  // ============================================================

  /// Stagger delay for list items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Get stagger delay for index
  static Duration staggerDelayFor(int index, {int maxItems = 10}) {
    final clampedIndex = index.clamp(0, maxItems);
    return Duration(milliseconds: 50 * clampedIndex);
  }

  // ============================================================
  // SPRING PHYSICS
  // ============================================================

  /// Default spring for most animations
  static const SpringDescription defaultSpring = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 25,
  );

  /// Bouncy spring for playful elements
  static const SpringDescription bouncySpring = SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 15,
  );

  /// Stiff spring for quick snaps
  static const SpringDescription stiffSpring = SpringDescription(
    mass: 1,
    stiffness: 500,
    damping: 30,
  );

  /// Gentle spring for slow movements
  static const SpringDescription gentleSpring = SpringDescription(
    mass: 1,
    stiffness: 200,
    damping: 20,
  );

  // ============================================================
  // PRESET ANIMATION CONFIGS
  // ============================================================

  /// Page transition config
  static const PageTransitionConfig pageTransition = PageTransitionConfig(
    duration: medium,
    curve: pinterestEaseOut,
  );

  /// Modal transition config
  static const PageTransitionConfig modalTransition = PageTransitionConfig(
    duration: normal,
    curve: pinterestEaseOut,
  );

  /// Card hover config
  static const AnimationConfig cardHover = AnimationConfig(
    duration: fast,
    curve: pinterestEaseOut,
  );

  /// Button press config
  static const AnimationConfig buttonPress = AnimationConfig(
    duration: instant,
    curve: Curves.easeInOut,
  );

  /// Scale on tap config
  static const ScaleConfig tapScale = ScaleConfig(
    pressedScale: 0.96,
    duration: fast,
    curve: pinterestEaseOut,
  );

  /// Hero animation config
  static const AnimationConfig heroAnimation = AnimationConfig(
    duration: medium,
    curve: pinterestEaseInOut,
  );
}

/// Configuration for page transitions
class PageTransitionConfig {
  final Duration duration;
  final Curve curve;

  const PageTransitionConfig({
    required this.duration,
    required this.curve,
  });
}

/// General animation configuration
class AnimationConfig {
  final Duration duration;
  final Curve curve;

  const AnimationConfig({
    required this.duration,
    required this.curve,
  });
}

/// Scale animation configuration
class ScaleConfig {
  final double pressedScale;
  final Duration duration;
  final Curve curve;

  const ScaleConfig({
    required this.pressedScale,
    required this.duration,
    required this.curve,
  });
}
