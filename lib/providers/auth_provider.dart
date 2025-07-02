import 'package:flutter/material.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(String phone, String password) {
    final loginData = MockData.data['auth']['login'];
    if (loginData['phone'] == phone && loginData['password'] == password) {
      final userJson = loginData['response']['user'];
      userJson['role'] = userJson['role'] ?? 'customer';
      _user = User.fromJson(userJson);
      notifyListeners();
    }
  }

  void register(String phone, String password, String email, String name) {
    final registerData = MockData.data['auth']['register'];
    if (registerData['phone'] == phone && registerData['password'] == password && registerData['email'] == email) {
      _user = User(
        id: 'user_new',
        phone: phone,
        email: email,
        role: 'customer',
        name: name,
      );
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}