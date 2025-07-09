// lib/screens/restaurant/top_restaurants_screen.dart
import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';

class TopRestaurantsScreen extends StatefulWidget {
  const TopRestaurantsScreen({super.key});

  @override
  State<TopRestaurantsScreen> createState() => _TopRestaurantsScreenState();
}

class _TopRestaurantsScreenState extends State<TopRestaurantsScreen> {
  List<RestaurantModel> _restaurants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await DioService.instance.get('/restaurants/top-selling', queryParameters: {'limit': 100});
      final data = res.data['data'] as List;
      _restaurants = data.map((e) => RestaurantModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhà hàng bán chạy')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _restaurants.length,
              itemBuilder: (_, i) {
                final item = _restaurants[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.address),
                  leading: item.imageUrl != null
                      ? Image.network(item.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.store),
                );
              },
            ),
    );
  }
}
