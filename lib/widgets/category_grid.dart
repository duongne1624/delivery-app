import 'package:delivery_online_app/theme/theme.dart';
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
              return _AnimatedCategoryItem(category: category);
            },
          );
        },
      ),
    );
  }
}
// Widget sống động cho category
class _AnimatedCategoryItem extends StatefulWidget {
  final CategoryModel category;
  const _AnimatedCategoryItem({required this.category});

  @override
  State<_AnimatedCategoryItem> createState() => _AnimatedCategoryItemState();
}

class _AnimatedCategoryItemState extends State<_AnimatedCategoryItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantByCategoryScreen(category: widget.category),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: _pressed ? 66 : 60,
              height: _pressed ? 66 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _pressed
                      ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                      : [Color(0xFFFFB074), Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _pressed ? theme.colorScheme.primary.withOpacity(0.25) : Colors.black12,
                    blurRadius: _pressed ? 16 : 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.fastfood,
                  size: _pressed ? 36 : 32,
                  color: Colors.white,
                  weight: 700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.category.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onBackground,
                fontFamily: 'Poppins',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
