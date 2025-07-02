import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/voucher.dart';

class VoucherProvider with ChangeNotifier {
  List<Voucher> get vouchers =>
      (MockData.data['vouchers'] as List<dynamic>)
          .map((voucher) => Voucher.fromJson(voucher))
          .toList();
}
