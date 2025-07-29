import 'package:flutter/material.dart';

class NotificationUtils {
  static String formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${time.day}/${time.month}/${time.year}';
  }

  static IconData getIconByStatus(int status) {
    switch (status) {
      case 1:
        return Icons.shopping_cart_outlined;
      case 2:
        return Icons.delivery_dining_outlined;
      case 3:
        return Icons.check_circle_outline;
      case 4:
        return Icons.local_offer_outlined;
      case 5:
      default:
        return Icons.info_outline;
    }
  }

  static Color getColorByStatus(int status) {
    switch (status) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      case 4:
        return Colors.purple;
      case 5:
      default:
        return Colors.grey;
    }
  }

  static String getStatusText(int status) {
    switch (status) {
      case 1:
        return "Đơn hàng mới";
      case 2:
        return "Đang xử lý";
      case 3:
        return "Hoàn thành";
      case 4:
        return "Khuyến mãi";
      case 5:
      default:
        return "Thông báo";
    }
  }
}
