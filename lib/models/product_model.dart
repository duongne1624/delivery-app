import 'restaurant_model.dart';
import 'category_model.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String image;
  final bool isAvailable;
  final int discountPercent;
  final int soldCount;
  final double rating;
  final int totalReviews;
  final String restaurantId;
  final RestaurantModel? restaurant;
  final String categoryId;
  final CategoryModel? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.image,
    required this.isAvailable,
    required this.discountPercent,
    required this.soldCount,
    required this.rating,
    required this.totalReviews,
    required this.restaurantId,
    this.restaurant,
    required this.categoryId,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      description: json['description'] ?? 'des',
      image: json['image'],
      isAvailable: json['is_available'] ?? false,
      discountPercent: json['discount_percent'] ?? 0,
      soldCount: json['sold_count'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      restaurantId: json['restaurant_id'],
      restaurant: json['restaurant'] != null
          ? RestaurantModel.fromJson(json['restaurant'])
          : null,
      categoryId: json['category_id'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price.toStringAsFixed(2),
      'description': description,
      'image': image,
      'is_available': isAvailable,
      'discount_percent': discountPercent,
      'category_id': categoryId,
      if (category != null) 'category': category!.toJson(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? image,
    bool? isAvailable,
    int? discountPercent,
    int? soldCount,
    double? rating,
    int? totalReviews,
    String? restaurantId,
    RestaurantModel? restaurant,
    String? categoryId,
    CategoryModel? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      discountPercent: discountPercent ?? this.discountPercent,
      soldCount: soldCount ?? this.soldCount,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurant: restaurant ?? this.restaurant,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
