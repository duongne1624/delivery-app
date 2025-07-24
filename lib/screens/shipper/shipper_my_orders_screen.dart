import 'package:flutter/material.dart';
import '../../services/shipper_service.dart';
import '../../models/order_model.dart';
import 'shipper_order_detail_screen.dart';

class ShipperMyOrdersScreen extends StatefulWidget {
  const ShipperMyOrdersScreen({super.key});

  @override
  State<ShipperMyOrdersScreen> createState() => _ShipperMyOrdersScreenState();
}

class _ShipperMyOrdersScreenState extends State<ShipperMyOrdersScreen> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ShipperService.getMyOrders();
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
          return Center(child: Text('Lỗi tải đơn hàng: \\${snapshot.error}'));
        }
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return const Center(child: Text('Bạn chưa nhận đơn hàng nào.'));
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Địa chỉ: ${order.deliveryAddress}'),
                    Text('Tổng tiền: ${order.totalPrice.toStringAsFixed(0)}đ'),
                    Text('Trạng thái: ${order.status}'),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
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
