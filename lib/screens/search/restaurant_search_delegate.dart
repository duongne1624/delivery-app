import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../routes/app_navigator.dart';
import '../../services/dio_service.dart';
import '../../widgets/item_cart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<RestaurantModel> _results = [];
  bool _loading = true;
  String _keyword = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _keyword = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    _search();
  }

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final res = await DioService.instance.get('/restaurants/search', queryParameters: {'keyword': _keyword});
      final data = res.data['data'] as List;
      _results = data.map((e) => RestaurantModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() => _loading = false);
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
        title: Row(
          children: [
            Icon(Icons.search, color: isDark ? theme.colorScheme.primary : Colors.deepOrange, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Kết quả: $_keyword',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? theme.colorScheme.primary : Colors.deepOrange,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                    const SizedBox(height: 16),
                    Text('Đang tìm kiếm...', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            : _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                        const SizedBox(height: 16),
                        Text('Không tìm thấy quán ăn nào.', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Hãy thử từ khóa khác hoặc kiểm tra lại chính tả.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (_, i) {
                      final item = _results[i];
                      return ItemCard(
                        title: item.name,
                        subtitle: item.address,
                        imageUrl: item.image,
                        onTap: () => AppNavigator.toRestaurantDetail(context, item.id),
                      );
                    },
                  ),
      ),
    );
  }
}
