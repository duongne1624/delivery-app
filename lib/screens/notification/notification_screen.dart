import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  static const String _readKey = 'notification_read_status';

  void reload() {
    setState(() {});
  }

  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'title': 'Đơn hàng đã được giao thành công',
      'body': 'Cảm ơn bạn đã sử dụng dịch vụ. Hãy đánh giá tài xế để nhận ưu đãi!',
      'status': 3,
      'time': DateTime.now().subtract(const Duration(minutes: 2)),
      'read': true,
      'orderId': 'ORDER123',
    },
    {
      'title': 'Tài xế đang đến lấy đơn',
      'body': 'Tài xế Nguyễn Văn A đang trên đường đến nhà hàng để lấy đơn của bạn.',
      'status': 2,
      'time': DateTime.now().subtract(const Duration(minutes: 10)),
      'read': true,
      'orderId': 'ORDER123',
    },
    {
      'title': 'Đơn hàng mới',
      'body': 'Bạn vừa đặt đơn hàng thành công. Hãy chuẩn bị điện thoại để nhận cuộc gọi từ tài xế.',
      'status': 1,
      'time': DateTime.now().subtract(const Duration(minutes: 20)),
      'read': true,
      'orderId': 'ORDER123',
    },
    {
      'title': 'Khuyến mãi đặc biệt',
      'body': 'Nhập mã GRABFOOD để nhận giảm 30% cho đơn tiếp theo!',
      'status': 4,
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'read': true,
    },
    {
      'title': 'Cập nhật chính sách',
      'body': 'Chúng tôi vừa cập nhật điều khoản sử dụng dịch vụ. Vui lòng xem chi tiết.',
      'status': 5,
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'read': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadReadStatus();
  }

  Future<void> _loadReadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final readList = prefs.getStringList(_readKey);
    if (readList != null && readList.length == _mockNotifications.length) {
      for (int i = 0; i < _mockNotifications.length; i++) {
        _mockNotifications[i]['read'] = readList[i] == '1';
      }
      setState(() {});
    }
  }

  Future<void> _saveReadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final readList = _mockNotifications.map((n) => n['read'] == true ? '1' : '0').toList();
    await prefs.setStringList(_readKey, readList);
  }

  bool get hasUnread => _mockNotifications.any((n) => n['read'] == false);

  void markAsRead(int index) {
    setState(() {
      _mockNotifications[index]['read'] = true;
    });
    _saveReadStatus();
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  IconData _getIconByStatus(int status) {
    switch (status) {
      case 1:
        return Icons.receipt_long; // Đơn hàng mới
      case 2:
        return Icons.directions_bike; // Đang giao
      case 3:
        return Icons.check_circle_outline; // Hoàn thành
      case 4:
        return Icons.local_offer; // Khuyến mãi
      case 5:
      default:
        return Icons.info_outline; // Thông tin
    }
  }

  Color _getColorByStatus(int status) {
    switch (status) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.purple;
      case 5:
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _mockNotifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 72, endIndent: 16),
        itemBuilder: (context, index) {
          final noti = _mockNotifications[index];
          final status = noti['status'] as int;
          final color = _getColorByStatus(status);
          final icon = _getIconByStatus(status);
          final time = noti['time'] as DateTime;
          final read = noti['read'] as bool;
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                  radius: 24,
                ),
                if (!read)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              noti['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noti['body'] as String,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeAgo(time),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            isThreeLine: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () {
              markAsRead(index);
              if (noti['orderId'] != null) {
                Navigator.pushNamed(context, '/order-detail', arguments: noti['orderId']);
              }
            },
          );
        },
      ),
    );
  }
}
