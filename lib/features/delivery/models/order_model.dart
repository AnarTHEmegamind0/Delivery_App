enum OrderStatus {
  available,
  accepted,
  inProgress,
  completed,
  cancelled,
}

class OrderModel {
  final String id;
  final String address;
  final double distanceInKm;
  final String time;
  final double price;
  final OrderStatus status;
  final String? customerName;
  final String? customerPhone;
  final String? notes;
  final String? restaurantName;
  final String? restaurantImageUrl;
  final String? itemsSummary;
  final int? itemCount;

  OrderModel({
    required this.id,
    required this.address,
    required this.distanceInKm,
    required this.time,
    required this.price,
    required this.status,
    this.customerName,
    this.customerPhone,
    this.notes,
    this.restaurantName,
    this.restaurantImageUrl,
    this.itemsSummary,
    this.itemCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      address: json['address'] as String,
      distanceInKm: (json['distanceInKm'] as num).toDouble(),
      time: json['time'] as String,
      price: (json['price'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.available,
      ),
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      restaurantName: json['restaurantName'] as String?,
      restaurantImageUrl: json['restaurantImageUrl'] as String?,
      itemsSummary: json['itemsSummary'] as String?,
      itemCount: json['itemCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'distanceInKm': distanceInKm,
      'time': time,
      'price': price,
      'status': status.toString().split('.').last,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
      'restaurantName': restaurantName,
      'restaurantImageUrl': restaurantImageUrl,
      'itemsSummary': itemsSummary,
      'itemCount': itemCount,
    };
  }

  OrderModel copyWith({
    String? id,
    String? address,
    double? distanceInKm,
    String? time,
    double? price,
    OrderStatus? status,
    String? customerName,
    String? customerPhone,
    String? notes,
    String? restaurantName,
    String? restaurantImageUrl,
    String? itemsSummary,
    int? itemCount,
  }) {
    return OrderModel(
      id: id ?? this.id,
      address: address ?? this.address,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      time: time ?? this.time,
      price: price ?? this.price,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      itemsSummary: itemsSummary ?? this.itemsSummary,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}
