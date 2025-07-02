import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card_widget.dart';

class RestaurantDetailScreen extends StatefulWidget {
  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        Provider.of<ProductProvider>(context, listen: false).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String restaurantId = args?['restaurantId'] ?? '';

    final restaurant = restaurantProvider.restaurants.firstWhere(
      (res) => res['id'] == restaurantId,
      orElse: () => {'name': 'Unknown', 'address': '', 'image': 'placeholder.jpg', 'rating': 0.0, 'delivery_time': ''},
    );
    final products = productProvider.getProductsByRestaurant(restaurantId);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name']),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Image.asset(
              'assets/images/${restaurant['image']}',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Info
                  Text(
                    restaurant['name'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        restaurant['rating'].toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(width: 16),
                      Text(
                        restaurant['delivery_time'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    restaurant['address'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  // Menu Section
                  Text(
                    'Thực đơn',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16),
                  products.isEmpty
                      ? Center(child: Text('Không có món ăn nào', style: Theme.of(context).textTheme.bodyMedium))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCardWidget(
                              name: product['name'],
                              price: product['price'].toDouble(),
                              image: product['image'],
                              description: product['description'],
                            );
                          },
                        ),
                  if (productProvider.hasMore)
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}