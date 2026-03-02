import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/spacing.dart';
import '../tokens/shadows.dart';
import '../tokens/animations.dart';
import 'shimmer_loading.dart';

/// Pinterest-style image card with gradient overlay and micro-interactions
/// Perfect for order cards, restaurant displays, and content previews
class ImageCard extends StatefulWidget {
  const ImageCard({
    super.key,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.badge,
    this.onTap,
    this.height = 200,
    this.borderRadius,
    this.showGradientOverlay = true,
    this.heroTag,
    this.bottomWidget,
    this.topRightWidget,
    this.aspectRatio,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final String? title;
  final String? subtitle;
  final Widget? badge;
  final VoidCallback? onTap;
  final double height;
  final BorderRadius? borderRadius;
  final bool showGradientOverlay;
  final String? heroTag;
  final Widget? bottomWidget;
  final Widget? topRightWidget;
  final double? aspectRatio;
  final BoxFit fit;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.pinterestEaseOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    HapticFeedback.lightImpact();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = widget.borderRadius ?? AppSpacing.borderRadiusXl;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: widget.fit,
      placeholder: (context, url) => ShimmerLoading(
        child: Container(
          color: isDark ? AppColors.darkCard : AppColors.lightBorder,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: isDark ? AppColors.darkCard : AppColors.lightBorder,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          size: 32,
        ),
      ),
    );

    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    final content = Stack(
      fit: StackFit.expand,
      children: [
        // Image
        ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: imageWidget,
        ),

        // Gradient overlay
        if (widget.showGradientOverlay && (widget.title != null || widget.bottomWidget != null))
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                gradient: AppColors.imageOverlayGradient,
              ),
            ),
          ),

        // Top right badge/widget
        if (widget.topRightWidget != null || widget.badge != null)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: widget.topRightWidget ?? widget.badge!,
          ),

        // Bottom content
        if (widget.title != null || widget.subtitle != null || widget.bottomWidget != null)
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: widget.bottomWidget ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        style: AppTypography.h3.copyWith(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        widget.subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
          ),
      ],
    );

    final cardWidget = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: effectiveBorderRadius,
              boxShadow: [
                ...AppShadows.md(isDark: isDark),
                if (_isPressed)
                  ...AppShadows.lg(isDark: isDark),
              ],
            ),
            child: child,
          ),
        );
      },
      child: content,
    );

    Widget result;
    if (widget.aspectRatio != null) {
      result = AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: cardWidget,
      );
    } else {
      result = SizedBox(
        height: widget.height,
        child: cardWidget,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: result,
    );
  }
}

/// Compact image card for lists
class CompactImageCard extends StatelessWidget {
  const CompactImageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.heroTag,
    this.imageSize = 64,
  });

  final String imageUrl;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? heroTag;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget imageWidget = ClipRRect(
      borderRadius: AppSpacing.borderRadiusMd,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        placeholder: (context, url) => ShimmerSkeleton.rect(
          width: imageSize,
          height: imageSize,
        ),
        errorWidget: (context, url, error) => Container(
          width: imageSize,
          height: imageSize,
          color: isDark ? AppColors.darkCard : AppColors.lightBorder,
          child: Icon(
            Icons.restaurant_outlined,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
        ),
      ),
    );

    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusLg,
        child: Padding(
          padding: AppSpacing.insetSm,
          child: Row(
            children: [
              imageWidget,
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h4.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
