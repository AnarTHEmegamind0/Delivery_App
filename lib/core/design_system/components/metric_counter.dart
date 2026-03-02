import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/spacing.dart';
import '../tokens/animations.dart';

/// Animated metric counter with count-up effect
/// Perfect for earnings display, statistics, and live counters
class MetricCounter extends StatefulWidget {
  const MetricCounter({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.duration,
    this.style,
    this.decimals = 0,
    this.curve,
    this.animated = true,
    this.thousandSeparator = ',',
  });

  final double value;
  final String prefix;
  final String suffix;
  final Duration? duration;
  final TextStyle? style;
  final int decimals;
  final Curve? curve;
  final bool animated;
  final String thousandSeparator;

  @override
  State<MetricCounter> createState() => _MetricCounterState();
}

class _MetricCounterState extends State<MetricCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AppAnimations.slow,
      vsync: this,
    );
    _setupAnimation();
    if (widget.animated) {
      _controller.forward();
    }
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? AppAnimations.pinterestEaseOut,
    ));
  }

  @override
  void didUpdateWidget(MetricCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _setupAnimation();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    final parts = value.toStringAsFixed(widget.decimals).split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '';

    // Add thousand separators
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(widget.thousandSeparator);
      }
      buffer.write(intPart[i]);
    }

    if (widget.decimals > 0) {
      return '${buffer.toString()}.$decPart';
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultStyle = AppTypography.numberHero.copyWith(
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
    final effectiveStyle = widget.style ?? defaultStyle;

    if (!widget.animated) {
      return Text(
        '${widget.prefix}${_formatNumber(widget.value)}${widget.suffix}',
        style: effectiveStyle,
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_formatNumber(_animation.value)}${widget.suffix}',
          style: effectiveStyle,
        );
      },
    );
  }
}

/// Earnings display widget with icon and label
class EarningsDisplay extends StatelessWidget {
  const EarningsDisplay({
    super.key,
    required this.amount,
    required this.label,
    this.icon,
    this.trend,
    this.trendPositive = true,
    this.size = EarningsDisplaySize.medium,
    this.animated = true,
  });

  final double amount;
  final String label;
  final IconData? icon;
  final String? trend;
  final bool trendPositive;
  final EarningsDisplaySize size;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dimensions = _getDimensions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with optional icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: dimensions.iconSize,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              SizedBox(width: dimensions.iconGap),
            ],
            Text(
              label,
              style: dimensions.labelStyle.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: dimensions.labelGap),

        // Amount
        MetricCounter(
          value: amount,
          prefix: '₮',
          style: dimensions.amountStyle.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          animated: animated,
        ),

        // Trend indicator
        if (trend != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                trendPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 14,
                color: trendPositive ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                trend!,
                style: AppTypography.labelSmall.copyWith(
                  color: trendPositive ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  _EarningsDimensions _getDimensions() {
    switch (size) {
      case EarningsDisplaySize.small:
        return _EarningsDimensions(
          iconSize: 14,
          iconGap: AppSpacing.xxs,
          labelGap: AppSpacing.xxs,
          labelStyle: AppTypography.labelSmall,
          amountStyle: AppTypography.number,
        );
      case EarningsDisplaySize.medium:
        return _EarningsDimensions(
          iconSize: 16,
          iconGap: AppSpacing.xs,
          labelGap: AppSpacing.xs,
          labelStyle: AppTypography.label,
          amountStyle: AppTypography.numberLarge,
        );
      case EarningsDisplaySize.large:
        return _EarningsDimensions(
          iconSize: 20,
          iconGap: AppSpacing.xs,
          labelGap: AppSpacing.sm,
          labelStyle: AppTypography.bodyMedium,
          amountStyle: AppTypography.numberHero,
        );
    }
  }
}

enum EarningsDisplaySize { small, medium, large }

class _EarningsDimensions {
  final double iconSize;
  final double iconGap;
  final double labelGap;
  final TextStyle labelStyle;
  final TextStyle amountStyle;

  const _EarningsDimensions({
    required this.iconSize,
    required this.iconGap,
    required this.labelGap,
    required this.labelStyle,
    required this.amountStyle,
  });
}

/// Circular progress with animated value
class CircularMetric extends StatefulWidget {
  const CircularMetric({
    super.key,
    required this.value,
    required this.maxValue,
    this.label,
    this.size = 100,
    this.strokeWidth = 8,
    this.backgroundColor,
    this.progressColor,
    this.animated = true,
  });

  final double value;
  final double maxValue;
  final String? label;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool animated;

  @override
  State<CircularMetric> createState() => _CircularMetricState();
}

class _CircularMetricState extends State<CircularMetric>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _setupAnimation();
    if (widget.animated) {
      _controller.forward();
    }
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: 0,
      end: widget.value / widget.maxValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.pinterestEaseOut,
    ));
  }

  @override
  void didUpdateWidget(CircularMetric oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _setupAnimation();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final progressColor = widget.progressColor ?? AppColors.primaryGreen;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: bgColor,
                  valueColor: AlwaysStoppedAnimation(bgColor),
                ),
              ),
              // Progress circle
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: widget.animated ? _animation.value : widget.value / widget.maxValue,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(progressColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MetricCounter(
                    value: widget.animated
                        ? _animation.value * widget.maxValue
                        : widget.value,
                    style: AppTypography.h2.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    animated: false,
                  ),
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: AppTypography.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
