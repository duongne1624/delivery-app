import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> items;

  const HorizontalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length > 10 ? 10 : items.length,
        itemBuilder: (_, i) => SizedBox(width: 160, child: items[i]),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    );
  }
}
