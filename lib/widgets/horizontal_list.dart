import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> items;

  const HorizontalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: items.length,
        itemBuilder: (_, i) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 350 + i * 120),
            curve: Curves.easeInOut,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: items[i],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
      ),
    );
  }
}
