import 'dart:developer';

import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:delivery_online_app/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../widgets/shimmer_list.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> with AutomaticKeepAliveClientMixin {
  List<OrderModel> orders = [];
  List<OrderModel> filteredOrders = [];
  bool isLoading = true;
  String filter = 'all';

  @override
  void initState() {
    super.initState();
    refreshOrders();
  }

  void refreshOrders() async {
    setState(() => isLoading = true);
    try {
      orders = await OrderService.getMyOrders();
      applyFilter();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void applyFilter() {
    if (filter == 'all') {
      filteredOrders = orders;
    } else {
      filteredOrders = orders.where((order) => order.status == filter).toList();
    }
    setState(() {});
  }

  Widget buildOrderItem(OrderModel order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => AppNavigator.toOrderDetail(context, order.id),
        leading: Icon(Icons.receipt_long, color: statusColor(order.status)),
        title: Text(
          '#${order.id.substring(0, 8).toUpperCase()}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatDateTimeVN(order.createdAt)),
            Text(
              '${order.items.length} món • ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(order.totalPrice)}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        trailing: Text(
          _getStatusLabel(order.status),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: statusColor(order.status),
          ),
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'delivering':
        return 'Đang giao';
      case 'completed':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'delivering':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildFilterTab(String label, String value) {
    final isSelected = filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            filter = value;
            applyFilter();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async => refreshOrders(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Đơn hàng của bạn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                buildFilterTab('Tất cả', 'all'),
                buildFilterTab('Chờ xác nhận', 'pending'),
                buildFilterTab('Đang giao', 'delivering'),
                buildFilterTab('Đã giao', 'completed'),
                buildFilterTab('Đã hủy', 'cancelled'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const ShimmerList()
                : filteredOrders.isEmpty
                    ? const Center(child: Text('Không có đơn hàng nào.'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) => buildOrderItem(filteredOrders[index]),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
