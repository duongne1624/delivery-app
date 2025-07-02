import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {
  final String name;
  final String? image;
  final VoidCallback onTap;

  const CategoryCardWidget({
    Key? key,
    required this.name,
    this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Image.asset('assets/images/$image', width: 40, height: 40)
                : Icon(Icons.fastfood, size: 40, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
