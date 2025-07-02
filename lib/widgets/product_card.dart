import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.image, width: 50, height: 50),
        title: Text(product.name),
        subtitle: Text('${product.price} VND'),
        onTap: () {
          // Điều hướng đến chi tiết món ăn
        },
      ),
    );
  }
}