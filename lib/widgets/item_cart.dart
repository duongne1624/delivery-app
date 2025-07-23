// lib/widgets/item_card.dart
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? restaurantId;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.restaurantId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      splashColor: isDark ? theme.colorScheme.primary.withOpacity(0.12) : Colors.deepOrange.withOpacity(0.12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl!,
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
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Icon(Icons.restaurant, color: isDark ? theme.colorScheme.primary : Colors.deepOrange, size: 22),
                          ),
                        ],
                      )
                    : Container(
                        color: isDark ? theme.colorScheme.surface : Colors.grey[200],
                        alignment: Alignment.center,
                        child: Icon(Icons.image_not_supported, color: isDark ? theme.colorScheme.primary : Colors.grey),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
              child: Text(
                title,
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
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
