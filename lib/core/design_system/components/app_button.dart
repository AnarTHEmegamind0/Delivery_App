import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

enum AppButtonVariant { primary, secondary, ghost }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getStyle(),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: AppTypography.button),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  ButtonStyle _getStyle() {
    Color? backgroundColor;
    Color? foregroundColor;
    Color? borderSideColor;
    double elevation = 0;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primaryGreen;
        foregroundColor = Colors.black; // Better contrast on bright green
        elevation = 0;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = AppColors.darkCard; // Or surface depending on theme, handled by context usually?
        // Using static colors for now, but ideally should use Theme.of(context) if we want strict theme adapting
        // Let's use Theme Lookups for flexibility
        // But for "Design System" enforcing specific tokens is common.
        // Let's stick to the brief: "Dark Theme (default)"
        backgroundColor = AppColors.darkCard; 
        foregroundColor = AppColors.darkTextPrimary;
        borderSideColor = AppColors.darkBorder;
        break;
      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primaryGreen;
        break;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderSideColor != null
            ? BorderSide(color: borderSideColor)
            : BorderSide.none,
      ),
    );
  }
}
