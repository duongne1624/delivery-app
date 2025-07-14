import 'package:flutter/material.dart';
import './theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? AppTheme.darkBackgroundGradient
        : AppTheme.lightBackgroundGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: child,
    );
  }
}
