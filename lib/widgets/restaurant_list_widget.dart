import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_card_widget.dart';

class RestaurantListWidget extends StatelessWidget {
  final bool isHomeScreen;

  const RestaurantListWidget({Key? key, this.isHomeScreen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final restaurants = isHomeScreen
        ? restaurantProvider.restaurants.take(10).toList()
        : restaurantProvider.restaurants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quán ăn nổi bật',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        restaurants.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                physics: isHomeScreen ? NeverScrollableScrollPhysics() : null,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return RestaurantCardWidget(
                    id: restaurant['id'],
                    name: restaurant['name'],
                    image: restaurant['image'],
                    rating: restaurant['rating'].toDouble(),
                    deliveryTime: restaurant['delivery_time'],
                  );
                },
              ),
      ],
    );
  }
}
