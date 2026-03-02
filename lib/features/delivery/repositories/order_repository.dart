import '../models/order_model.dart';

class OrderRepository {
  // Sample restaurant images for demo
  static const _restaurantImages = [
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=800',
  ];

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
        restaurantName: 'KFC Mongolia',
        restaurantImageUrl: _restaurantImages[0],
        itemsSummary: 'Chicken Bucket, Fries, Cola',
        itemCount: 3,
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
        restaurantName: 'Pizza Hut',
        restaurantImageUrl: _restaurantImages[1],
        itemsSummary: 'Large Pepperoni Pizza, Garlic Bread',
        itemCount: 2,
      ),
      OrderModel(
        id: '4',
        address: 'Хан-Уул дүүрэг, Зайсан, Хилтон зочид буудлын ард',
        distanceInKm: 5.8,
        time: '15:30',
        price: 68000,
        status: OrderStatus.available,
        customerName: 'Н. Номин',
        customerPhone: '+97699445566',
        restaurantName: 'Burger King',
        restaurantImageUrl: _restaurantImages[2],
        itemsSummary: 'Whopper Meal x2, Onion Rings',
        itemCount: 5,
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
        restaurantName: 'Veranda Restaurant',
        restaurantImageUrl: _restaurantImages[3],
        itemsSummary: 'Caesar Salad, Grilled Salmon, Tiramisu',
        itemCount: 3,
      ),
    ];
  }

  Future<List<OrderModel>> fetchCompletedOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      OrderModel(
        id: '5',
        address: 'Чингэлтэй дүүрэг, Гэмтэл согог судлалын төв',
        distanceInKm: 3.2,
        time: '12:00',
        price: 32000,
        status: OrderStatus.completed,
        customerName: 'Э. Энхболд',
        customerPhone: '+97699778899',
        restaurantName: 'Sushi Master',
        restaurantImageUrl: _restaurantImages[4],
        itemsSummary: 'Dragon Roll, Miso Soup',
        itemCount: 2,
      ),
      OrderModel(
        id: '6',
        address: 'Баянгол дүүрэг, Их тойруу',
        distanceInKm: 2.1,
        time: '11:30',
        price: 28000,
        status: OrderStatus.completed,
        customerName: 'С. Сараа',
        customerPhone: '+97699001122',
        restaurantName: 'Modern Nomads',
        restaurantImageUrl: _restaurantImages[5],
        itemsSummary: 'Khorkhog, Buuz',
        itemCount: 2,
      ),
    ];
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
