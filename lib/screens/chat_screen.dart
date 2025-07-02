import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              'Tin nhắn sẽ được hiển thị tại đây',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).addNotification();
            },
            child: Text('Thêm thông báo'),
          ),
        ),
      ],
    );
  }
}
