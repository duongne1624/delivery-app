class OrderItemModel {
  final String id;
  final int quantity;
  final int price;
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
      price: (json['price'] is int)
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      product: ProductOrderModel.fromJson(json['product']),
    );
  }
}

class ProductOrderModel {
  final String id;
  final String name;
  final int price;
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
      price: (json['price'] is int)
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      image: json['product'] ?? '',
    );
  }
}
