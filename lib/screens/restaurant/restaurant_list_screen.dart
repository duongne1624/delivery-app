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
    return Scaffold(
      appBar: AppBar(title: const Text("Nhà hàng")),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: provider.restaurants.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= provider.restaurants.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final restaurant = provider.restaurants[index];
              return ListTile(
                leading: restaurant.image.isNotEmpty
                    ? Image.network(restaurant.image, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.restaurant),
                title: Text(restaurant.name),
                subtitle: Text(restaurant.address),
                onTap: () => AppNavigator.toRestaurantDetail(context, restaurant.id),
              );
            },
          );
        },
      ),
    );
  }
}
