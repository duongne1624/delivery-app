import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class ProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  List<Map<String, dynamic>> get products => _products;
  bool get hasMore => _hasMore;

  ProductProvider() {
    _loadProducts();
  }

  void _loadProducts() {
    final allProducts = List<Map<String, dynamic>>.from(MockData.data['products']);
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= allProducts.length) {
      _hasMore = false;
      return;
    }

    _products.addAll(allProducts.sublist(
      startIndex,
      endIndex > allProducts.length ? allProducts.length : endIndex,
    ));
    _currentPage++;
    notifyListeners();
  }

  void loadMore() {
    if (_hasMore) {
      _loadProducts();
    }
  }

  List<Map<String, dynamic>> getProductsByRestaurant(String restaurantId) {
    return _products.where((product) => product['restaurant_id'] == restaurantId).toList();
  }
}