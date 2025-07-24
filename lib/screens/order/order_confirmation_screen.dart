import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/product_model.dart';
import '../../models/user_address_model.dart';
import '../../routes/app_navigator.dart';
import '../../services/order_service.dart';
import '../../services/user_address_service.dart';
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
  final _noteController = TextEditingController();
  String _selectedPaymentMethod = 'cod';
  bool _isLoading = false;
  UserAddress? _selectedAddress;
  final _addressService = UserAddressService();

  double get _totalPrice {
    return widget.cart.entries.fold(0, (sum, entry) {
      final product = widget.products.firstWhere((p) => p.id == entry.key);
      return sum + product.price * entry.value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final addresses = await _addressService.getAddresses();
      if (addresses.isNotEmpty && mounted) {
        final defaultAddress = addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => addresses.first,
        );
        setState(() {
          _selectedAddress = defaultAddress;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Lỗi tải địa chỉ: $e');
    }
  }

  Future<void> _selectAddress() async {
    // Lấy danh sách địa chỉ đã lưu
    final addresses = await _addressService.getAddresses();
    if (!mounted) return;

    // Hiển thị dialog chọn địa chỉ
    final selected = await showModalBottomSheet<UserAddress?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Chọn địa chỉ mới'),
              leading: const Icon(Icons.add_location),
              onTap: () async {
                final result = await AppNavigator.toMapLocationPicker(context);
                if (result != null && result is Map<String, dynamic> && mounted) {
                  final newAddress = UserAddress(
                    id: '',
                    name: 'Địa chỉ mới',
                    address: result['address'] as String,
                    latitude: result['latitude'] as double,
                    longitude: result['longitude'] as double,
                    placeId: result['placeId'] as String?,
                    isDefault: false,
                  );
                  Navigator.pop(context, newAddress);
                }
              },
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return ListTile(
                    title: Text(address.name),
                    subtitle: Text(address.address, maxLines: 2, overflow: TextOverflow.ellipsis),
                    leading: const Icon(Icons.location_on),
                    trailing: address.isDefault ? const Icon(Icons.check_circle, color: Colors.green) : null,
                    onTap: () => Navigator.pop(context, address),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedAddress = selected;
      });
    }
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      Fluttertoast.showToast(msg: 'Vui lòng chọn địa chỉ giao hàng');
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
        deliveryAddress: _selectedAddress!.address,
        latitude: _selectedAddress!.latitude,
        longitude: _selectedAddress!.longitude,
        placeId: _selectedAddress!.placeId,
        note: _noteController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
      );

      final data = res['data'];
      final orderId = data['order']['id'];
      final paymentUrl = data['paymentUrl'];

      widget.cart.clear();

      if (_selectedPaymentMethod == 'cod') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
          (route) => route.isFirst,
        );
      } else {
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
      Fluttertoast.showToast(msg: 'Đặt hàng thất bại: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
                  Text('Địa chỉ giao hàng', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectAddress,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      child: Text(
                        _selectedAddress != null
                            ? '${_selectedAddress!.name}: ${_selectedAddress!.address}'
                            : 'Chọn địa chỉ giao hàng',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
