
import 'package:flutter/material.dart';
import '../../services/shipper_service.dart';
import '../../models/order_model.dart';
import 'shipper_order_detail_screen.dart';

class ShipperPendingOrdersScreen extends StatefulWidget {
  const ShipperPendingOrdersScreen({super.key});

  @override
  State<ShipperPendingOrdersScreen> createState() => _ShipperPendingOrdersScreenState();
}

class _ShipperPendingOrdersScreenState extends State<ShipperPendingOrdersScreen> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ShipperService.getPendingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải đơn hàng: ${snapshot.error}'));
        }
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return const Center(child: Text('Không có đơn hàng nào chờ nhận.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: ListTile(
                title: Text('Mã đơn: ${order.id}'),
                subtitle: Text('Địa chỉ: ${order.deliveryAddress}'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final success = await ShipperService.acceptOrder(order.id);
                    if (success && mounted) {
                      setState(() {
                        _ordersFuture = ShipperService.getPendingOrders();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhận đơn thành công!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhận đơn thất bại!')));
                    }
                  },
                  child: const Text('Nhận đơn'),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShipperOrderDetailScreen(orderId: order.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
