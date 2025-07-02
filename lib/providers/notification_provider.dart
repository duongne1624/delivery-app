import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void addNotification() {
    _unreadCount++;
    notifyListeners();
  }

  void markAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  void incrementUnreadCount() {
    _unreadCount++;
    notifyListeners();
  }

  void decrementUnreadCount() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }
}
