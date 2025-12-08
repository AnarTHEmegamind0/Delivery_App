import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum AppCardVariant { solid, glass, outlined }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.solid,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppCardVariant.glass) {
      return _buildGlassCard(context);
    }
    return _buildStandardCard(context);
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: AppColors.glassGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context) {
    final theme = Theme.of(context);
    final isOutlined = variant == AppCardVariant.outlined;

    return Card(
      elevation: isOutlined ? 0 : theme.cardTheme.elevation,
      color: isOutlined ? Colors.transparent : theme.cardTheme.color,
      shape: isOutlined
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor),
            )
          : theme.cardTheme.shape,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
