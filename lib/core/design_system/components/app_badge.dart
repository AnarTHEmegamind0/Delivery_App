import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

enum AppBadgeType { success, warning, error, info }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeType type;

  const AppBadge({
    super.key,
    required this.label,
    this.type = AppBadgeType.info,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case AppBadgeType.success:
        bgColor = AppColors.success.withOpacity(0.2);
        textColor = AppColors.success;
        break;
      case AppBadgeType.warning:
        bgColor = AppColors.warning.withOpacity(0.2);
        textColor = AppColors.warning;
        break;
      case AppBadgeType.error:
        bgColor = AppColors.error.withOpacity(0.2);
        textColor = AppColors.error;
        break;
      case AppBadgeType.info:
        bgColor = AppColors.info.withOpacity(0.2);
        textColor = AppColors.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
