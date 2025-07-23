import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';
import '../../widgets/product_item_card.dart';
import '../order/order_confirmation_screen.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    final selectedProducts = _products.where((p) => _cart.containsKey(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Text('Chi tiết nhà hàng', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange))
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark ? Colors.black38 : Colors.black12,
                                          blurRadius: 12,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.network(
                                                _restaurant!.image,
                                                height: 180,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Container(
                                                  color: isDark ? theme.colorScheme.surface : Colors.grey[300],
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.broken_image, color: isDark ? theme.colorScheme.primary : Colors.grey),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 16,
                                              top: 16,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: isDark ? theme.colorScheme.primary.withOpacity(0.85) : Colors.deepOrange.withOpacity(0.85),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.star, color: Colors.yellowAccent, size: 18),
                                                    const SizedBox(width: 4),
                                                    // Text('${_restaurant!.rating.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _restaurant!.name,
                                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _restaurant!.address,
                                          style: theme.textTheme.bodyMedium?.copyWith(color: isDark ? theme.colorScheme.primary : Colors.deepOrange, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= _products.length) {
                                  return Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange));
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
                              childAspectRatio: 0.78,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_cart.isNotEmpty)
              Container(
                color: isDark ? theme.colorScheme.surface.withOpacity(0.97) : Colors.white.withOpacity(0.97),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true,
                    itemCount: _cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (_, index) {
                      final entry = _cart.entries.elementAt(index);
                      final product = _products.firstWhere((p) => p.id == entry.key);
                      final quantity = entry.value;
                      final itemTotal = product.price * quantity;

                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? theme.colorScheme.surfaceVariant.withOpacity(0.13) : theme.colorScheme.surfaceVariant.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: isDark ? theme.colorScheme.surface : Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: Icon(Icons.broken_image, color: isDark ? theme.colorScheme.primary : Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.price.toStringAsFixed(0)} đ x $quantity',
                                    style: theme.textTheme.bodySmall?.copyWith(color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${itemTotal.toStringAsFixed(0)} đ',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, size: 20, color: theme.colorScheme.primary),
                                  onPressed: () => _removeFromCart(product),
                                ),
                                Text('$quantity', style: theme.textTheme.bodyMedium),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, size: 20, color: theme.colorScheme.primary),
                                  onPressed: () => _addToCart(product),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                  onPressed: () => _deleteFromCart(product),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng: ${_total.toStringAsFixed(0)} đ',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ElevatedButton.icon(
                    onPressed: _total > 0
                        ? () {
                            final selectedProducts = _products.where((p) => _cart.containsKey(p.id)).toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderConfirmationScreen(
                                  products: selectedProducts,
                                  cart: Map.from(_cart)
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('Đặt hàng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
