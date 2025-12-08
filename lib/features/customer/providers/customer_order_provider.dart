import 'package:flutter/material.dart';
import '../models/customer_order_model.dart';
import '../repositories/customer_order_repository.dart';

class CustomerOrderProvider extends ChangeNotifier {
  final CustomerOrderRepository _repository = CustomerOrderRepository();
  List<CustomerOrderModel> _orders = [];
  bool _isLoading = false;

  List<CustomerOrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  // Filtered lists
  List<CustomerOrderModel> get activeOrders => _orders
      .where((o) => o.status == CustomerOrderStatus.preparing || o.status == CustomerOrderStatus.delivering)
      .toList();
      
  List<CustomerOrderModel> get pastOrders => _orders
      .where((o) => o.status == CustomerOrderStatus.completed || o.status == CustomerOrderStatus.cancelled)
      .toList();

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 500));
    _orders = await _repository.getOrders();
    
    _isLoading = false;
    notifyListeners();
  }
}
