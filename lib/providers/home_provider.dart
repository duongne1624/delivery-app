import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/restaurant_model.dart';
import '../models/product_model.dart';
import '../services/dio_service.dart';

class HomeProvider with ChangeNotifier {
  List<CategoryModel> categories = [];
  List<RestaurantModel> topRestaurants = [];
  List<ProductModel> topProducts = [];

  bool isLoading = true;

  Future<void> loadHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      final responses = await Future.wait([
        DioService.instance.get('/categories'),
        DioService.instance.get('/restaurants/top-selling', queryParameters: {'limit': 10}),
        DioService.instance.get('/products/top-selling', queryParameters: {'limit': 10}),
      ]);

      final categoryList = responses[0].data['data'] as List;
      final restaurantList = responses[1].data['data']['data'] as List;
      final productList = responses[2].data['data'] as List;

      categories = categoryList.map((e) => CategoryModel.fromJson(e)).toList();
      topRestaurants = restaurantList.map((e) => RestaurantModel.fromJson(e)).toList();
      topProducts = productList.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading home data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
