import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3000',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static Dio get instance => _dio;

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _dio.options.headers.remove('Authorization');
  }
}
