import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../utils/notification_utils.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final Function(String) onDelete;
  final Function(String) onTap;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = NotificationUtils.getColorByStatus(notification.status);
    final icon = NotificationUtils.getIconByStatus(notification.status);

    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => onDelete(notification.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: notification.read ? Colors.white : Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.read ? Colors.grey.withOpacity(0.2) : Colors.blue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (!notification.read) {
                onTap(notification.id);
              }
              if (notification.orderId != null) {
                AppNavigator.toOrderDetail(context, notification.orderId!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      if (!notification.read)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: notification.read ? FontWeight.w500 : FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              NotificationUtils.formatTimeAgo(notification.time),
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.body,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                NotificationUtils.getStatusText(notification.status),
                                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
