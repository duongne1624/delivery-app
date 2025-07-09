import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../services/restaurant_service.dart';

class RestaurantProvider with ChangeNotifier {
  final List<RestaurantModel> _restaurants = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  List<RestaurantModel> get restaurants => _restaurants;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newRestaurants = await RestaurantService.fetchRestaurants(_page);
      if (newRestaurants.isEmpty) {
        _hasMore = false;
      } else {
        _restaurants.addAll(newRestaurants);
        _page++;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _restaurants.clear();
    _page = 1;
    _hasMore = true;
    notifyListeners();
    fetchMore();
  }
}
