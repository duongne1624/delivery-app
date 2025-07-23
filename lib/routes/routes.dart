import 'package:delivery_online_app/screens/order/order_detail_screen.dart';
import 'package:delivery_online_app/screens/search/restaurant_search_delegate.dart';
import 'package:flutter/material.dart';
import '../models/user_address_model.dart';
import '../screens/address/add_edit_user_address_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/product/top_products_screen.dart';
import '../screens/restaurant/restaurant_detail_screen.dart';
import '../screens/restaurant/top_restaurants_screen.dart';
import '../screens/address/user_address_screen.dart';
import '../screens/main_layout.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String favorite = '/favorite';
  static const String topRestaurants = '/restaurants/top';
  static const String topProducts = '/products/top';
  static const String search = '/search';
  static const String restaurantDetail = '/restaurant/detail';
  static const String orderDetail = '/orders/detail';
  static const String userAddresses = '/user/addresses';
  static const String addEditAddress = '/user/addresses/add-edit';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case main:
      case home:
      case orders:
      case favorite:
      case profile:
        final index = {
          home: 0,
          orders: 1,
          favorite: 2,
          profile: 3,
          main: settings.arguments as int? ?? 0,
        }[settings.name]!;
        return MaterialPageRoute(builder: (_) => MainLayout(initialIndex: index));
      case topRestaurants:
        return MaterialPageRoute(builder: (_) => const TopRestaurantsScreen());
      case topProducts:
        return MaterialPageRoute(builder: (_) => const TopProductsScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen(), settings: settings);
      case restaurantDetail:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurantId: id));
      case orderDetail:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: id));
      case userAddresses:
        return MaterialPageRoute(builder: (_) => const UserAddressScreen());
      case addEditAddress:
        final address = settings.arguments as UserAddress?;
        return MaterialPageRoute(
          builder: (_) => AddEditUserAddressScreen(address: address),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Không tìm thấy trang')),
          ),
        );
    }
  }
}
