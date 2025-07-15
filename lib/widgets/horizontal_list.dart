import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> items;

  const HorizontalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 300 + i * 100),
            child: items[i],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    );
  }
}
