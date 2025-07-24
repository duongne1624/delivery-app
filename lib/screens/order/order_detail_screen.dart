import 'package:delivery_online_app/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../services/payment_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<OrderModel> _orderFuture;
  Future<bool>? _paymentStatusFuture;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  void _loadOrder() {
    _orderFuture = OrderService.getOrderDetail(widget.orderId);
    // Sau khi lấy order, kiểm tra nếu là online thì gọi verifyPayment
    _orderFuture.then((order) {
      if (order.payment.method.toLowerCase() != 'cod') {
        setState(() {
          _paymentStatusFuture = PaymentService.verifyPayment(order.id);
        });
      } else {
        setState(() {
          _paymentStatusFuture = null;
        });
      }
    });
  }

  Future<void> _cancelOrder(String orderId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận huỷ đơn'),
        content: const Text('Bạn có chắc chắn muốn huỷ đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Huỷ đơn'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await OrderService.cancelOrder(orderId);

        if (!mounted) return;

        // Reload lại dữ liệu đơn hàng
        setState(() {
          _orderFuture = OrderService.getOrderDetail(orderId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã huỷ đơn hàng.')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Huỷ đơn thất bại: $e')),
        );
      }
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
            Icon(Icons.receipt_long, color: isDark ? theme.colorScheme.primary : Colors.deepOrange, size: 26),
            const SizedBox(width: 8),
            Text('Chi tiết đơn hàng', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: FutureBuilder<OrderModel>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange));
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                  const SizedBox(height: 12),
                  Text('Không thể tải đơn hàng.', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Vui lòng thử lại hoặc kiểm tra kết nối.', style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          final order = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black38 : Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Mã đơn hàng:', order.id, theme, isDark),
                      const SizedBox(height: 8),
                      _buildInfoRow('Trạng thái:', _mapStatus(order.status), theme, isDark),
                      const SizedBox(height: 8),
                      _buildInfoRow('Địa chỉ:', order.deliveryAddress, theme, isDark),
                      _buildInfoRow('Thời gian tạo:', formatDateTimeVN(order.createdAt), theme, isDark),
                      _buildInfoRow('Cập nhật cuối cùng:', formatDateTimeVN(order.updatedAt), theme, isDark),
                      if (order.note != null && order.note!.isNotEmpty)
                        _buildInfoRow('Ghi chú:', order.note!, theme, isDark),
                      if (order.shipper != null)
                        _buildInfoRow('Shipper:', '${order.shipper!.name} (${order.shipper!.phone})', theme, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // PHẦN THANH TOÁN
                _buildPaymentSection(order, theme, isDark),
                const SizedBox(height: 18),
                Text('Danh sách món ăn:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black26 : Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      leading: item.product.image != null && item.product.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: isDark ? theme.colorScheme.surface : Colors.grey[300],
                              alignment: Alignment.center,
                              child: Icon(Icons.image_not_supported, color: isDark ? theme.colorScheme.primary : Colors.grey),
                            ),
                      title: Text(item.product.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                      subtitle: Text('Số lượng: ${item.quantity}', style: theme.textTheme.bodySmall),
                      trailing: Text(currencyFormat.format(item.price), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng tiền:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(currencyFormat.format(order.totalPrice), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                if (_canCancel(order.status))
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('Huỷ đơn hàng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onPressed: () => _cancelOrder(order.id),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentSection(OrderModel order, ThemeData theme, bool isDark) {
    if (order.payment.method.toLowerCase() == 'cod') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Phương thức thanh toán:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text('Thanh toán khi nhận hàng', style: theme.textTheme.bodyMedium),
        ],
      );
    }
    return FutureBuilder<bool>(
      future: _paymentStatusFuture,
      builder: (context, snapshot) {
        final paid = snapshot.data == true;
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
            // Có thể bổ sung thêm các thông tin khác nếu backend trả về
            const SizedBox(height: 8),
            Text('Tổng tiền: ${currencyFormat.format(order.totalPrice)}'),
            // ...
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
}
