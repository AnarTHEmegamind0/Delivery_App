import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/design_system/design_system.dart';
import '../../../core/utils.dart';
import '../models/order_model.dart';
import '../pages/order_detail_page.dart';

/// Pinterest-style order card with image, glassmorphism, and micro-interactions
class PinterestOrderCard extends StatefulWidget {
  const PinterestOrderCard({
    super.key,
    required this.order,
    this.onAccept,
    this.index = 0,
  });

  final OrderModel order;
  final VoidCallback? onAccept;
  final int index;

  @override
  State<PinterestOrderCard> createState() => _PinterestOrderCardState();
}

class _PinterestOrderCardState extends State<PinterestOrderCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.pinterestEaseOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
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
    HapticFeedback.lightImpact();
    if (widget.order.status == OrderStatus.inProgress ||
        widget.order.status == OrderStatus.completed) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OrderDetailPage(order: widget.order),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.pinterestEaseOut,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: AppAnimations.medium,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = widget.order.restaurantImageUrl != null;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: AppSpacing.borderRadiusXl,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
            boxShadow: _isPressed
                ? AppShadows.sm(isDark: isDark)
                : AppShadows.md(isDark: isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image header with overlay
              if (hasImage) _buildImageHeader(isDark),

              // Content section
              Padding(
                padding: AppSpacing.cardInset,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant name and status
                    if (!hasImage) _buildHeaderRow(isDark),

                    // Address
                    _buildAddressRow(isDark),
                    const SizedBox(height: AppSpacing.md),

                    // Metrics row
                    _buildMetricsRow(isDark),
                    const SizedBox(height: AppSpacing.md),

                    // Divider
                    Container(
                      height: 1,
                      color: isDark
                          ? AppColors.darkBorderSubtle
                          : AppColors.lightBorderSubtle,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Price and action row
                    _buildActionRow(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(bool isDark) {
    return Stack(
      children: [
        // Restaurant image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXl),
            topRight: Radius.circular(AppSpacing.radiusXl),
          ),
          child: Hero(
            tag: 'order_image_${widget.order.id}',
            child: CachedNetworkImage(
              imageUrl: widget.order.restaurantImageUrl!,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerSkeleton.rect(
                height: 140,
                radius: 0,
              ),
              errorWidget: (context, url, error) => Container(
                height: 140,
                color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                child: const Icon(
                  Icons.restaurant_outlined,
                  size: 48,
                  color: AppColors.darkTextTertiary,
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusXl),
                topRight: Radius.circular(AppSpacing.radiusXl),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),

        // Restaurant name on image
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.order.restaurantName ?? 'Рестаран',
                  style: AppTypography.h3.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusChip(),
            ],
          ),
        ),

        // Item count badge
        if (widget.order.itemCount != null)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              borderRadius: AppSpacing.borderRadiusFull,
              blur: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    '${widget.order.itemCount}',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryGreen.withOpacity(0.15)
                  : AppColors.primaryGreenLight.withOpacity(0.15),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(
              Icons.restaurant_outlined,
              color: isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              widget.order.restaurantName ?? 'Рестаран',
              style: AppTypography.h4.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildStatusChip(),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    String statusText;
    StatusType statusType;

    switch (widget.order.status) {
      case OrderStatus.available:
        statusText = 'Шинэ';
        statusType = StatusType.pending;
        break;
      case OrderStatus.accepted:
      case OrderStatus.inProgress:
        statusText = 'Хүргэж байна';
        statusType = StatusType.info;
        break;
      case OrderStatus.completed:
        statusText = 'Дууссан';
        statusType = StatusType.success;
        break;
      case OrderStatus.cancelled:
        statusText = 'Цуцлагдсан';
        statusType = StatusType.error;
        break;
    }

    return StatusChip(
      label: statusText,
      type: statusType,
      size: StatusChipSize.small,
    );
  }

  Widget _buildAddressRow(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : AppColors.lightBorderSubtle,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Icon(
            Icons.location_on_outlined,
            size: 18,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order.address,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.order.itemsSummary != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  widget.order.itemsSummary!,
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
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
  }

  Widget _buildMetricsRow(bool isDark) {
    return Row(
      children: [
        _buildMetricItem(
          icon: Icons.route_outlined,
          value: AppUtils.formatDistance(widget.order.distanceInKm),
          isDark: isDark,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: AppSpacing.lg),
        _buildMetricItem(
          icon: Icons.schedule_outlined,
          value: widget.order.time,
          isDark: isDark,
        ),
        if (widget.order.customerName != null) ...[
          const Spacer(),
          _buildMetricItem(
            icon: Icons.person_outline,
            value: widget.order.customerName!.split(' ').first,
            isDark: isDark,
          ),
        ],
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required bool isDark,
    Color? color,
  }) {
    final effectiveColor = color ??
        (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: effectiveColor,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          value,
          style: AppTypography.label.copyWith(
            color: effectiveColor,
            fontWeight: color != null ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(bool isDark) {
    return Row(
      children: [
        // Price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Орлого',
                style: AppTypography.caption.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                AppUtils.formatCurrency(widget.order.price),
                style: AppTypography.h2.copyWith(
                  color: isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Accept button (for available orders)
        if (widget.onAccept != null && widget.order.status == OrderStatus.available)
          AnimatedButton(
            label: 'Хүлээн авах',
            onPressed: widget.onAccept,
            size: AnimatedButtonSize.medium,
            icon: Icons.check_rounded,
          ),

        // Navigate button (for in-progress orders)
        if (widget.order.status == OrderStatus.inProgress)
          AnimatedButton(
            label: 'Дэлгэрэнгүй',
            onPressed: _handleTap,
            variant: AnimatedButtonVariant.secondary,
            size: AnimatedButtonSize.medium,
            icon: Icons.arrow_forward_rounded,
            iconPosition: IconPosition.right,
          ),
      ],
    );
  }
}
