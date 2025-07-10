import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/dio_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? user;

  bool get isAuthenticated => user != null;

  Future<bool> loadUser() async {
    try {
      final res = await DioService.instance.get('/users/me');
      user = UserModel.fromJson(res.data['data']);
      notifyListeners();
      return true;
    } catch (e) {
      await DioService.clearToken();
      return false;
    }
  }

  Future<bool> login(String phone, String password) async {
    try {
      final res = await DioService.instance.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });

      final token = res.data['data']['access_token'];
      await DioService.setToken(token);

      return await loadUser();
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    String? email,
    required String password,
  }) async {
    try {
      final res = await DioService.instance.post('/auth/register', data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      });

      return res.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    user = null;
    await DioService.clearToken();
    notifyListeners();
  }
}
