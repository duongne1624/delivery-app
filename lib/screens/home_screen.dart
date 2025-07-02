import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../providers/cart_provider.dart';
import '../widgets/greeting_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/action_card_widget.dart';
import '../widgets/category_list_widget.dart';
import '../widgets/restaurant_list_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.name ?? 'Khách';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  GreetingWidget(userName: userName),
                  SizedBox(height: 16),
                  // Hero Search Bar
                  SearchBarWidget(
                    onSubmitted: (value) {
                      Navigator.pushNamed(context, AppRoutes.restaurantList, arguments: {'search': value});
                    },
                  ),
                  SizedBox(height: 24),
                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionCardWidget(
                        icon: Icons.restaurant_menu,
                        title: 'Đặt món ăn',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.productList);
                        },
                      ),
                      ActionCardWidget(
                        icon: Icons.category,
                        title: 'Danh mục',
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Categories
                  CategoryListWidget(),
                  SizedBox(height: 24),
                  // Restaurants
                  RestaurantListWidget(isHomeScreen: true),
                ],
              ),
            ),
          ),
        ),
        // Sticky Order and Cart Buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.productList);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Đặt món ngay'),
                ),
              ),
              SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Stack(
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    if (Provider.of<CartProvider>(context).itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${Provider.of<CartProvider>(context).itemCount}',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
