import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/constants.dart';
import '../models/rating_model.dart';

class RatingDisplay extends StatelessWidget {
  final RatingModel rating;

  const RatingDisplay({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating Number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          rating.averageRating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 64,
                              ),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      '${rating.totalReviews} ${AppConstants.reviews}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    Text(
                      '${rating.breakdown.total} ${AppConstants.deliveries}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
              
              // Bookmark Icon
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          
          if (rating.monthlyChange != 0) ...[
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Icon(
                  rating.monthlyChange > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  '${AppConstants.thisMonth} ${rating.monthlyChange > 0 ? '+' : ''}${rating.monthlyChange.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
