import 'package:dio/dio.dart';
import '../models/restaurant_model.dart';
import 'dio_service.dart';

class RestaurantService {
  static Future<List<RestaurantModel>> fetchRestaurants(int page, {int limit = 10}) async {
    final res = await DioService.instance.get('/restaurants/paginate', queryParameters: {
      'page': page,
      'limit': limit,
    });

    final List data = res.data['data'];
    return data.map((e) => RestaurantModel.fromJson(e)).toList();
  }
}