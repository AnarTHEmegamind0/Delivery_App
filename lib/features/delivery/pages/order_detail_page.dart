import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/design_system/design_system.dart';
import '../models/order_model.dart';
import 'order_map_navigation_page.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    HapticFeedback.lightImpact();
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _showIssueSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassBottomSheet(
        child: Padding(
          padding: AppSpacing.sheetInset,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ямар асуудал гарсан бэ?',
                    style: AppTypography.h2.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ...[
                ('Хариуцагч байхгүй', Icons.person_off_outlined),
                ('Хаяг буруу', Icons.wrong_location_outlined),
                ('Бараа гэмтсэн', Icons.broken_image_outlined),
                ('Төлбөр төлөхгүй байна', Icons.money_off_outlined),
                ('Бусад', Icons.more_horiz_rounded),
              ].map((issue) => _buildIssueOption(
                    context,
                    issue.$1,
                    issue.$2,
                    isDark,
                  )),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueOption(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppSpacing.borderRadiusLg,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Мэдэгдэл илгээгдлээ: $title'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
              ),
            );
          },
          borderRadius: AppSpacing.borderRadiusLg,
          child: Padding(
            padding: AppSpacing.cardInset,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(icon, color: AppColors.error, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = widget.order.restaurantImageUrl != null;
    final headerHeight = hasImage ? 280.0 : 0.0;

    // Mock order items
    final orderItems = widget.order.itemsSummary?.split(', ') ?? [
      'Burger King - Whopper Combo',
      'Coca Cola 500ml x2',
      'Картофны шаарсан',
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Main scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero image header with parallax
              if (hasImage) _buildHeroHeader(isDark, headerHeight),

              // Content
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: Offset(0, hasImage ? -24 : 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      borderRadius: hasImage
                          ? AppSpacing.borderRadiusTopXl
                          : BorderRadius.zero,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        if (hasImage)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: AppSpacing.sm),
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary,
                                borderRadius: AppSpacing.borderRadiusFull,
                              ),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Restaurant name and status
                              _buildRestaurantHeader(isDark),
                              const SizedBox(height: AppSpacing.xl),

                              // Customer Info Card
                              _buildCustomerCard(isDark),
                              const SizedBox(height: AppSpacing.md),

                              // Delivery Address Card
                              _buildAddressCard(isDark),
                              const SizedBox(height: AppSpacing.md),

                              // Order Items Card
                              _buildOrderItemsCard(isDark, orderItems),
                              const SizedBox(height: AppSpacing.md),

                              // Notes Card
                              if (widget.order.notes != null)
                                _buildNotesCard(isDark),
                              const SizedBox(height: AppSpacing.xxl),

                              // Action buttons
                              _buildActionButtons(isDark),
                              const SizedBox(height: AppSpacing.xxxl),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating back button and actions
          _buildFloatingHeader(isDark, hasImage),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(bool isDark, double height) {
    final parallaxOffset = _scrollOffset * 0.5;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Parallax image
            Transform.translate(
              offset: Offset(0, parallaxOffset),
              child: Hero(
                tag: 'order_image_${widget.order.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.order.restaurantImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? AppColors.darkCard : AppColors.lightBorder,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? AppColors.darkCard : AppColors.lightBorder,
                    child: const Icon(
                      Icons.restaurant_outlined,
                      size: 64,
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      (isDark ? AppColors.darkBackground : AppColors.lightBackground)
                          .withOpacity(0.3),
                      isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHeader(bool isDark, bool hasImage) {
    final opacity = hasImage
        ? (1 - (_scrollOffset / 100).clamp(0.0, 1.0))
        : 0.0;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        decoration: BoxDecoration(
          color: (_scrollOffset > 150 || !hasImage)
              ? (isDark ? AppColors.darkBackground : AppColors.lightBackground)
              : Colors.transparent,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                // Back button
                GlassContainer(
                  padding: EdgeInsets.zero,
                  borderRadius: AppSpacing.borderRadiusFull,
                  blur: hasImage && opacity > 0.5 ? 12 : 0,
                  shadow: false,
                  border: false,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: hasImage && opacity > 0.5
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),

                // Title (appears on scroll)
                if (_scrollOffset > 150 || !hasImage)
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.order.restaurantName ?? 'Захиалга',
                      style: AppTypography.h4.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Spacer(flex: 3),

                const Spacer(),

                // Issue button
                GlassContainer(
                  padding: EdgeInsets.zero,
                  borderRadius: AppSpacing.borderRadiusFull,
                  blur: hasImage && opacity > 0.5 ? 12 : 0,
                  shadow: false,
                  border: false,
                  child: IconButton(
                    icon: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: () => _showIssueSheet(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantHeader(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order.restaurantName ?? 'Рестаран',
                style: AppTypography.h1.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  StatusChip(
                    label: widget.order.status == OrderStatus.inProgress
                        ? 'Хүргэж байна'
                        : 'Дууссан',
                    type: widget.order.status == OrderStatus.inProgress
                        ? StatusType.info
                        : StatusType.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    widget.order.time,
                    style: AppTypography.label.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Орлого',
              style: AppTypography.caption.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            MetricCounter(
              value: widget.order.price,
              prefix: '₮',
              style: AppTypography.h2.copyWith(
                color: isDark
                    ? AppColors.primaryGreen
                    : AppColors.primaryGreenLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerCard(bool isDark) {
    return Container(
      padding: AppSpacing.cardInset,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppSpacing.borderRadiusLg,
            ),
            child: Center(
              child: Text(
                (widget.order.customerName ?? 'U')[0].toUpperCase(),
                style: AppTypography.h2.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Хэрэглэгч',
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  widget.order.customerName ?? 'Хэрэглэгч',
                  style: AppTypography.h3.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  widget.order.customerPhone ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Call button
          AnimatedButton(
            label: '',
            onPressed: () => _makePhoneCall(widget.order.customerPhone ?? ''),
            variant: AnimatedButtonVariant.primary,
            size: AnimatedButtonSize.medium,
            icon: Icons.phone_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(bool isDark) {
    return Container(
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Хүргэх хаяг',
                style: AppTypography.label.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.order.distanceInKm.toStringAsFixed(1)} км',
                style: AppTypography.label.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.order.address,
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard(bool isDark, List<String> items) {
    return Container(
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.accentGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Захиалсан бараа',
                style: AppTypography.label.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBorderSubtle,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Text(
                  '${items.length} бараа',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...items.asMap().entries.map((entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < items.length - 1 ? AppSpacing.sm : 0,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTypography.body.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNotesCard(bool isDark) {
    return Container(
      padding: AppSpacing.cardInset,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Тэмдэглэл',
                style: AppTypography.label.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.order.notes!,
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        // Navigate button
        AnimatedButton(
          label: 'Газрын зураг харах',
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    OrderMapNavigationPage(order: widget.order),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
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
          },
          icon: Icons.map_outlined,
          fullWidth: true,
          size: AnimatedButtonSize.large,
        ),
        const SizedBox(height: AppSpacing.md),

        // Complete button
        AnimatedButton(
          label: 'Хүргэлт амжилттай – Дуусгах',
          onPressed: widget.order.status == OrderStatus.inProgress
              ? null
              : null, // Would navigate to completion flow
          variant: AnimatedButtonVariant.secondary,
          disabled: true,
          icon: Icons.check_circle_outline,
          fullWidth: true,
          size: AnimatedButtonSize.large,
        ),
        const SizedBox(height: AppSpacing.sm),

        Text(
          'Газрын зураг дээр хаягт очсоны дараа дуусгана уу',
          style: AppTypography.caption.copyWith(
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
