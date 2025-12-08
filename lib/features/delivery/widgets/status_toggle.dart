import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class StatusToggle extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onChanged;

  const StatusToggle({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isOnline ? AppTheme.primaryGradient : null,
        color: isOnline ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: isOnline
            ? [
                BoxShadow(
                  color: AppTheme.successColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!isOnline),
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.white : Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  isOnline ? 'ONLINE' : 'OFFLINE',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isOnline ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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
