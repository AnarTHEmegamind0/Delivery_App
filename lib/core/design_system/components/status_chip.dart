import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/spacing.dart';
import '../tokens/animations.dart';

enum StatusType { success, warning, error, info, neutral, pending }

/// Animated status chip with optional glow effect
/// Perfect for order status, delivery status, and notifications
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusType.neutral,
    this.icon,
    this.animated = false,
    this.size = StatusChipSize.medium,
    this.outlined = false,
    this.showGlow = false,
  });

  final String label;
  final StatusType type;
  final IconData? icon;
  final bool animated;
  final StatusChipSize size;
  final bool outlined;
  final bool showGlow;

  /// Create from order status string
  factory StatusChip.fromStatus(String status, {bool animated = false}) {
    final type = _getTypeFromStatus(status);
    final icon = _getIconFromStatus(status);
    return StatusChip(
      label: status,
      type: type,
      icon: icon,
      animated: animated,
    );
  }

  static StatusType _getTypeFromStatus(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') || lower.contains('delivered') || lower.contains('success')) {
      return StatusType.success;
    } else if (lower.contains('progress') || lower.contains('delivering') || lower.contains('picked')) {
      return StatusType.info;
    } else if (lower.contains('pending') || lower.contains('waiting') || lower.contains('new')) {
      return StatusType.pending;
    } else if (lower.contains('cancelled') || lower.contains('failed') || lower.contains('error')) {
      return StatusType.error;
    } else if (lower.contains('warning') || lower.contains('delayed')) {
      return StatusType.warning;
    }
    return StatusType.neutral;
  }

  static IconData _getIconFromStatus(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('completed') || lower.contains('delivered') || lower.contains('success')) {
      return Icons.check_circle_outline_rounded;
    } else if (lower.contains('progress') || lower.contains('delivering')) {
      return Icons.local_shipping_outlined;
    } else if (lower.contains('picked')) {
      return Icons.inventory_2_outlined;
    } else if (lower.contains('pending') || lower.contains('waiting')) {
      return Icons.schedule_outlined;
    } else if (lower.contains('new')) {
      return Icons.notifications_active_outlined;
    } else if (lower.contains('cancelled') || lower.contains('failed')) {
      return Icons.cancel_outlined;
    }
    return Icons.info_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDark);
    final dimensions = _getDimensions();

    Widget chip = Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : colors.background,
        borderRadius: AppSpacing.borderRadiusFull,
        border: outlined
            ? Border.all(color: colors.foreground, width: 1.5)
            : null,
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: colors.foreground.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: dimensions.iconSize,
              color: colors.foreground,
            ),
            SizedBox(width: dimensions.iconGap),
          ],
          Text(
            label,
            style: dimensions.textStyle.copyWith(
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );

    // Removed repeating animations to avoid debugFrameWasSentToEngine errors

    return chip;
  }

  _StatusColors _getColors(bool isDark) {
    switch (type) {
      case StatusType.success:
        return _StatusColors(
          background: AppColors.success.withOpacity(isDark ? 0.2 : 0.15),
          foreground: isDark ? AppColors.successLight : AppColors.successDark,
        );
      case StatusType.warning:
        return _StatusColors(
          background: AppColors.warning.withOpacity(isDark ? 0.2 : 0.15),
          foreground: isDark ? AppColors.warningLight : AppColors.warningDark,
        );
      case StatusType.error:
        return _StatusColors(
          background: AppColors.error.withOpacity(isDark ? 0.2 : 0.15),
          foreground: isDark ? AppColors.errorLight : AppColors.errorDark,
        );
      case StatusType.info:
        return _StatusColors(
          background: AppColors.info.withOpacity(isDark ? 0.2 : 0.15),
          foreground: isDark ? AppColors.infoLight : AppColors.infoDark,
        );
      case StatusType.pending:
        return _StatusColors(
          background: AppColors.accentGold.withOpacity(isDark ? 0.2 : 0.15),
          foreground: isDark ? AppColors.accentGold : AppColors.accentGoldDark,
        );
      case StatusType.neutral:
        return _StatusColors(
          background: isDark
              ? AppColors.darkCard
              : AppColors.lightBorder,
          foreground: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        );
    }
  }

  _StatusDimensions _getDimensions() {
    switch (size) {
      case StatusChipSize.small:
        return _StatusDimensions(
          horizontalPadding: AppSpacing.sm,
          verticalPadding: AppSpacing.xxs,
          iconSize: 12,
          iconGap: AppSpacing.xxs,
          textStyle: AppTypography.labelSmall,
        );
      case StatusChipSize.medium:
        return _StatusDimensions(
          horizontalPadding: AppSpacing.md,
          verticalPadding: AppSpacing.xs,
          iconSize: 14,
          iconGap: AppSpacing.xs,
          textStyle: AppTypography.label,
        );
      case StatusChipSize.large:
        return _StatusDimensions(
          horizontalPadding: AppSpacing.lg,
          verticalPadding: AppSpacing.sm,
          iconSize: 18,
          iconGap: AppSpacing.xs,
          textStyle: AppTypography.bodyMedium,
        );
    }
  }
}

enum StatusChipSize { small, medium, large }

class _StatusColors {
  final Color background;
  final Color foreground;

  const _StatusColors({
    required this.background,
    required this.foreground,
  });
}

class _StatusDimensions {
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double iconGap;
  final TextStyle textStyle;

  const _StatusDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.iconGap,
    required this.textStyle,
  });
}

/// Animated dot indicator for live status
class StatusDot extends StatelessWidget {
  const StatusDot({
    super.key,
    this.type = StatusType.success,
    this.size = 8,
    this.animated = true,
  });

  final StatusType type;
  final double size;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getColor(isDark);

    Widget dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: size,
            spreadRadius: 0,
          ),
        ],
      ),
    );

    // Removed repeating animations to avoid debugFrameWasSentToEngine errors

    return dot;
  }

  Color _getColor(bool isDark) {
    switch (type) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.warning:
        return AppColors.warning;
      case StatusType.error:
        return AppColors.error;
      case StatusType.info:
        return AppColors.info;
      case StatusType.pending:
        return AppColors.accentGold;
      case StatusType.neutral:
        return isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;
    }
  }
}
