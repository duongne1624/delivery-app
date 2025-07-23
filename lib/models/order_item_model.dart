class OrderItemModel {
  final String id;
  final int quantity;
  final double price;
  final ProductOrderModel product;

  OrderItemModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      quantity: (json['quantity'] is int)
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      product: ProductOrderModel.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'product': product.toJson(),
    };
  }
}

class ProductOrderModel {
  final String id;
  final String name;
  final double price;
  final String image;

  ProductOrderModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory ProductOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    };
  }
}
