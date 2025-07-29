

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import 'order_timeline.dart';


class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<OrderModel> _orderFuture;
  late NumberFormat currencyFormat;
  Future<bool>? _paymentStatusFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = OrderService.getOrderDetail(widget.orderId);
    currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  }

  Widget _buildPaymentSection(OrderModel order, ThemeData theme, bool isDark) {
    if (order.payment.method.toLowerCase() == 'cod') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Phương thức thanh toán:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text('COD', style: theme.textTheme.bodyMedium),
        ],
      );
    }
    return FutureBuilder<bool>(
      future: _paymentStatusFuture,
      builder: (context, snapshot) {
        final paid = order.payment.status == "success";
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phương thức thanh toán:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(order.payment.method, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(paid ? Icons.verified : Icons.error_outline, color: paid ? Colors.green : Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        paid ? 'Đã thanh toán' : 'Chưa thanh toán',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: paid ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (paid)
              TextButton(
                onPressed: () => _showPaymentDetail(order),
                child: const Text('Chi tiết'),
              ),
          ],
        );
      },
    );
  }

  void _showPaymentDetail(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chi tiết thanh toán'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã đơn hàng: ${order.id}'),
            Text('Phương thức: ${order.payment.method}'),
            const SizedBox(height: 8),
            Text('Tổng tiền: ${currencyFormat.format(order.totalPrice)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: isDark ? theme.colorScheme.primary : Colors.deepOrange)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  String _mapStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'shipping':
        return 'Đang giao';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã huỷ';
      default:
        return status;
    }
  }

  bool _canCancel(String status) {
    return status == 'pending' || status == 'confirmed';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: FutureBuilder<OrderModel>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy đơn hàng.'));
          }
          final order = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderTimeline(
                  createdAt: order.createdAt,
                  shipperConfirmedAt: order.shipperConfirmedAt,
                  completedAt: order.status == 'completed' ? order.updatedAt : null,
                  cancelledAt: order.status == 'cancelled' ? order.updatedAt : null,
                  theme: theme,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _buildInfoRow('Mã đơn:', order.id, theme, isDark),
                _buildInfoRow('Trạng thái:', _mapStatus(order.status), theme, isDark),
                _buildInfoRow('Địa chỉ:', order.deliveryAddress, theme, isDark),
                _buildInfoRow('Tổng tiền:', currencyFormat.format(order.totalPrice), theme, isDark),
                const SizedBox(height: 16),
                Text('Sản phẩm đã mua:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = order.items[i];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.image,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 54,
                              height: 54,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${currencyFormat.format(item.product.price)}',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                              ),
                            ],
                          ),
                        ),
                        Text('x${item.quantity}', style: theme.textTheme.bodyMedium),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildPaymentSection(order, theme, isDark),
                if (_canCancel(order.status))
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận hủy đơn'),
                              content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
                                ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Có')),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await OrderService.cancelOrder(order.id);
                              setState(() {
                                _orderFuture = OrderService.getOrderDetail(order.id);
                              });
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đã hủy đơn hàng thành công')),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Hủy đơn hàng thất bại: $e')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        label: const Text('Hủy đơn hàng'),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
