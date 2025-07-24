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
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  Color statusColor(String status) {
    switch (status) {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: isDark ? theme.colorScheme.primary : Colors.deepOrange, size: 26),
            const SizedBox(width: 8),
            Text('Đơn hàng của bạn', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => refreshOrders(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  buildFilterTab('Tất cả', 'all'),
                  buildFilterTab('Hoàn thành', 'completed'),
                  buildFilterTab('Đã hủy', 'cancelled'),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const ShimmerList()
                  : filteredOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox, size: 64, color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                              const SizedBox(height: 12),
                              Text('Không có đơn hàng nào.', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Bạn chưa đặt đơn hàng nào.', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredOrders.length,
                          itemBuilder: (_, index) {
                            final order = filteredOrders[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                              color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
                              shadowColor: isDark ? Colors.black38 : Colors.black12,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => AppNavigator.toOrderDetail(context, order.id),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.receipt_long, color: statusColor(order.status), size: 32),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '#${order.id.substring(0, 8).toUpperCase()}',
                                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              formatDateTimeVN(order.createdAt),
                                              style: theme.textTheme.bodySmall,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${order.items.length} món • ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(order.totalPrice)}',
                                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _getStatusLabel(order.status),
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: statusColor(order.status),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
