import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/home_product_card.dart';
import '../../widgets/home_restaurant_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/horizontal_list.dart';
import '../../widgets/section_header.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/shimmer_item_card.dart';
// import '../../theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void reload() {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.loadHomeData();
  }
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
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: EdgeInsets.zero,
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
                  child: Container(
                    width: double.infinity,
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
            ),
            if (provider.isLoading) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                child: CategoryGrid(),
              ),
              const SizedBox(height: 10),
              SectionHeader(
                title: 'Nhà hàng bán chạy',
                onTap: () {},
              ),
              Builder(
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: HorizontalList(
                    items: List.generate(5, (_) => const ShimmerItemCard()),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SectionHeader(
                title: 'Sản phẩm bán chạy',
                onTap: () {},
              ),
              Builder(
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: HorizontalList(
                    items: List.generate(5, (_) => const ShimmerItemCard()),
                  ),
                ),
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: CategoryGrid(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Nhà hàng bán chạy',
                  onTap: () => AppNavigator.toTopRestaurants(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: provider.topRestaurants.length > 10 ? 10 : provider.topRestaurants.length,
                  itemBuilder: (context, index) {
                    final e = provider.topRestaurants[index];
                    return HomeRestaurantCard(
                      restaurant: e,
                      onTap: () => AppNavigator.toRestaurantDetail(context, e.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Sản phẩm bán chạy',
                  onTap: () => AppNavigator.toTopProducts(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: provider.topProducts.length > 10 ? 10 : provider.topProducts.length,
                  itemBuilder: (context, index) {
                    final e = provider.topProducts[index];
                    return HomeProductCard(
                      product: e,
                      onTap: () => AppNavigator.toRestaurantDetail(context, e.restaurantId),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      );
  }
}