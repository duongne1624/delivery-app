import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> get orders =>
      (MockData.data['orders'] as List<dynamic>)
          .map((order) => Order.fromJson(order))
          .toList();

  Order? getOrderDetail(String id) {
    if (MockData.data['order_detail']['id'] == id) {
      return Order.fromJson(MockData.data['order_detail']);
    }
    return null;
  }

  void cancelOrder(String id) {
    // Mô phỏng hủy đơn hàng
    notifyListeners();
  }
}