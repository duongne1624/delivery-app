import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import 'category_card_widget.dart';
import '../routes/app_routes.dart';

class CategoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh mục món ăn',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        categoryProvider.categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CategoryCardWidget(
                        name: category['name'],
                        image: category['image'],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productList,
                            arguments: category['id'],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
