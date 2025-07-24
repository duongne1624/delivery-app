import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/home_restaurant_model.dart';
import '../models/home_product_model.dart';
import '../services/dio_service.dart';

class HomeProvider with ChangeNotifier {
  List<CategoryModel> categories = [];
  List<HomeRestaurantModel> topRestaurants = [];
  List<HomeProductModel> topProducts = [];

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
      topRestaurants = restaurantList.map((e) => HomeRestaurantModel.fromJson(e)).toList();
      topProducts = productList.map((e) => HomeProductModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading home data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
