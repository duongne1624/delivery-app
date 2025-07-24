import 'package:flutter/material.dart';
import '../../services/shipper_service.dart';
import '../../models/order_model.dart';
import '../../widgets/order_address_map_view.dart';

class ShipperOrderDetailScreen extends StatefulWidget {
  final String orderId;
  const ShipperOrderDetailScreen({super.key, required this.orderId});

  @override
  State<ShipperOrderDetailScreen> createState() => _ShipperOrderDetailScreenState();
}

class _ShipperOrderDetailScreenState extends State<ShipperOrderDetailScreen> {
  late Future<OrderModel> _orderFuture;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _orderFuture = ShipperService.getOrderDetail(widget.orderId);
  }

  void _showMap(BuildContext context, OrderModel order) {
    if (order.deliveryLatitude != null && order.deliveryLongitude != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OrderAddressMapView(
          latitude: order.deliveryLatitude!,
          longitude: order.deliveryLongitude!,
          address: order.deliveryAddress,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không có vị trí địa chỉ khách hàng.')));
    }
  }

  Future<void> _confirmOrder(BuildContext context, OrderModel order) async {
    setState(() => _isConfirming = true);
    final success = await ShipperService.updateOrderStatus(order.id, 'completed');
    setState(() => _isConfirming = false);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xác nhận giao thành công!')));
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xác nhận thất bại!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderModel>(
      future: _orderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(child: Text('Không thể tải chi tiết đơn hàng.'));
        }
        final order = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mã đơn: ${order.id}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Khách hàng: ${order.customer.name} (${order.customer.phone})'),
                const SizedBox(height: 8),
                Text('Địa chỉ giao: ${order.deliveryAddress}'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text('Xem vị trí trên bản đồ'),
                  onPressed: () => _showMap(context, order),
                ),
                const SizedBox(height: 16),
                Text('Tổng tiền: ${order.totalPrice.toStringAsFixed(0)}đ', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Ghi chú: ${order.note ?? "Không có"}'),
                const SizedBox(height: 16),
                Text('Danh sách món:', style: Theme.of(context).textTheme.titleSmall),
                ...order.items.map((item) => ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Số lượng: ${item.quantity}'),
                  trailing: Text('${item.price.toStringAsFixed(0)}đ'),
                )),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: _isConfirming ? const Text('Đang xác nhận...') : const Text('Xác nhận giao thành công'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                    onPressed: _isConfirming ? null : () => _confirmOrder(context, order),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
