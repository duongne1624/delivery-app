import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onSubmitted;

  const SearchBarWidget({Key? key, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search-bar',
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm món ăn hoặc quán',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}