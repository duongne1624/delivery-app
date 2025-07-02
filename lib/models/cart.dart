import 'addon.dart';

class CartItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final List<Addon> addons;

  CartItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.addons,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      addons: (json['addons'] as List<dynamic>)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
    );
  }
}

class Cart {
  final String userId;
  final List<CartItem> items;
  double totalPrice;

  Cart({
    required this.userId,
    required this.items,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userId: json['user_id'],
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: json['total_price'].toDouble(),
    );
  }
}