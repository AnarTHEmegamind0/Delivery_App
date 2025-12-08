import '../models/customer_order_model.dart';

class CustomerOrderRepository {
  Future<List<CustomerOrderModel>> getOrders() async {
    // Mock data matching screenshots
    return [
      // 1. Active Order - Burger King (Delivering)
      CustomerOrderModel(
        id: 'ORDER-001',
        restaurantName: 'Burger King',
        items: [
          CustomerOrderItem(name: 'Whopper Combo', price: 18000, quantity: 1),
          CustomerOrderItem(name: 'Coca Cola 500ml', price: 3000, quantity: 2),
        ],
        totalAmount: 45000,
        status: CustomerOrderStatus.delivering,
        time: '14:30',
        driver: CustomerDriverInfo(
          name: 'Д. Дорж',
          vehiclePlate: 'УБ 1234 АА',
          phoneNumber: '99112233',
          rating: 4.9,
        ),
        deliveryTimeEstimate: '15 минут',
      ),
      
      // 2. Active Order - KFC (Preparing)
      CustomerOrderModel(
        id: 'ORDER-002',
        restaurantName: 'KFC',
        items: [
          CustomerOrderItem(name: 'Zinger Box', price: 15900, quantity: 1),
          CustomerOrderItem(name: 'Large Fries', price: 5000, quantity: 1),
        ],
        totalAmount: 38000,
        status: CustomerOrderStatus.preparing,
        time: '14:45',
      ),
      
      // 3. Completed Order - Pizza Hut (For Rating)
      CustomerOrderModel(
        id: 'ORDER-003',
        restaurantName: 'Pizza Hut',
        items: [
          CustomerOrderItem(name: 'Pepperoni Large', price: 45000, quantity: 1),
          CustomerOrderItem(name: 'Chicken Wings', price: 11000, quantity: 1),
        ],
        totalAmount: 62000, // 56k + 6k delivery
        deliveryFee: 6000,
        status: CustomerOrderStatus.completed,
        time: 'Yesterday',
        driver: CustomerDriverInfo(
          name: 'Д. Дорж',
          vehiclePlate: 'УБ 1234 АА',
          phoneNumber: '99112233',
          rating: 4.9,
        ),
      ),
    ];
  }
}
