// lib/screens/restaurant/restaurant_by_category_screen.dart
import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../models/restaurant_model.dart';
import '../../routes/app_navigator.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Text(widget.category.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: _restaurants.isEmpty && _isLoading
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
              itemCount: _restaurants.length + (_isLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _restaurants.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                    ),
                  );
                }
                final item = _restaurants[i];
                return Container(
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => AppNavigator.toRestaurantDetail(context, item.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: item.image.isNotEmpty
                                ? Image.network(
                                    item.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: isDark ? theme.colorScheme.surface : Colors.grey[300],
                                      alignment: Alignment.center,
                                      child: Icon(Icons.broken_image, color: isDark ? theme.colorScheme.primary : Colors.grey),
                                    ),
                                  )
                                : Container(
                                    color: isDark ? theme.colorScheme.surface : Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: Icon(Icons.image_not_supported, color: isDark ? theme.colorScheme.primary : Colors.grey),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
                          child: Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                              color: isDark ? theme.colorScheme.onSurface : Color(0xFF212121),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          child: Text(
                            item.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          );
      }
    
  }
