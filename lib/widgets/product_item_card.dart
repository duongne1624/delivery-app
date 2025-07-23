import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdd;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      splashColor: isDark ? theme.colorScheme.primary.withOpacity(0.12) : Colors.deepOrange.withOpacity(0.12),
      onTap: onAdd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.black12,
              blurRadius: 14,
              offset: Offset(0, 7),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: product.image.isNotEmpty
                        ? Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: isDark ? theme.colorScheme.surface : Colors.grey[200],
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                  color: isDark ? theme.colorScheme.primary : Colors.deepOrange,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: isDark ? theme.colorScheme.surface : Colors.grey[300],
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image, color: isDark ? theme.colorScheme.primary : Colors.grey),
                            ),
                          )
                        : Container(
                            color: isDark ? theme.colorScheme.surface : Colors.grey[200],
                            alignment: Alignment.center,
                            child: Icon(Icons.image_not_supported, color: isDark ? theme.colorScheme.primary : Colors.grey),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Material(
                    color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074),
                    elevation: 2,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onAdd,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  color: isDark ? theme.colorScheme.onSurface : Color(0xFF212121),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                '${product.price} đ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
