import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/item_cart.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/horizontal_list.dart';
import '../../widgets/section_header.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/shimmer_item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      if (provider.categories.isEmpty || provider.topProducts.isEmpty || provider.topRestaurants.isEmpty) {
        provider.loadHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0.5,
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
              child: SearchBarWidget(isLoading: provider.isLoading),
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryGrid(), // có thể dùng shimmer nếu muốn
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: 'Nhà hàng bán chạy',
                    onTap: () {}, // placeholder
                  ),
                  HorizontalList(
                    items: List.generate(5, (_) => const ShimmerItemCard()),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: 'Sản phẩm bán chạy',
                    onTap: () {}, // placeholder
                  ),
                  HorizontalList(
                    items: List.generate(5, (_) => const ShimmerItemCard()),
                  ),
                ],
              ),
            )
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
                      onTap: () => AppNavigator.toTopRestaurants(context),
                    ),
                    HorizontalList(
                      items: provider.topRestaurants.map((e) {
                        return ItemCard(
                          title: e.name,
                          subtitle: e.address,
                          imageUrl: e.image,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: 'Sản phẩm bán chạy',
                      onTap: () => AppNavigator.toTopProducts(context),
                    ),
                    HorizontalList(
                      items: provider.topProducts.map((e) {
                        return ItemCard(
                          title: e.name,
                          subtitle: '${e.price} đ',
                          imageUrl: e.image,
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
