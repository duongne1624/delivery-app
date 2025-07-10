import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      style: TextStyle(color: theme.colorScheme.onBackground),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm món ăn, danh mục...',
        hintStyle: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.5)),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.onBackground.withOpacity(0.7)),
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.05), // nền nhẹ
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.onBackground.withOpacity(0.01)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.colorScheme.onBackground.withOpacity(0.3)),
        ),
      ),
    );
  }
}
