import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../routes/app_navigator.dart';
import '../../services/dio_service.dart';
import '../../widgets/item_cart.dart';

class TopProductsScreen extends StatefulWidget {
  const TopProductsScreen({super.key});

  @override
  State<TopProductsScreen> createState() => _TopProductsScreenState();
}

class _TopProductsScreenState extends State<TopProductsScreen> {
  final List<ProductModel> _products = [];
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
      final res = await DioService.instance.get('/products/top-selling', queryParameters: {
        'limit': _limit,
        'page': _page,
      });
      final List data = res.data['data'];
      final items = data.map((e) => ProductModel.fromJson(e)).toList();

      setState(() {
        _products.addAll(items);
        _hasMore = items.length == _limit;
        if (_hasMore) _page++;
      });
    } catch (e) {
      debugPrint('Lỗi tải sản phẩm: $e');
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
      appBar: AppBar(title: const Text('Sản phẩm bán chạy')),
      body: RefreshIndicator(
        onRefresh: () async {
          _page = 1;
          _products.clear();
          _hasMore = true;
          await _load();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _products.length + (_hasMore ? 1 : 0),
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            if (i >= _products.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final item = _products[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ItemCard(
                title: item.name,
                subtitle: '${item.price} đ',
                imageUrl: item.image,
                onTap: () => AppNavigator.toRestaurantDetail(context, item.restaurantId),
              ),
            );
          },
        ),
      ),
    );
  }
}
