import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../routes/app_navigator.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    provider.reset();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
        provider.fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Text("Nhà hàng", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          if (provider.restaurants.isEmpty && provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange));
          }
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.82,
            ),
            itemCount: provider.restaurants.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= provider.restaurants.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                  ),
                );
              }

              final restaurant = provider.restaurants[index];
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
                  onTap: () => AppNavigator.toRestaurantDetail(context, restaurant.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: restaurant.image.isNotEmpty
                              ? Image.network(
                                  restaurant.image,
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
                          restaurant.name,
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
                          restaurant.address,
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
          );
        },
      ),
    );
  }
}
