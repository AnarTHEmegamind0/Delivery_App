import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _repository = OrderRepository();
  
  List<OrderModel> _availableOrders = [];
  List<OrderModel> _inProgressOrders = [];
  List<OrderModel> _completedOrders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get availableOrders => _availableOrders;
  List<OrderModel> get inProgressOrders => _inProgressOrders;
  List<OrderModel> get completedOrders => _completedOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAvailableOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availableOrders = await _repository.fetchAvailableOrders();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInProgressOrders() async {
    try {
      _inProgressOrders = await _repository.fetchInProgressOrders();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchCompletedOrders() async {
    try {
      _completedOrders = await _repository.fetchCompletedOrders();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await _repository.acceptOrder(orderId);
      
      // Move order from available to in progress
      final order = _availableOrders.firstWhere((o) => o.id == orderId);
      _availableOrders.removeWhere((o) => o.id == orderId);
      _inProgressOrders.add(order.copyWith(status: OrderStatus.accepted));
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeOrder(String orderId) async {
    try {
      await _repository.completeOrder(orderId);
      
      // Move order from in progress to completed
      final order = _inProgressOrders.firstWhere((o) => o.id == orderId);
      _inProgressOrders.removeWhere((o) => o.id == orderId);
      _completedOrders.insert(0, order.copyWith(status: OrderStatus.completed));
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshAllOrders() async {
    await Future.wait([
      fetchAvailableOrders(),
      fetchInProgressOrders(),
      fetchCompletedOrders(),
    ]);
  }
}
