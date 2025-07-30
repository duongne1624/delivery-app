
import 'package:delivery_online_app/routes/app_navigator.dart';
import 'package:delivery_online_app/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../widgets/shimmer_list.dart';


class CurrentOrdersScreen extends StatefulWidget {
  const CurrentOrdersScreen({Key? key}) : super(key: key);

  @override
  State<CurrentOrdersScreen> createState() => CurrentOrdersScreenState();
}

class CurrentOrdersScreenState extends State<CurrentOrdersScreen> {

  List<OrderModel> orders = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshOrders();
    });
  }

  @override
  void initState() {
    super.initState();
    refreshOrders();
  }

  Future<void> refreshOrders() async {
    setState(() => isLoading = true);
    try {
      orders = await OrderService.getCurrentOrders();
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'delivering':
        return 'Đang giao';
      case 'confirmed':
        return 'Đã xác nhận';
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
      case 'confirmed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        title: Row(
          children: [
            Icon(Icons.list_alt, color: isDark ? theme.colorScheme.primary : Colors.deepOrange, size: 26),
            const SizedBox(width: 8),
            Text('Đơn hiện tại', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshOrders,
        child: isLoading
            ? const ShimmerList()
            : orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                        const SizedBox(height: 12),
                        Text('Không có đơn hàng nào.', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Bạn chưa có đơn hàng nào đang xử lý.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: orders.length,
                    itemBuilder: (_, index) {
                      final order = orders[index];
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
                                        '#${order.id.split('-')[0].toUpperCase()}',
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
    );
  }
}
