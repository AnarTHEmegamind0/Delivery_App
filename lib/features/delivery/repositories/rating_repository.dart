import '../models/rating_model.dart';

class RatingRepository {
  // Mock data for now
  Future<RatingModel> fetchRatings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return RatingModel(
      averageRating: 4.8,
      totalReviews: 156,
      breakdown: RatingBreakdown(
        fiveStars: 142,
        fourStars: 12,
        threeStars: 2,
        twoStars: 0,
        oneStar: 0,
      ),
      recentReviews: [
        ReviewModel(
          id: '1',
          customerName: 'Б. Батсайхан',
          rating: 5,
          comment: 'Маш сайн үйлчилгээ, хурдан хүргэсэн',
          timestamp: DateTime.now().subtract(const Duration(hours: 14, minutes: 30)),
        ),
        ReviewModel(
          id: '2',
          customerName: 'Д. Дорж',
          rating: 5,
          comment: null,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ReviewModel(
          id: '3',
          customerName: 'С. Сарантуяа',
          rating: 4,
          comment: 'Сайн байсан',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      monthlyChange: 0.2,
    );
  }

  Future<List<ReviewModel>> fetchRecentReviews({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ratings = await fetchRatings();
    return ratings.recentReviews.take(limit).toList();
  }
}
