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
    return Scaffold(
      appBar: AppBar(title: Text('Kết quả tìm kiếm: $_keyword')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('Không tìm thấy quán ăn nào.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _results.length,
                  itemBuilder: (_, i) {
                    final item = _results[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ItemCard(
                        title: item.name,
                        subtitle: item.address,
                        imageUrl: item.image,
                        onTap: () => AppNavigator.toRestaurantDetail(context, item.id),
                      ),
                    );
                  },
                ),
    );
  }
}
