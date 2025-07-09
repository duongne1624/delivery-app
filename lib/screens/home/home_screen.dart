import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/item_cart.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/horizontal_list.dart';
import '../../widgets/section_header.dart';
import '../../widgets/category_grid.dart';
import '../../screens/restaurant/top_restaurants_screen.dart';
import '../../screens/product/top_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadHomeData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchBarWidget(),
                    const SizedBox(height: 16),
                    const CategoryGrid(),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: 'Nhà hàng bán chạy',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TopRestaurantsScreen()),
                      ),
                    ),
                    HorizontalList(
                      items: provider.topRestaurants.map((e) {
                        return ItemCard(
                          title: e.name,
                          subtitle: e.address,
                          imageUrl: e.imageUrl,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: 'Sản phẩm bán chạy',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TopProductsScreen()),
                      ),
                    ),
                    HorizontalList(
                      items: provider.topProducts.map((e) {
                        return ItemCard(
                          title: e.name,
                          subtitle: '${e.price} đ',
                          imageUrl: e.imageUrl,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
