import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/shadows.dart';

/// A glassmorphism container with backdrop blur and subtle borders
/// Perfect for overlays, cards on images, and modern UI elements
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blur = 16.0,
    this.opacity = 0.1,
    this.border = true,
    this.shadow = true,
    this.color,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final bool border;
  final bool shadow;
  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? AppSpacing.borderRadiusXl;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: shadow ? AppShadows.lg(isDark: isDark) : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? AppSpacing.cardInset,
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.glassGradientDark
                  : AppColors.glassGradientLight,
              borderRadius: effectiveBorderRadius,
              border: border
                  ? Border.all(
                      color: isDark
                          ? AppColors.glassBorderDark
                          : AppColors.glassBorderLight,
                      width: 1,
                    )
                  : null,
              color: color?.withOpacity(opacity),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A glass bottom sheet with drag handle
class GlassBottomSheet extends StatelessWidget {
  const GlassBottomSheet({
    super.key,
    required this.child,
    this.showHandle = true,
    this.blur = 24.0,
    this.maxHeight,
  });

  final Widget child;
  final bool showHandle;
  final double blur;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : null,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusTopXl,
        boxShadow: AppShadows.xxl(isDark: isDark),
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusTopXl,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.glassGradientDark
                  : AppColors.glassGradientLight,
              borderRadius: AppSpacing.borderRadiusTopXl,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? AppColors.glassBorderDark
                      : AppColors.glassBorderLight,
                  width: 1,
                ),
                left: BorderSide(
                  color: isDark
                      ? AppColors.glassBorderDark
                      : AppColors.glassBorderLight,
                  width: 1,
                ),
                right: BorderSide(
                  color: isDark
                      ? AppColors.glassBorderDark
                      : AppColors.glassBorderLight,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showHandle) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
