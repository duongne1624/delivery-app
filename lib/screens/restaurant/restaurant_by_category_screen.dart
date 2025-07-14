// lib/screens/restaurant/restaurant_by_category_screen.dart
import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';

class RestaurantByCategoryScreen extends StatefulWidget {
  final CategoryModel category;

  const RestaurantByCategoryScreen({super.key, required this.category});

  @override
  State<RestaurantByCategoryScreen> createState() => _RestaurantByCategoryScreenState();
}

class _RestaurantByCategoryScreenState extends State<RestaurantByCategoryScreen> {
  final List<RestaurantModel> _restaurants = [];
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final res = await DioService.instance.get(
        '/restaurants/paginate-by-product-category/${widget.category.id}',
        queryParameters: {'limit': _limit, 'page': _page},
      );
      final data = res.data['data'] as List;
      final fetched = data.map((e) => RestaurantModel.fromJson(e)).toList();

      if (fetched.length < _limit) _hasMore = false;
      _restaurants.addAll(fetched);
      _page++;
    } catch (e) {
      debugPrint('Load error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _restaurants.length + (_isLoading ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == _restaurants.length) {
            return const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ));
          }
          final item = _restaurants[i];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.address),
            leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
