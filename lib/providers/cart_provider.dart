import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  void addToCart(Map<String, dynamic> product) {
    _cartItems.add({
      'id': product['id'] ?? UniqueKey().toString(),
      'name': product['name'],
      'price': product['price'],
      'image': product['image'],
      'quantity': 1,
    });
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void updateQuantity(String id, int quantity) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    if (item != null) {
      item['quantity'] = quantity > 0 ? quantity : 1;
      notifyListeners();
    }
  }
}