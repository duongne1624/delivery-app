class ProductModel {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String restaurantId;
  final int totalSold;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.restaurantId,
    required this.totalSold
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['image'],
      restaurantId: json['restaurant_id'],
      totalSold: json['total_sold']
    );
  }
}
