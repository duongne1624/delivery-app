import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionHeader({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: const Icon(Icons.arrow_forward_ios, size: 24),
        ),
      ],
    );
  }
}
