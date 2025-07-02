import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductCardWidget extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final String description;

  const ProductCardWidget({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/$image',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '${price.toStringAsFixed(0)} VND',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).addToCart({
                      'id': name, // Use a unique ID in production
                      'name': name,
                      'price': price,
                      'image': image,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$name đã được thêm vào giỏ!')),
                    );
                  },
                  child: Text('Thêm vào giỏ'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 36),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
