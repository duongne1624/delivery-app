import 'package:flutter/material.dart';
import '../models/home_product_model.dart';

class HomeProductCard extends StatelessWidget {
  final HomeProductModel product;
  final VoidCallback? onTap;
  const HomeProductCard({super.key, required this.product, this.onTap});

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final imageHeight = constraints.maxHeight;
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      product.image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: imageHeight,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
                    ),
                  );
                },
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
                      product.name,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price} đ',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Đã bán: ${product.soldCount}',
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
