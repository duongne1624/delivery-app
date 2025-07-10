import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Widget> items;
  final double height;
  final double itemWidth;
  final EdgeInsets padding;

  const HorizontalList({
    super.key,
    required this.items,
    this.height = 200,
    this.itemWidth = 160,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: items.length > 10 ? 10 : items.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              right: index == items.length - 1 ? 0 : 12,
            ),
            width: itemWidth,
            child: items[index],
          );
        },
      ),
    );
  }
}
