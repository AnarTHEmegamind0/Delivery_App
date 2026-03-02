import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';

/// Shimmer loading skeleton for Pinterest-style loading states
/// Provides smooth, animated placeholders while content loads
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer(
      gradient: AppColors.shimmerGradient(isDark),
      child: child,
    );
  }
}

/// Pre-built shimmer skeleton shapes
class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton._({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  /// Circular skeleton (for avatars)
  factory ShimmerSkeleton.circle({
    double size = 48,
  }) {
    return ShimmerSkeleton._(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }

  /// Rectangular skeleton (for cards, images)
  factory ShimmerSkeleton.rect({
    double? width,
    double height = 100,
    double radius = AppSpacing.radiusMd,
  }) {
    return ShimmerSkeleton._(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Text line skeleton
  factory ShimmerSkeleton.text({
    double? width,
    double height = 16,
  }) {
    return ShimmerSkeleton._(
      width: width,
      height: height,
      borderRadius: AppSpacing.borderRadiusSm,
    );
  }

  /// Pill/badge skeleton
  factory ShimmerSkeleton.pill({
    double width = 80,
    double height = 24,
  }) {
    return ShimmerSkeleton._(
      width: width,
      height: height,
      borderRadius: AppSpacing.borderRadiusFull,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBorder,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Pinterest-style card skeleton
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 200,
    this.showAvatar = false,
    this.lines = 2,
  });

  final double height;
  final bool showAvatar;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ShimmerSkeleton.rect(
            height: height,
            radius: AppSpacing.radiusLg,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Content
          Row(
            children: [
              if (showAvatar) ...[
                ShimmerSkeleton.circle(size: 32),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerSkeleton.text(width: double.infinity),
                    if (lines > 1) ...[
                      const SizedBox(height: AppSpacing.xs),
                      ShimmerSkeleton.text(width: 150),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// List item skeleton
class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({
    super.key,
    this.showLeading = true,
    this.showTrailing = false,
    this.lines = 2,
  });

  final bool showLeading;
  final bool showTrailing;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: AppSpacing.verticalMd,
        child: Row(
          children: [
            if (showLeading) ...[
              ShimmerSkeleton.circle(size: 48),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerSkeleton.text(
                    width: double.infinity,
                    height: 14,
                  ),
                  if (lines > 1) ...[
                    const SizedBox(height: AppSpacing.xs),
                    ShimmerSkeleton.text(
                      width: 120,
                      height: 12,
                    ),
                  ],
                ],
              ),
            ),
            if (showTrailing) ...[
              const SizedBox(width: AppSpacing.md),
              ShimmerSkeleton.rect(
                width: 60,
                height: 24,
                radius: AppSpacing.radiusSm,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Order card skeleton for delivery app
class ShimmerOrderCard extends StatelessWidget {
  const ShimmerOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShimmerLoading(
      child: Container(
        padding: AppSpacing.cardInset,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: AppSpacing.borderRadiusXl,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                ShimmerSkeleton.rect(
                  width: 56,
                  height: 56,
                  radius: AppSpacing.radiusMd,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerSkeleton.text(width: 140, height: 16),
                      const SizedBox(height: AppSpacing.xs),
                      ShimmerSkeleton.text(width: 100, height: 12),
                    ],
                  ),
                ),
                ShimmerSkeleton.pill(width: 70, height: 28),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Divider
            Container(
              height: 1,
              color: isDark
                  ? AppColors.darkBorderSubtle
                  : AppColors.lightBorderSubtle,
            ),
            const SizedBox(height: AppSpacing.md),

            // Details
            Row(
              children: [
                ShimmerSkeleton.circle(size: 20),
                const SizedBox(width: AppSpacing.xs),
                ShimmerSkeleton.text(width: 80, height: 14),
                const Spacer(),
                ShimmerSkeleton.circle(size: 20),
                const SizedBox(width: AppSpacing.xs),
                ShimmerSkeleton.text(width: 60, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
