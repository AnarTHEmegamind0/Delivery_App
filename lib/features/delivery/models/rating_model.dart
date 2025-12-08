class ReviewModel {
  final String id;
  final String customerName;
  final int rating;
  final String? comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.customerName,
    required this.rating,
    this.comment,
    required this.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class RatingBreakdown {
  final int fiveStars;
  final int fourStars;
  final int threeStars;
  final int twoStars;
  final int oneStar;

  RatingBreakdown({
    required this.fiveStars,
    required this.fourStars,
    required this.threeStars,
    required this.twoStars,
    required this.oneStar,
  });

  int get total => fiveStars + fourStars + threeStars + twoStars + oneStar;

  double getPercentage(int count) {
    if (total == 0) return 0;
    return (count / total) * 100;
  }

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingBreakdown(
      fiveStars: json['fiveStars'] as int,
      fourStars: json['fourStars'] as int,
      threeStars: json['threeStars'] as int,
      twoStars: json['twoStars'] as int,
      oneStar: json['oneStar'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fiveStars': fiveStars,
      'fourStars': fourStars,
      'threeStars': threeStars,
      'twoStars': twoStars,
      'oneStar': oneStar,
    };
  }
}

class RatingModel {
  final double averageRating;
  final int totalReviews;
  final RatingBreakdown breakdown;
  final List<ReviewModel> recentReviews;
  final double monthlyChange; // e.g., +0.2

  RatingModel({
    required this.averageRating,
    required this.totalReviews,
    required this.breakdown,
    this.recentReviews = const [],
    this.monthlyChange = 0.0,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      breakdown: RatingBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
      recentReviews: (json['recentReviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyChange: (json['monthlyChange'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'breakdown': breakdown.toJson(),
      'recentReviews': recentReviews.map((e) => e.toJson()).toList(),
      'monthlyChange': monthlyChange,
    };
  }

  RatingModel copyWith({
    double? averageRating,
    int? totalReviews,
    RatingBreakdown? breakdown,
    List<ReviewModel>? recentReviews,
    double? monthlyChange,
  }) {
    return RatingModel(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      breakdown: breakdown ?? this.breakdown,
      recentReviews: recentReviews ?? this.recentReviews,
      monthlyChange: monthlyChange ?? this.monthlyChange,
    );
  }
}
