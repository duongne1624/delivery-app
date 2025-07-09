class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String imageUrl;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      imageUrl: json['image'] ?? '',
    );
  }
}
