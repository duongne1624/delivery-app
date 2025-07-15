import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchBarWidget extends StatelessWidget {
  final bool isLoading;
  const SearchBarWidget({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm quán ăn...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
