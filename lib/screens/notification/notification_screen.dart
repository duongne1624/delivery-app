import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/notification_local_storage.dart';
import '../../widgets/notification_item.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static Future<void> addNewNotification(NotificationModel notification) async {
    await NotificationLocalStorage.addNotification(notification);
  }

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Đăng ký NotificationScreenState với NotificationService thông qua NotificationProvider
      if (ModalRoute.of(context)?.settings.name == '/notifications') {
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider.notificationService.setNotificationScreenState(this);
      }
    });
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifications = await NotificationLocalStorage.loadNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void reload() {
    _loadNotifications();
  }

  Future<void> _markAsRead(String notificationId) async {
    await NotificationLocalStorage.markAsRead(notificationId);
    await _loadNotifications();
  }

  Future<void> _deleteNotification(String notificationId) async {
    await NotificationLocalStorage.deleteNotification(notificationId);
    await _loadNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa thông báo'), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _markAllAsRead() async {
    await NotificationLocalStorage.markAllAsRead();
    await _loadNotifications();
  }

  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả thông báo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await NotificationLocalStorage.clearAllNotifications();
      await _loadNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa tất cả thông báo'), duration: Duration(seconds: 2)),
      );
    }
  }

  bool get hasUnread => _notifications.any((n) => !n.read);
  int get unreadCount => _notifications.where((n) => !n.read).length;

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Không có thông báo nào', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text('Kéo xuống để làm mới', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Thông báo'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  if (hasUnread) _markAllAsRead();
                  break;
                case 'clear_all':
                  _clearAllNotifications();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (hasUnread)
                const PopupMenuItem(value: 'mark_all_read', child: Text('Đánh dấu tất cả đã đọc')),
              const PopupMenuItem(value: 'clear_all', child: Text('Xóa tất cả')),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(
                        notification: _notifications[index],
                        onDelete: _deleteNotification,
                        onTap: _markAsRead,
                      );
                    },
                  ),
      ),
    );
  }
}
