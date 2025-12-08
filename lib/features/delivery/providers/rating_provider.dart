import 'package:flutter/foundation.dart';
import '../models/rating_model.dart';
import '../repositories/rating_repository.dart';

class RatingProvider with ChangeNotifier {
  final RatingRepository _repository = RatingRepository();
  
  RatingModel? _ratings;
  bool _isLoading = false;
  String? _error;

  RatingModel? get ratings => _ratings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get averageRating => _ratings?.averageRating ?? 0;
  int get totalReviews => _ratings?.totalReviews ?? 0;

  Future<void> fetchRatings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ratings = await _repository.fetchRatings();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
