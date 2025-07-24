class HomeProductModel {
  final String id;
  final String name;
  final num price;
  final String image;
  final String restaurantId;
  final String categoryId;
  final int soldCount;

  HomeProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.restaurantId,
    required this.categoryId,
    required this.soldCount,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as num,
      image: json['image'] as String,
      restaurantId: json['restaurant_id'] as String,
      categoryId: json['category_id'] as String,
      soldCount: json['sold_count'] is int
          ? json['sold_count'] as int
          : int.tryParse(json['sold_count'].toString()) ?? 0,
    );
  }
}
