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

    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [theme.colorScheme.background, theme.colorScheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFB074), Color(0xFFFDE8D0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black54 : Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trang chủ',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074),
                              fontSize: 26,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isDark
                                  ? LinearGradient(
                                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFFFFB074), Colors.orangeAccent],
                                    ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.person_outline, color: isDark ? Colors.white : Colors.white, size: 28),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SearchBarWidget(isLoading: provider.isLoading),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: provider.isLoading
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CategoryGrid(),
                          const SizedBox(height: 16),
                          SectionHeader(
                            title: 'Nhà hàng bán chạy',
                            onTap: () {},
                          ),
                          HorizontalList(
                            items: List.generate(5, (_) => const ShimmerItemCard()),
                          ),
                          const SizedBox(height: 16),
                          SectionHeader(
                            title: 'Sản phẩm bán chạy',
                            onTap: () {},
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
                                  onTap: () => AppNavigator.toRestaurantDetail(context, e.id),
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
                                  onTap: () => AppNavigator.toRestaurantDetail(context, e.restaurantId),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
