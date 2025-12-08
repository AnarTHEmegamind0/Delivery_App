enum CustomerOrderStatus {
  preparing, // Бэлтгэж байна
  delivering, // Хүргэж байна
  completed, // Дууссан
  cancelled, // Цуцлагдсан
}

class CustomerOrderModel {
  final String id;
  final String restaurantName;
  final List<CustomerOrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final CustomerOrderStatus status;
  final String time; // e.g., "14:30"
  final CustomerDriverInfo? driver;
  final String? deliveryTimeEstimate; // e.g., "15 минут"

  CustomerOrderModel({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    this.deliveryFee = 0,
    required this.status,
    required this.time,
    this.driver,
    this.deliveryTimeEstimate,
  });

  // Derived getters
  double get subtotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  
  // Helpers for UI
  String get statusText {
    switch (status) {
      case CustomerOrderStatus.preparing:
        return 'Бэлтгэж байна';
      case CustomerOrderStatus.delivering:
        return 'Хүргэж байна';
      case CustomerOrderStatus.completed:
        return 'Дууссан';
      case CustomerOrderStatus.cancelled:
        return 'Цуцлагдсан';
    }
  }
}

class CustomerOrderItem {
  final String name;
  final String? description; // e.g. "Large", "Whopper"
  final double price;
  final int quantity;

  CustomerOrderItem({
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
  });
}

class CustomerDriverInfo {
  final String name;
  final String vehiclePlate;
  final String phoneNumber;
  final double rating;

  CustomerDriverInfo({
    required this.name,
    required this.vehiclePlate,
    required this.phoneNumber,
    required this.rating,
  });
}
