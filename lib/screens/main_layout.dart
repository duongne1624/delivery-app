import 'package:flutter/material.dart';
import 'dart:ui';

import 'home/home_screen.dart';
// import 'order/order_screen.dart';
import 'profile/profile_screen.dart';
import 'order/current_orders_screen.dart';
import 'notification/notification_screen.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex;

  final PageStorageBucket _bucket = PageStorageBucket();

  // Tạo callback để refresh đơn hàng
  final GlobalKey<HomeScreenState> _homeScreenKey = GlobalKey<HomeScreenState>();
  final GlobalKey<CurrentOrdersScreenState> _currentOrdersScreenKey = GlobalKey<CurrentOrdersScreenState>();
  final GlobalKey<ProfileScreenState> _profileScreenKey = GlobalKey<ProfileScreenState>();
  final GlobalKey<NotificationScreenState> _notificationScreenKey = GlobalKey<NotificationScreenState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _homeScreenKey.currentState?.reload();
    } else if (index == 1) {
      _currentOrdersScreenKey.currentState?.refreshOrders();
    } else if (index == 2) {
      _notificationScreenKey.currentState?.reload();
    } else if (index == 3) {
      _profileScreenKey.currentState?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(key: _homeScreenKey),
            // Đơn hiện tại: các đơn đang đặt, chưa hoàn thành hoặc hủy
            CurrentOrdersScreen(key: _currentOrdersScreenKey),
            NotificationScreen(key: _notificationScreenKey),
            ProfileScreen(key: _profileScreenKey),
          ],
        ),
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
                _buildNavItem(icon: Icons.list_alt, label: 'Đơn hiện tại', index: 1),
                _buildNavItem(
                  iconWidget: NotificationIconWithBadge(notificationKey: _notificationScreenKey),
                  icon: Icons.notifications,
                  label: 'Thông báo',
                  index: 2,
                ),
                _buildNavItem(icon: Icons.person_outline, label: 'Tài khoản', index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    IconData? icon,
    Widget? iconWidget,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;
    final theme = Theme.of(context);

    Widget iconToShow = iconWidget ?? Icon(
      icon,
      color: isSelected ? theme.colorScheme.primary : Colors.grey,
    );

    iconToShow = AnimatedContainer(
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
      child: iconToShow,
    );

    return BottomNavigationBarItem(
      icon: iconToShow,
      label: label,
    );
  }

}

class NotificationIconWithBadge extends StatelessWidget {
  final GlobalKey<NotificationScreenState> notificationKey;
  const NotificationIconWithBadge({super.key, required this.notificationKey});

  @override
  Widget build(BuildContext context) {
    final hasUnread = notificationKey.currentState?.hasUnread ?? false;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications),
        if (hasUnread)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
