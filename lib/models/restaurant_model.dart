class RestaurantModel {
  final String id;
  final String name;
  final String? nameNormalized;
  final String address;
  final String? phone;
  final String image;
  final String? imagePublicId;
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
    this.nameNormalized,
    required this.address,
    this.phone,
    required this.image,
    this.imagePublicId,
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
      nameNormalized: json['name_normalized'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'],
      imagePublicId: json['image_public_id'],
      isActive: json['is_active'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      isOpenNow: json['is_open_now'],
      createdById: json['created_by_id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      totalOrders: json['total_orders'] != null
          ? int.tryParse(json['total_orders'].toString())
          : null,
    );
  }
}
