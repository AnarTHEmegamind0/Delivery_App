import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import 'shimmer_loading.dart';

/// Hero image with parallax scroll effect
/// Perfect for detail page headers and immersive content
class HeroImage extends StatelessWidget {
  const HeroImage({
    super.key,
    required this.imageUrl,
    required this.scrollController,
    this.height = 300,
    this.parallaxFactor = 0.5,
    this.heroTag,
    this.overlay,
    this.bottomWidget,
    this.topWidget,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final ScrollController scrollController;
  final double height;
  final double parallaxFactor;
  final String? heroTag;
  final Widget? overlay;
  final Widget? bottomWidget;
  final Widget? topWidget;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.darkBackground,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: _buildHeroContent(context),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: double.infinity,
      height: height * 1.5, // Extra height for parallax
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
          size: 48,
        ),
      ),
    );

    if (heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image with parallax
        imageWidget,

        // Gradient overlay
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.imageOverlayGradient,
          ),
        ),

        // Custom overlay
        if (overlay != null) overlay!,

        // Top widget (e.g., back button, actions)
        if (topWidget != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: topWidget!,
          ),

        // Bottom widget (e.g., title, info)
        if (bottomWidget != null)
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: bottomWidget!,
          ),
      ],
    );
  }
}

/// Standalone hero image container (non-sliver version)
class HeroImageContainer extends StatefulWidget {
  const HeroImageContainer({
    super.key,
    required this.imageUrl,
    this.height = 300,
    this.heroTag,
    this.overlay,
    this.bottomWidget,
    this.onTap,
    this.borderRadius,
  });

  final String imageUrl;
  final double height;
  final String? heroTag;
  final Widget? overlay;
  final Widget? bottomWidget;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  State<HeroImageContainer> createState() => _HeroImageContainerState();
}

class _HeroImageContainerState extends State<HeroImageContainer> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.zero;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: widget.height,
      placeholder: (context, url) => ShimmerLoading(
        child: Container(
          height: widget.height,
          color: isDark ? AppColors.darkCard : AppColors.lightBorder,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: widget.height,
        color: isDark ? AppColors.darkCard : AppColors.lightBorder,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          size: 48,
        ),
      ),
    );

    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    final content = ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: Stack(
        children: [
          // Image
          imageWidget,

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: effectiveBorderRadius,
                gradient: AppColors.imageOverlayGradient,
              ),
            ),
          ),

          // Custom overlay
          if (widget.overlay != null) widget.overlay!,

          // Bottom widget
          if (widget.bottomWidget != null)
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: widget.bottomWidget!,
            ),
        ],
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: content,
      );
    }

    return content;
  }
}

/// Collapsing header with parallax effect
class CollapsingHeader extends StatelessWidget {
  const CollapsingHeader({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.expandedHeight = 280,
    this.collapsedHeight,
    this.heroTag,
    this.actions,
    this.leading,
    this.bottom,
  });

  final String imageUrl;
  final String title;
  final String? subtitle;
  final double expandedHeight;
  final double? collapsedHeight;
  final String? heroTag;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      leading: leading,
      actions: actions,
      bottom: bottom,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(
          left: 16,
          bottom: 16,
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            heroTag != null
                ? Hero(
                    tag: heroTag!,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),

            // Gradient overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x40000000),
                    Color(0xCC000000),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Subtitle
            if (subtitle != null)
              Positioned(
                left: 16,
                bottom: 48,
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
