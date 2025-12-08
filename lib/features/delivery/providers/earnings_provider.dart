import 'package:flutter/foundation.dart';
import '../models/earnings_model.dart';
import '../repositories/earnings_repository.dart';

class EarningsProvider with ChangeNotifier {
  final EarningsRepository _repository = EarningsRepository();
  
  EarningsModel? _earnings;
  bool _isLoading = false;
  String? _error;

  EarningsModel? get earnings => _earnings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get dailyEarnings => _earnings?.daily ?? 0;
  double get weeklyEarnings => _earnings?.weekly ?? 0;
  double get monthlyEarnings => _earnings?.monthly ?? 0;
  double get totalBalance => _earnings?.totalBalance ?? 0;

  Future<void> fetchEarnings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _earnings = await _repository.fetchEarnings();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestWithdrawal(double amount) async {
    if (_earnings == null || amount > _earnings!.totalBalance) {
      _error = 'Insufficient balance';
      notifyListeners();
      return;
    }

    try {
      await _repository.requestWithdrawal(amount);
      // Refresh earnings after withdrawal
      await fetchEarnings();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
