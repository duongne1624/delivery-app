import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';
import '../../widgets/product_item_card.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  List<ProductModel> _products = [];
  RestaurantModel? _restaurant;
  int _page = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  double _total = 0;
  final _scrollController = ScrollController();

  // Giỏ hàng tạm: {productId: quantity}
  final Map<String, int> _cart = {};

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchProducts({bool isLoadMore = false}) async {
    if (isLoadMore) setState(() => _isLoadingMore = true);

    try {
      final restaurantRes = await DioService.instance.get('/restaurants/${widget.restaurantId}');
      _restaurant = RestaurantModel.fromJson(restaurantRes.data['data']);
      final res = await DioService.instance.get(
        '/restaurants/${widget.restaurantId}/products',
        queryParameters: {'limit': 10, 'page': _page},
      );
      final data = res.data['data']['data'] as List;
      final newProducts = data.map((e) => ProductModel.fromJson(e)).toList();

      setState(() {
        if (isLoadMore) {
          _products.addAll(newProducts);
        } else {
          _products = newProducts;
        }

        _hasMore = newProducts.length == 10;
        if (_hasMore) _page++;
      });
    } catch (e) {
      debugPrint('Lỗi tải sản phẩm: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _hasMore) {
      _fetchProducts(isLoadMore: true);
    }
  }

  void _addToCart(ProductModel product) {
    setState(() {
      _cart.update(product.id, (value) => value + 1, ifAbsent: () => 1);
      _total += product.price;
    });
  }

  void _removeFromCart(ProductModel product) {
    if (_cart.containsKey(product.id)) {
      setState(() {
        _cart.update(product.id, (value) => value - 1);
        if (_cart[product.id]! <= 0) {
          _cart.remove(product.id);
        }
        _total -= product.price;
      });
    }
  }

  void _deleteFromCart(ProductModel product) {
    if (_cart.containsKey(product.id)) {
      setState(() {
        final qty = _cart[product.id]!;
        _total -= product.price * qty;
        _cart.remove(product.id);
      });
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

    final selectedProducts = _products.where((p) => _cart.containsKey(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết nhà hàng')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _page = 1;
                      _hasMore = true;
                      await _fetchProducts();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: _restaurant == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          _restaurant!.image,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _restaurant!.name,
                                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _restaurant!.address,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= _products.length) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final p = _products[index];
                                return ProductItemCard(
                                  product: p,
                                  onAdd: () => _addToCart(p),
                                );
                              },
                              childCount: _products.length + (_isLoadingMore ? 1 : 0),
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_cart.isNotEmpty)
              Container(
                color: theme.colorScheme.surface.withOpacity(0.95),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true,
                    itemCount: _cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final entry = _cart.entries.elementAt(index);
                      final product = _products.firstWhere((p) => p.id == entry.key);
                      final quantity = entry.value;
                      final itemTotal = product.price * quantity;

                      return Row(
                        children: [
                          // Tên sản phẩm
                          Expanded(
                            child: Text(
                              product.name,
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Giá
                          Text(
                            '${itemTotal.toStringAsFixed(0)} đ',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                          ),
                          const SizedBox(width: 8),

                          // Nút trừ
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: () => _removeFromCart(product),
                          ),

                          // Số lượng
                          Text('$quantity', style: theme.textTheme.bodyMedium),

                          // Nút cộng
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () => _addToCart(product),
                          ),

                          // Nút xoá
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                            onPressed: () => _deleteFromCart(product),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

            // Tổng tiền + nút đặt hàng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng: ${_total.toStringAsFixed(0)} đ',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _total > 0 ? () {} : null,
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('Đặt hàng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
