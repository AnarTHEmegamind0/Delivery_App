import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/design_system/design_system.dart';
import '../../../core/utils.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: _buildHeader(context, provider, isDark),
              ),

              // Content
              if (provider.isLoading)
                SliverFillRemaining(
                  child: _buildLoadingState(isDark),
                )
              else if (provider.error != null)
                SliverFillRemaining(
                  child: _buildErrorState(context, provider, isDark),
                )
              else if (provider.notifications.isEmpty)
                SliverFillRemaining(
                  child: _buildEmptyState(isDark),
                )
              else
                ..._buildGroupedNotifications(context, provider, isDark),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    NotificationProvider provider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мэдэгдэл',
                    style: AppTypography.h1.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  if (provider.unreadCount > 0) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${provider.unreadCount} шинэ мэдэгдэл',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              if (provider.unreadCount > 0 && !provider.isLoading)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    provider.markAllAsRead();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryGreen.withOpacity(0.15)
                          : AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                    child: Text(
                      'Бүгдийг уншсан',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Padding(
      padding: AppSpacing.screenInset,
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ShimmerSkeleton.rect(
              height: 100,
              radius: AppSpacing.radiusMd,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    NotificationProvider provider,
    bool isDark,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.12),
              borderRadius: AppSpacing.borderRadiusFull,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Алдаа гарлаа',
            style: AppTypography.h3.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: Text(
              provider.error!,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedButton(
            label: 'Дахин оролдох',
            onPressed: () => provider.fetchNotifications(),
            size: AnimatedButtonSize.medium,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBorderSubtle,
                  isDark
                      ? AppColors.darkCard
                      : AppColors.lightCard,
                ],
              ),
              borderRadius: AppSpacing.borderRadiusFull,
              boxShadow: AppShadows.md(isDark: isDark),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 56,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                Positioned(
                  top: 28,
                  right: 32,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Бүгд гүйцэтгэгдлээ!',
            style: AppTypography.h3.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: Text(
              'Одоогоор шинэ мэдэгдэл байхгүй байна.\nШинэ захиалга ирэхэд танд мэдэгдэх болно.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedNotifications(
    BuildContext context,
    NotificationProvider provider,
    bool isDark,
  ) {
    final grouped = _groupNotificationsByDate(provider.notifications);
    final widgets = <Widget>[];

    for (final entry in grouped.entries) {
      // Section header
      widgets.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              entry.key,
              style: AppTypography.labelLarge.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      );

      // Notification cards
      widgets.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final notification = entry.value[index];

              return _PinterestNotificationCard(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    provider.markAsRead(notification.id);
                  }
                },
                onDismissed: () {
                  provider.deleteNotification(notification.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Мэдэгдэл устгагдлаа',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: isDark
                          ? AppColors.darkCard
                          : AppColors.lightTextPrimary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                isDark: isDark,
              );
            },
            childCount: entry.value.length,
          ),
        ),
      );
    }

    return widgets;
  }

  Map<String, List<NotificationModel>> _groupNotificationsByDate(
    List<NotificationModel> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));

    final Map<String, List<NotificationModel>> grouped = {};

    for (final notification in notifications) {
      final date = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      String key;
      if (date == today) {
        key = 'Өнөөдөр';
      } else if (date == yesterday) {
        key = 'Өчигдөр';
      } else if (date.isAfter(thisWeek)) {
        key = 'Энэ долоо хоног';
      } else {
        key = 'Өмнө нь';
      }

      grouped[key] ??= [];
      grouped[key]!.add(notification);
    }

    return grouped;
  }
}

class _PinterestNotificationCard extends StatefulWidget {
  const _PinterestNotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
    required this.isDark,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final bool isDark;

  @override
  State<_PinterestNotificationCard> createState() =>
      _PinterestNotificationCardState();
}

class _PinterestNotificationCardState extends State<_PinterestNotificationCard>
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

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.newOrder:
        return Icons.shopping_bag_outlined;
      case NotificationType.customerNeed:
        return Icons.phone_callback_outlined;
      case NotificationType.payment:
        return Icons.account_balance_wallet_outlined;
      case NotificationType.system:
        return Icons.info_outline_rounded;
      case NotificationType.orderRequest:
        return Icons.cancel_outlined;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.newOrder:
        return AppColors.primaryGreen;
      case NotificationType.customerNeed:
        return AppColors.warning;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.system:
        return AppColors.info;
      case NotificationType.orderRequest:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(widget.notification.type);

    return Dismissible(
      key: Key(widget.notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDismissed(),
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.error.withOpacity(0.8),
              AppColors.error,
            ],
          ),
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Устгах',
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: widget.notification.isRead
                    ? (widget.isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder)
                    : color.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: _isPressed
                  ? AppShadows.xs(isDark: widget.isDark)
                  : AppShadows.sm(isDark: widget.isDark),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    _getIconForType(widget.notification.type),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.notification.title,
                              style: AppTypography.bodyMedium.copyWith(
                                color: widget.isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: widget.notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!widget.notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.glow(color, intensity: 0.5),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        widget.notification.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: widget.isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppUtils.formatTimeAgo(widget.notification.timestamp),
                        style: AppTypography.caption.copyWith(
                          color: widget.isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
