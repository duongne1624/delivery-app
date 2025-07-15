import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItemCard extends StatelessWidget {
  const ShimmerItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(height: 100, width: double.infinity, color: Colors.white),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(''),
            ),
          ],
        ),
      ),
    );
  }
}
