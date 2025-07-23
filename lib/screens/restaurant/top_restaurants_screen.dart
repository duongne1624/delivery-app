import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../routes/app_navigator.dart';
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

      final List data = res.data['data']['data'];
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Text('Nhà hàng bán chạy', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: _restaurants.isEmpty && _loading
          ? Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange))
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.82,
              ),
              itemCount: _restaurants.length + (_hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i < _restaurants.length) {
                  final item = _restaurants[i];
                  return ItemCard(
                    title: item.name,
                    subtitle: item.address,
                    imageUrl: item.image,
                    onTap: () => AppNavigator.toRestaurantDetail(context, item.id),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                    ),
                  );
                }
              },
            ),
    );
  }
}
