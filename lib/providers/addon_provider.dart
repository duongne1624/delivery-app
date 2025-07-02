import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/addon.dart';

class AddonProvider with ChangeNotifier {
  List<Addon> get addons =>
      (MockData.data['addons'] as List<dynamic>)
          .map((addon) => Addon.fromJson(addon))
          .toList();
}