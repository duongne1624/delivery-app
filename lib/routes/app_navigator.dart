import 'package:flutter/material.dart';
import '../models/user_address_model.dart';
import '../screens/address/map_location_picker.dart';
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
  static void toCurrentOrders(BuildContext context) => toMain(context, index: 2);
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

  static Future<dynamic> toAddEditAddress(BuildContext context, {UserAddress? address}) {
    return Navigator.pushNamed(context, AppRoutes.addEditAddress, arguments: address);
  }

  static Future<dynamic> toMapLocationPicker(
    BuildContext context, {
    String? initialAddress,
    double? initialLatitude,
    double? initialLongitude,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPicker(
          initialAddress: initialAddress,
          initialLatitude: initialLatitude,
          initialLongitude: initialLongitude,
        ),
      ),
    );
  }

  static void toShipper(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/shipper',
      (route) => false,
    );
  }

  static void toChat(BuildContext context, String orderId, String userId, String otherUserId) {
    Navigator.pushNamed(
      context,
      AppRoutes.chat,
      arguments: {
        'orderId': orderId,
        'userId': userId,
        'otherUserId': otherUserId,
      },
    );
  }
}
