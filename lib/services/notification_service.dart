import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dio_service.dart';
import '../models/notification_model.dart';

class NotificationService {
  late IO.Socket socket;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Function(NotificationModel) onNotificationReceived;

  NotificationService({required this.onNotificationReceived});

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void connect(String userId) {
    socket = IO.io(DioService.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('join', userId);
    });

    socket.on('notification', (data) {
      print('Notification received: $data');
      final notification = NotificationModel.fromJson(data);
      showNotification(notification.title, notification.body);
      onNotificationReceived(notification);
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
