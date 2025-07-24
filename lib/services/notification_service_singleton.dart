import 'notification_service.dart';
import '../models/notification_model.dart';

class NotificationServiceSingleton {
  static NotificationService? _instance;

  static NotificationService getInstance(Function(NotificationModel) onNotificationReceived) {
    _instance ??= NotificationService(onNotificationReceived: onNotificationReceived);
    return _instance!;
  }

  static void dispose() {
    _instance?.disconnect();
    _instance = null;
  }
}
