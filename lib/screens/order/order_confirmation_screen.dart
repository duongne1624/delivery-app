import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/order_service.dart';
import '../payment/payment_webview_screen.dart';
import 'order_detail_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final Map<String, int> cart;
  final List<ProductModel> products;

  const OrderConfirmationScreen({
    super.key,
    required this.cart,
    required this.products,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedPaymentMethod = 'cod';
  bool _isLoading = false;

  double get _totalPrice {
    return widget.cart.entries.fold(0, (sum, entry) {
      final product = widget.products.firstWhere((p) => p.id == entry.key);
      return sum + product.price * entry.value;
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final address = _addressController.text.trim();
    final note = _noteController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final items = widget.cart.entries.map((e) => {
            'product_id': e.key,
            'quantity': e.value,
          }).toList();

      final res = await OrderService.createOrder(
        items: items,
        deliveryAddress: address,
        note: note,
        paymentMethod: _selectedPaymentMethod,
      );

      final data = res['data'];
      final orderId = data['order']['id'];
      final paymentUrl = data['paymentUrl'];

      widget.cart.clear();

      if (_selectedPaymentMethod == 'cod' || paymentUrl == null) {
        // Đơn COD: chuyển thẳng tới chi tiết đơn
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
          (route) => route.isFirst,
        );
      } else {
        // Online: mở WebView thanh toán
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => PaymentWebViewScreen(
              paymentUrl: paymentUrl,
              orderId: orderId,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt hàng thất bại: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const paymentOptions = {
      'cod': 'Thanh toán khi nhận hàng (COD)',
      'vnpay': 'Thanh toán qua VNPAY',
      'zalopay': 'Thanh toán qua ZaloPay',
      'momo': 'Thanh toán qua Momo',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận đơn hàng')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh sách sản phẩm
                  Text('Sản phẩm đã chọn', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...widget.cart.entries.map((entry) {
                    final product = widget.products.firstWhere((p) => p.id == entry.key);
                    final quantity = entry.value;
                    final itemTotal = product.price * quantity;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name, style: theme.textTheme.bodyMedium),
                                Text('${product.price}đ x $quantity',
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text('${itemTotal.toStringAsFixed(0)} đ',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  // Phương thức thanh toán
                  Text('Phương thức thanh toán', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...paymentOptions.entries.map((entry) => RadioListTile<String>(
                        value: entry.key,
                        groupValue: _selectedPaymentMethod,
                        title: Text(entry.value),
                        onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                      )),

                  const SizedBox(height: 16),
                  // Địa chỉ giao hàng
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ giao hàng',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  // Ghi chú
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú (tuỳ chọn)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note_alt_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  // Tổng cộng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng cộng:', style: theme.textTheme.titleMedium),
                      Text('${_totalPrice.toStringAsFixed(0)} đ',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Nút đặt hàng
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Đặt hàng ngay'),
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
