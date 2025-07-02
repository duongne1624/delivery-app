import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class RestaurantProvider with ChangeNotifier {
  List<Map<String, dynamic>> _restaurants = [];
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  List<Map<String, dynamic>> get restaurants => _restaurants;
  bool get hasMore => _hasMore;

  RestaurantProvider() {
    _loadRestaurants();
  }

  void _loadRestaurants() {
    final allRestaurants = List<Map<String, dynamic>>.from(MockData.data['restaurants']);
    final startIndex = _currentPage * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= allRestaurants.length) {
      _hasMore = false;
      return;
    }

    _restaurants.addAll(allRestaurants.sublist(
      startIndex,
      endIndex > allRestaurants.length ? allRestaurants.length : endIndex,
    ));
    _currentPage++;
    notifyListeners();
  }

  void loadMore() {
    if (_hasMore) {
      _loadRestaurants();
    }
  }
}