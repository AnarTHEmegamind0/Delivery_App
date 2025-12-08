class DriverProfileModel {
  final String id;
  final String name;
  final String phone;
  final double rating;
  final int totalReviews;
  final int totalDeliveries;
  final String vehicleNumber;
  final String? vehicleType;
  final String? profileImageUrl;
  final bool isOnline;

  DriverProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalReviews,
    required this.totalDeliveries,
    required this.vehicleNumber,
    this.vehicleType,
    this.profileImageUrl,
    this.isOnline = false,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      totalDeliveries: json['totalDeliveries'] as int,
      vehicleNumber: json['vehicleNumber'] as String,
      vehicleType: json['vehicleType'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalDeliveries': totalDeliveries,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'profileImageUrl': profileImageUrl,
      'isOnline': isOnline,
    };
  }

  DriverProfileModel copyWith({
    String? id,
    String? name,
    String? phone,
    double? rating,
    int? totalReviews,
    int? totalDeliveries,
    String? vehicleNumber,
    String? vehicleType,
    String? profileImageUrl,
    bool? isOnline,
  }) {
    return DriverProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
