class HomeRestaurantModel {
  final String id;
  final String name;
  final String address;
  final String image;
  final int totalOrders;

  HomeRestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.totalOrders,
  });

  factory HomeRestaurantModel.fromJson(Map<String, dynamic> json) {
    return HomeRestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      image: json['image'] as String,
      totalOrders: json['total_orders'] is int
          ? json['total_orders'] as int
          : int.tryParse(json['total_orders'].toString()) ?? 0,
    );
  }
}
