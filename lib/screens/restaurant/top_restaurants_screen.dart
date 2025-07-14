import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';
import '../../widgets/item_cart.dart';

class TopRestaurantsScreen extends StatefulWidget {
  const TopRestaurantsScreen({super.key});

  @override
  State<TopRestaurantsScreen> createState() => _TopRestaurantsScreenState();
}

class _TopRestaurantsScreenState extends State<TopRestaurantsScreen> {
  List<RestaurantModel> _restaurants = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 20;
  final ScrollController _scrollController = ScrollController();

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
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);

    try {
      final res = await DioService.instance.get('/restaurants/top-selling', queryParameters: {
        'limit': _limit,
        'page': _page,
      });

      final List data = res.data['data'];
      final newItems = data.map((e) => RestaurantModel.fromJson(e)).toList();

      setState(() {
        _restaurants.addAll(newItems);
        _hasMore = newItems.length == _limit;
        _page++;
      });
    } catch (e) {
      debugPrint('Error loading top restaurants: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nhà hàng bán chạy')),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: _restaurants.length + (_hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i < _restaurants.length) {
            final item = _restaurants[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ItemCard(
                title: item.name,
                subtitle: item.address,
                imageUrl: item.image,
              ),
            );
          } else {
            return const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}
