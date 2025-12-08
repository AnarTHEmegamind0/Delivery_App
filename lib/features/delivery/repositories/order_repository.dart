import '../models/order_model.dart';

class OrderRepository {
  // Mock data for now
  Future<List<OrderModel>> fetchAvailableOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      OrderModel(
        id: '1',
        address: 'Баянзүрх дүүрэг, 15-р хороо, Энхтайваны өргөн чөлөө 24',
        distanceInKm: 2.3,
        time: '14:30',
        price: 45000,
        status: OrderStatus.available,
        customerName: 'Б. Батсайхан',
        customerPhone: '+97699111234',
      ),
      OrderModel(
        id: '2',
        address: 'Сухбаатар дүүрэг, 1-р хороо, Сухбаатарын талбай 1',
        distanceInKm: 4.1,
        time: '15:00',
        price: 52000,
        status: OrderStatus.available,
        customerName: 'Д. Дорж',
        customerPhone: '+97699112345',
      ),
    ];
  }

  Future<List<OrderModel>> fetchInProgressOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      OrderModel(
        id: '3',
        address: 'Баянзүрх дүүрэг, 15-р хороо, Энхтайваны өргөн чөлөө 24, 5-р давхар, 512 тоот',
        distanceInKm: 0.08,
        time: '14:45',
        price: 45000,
        status: OrderStatus.inProgress,
        customerName: 'Б. Батсайхан',
        customerPhone: '+97699111234',
        notes: 'Лифт ажиллахгүй байна, шатаар өгнө үү. Утсаар холбогдоно уу.',
      ),
    ];
  }

  Future<List<OrderModel>> fetchCompletedOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<void> acceptOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make API call
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make API call
  }

  Future<void> completeOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make API call
  }
}
