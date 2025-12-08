import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../providers/rating_provider.dart';
import '../widgets/rating_display.dart';

class RatingDetailPage extends StatefulWidget {
  const RatingDetailPage({super.key});

  @override
  State<RatingDetailPage> createState() => _RatingDetailPageState();
}

class _RatingDetailPageState extends State<RatingDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RatingProvider>().fetchRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.myRating),
      ),
      body: Consumer<RatingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.ratings == null) {
            return const Center(child: Text('Мэдээлэл олдсонгүй'));
          }

          final rating = provider.ratings!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating Display Card
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: RatingDisplay(rating: rating),
                ),
                
                // Rating Breakdown
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.ratingBreakdown,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppTheme.spacingL),
                          _buildRatingBar(context, 5, rating.breakdown.fiveStars, rating.breakdown),
                          _buildRatingBar(context, 4, rating.breakdown.fourStars, rating.breakdown),
                          _buildRatingBar(context, 3, rating.breakdown.threeStars, rating.breakdown),
                          _buildRatingBar(context, 2, rating.breakdown.twoStars, rating.breakdown),
                          _buildRatingBar(context, 1, rating.breakdown.oneStar, rating.breakdown),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Recent Reviews
                if (rating.recentReviews.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Text(
                      AppConstants.recentReviews,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...rating.recentReviews.map((review) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    review.customerName,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                Text(
                                  AppUtils.formatDate(review.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  size: 16,
                                  color: index < review.rating
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                                );
                              }),
                            ),
                            if (review.comment != null) ...[
                              const SizedBox(height: AppTheme.spacingS),
                              Text(
                                review.comment!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: AppTheme.spacingL),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, int stars, int count, breakdown) {
    final percentage = breakdown.getPercentage(count);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
          Text(
            '$stars',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: AppTheme.spacingXS),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          SizedBox(
            width: 60,
            child: Text(
              '$count (${percentage.toStringAsFixed(0)}%)',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
