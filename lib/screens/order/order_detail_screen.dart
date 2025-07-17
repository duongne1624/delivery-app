import 'package:delivery_online_app/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<OrderModel> _orderFuture;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  void _loadOrder() {
    _orderFuture = OrderService.getOrderDetail(widget.orderId);
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

        // 👉 Reload lại dữ liệu đơn hàng
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
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: FutureBuilder<OrderModel>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text('Không thể tải đơn hàng.'));
          }

          final order = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Mã đơn hàng:', order.id),
                const SizedBox(height: 8),
                _buildInfoRow('Trạng thái:', _mapStatus(order.status)),
                const SizedBox(height: 8),
                _buildInfoRow('Địa chỉ:', order.deliveryAddress),
                _buildInfoRow('Thời gian tạo:', formatDateTimeVN(order.createdAt)),
                _buildInfoRow('Cập nhật cuối cùng:', formatDateTimeVN(order.updatedAt)),
                if (order.note != null && order.note!.isNotEmpty)
                  _buildInfoRow('Ghi chú:', order.note!),
                if (order.shipper != null)
                  _buildInfoRow('Shipper:', '${order.shipper!.name} (${order.shipper!.phone})'),
                const SizedBox(height: 16),
                const Divider(),
                const Text('Danh sách món ăn:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: item.product.image != null && item.product.image.isNotEmpty
                        ? Image.network(
                            item.product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported),
                          ),
                    title: Text(item.product.name),
                    subtitle: Text('Số lượng: ${item.quantity}'),
                    trailing: Text(currencyFormat.format(item.price)),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng tiền:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(currencyFormat.format(order.totalPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
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
