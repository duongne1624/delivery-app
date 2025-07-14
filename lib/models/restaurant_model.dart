class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final String image;
  final bool? isActive;
  final String? openTime;
  final String? closeTime;
  final bool? isOpenNow;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalOrders;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.image,
    this.isActive,
    this.openTime,
    this.closeTime,
    this.isOpenNow,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.totalOrders,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'],
      isActive: json['is_active'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      isOpenNow: json['is_open_now'],
      createdById: json['created_by_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      totalOrders: int.tryParse(json['total_orders'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'image': image,
      'is_active': isActive,
      'open_time': openTime,
      'close_time': closeTime,
      'is_open_now': isOpenNow,
      'created_by_id': createdById,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'total_orders': totalOrders,
    };
  }
}
