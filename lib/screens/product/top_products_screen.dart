// lib/screens/product/top_products_screen.dart
import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/dio_service.dart';

class TopProductsScreen extends StatefulWidget {
  const TopProductsScreen({super.key});

  @override
  State<TopProductsScreen> createState() => _TopProductsScreenState();
}

class _TopProductsScreenState extends State<TopProductsScreen> {
  List<ProductModel> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await DioService.instance.get('/products/top-selling', queryParameters: {'limit': 100});
      final data = res.data['data'] as List;
      _products = data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm bán chạy')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (_, i) {
                final item = _products[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.price} đ'),
                  leading: item.imageUrl != null
                      ? Image.network(item.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.ramen_dining),
                );
              },
            ),
    );
  }
}
