class OrderProduct {
  final String productId;
  final String name;
  final int quantity;
  final double price;

  OrderProduct({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String restaurantId;
  final List<OrderProduct> products;
  final double totalPrice;
  final String status;
  final String createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.products,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      restaurantId: json['restaurant_id'],
      products: (json['products'] as List<dynamic>)
          .map((product) => OrderProduct.fromJson(product))
          .toList(),
      totalPrice: json['total_price'].toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}