import 'package:flutter/material.dart';
import 'routes.dart';

class AppNavigator {
  static void toSplash(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (route) => false);
  }

  static void toLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  static void toRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  static void toMain(BuildContext context, {int index = 0}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.main,
      (route) => false,
      arguments: index,
    );
  }

  static void toHome(BuildContext context) => toMain(context, index: 0);
  static void toOrders(BuildContext context) => toMain(context, index: 1);
  static void toFavorites(BuildContext context) => toMain(context, index: 2);
  static void toProfile(BuildContext context) => toMain(context, index: 3);

  static void toTopRestaurants(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.topRestaurants);
  }

  static void toTopProducts(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.topProducts);
  }

  static void toSearchScreen(BuildContext context, String keyword) {
    Navigator.pushNamed(context, '/search', arguments: keyword);
  }

  static void toRestaurantDetail(BuildContext context, String restaurantId) {
    Navigator.pushNamed(
      context,
      AppRoutes.restaurantDetail,
      arguments: restaurantId,
    );
  }

  static void toOrderDetail(BuildContext context, String orderId) {
    Navigator.pushNamed(
      context,
      AppRoutes.orderDetail,
      arguments: orderId,
    );
  }

  static void toUserAddresses(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userAddresses);
  }
  
}
