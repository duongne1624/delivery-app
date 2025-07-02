import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Lịch sử đơn hàng sẽ được hiển thị tại đây',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}