import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/category_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/addon_provider.dart';
import 'providers/voucher_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/message_provider.dart';
import 'providers/review_provider.dart';
import 'providers/review_tag_provider.dart';
import 'providers/report_provider.dart';
import 'providers/product_provider.dart';
import 'routes/app_routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/restaurant_detail_screen.dart';
import 'screens/restaurant_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AddonProvider()),
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => ReviewTagProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Food Delivery App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => LoginScreen(),
          AppRoutes.register: (context) => RegisterScreen(),
          AppRoutes.home: (context) => MainScreen(),
          AppRoutes.restaurantDetail: (context) => RestaurantDetailScreen(),
          AppRoutes.restaurantList: (context) => RestaurantListScreen(),
          AppRoutes.orderHistory: (context) => MainScreen(),
          AppRoutes.wallet: (context) => MainScreen(),
          AppRoutes.chat: (context) => MainScreen(),
          AppRoutes.cart: (context) => MainScreen(),
        },
      ),
    );
  }
}
