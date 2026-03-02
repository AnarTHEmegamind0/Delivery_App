import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/spacing.dart';
import '../tokens/shadows.dart';
import '../tokens/animations.dart';

enum AnimatedButtonVariant { primary, secondary, ghost, danger, success }
enum AnimatedButtonSize { small, medium, large }

/// Award-quality animated button with micro-interactions
/// Features scale animation, haptic feedback, and morphing states
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AnimatedButtonVariant.primary,
    this.size = AnimatedButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isLoading = false,
    this.isSuccess = false,
    this.disabled = false,
    this.fullWidth = false,
    this.hapticFeedback = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AnimatedButtonVariant variant;
  final AnimatedButtonSize size;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool isLoading;
  final bool isSuccess;
  final bool disabled;
  final bool fullWidth;
  final bool hapticFeedback;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

enum IconPosition { left, right }

class _AnimatedButtonState extends State<AnimatedButton>
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.tapScale.pressedScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.pinterestEaseOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isDisabled) return;
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
    if (_isDisabled) return;
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed?.call();
  }

  bool get _isDisabled => widget.disabled || widget.isLoading || widget.onPressed == null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDark);
    final dimensions = _getDimensions();

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.pinterestEaseOut,
          width: widget.fullWidth ? double.infinity : null,
          height: dimensions.height,
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.horizontalPadding,
          ),
          decoration: BoxDecoration(
            color: _isDisabled ? colors.disabledBackground : colors.background,
            borderRadius: BorderRadius.circular(dimensions.borderRadius),
            border: colors.border != null
                ? Border.all(
                    color: _isDisabled
                        ? colors.border!.withOpacity(0.5)
                        : colors.border!,
                    width: 1.5,
                  )
                : null,
            boxShadow: !_isDisabled && widget.variant == AnimatedButtonVariant.primary
                ? (_isPressed
                    ? AppShadows.sm(isDark: isDark)
                    : AppShadows.glow(colors.background, intensity: 0.3))
                : null,
          ),
          child: _buildContent(colors, dimensions),
        ),
      ),
    );
  }

  Widget _buildContent(_ButtonColors colors, _ButtonDimensions dimensions) {
    if (widget.isSuccess) {
      return Center(
        child: _SuccessCheckIcon(
          color: colors.foreground,
          size: dimensions.iconSize,
        ),
      );
    }

    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: dimensions.iconSize,
          height: dimensions.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(colors.foreground),
          ),
        ),
      );
    }

    final textWidget = Text(
      widget.label,
      style: dimensions.textStyle.copyWith(
        color: _isDisabled
            ? colors.foreground.withOpacity(0.5)
            : colors.foreground,
      ),
    );

    if (widget.icon == null) {
      return Center(child: textWidget);
    }

    final iconWidget = Icon(
      widget.icon,
      size: dimensions.iconSize,
      color: _isDisabled
          ? colors.foreground.withOpacity(0.5)
          : colors.foreground,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.iconPosition == IconPosition.left
          ? [
              iconWidget,
              SizedBox(width: dimensions.iconGap),
              textWidget,
            ]
          : [
              textWidget,
              SizedBox(width: dimensions.iconGap),
              iconWidget,
            ],
    );
  }

  _ButtonColors _getColors(bool isDark) {
    switch (widget.variant) {
      case AnimatedButtonVariant.primary:
        return _ButtonColors(
          background: isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight,
          foreground: isDark ? AppColors.darkBackground : Colors.white,
          disabledBackground: isDark
              ? AppColors.primaryGreen.withOpacity(0.3)
              : AppColors.primaryGreenLight.withOpacity(0.3),
        );
      case AnimatedButtonVariant.secondary:
        return _ButtonColors(
          background: isDark ? AppColors.darkCard : AppColors.lightCard,
          foreground: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          border: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          disabledBackground: isDark
              ? AppColors.darkCard.withOpacity(0.5)
              : AppColors.lightCard.withOpacity(0.5),
        );
      case AnimatedButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          disabledBackground: Colors.transparent,
        );
      case AnimatedButtonVariant.danger:
        return _ButtonColors(
          background: AppColors.error,
          foreground: Colors.white,
          disabledBackground: AppColors.error.withOpacity(0.3),
        );
      case AnimatedButtonVariant.success:
        return _ButtonColors(
          background: AppColors.success,
          foreground: isDark ? AppColors.darkBackground : Colors.white,
          disabledBackground: AppColors.success.withOpacity(0.3),
        );
    }
  }

  _ButtonDimensions _getDimensions() {
    switch (widget.size) {
      case AnimatedButtonSize.small:
        return _ButtonDimensions(
          height: 36,
          horizontalPadding: AppSpacing.md,
          borderRadius: AppSpacing.radiusSm,
          textStyle: AppTypography.buttonSmall,
          iconSize: 16,
          iconGap: AppSpacing.xs,
        );
      case AnimatedButtonSize.medium:
        return _ButtonDimensions(
          height: 48,
          horizontalPadding: AppSpacing.xl,
          borderRadius: AppSpacing.radiusMd,
          textStyle: AppTypography.button,
          iconSize: 20,
          iconGap: AppSpacing.sm,
        );
      case AnimatedButtonSize.large:
        return _ButtonDimensions(
          height: 56,
          horizontalPadding: AppSpacing.xxl,
          borderRadius: AppSpacing.radiusLg,
          textStyle: AppTypography.button,
          iconSize: 24,
          iconGap: AppSpacing.sm,
        );
    }
  }
}

/// Animated success check icon
class _SuccessCheckIcon extends StatefulWidget {
  const _SuccessCheckIcon({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  State<_SuccessCheckIcon> createState() => _SuccessCheckIconState();
}

class _SuccessCheckIconState extends State<_SuccessCheckIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.overshoot),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        Icons.check_rounded,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;
  final Color disabledBackground;

  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
    required this.disabledBackground,
  });
}

class _ButtonDimensions {
  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final TextStyle textStyle;
  final double iconSize;
  final double iconGap;

  const _ButtonDimensions({
    required this.height,
    required this.horizontalPadding,
    required this.borderRadius,
    required this.textStyle,
    required this.iconSize,
    required this.iconGap,
  });
}
