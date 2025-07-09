import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/home_provider.dart';
import '../screens/restaurant/restaurant_by_category_screen.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<HomeProvider>().categories;

    // Chia thành từng trang 6 mục (2 hàng x 3 cột)
    final pages = <List<CategoryModel>>[];
    for (int i = 0; i < categories.length; i += 6) {
      pages.add(categories.sublist(i, i + 6 > categories.length ? categories.length : i + 6));
    }

    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: pages.length,
        controller: PageController(viewportFraction: 0.95),
        itemBuilder: (context, pageIndex) {
          final items = pages[pageIndex];
          return GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 cột
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final category = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantByCategoryScreen(category: category),
                    ),
                  );
                },
                child: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.fastfood, size: 30),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
