import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/utils.dart';

class EarningsDisplay extends StatelessWidget {
  final double amount;
  final String label;

  const EarningsDisplay({
    super.key,
    required this.amount,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          AppUtils.formatCurrency(amount),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
        ),
      ],
    );
  }
}
