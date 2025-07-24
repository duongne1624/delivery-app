import 'package:flutter/material.dart';
import '../models/home_restaurant_model.dart';

class HomeRestaurantCard extends StatelessWidget {
  final HomeRestaurantModel restaurant;
  final VoidCallback? onTap;
  const HomeRestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  restaurant.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      restaurant.name,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.address,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Đơn đã bán: ${restaurant.totalOrders}',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
