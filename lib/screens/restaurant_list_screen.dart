import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/restaurant_list_widget.dart';

class RestaurantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách quán ăn'),
      ),
      body: RestaurantListWidget(isHomeScreen: false),
    );
  }
}
