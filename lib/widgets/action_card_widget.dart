import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ActionCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ActionCardWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        if (title == 'Danh mục') {
          Navigator.pushNamed(context, AppRoutes.restaurantList);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
