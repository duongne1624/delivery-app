class Product {
  final String id;
  final String name;
  final double price;
  final String categoryId;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      categoryId: json['category_id'],
      description: json['description'],
      image: json['image'],
    );
  }
}