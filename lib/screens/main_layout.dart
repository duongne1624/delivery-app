import 'package:flutter/material.dart';
import 'dart:ui';

import 'home/home_screen.dart';
import 'order/order_screen.dart';
import 'profile/profile_screen.dart';
import 'favorite/favorite_screen.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    OrderScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.surface.withOpacity(0.01),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onTap,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              items: [
                _buildNavItem(icon: Icons.home_rounded, label: 'Trang chủ', index: 0),
                _buildNavItem(icon: Icons.receipt_long, label: 'Đơn hàng', index: 1),
                _buildNavItem(icon: Icons.favorite_border, label: 'Yêu thích', index: 2),
                _buildNavItem(icon: Icons.person_outline, label: 'Tài khoản', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;
    final theme = Theme.of(context);

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.surface.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.surface.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: isSelected
              ? theme.colorScheme.primary
              : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
