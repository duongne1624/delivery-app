import 'package:flutter/material.dart';
import 'shipper_home_screen.dart';
import 'shipper_pending_orders_screen.dart';
import 'shipper_my_orders_screen.dart';
import 'shipper_profile_screen.dart';

class ShipperNavigation extends StatefulWidget {
  const ShipperNavigation({super.key});

  @override
  State<ShipperNavigation> createState() => _ShipperNavigationState();
}

class _ShipperNavigationState extends State<ShipperNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    ShipperHomeScreen(),
    ShipperPendingOrdersScreen(),
    ShipperMyOrdersScreen(),
    ShipperProfileScreen(),
  ];

  static final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Trang chủ'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Chưa nhận'),
    BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Đã nhận'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
