import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Thông tin ví và thanh toán sẽ được hiển thị tại đây',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
