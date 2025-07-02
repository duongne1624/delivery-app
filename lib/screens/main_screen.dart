import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added import
import '../providers/notification_provider.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'wallet_screen.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    HomeScreen(),
    OrderHistoryScreen(),
    WalletScreen(),
    ChatScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) { // Tin nhắn tab
      Provider.of<NotificationProvider>(context, listen: false).markAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 24,
              color: _selectedIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/history.svg',
              height: 24,
              color: _selectedIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            label: 'Hoạt động',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/wallet.svg',
              height: 24,
              color: _selectedIndex == 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            label: 'Thanh toán',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icons/message.svg',
                  height: 24,
                  color: _selectedIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${notificationProvider.unreadCount}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Tin nhắn',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        elevation: Theme.of(context).bottomNavigationBarTheme.elevation!,
        onTap: _onItemTapped,
        selectedLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
