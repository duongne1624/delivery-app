import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/notification_model.dart';

class NotificationLocalStorage {
  static const String _notificationsKey = 'stored_notifications';
  static const int _maxNotifications = 100;

  static Future<void> saveNotifications(List<NotificationModel> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_notificationsKey, json.encode(jsonList));
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  static Future<List<NotificationModel>> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_notificationsKey);
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List;
        return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
    return [];
  }

  static Future<void> addNotification(NotificationModel notification) async {
    final notifications = await loadNotifications();
    final existingIndex = notifications.indexWhere((n) => n.id == notification.id);
    if (existingIndex != -1) {
      notifications[existingIndex] = notification;
    } else {
      notifications.insert(0, notification);
    }
    if (notifications.length > _maxNotifications) {
      notifications.removeRange(_maxNotifications, notifications.length);
    }
    await saveNotifications(notifications);
  }

  static Future<void> markAsRead(String notificationId) async {
    final notifications = await loadNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(read: true);
      await saveNotifications(notifications);
    }
  }

  static Future<void> deleteNotification(String notificationId) async {
    final notifications = await loadNotifications();
    notifications.removeWhere((n) => n.id == notificationId);
    await saveNotifications(notifications);
  }

  static Future<void> markAllAsRead() async {
    final notifications = await loadNotifications();
    final updatedNotifications = notifications.map((n) => n.copyWith(read: true)).toList();
    await saveNotifications(updatedNotifications);
  }

  static Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }
}
