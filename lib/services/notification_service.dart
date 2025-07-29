import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/notification_model.dart';
import '../screens/notification/notification_screen.dart';
import '../widgets/in_app_notification.dart';
import 'dio_service.dart';
import 'notification_local_storage.dart';

class NotificationService {
  IO.Socket? socket;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Function(NotificationModel)? onNotificationReceived;

  // GlobalKey để truy cập Navigator context
  GlobalKey<NavigatorState>? _navigatorKey;

  // Reference đến NotificationScreen để reload
  NotificationScreenState? _notificationScreenState;

  NotificationService({this.onNotificationReceived});

  // Set navigator key để hiển thị overlay và điều hướng
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    print('NotificationService: _navigatorKey set to ${navigatorKey.toString()} at ${DateTime.now()}');
  }

  // Set reference đến NotificationScreen để reload
  void setNotificationScreenState(NotificationScreenState state) {
    _notificationScreenState = state;
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Xử lý khi tap vào system notification
  void _onNotificationTapped(NotificationResponse response) {
    if (_navigatorKey == null) {
      print('Cannot handle notification tap: _navigatorKey is null at ${DateTime.now()}');
      return;
    }
    if (response.payload != null && _navigatorKey!.currentContext != null) {
      try {
        final notificationData = response.payload!.split('|');
        if (notificationData.isNotEmpty) {
          final notificationId = notificationData[0];
          final orderId = notificationData.length > 1 ? notificationData[1] : null;

          // Mark as read
          NotificationLocalStorage.markAsRead(notificationId);

          // Reload notification screen if available
          _notificationScreenState?.reload();

          // Navigate to order detail if orderId exists
          final context = _navigatorKey!.currentContext!;
          if (orderId != null && orderId.isNotEmpty) {
            AppNavigator.toOrderDetail(context, orderId);
          } else {
            AppNavigator.toCurrentOrders(context);
          }
        }
      } catch (e) {
        print('Error handling notification tap: $e');
      }
    } else {
      print('Cannot handle notification tap: _navigatorKey.currentContext is null at ${DateTime.now()}');
    }
  }

  Future<void> showNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Create payload for notification tap handling
    final payload = '${notification.id}|${notification.orderId ?? ''}';

    await flutterLocalNotificationsPlugin.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Hiển thị in-app notification overlay
  void showInAppNotification(NotificationModel notification) {
    if (_navigatorKey == null) {
      print('Cannot show in-app notification: _navigatorKey is null at ${DateTime.now()}');
      return;
    }
    final context = _navigatorKey!.currentContext;
    if (context != null) {
      NotificationOverlay.show(
        context,
        notification,
        onTap: () {
          // Mark as read when tapped
          NotificationLocalStorage.markAsRead(notification.id);

          // Reload notification screen
          _notificationScreenState?.reload();

          // Navigate based on notification content
          if (notification.orderId != null) {
            AppNavigator.toOrderDetail(context, notification.orderId!);
          } else {
            AppNavigator.toCurrentOrders(context);
          }
        },
      );
    } else {
      print('Cannot show in-app notification: _navigatorKey.currentContext is null at ${DateTime.now()}');
    }
  }

  // Xử lý thông báo nhận được từ server
  Future<void> _handleReceivedNotification(Map<String, dynamic> data) async {
    try {
      // Parse notification từ server data
      final notification = NotificationModel.fromJson(data);
      final existingNotifications = await NotificationLocalStorage.loadNotifications();
      if (existingNotifications.any((n) => n.id == notification.id)) {
        print('Duplicate notification ignored: ${notification.id} at ${DateTime.now()}');
        return;
      }

      print('Notification received: ${notification.title} at ${DateTime.now()}');

      // Lưu vào local storage
      await NotificationLocalStorage.addNotification(notification);

      // Hiển thị system notification (background/foreground)
      await showNotification(notification);

      // Hiển thị in-app notification overlay (chỉ khi app đang mở)
      showInAppNotification(notification);

      // Reload notification screen nếu đang mở
      _notificationScreenState?.reload();

      // Callback để xử lý thêm nếu cần
      if (onNotificationReceived != null) {
        onNotificationReceived!(notification);
      }
    } catch (e) {
      print('Error handling received notification: $e');
    }
  }

  void connect(String userId) {
    // Disconnect and clear previous listeners to prevent duplicates
    if (socket != null) {
      socket!.off('notification');
      socket!.disconnect();
      socket = null; // Reset socket
    }

    socket = IO.io(DioService.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      print('Connected to notification server at ${DateTime.now()}');
      socket!.emit('join', userId);
    });

    socket!.on('notification', (data) {
      _handleReceivedNotification(data);
    });

    socket!.onDisconnect((_) {
      print('Disconnected from notification server at ${DateTime.now()}');
    });

    socket!.onError((error) {
      print('Socket error: $error');
    });
  }

  void disconnect() {
    if (socket != null) {
      socket!.off('notification');
      socket!.disconnect();
      socket = null; // Reset socket
    }
  }

  // Thêm thông báo test cho development
  Future<void> addTestNotification() async {
    final testNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Thông báo test',
      body: 'Đây là thông báo test từ hệ thống',
      status: 1,
      time: DateTime.now(),
      read: false,
      orderId: 'TEST${DateTime.now().millisecondsSinceEpoch}',
    );

    await _handleReceivedNotification(testNotification.toJson());
  }

  // Đánh dấu tất cả thông báo đã đọc
  Future<void> markAllAsRead() async {
    await NotificationLocalStorage.markAllAsRead();
    _notificationScreenState?.reload();
  }
}
