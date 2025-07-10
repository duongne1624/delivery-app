import 'package:delivery_online_app/routes/app_navigator.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Trang chủ',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person_outline, color: theme.colorScheme.onBackground),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const SearchBarWidget(),
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadHomeData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CategoryGrid(),
                    const SizedBox(height: 16),

                    SectionHeader(
                      title: 'Nhà hàng bán chạy',
                      onTap: () => AppNavigator.toTopRestaurants(context)
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
                      onTap: () => AppNavigator.toTopProducts(context)
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
