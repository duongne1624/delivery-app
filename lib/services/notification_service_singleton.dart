import 'package:flutter/material.dart';
import 'notification_local_storage.dart';
import 'notification_service.dart';
import '../models/notification_model.dart';

class NotificationServiceSingleton {
  static NotificationService? _instance;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static bool _initialized = false;

  static NotificationService getInstance(Function(NotificationModel) onNotificationReceived) {
    if (_instance == null) {
      _instance = NotificationService(
        onNotificationReceived: (notification) {
          // Gọi callback và thêm thông báo vào local storage
          NotificationLocalStorage.addNotification(notification);
          onNotificationReceived(notification);
        },
      );
      // Khởi tạo notifications
      if (!_initialized) {
        _instance!.initNotifications();
        _initialized = true;
        print('NotificationServiceSingleton: Initialized at ${DateTime.now()}');
      }
      // Gán _navigatorKey nếu đã có
      if (_navigatorKey != null) {
        _instance!.setNavigatorKey(_navigatorKey!);
      }
    }
    return _instance!;
  }

  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    if (_instance != null) {
      _instance!.setNavigatorKey(navigatorKey);
      print('NotificationServiceSingleton: Navigator key set at ${DateTime.now()}');
    }
  }

  static void dispose() {
    if (_instance != null) {
      _instance!.disconnect();
      _instance = null;
      _navigatorKey = null;
      _initialized = false;
      print('NotificationServiceSingleton: Disposed at ${DateTime.now()}');
    }
  }
}
