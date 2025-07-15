import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../services/dio_service.dart';
import '../../widgets/item_cart.dart';

class SearchRestaurantScreen extends StatefulWidget {
  const SearchRestaurantScreen({super.key});

  @override
  State<SearchRestaurantScreen> createState() => _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState extends State<SearchRestaurantScreen> {
  final TextEditingController _controller = TextEditingController();
  List<RestaurantModel> _results = [];
  bool _loading = false;

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) return;
    setState(() => _loading = true);
    try {
      final res = await DioService.instance.get('/restaurants/search', queryParameters: {'keyword': keyword});
      final data = res.data['data'] as List;
      setState(() {
        _results = data.map((e) => RestaurantModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm nhà hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Nhập tên nhà hàng...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _results.clear());
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_results.isEmpty)
              const Expanded(child: Center(child: Text('Không có kết quả')))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final item = _results[i];
                    return ItemCard(
                      title: item.name,
                      subtitle: item.address,
                      imageUrl: item.image,
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
