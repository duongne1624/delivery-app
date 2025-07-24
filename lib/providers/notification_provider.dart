import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(int index) {
    if (!_notifications[index].read) {
      _notifications[index] = NotificationModel(
        title: _notifications[index].title,
        body: _notifications[index].body,
        status: _notifications[index].status,
        time: _notifications[index].time,
        read: true,
        orderId: _notifications[index].orderId,
      );
      notifyListeners();
    }
  }

  bool get hasUnread => _notifications.any((n) => !n.read);

  void clear() {
    _notifications.clear();
    notifyListeners();
  }
}
