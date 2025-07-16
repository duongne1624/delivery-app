import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../routes/app_navigator.dart';

class SearchBarWidget extends StatefulWidget {
  final bool isLoading;
  const SearchBarWidget({super.key, this.isLoading = false});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  void _handleSearch(String value) {
    final keyword = value.trim();
    if (keyword.isNotEmpty) {
      AppNavigator.toSearchScreen(context, keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading) {
      return Shimmer.fromColors(
        baseColor: theme.colorScheme.surface.withOpacity(0.3),
        highlightColor: theme.colorScheme.surface.withOpacity(0.1),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: _handleSearch,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm quán ăn...',
        prefixIcon: IconButton(
          icon: Icon(Icons.search, color: theme.iconTheme.color),
          onPressed: () => _handleSearch(_controller.text),
        ),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        contentPadding: theme.inputDecorationTheme.contentPadding,
        border: theme.inputDecorationTheme.border,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        hintStyle: theme.inputDecorationTheme.hintStyle,
      ),
    );
  }
}
