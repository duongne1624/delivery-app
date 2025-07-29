import 'package:flutter/material.dart';
import '../services/notification_local_storage.dart';
import '../services/notification_service.dart';
import '../services/notification_service_singleton.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService;
  List<NotificationModel> _notifications = [];

  NotificationProvider()
      : _notificationService = NotificationServiceSingleton.getInstance((notification) {
          // Callback này được xử lý trong singleton
        }) {
    _initialize();
  }

  NotificationService get notificationService => _notificationService;

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  bool get hasUnread => _notifications.any((n) => !n.read);

  int get unreadCount => _notifications.where((n) => !n.read).length;

  Future<void> _initialize() async {
    await _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    _notifications = await NotificationLocalStorage.loadNotifications();
    notifyListeners();
  }

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    NotificationServiceSingleton.setNavigatorKey(navigatorKey);
  }

  void setNotificationScreenState(dynamic state) {
    _notificationService.setNotificationScreenState(state);
  }

  void connect(String userId) {
    _notificationService.connect(userId);
  }

  void disconnect() {
    NotificationServiceSingleton.dispose();
  }

  Future<void> addNotification(NotificationModel notification) async {
    await NotificationLocalStorage.addNotification(notification);
    await _loadNotifications(); // Reload to sync with storage
  }

  Future<void> markAsRead(String notificationId) async {
    await NotificationLocalStorage.markAsRead(notificationId);
    await _loadNotifications(); // Reload to sync with storage
  }

  Future<void> markAllAsRead() async {
    await NotificationLocalStorage.markAllAsRead();
    await _loadNotifications(); // Reload to sync with storage
  }

  Future<void> clear() async {
    await NotificationLocalStorage.clearAllNotifications();
    _notifications.clear();
    notifyListeners();
  }

  Future<void> addTestNotification() async {
    await _notificationService.addTestNotification();
    await _loadNotifications(); // Reload to sync with storage
  }
}
