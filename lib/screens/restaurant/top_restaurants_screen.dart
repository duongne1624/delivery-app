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
  final List<RestaurantModel> _restaurants = [];
  final ScrollController _scrollController = ScrollController();

  bool _loading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _load();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _load() async {
    if (_loading || !_hasMore) return;

    setState(() => _loading = true);
    try {
      final res = await DioService.instance.get('/restaurants/top-selling', queryParameters: {
        'limit': _limit,
        'page': _page,
      });
      final List data = res.data['data'];
      final items = data.map((e) => RestaurantModel.fromJson(e)).toList();

      setState(() {
        _restaurants.addAll(items);
        _hasMore = items.length == _limit;
        if (_hasMore) _page++;
      });
    } catch (e) {
      debugPrint('Lỗi tải nhà hàng: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _load();
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
      body: RefreshIndicator(
        onRefresh: () async {
          _page = 1;
          _restaurants.clear();
          _hasMore = true;
          await _load();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _restaurants.length + (_hasMore ? 1 : 0),
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            if (i >= _restaurants.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final item = _restaurants[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ItemCard(
                title: item.name,
                subtitle: item.address,
                imageUrl: item.imageUrl,
              ),
            );
          },
        ),
      ),
    );
  }
}
