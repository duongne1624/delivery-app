
import 'package:flutter/material.dart';
import '../../services/shipper_service.dart';

class ShipperHomeScreen extends StatefulWidget {
  const ShipperHomeScreen({super.key});

  @override
  State<ShipperHomeScreen> createState() => _ShipperHomeScreenState();
}

class _ShipperHomeScreenState extends State<ShipperHomeScreen> {
  bool isOnline = true;

  int activeOrders = 0;
  int completedToday = 0;
  double incomeToday = 0;
  double incomeMonth = 0;
  bool _loadingStats = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _loadingStats = true);
    try {
      final stats = await ShipperService.getStats();
      setState(() {
        activeOrders = stats['deliveringCount'] ?? 0;
        completedToday = stats['deliveredCount'] ?? 0;
        incomeToday = (stats['incomeToday'] ?? 0).toDouble();
        incomeMonth = (stats['incomeMonth'] ?? 0).toDouble();
        _loadingStats = false;
      });
    } catch (e) {
      setState(() => _loadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _loadingStats
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Xin chào, Shipper!', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Switch.adaptive(
                value: isOnline,
                onChanged: (v) => setState(() => isOnline = v),
                activeColor: Colors.green,
              ),
            ],
          ),
          Text(isOnline ? 'Trạng thái: Đang hoạt động' : 'Trạng thái: Đang offline',
              style: TextStyle(color: isOnline ? Colors.green : Colors.red, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Đơn đang giao', activeOrders.toString(), Icons.local_shipping, Colors.orange),
              _buildStatCard('Đã hoàn thành', completedToday.toString(), Icons.check_circle, Colors.blue),
            ],
          ),
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.green),
              title: Text('Thu nhập hôm nay: ${incomeToday.toStringAsFixed(0)}đ'),
              subtitle: Text('Tháng này: ${incomeMonth.toStringAsFixed(0)}đ'),
              trailing: IconButton(
                icon: const Icon(Icons.bar_chart),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xem thống kê thu nhập!')));
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Thông báo mới', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            color: Colors.yellow[50],
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.amber),
              title: const Text('Bạn có 2 đơn mới chờ nhận!'),
              subtitle: const Text('Nhấn vào tab "Chưa nhận" để xem chi tiết.'),
            ),
          ),
          const SizedBox(height: 18),
          Text('Truy cập nhanh', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickButton(context, Icons.assignment, 'Chưa nhận', 0),
              _buildQuickButton(context, Icons.local_shipping, 'Đang giao', 1),
              _buildQuickButton(context, Icons.bar_chart, 'Thống kê', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(BuildContext context, IconData icon, String label, int tabIndex) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đi tới "$label"')));
          },
          borderRadius: BorderRadius.circular(24),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.deepOrange.withOpacity(0.1),
            child: Icon(icon, color: Colors.deepOrange, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
