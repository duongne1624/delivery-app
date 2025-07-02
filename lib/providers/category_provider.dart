import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class CategoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _categories = [];

  List<Map<String, dynamic>> get categories => _categories;

  CategoryProvider() {
    _loadCategories();
  }

  void _loadCategories() {
    _categories = List<Map<String, dynamic>>.from(MockData.data['categories']);
    notifyListeners();
  }
}