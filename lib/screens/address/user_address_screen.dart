import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/user_address_model.dart';
import '../../routes/app_navigator.dart';
import '../../services/user_address_service.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  late UserAddressService _service;
  List<UserAddress> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = UserAddressService();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await _service.getAddresses();
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      print(e);
    }
  }

  Future<void> _delete(String id) async {
    await _service.deleteAddress(id);
    Fluttertoast.showToast(msg: 'Đã xoá địa chỉ');
    _loadAddresses();
  }

  Future<void> _setDefault(String id) async {
    await _service.setDefaultAddress(id);
    Fluttertoast.showToast(msg: 'Đã đặt làm mặc định');
    _loadAddresses();
  }

  void _showConfirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá địa chỉ này?'),
        content: const Text('Hành động này sẽ không thể khôi phục.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _delete(id);
              },
              child: const Text('Xoá')),
        ],
      ),
    );
  }

  void _navigateToAddEdit({UserAddress? address}) async {
    final result = await AppNavigator.toAddEditAddress(context, address: address);
    if (result == true) {
      _loadAddresses();
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
            Icon(Icons.location_on, color: isDark ? theme.colorScheme.primary : Colors.deepOrange, size: 26),
            const SizedBox(width: 8),
            Text('Địa chỉ giao hàng', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: isDark ? theme.colorScheme.primary : Colors.deepOrange))
          : _addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: isDark ? theme.colorScheme.primary : Colors.deepOrange),
                      const SizedBox(height: 12),
                      Text('Chưa có địa chỉ nào', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Hãy thêm địa chỉ để giao hàng nhanh hơn.', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black26 : Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(
                          address.isDefault ? Icons.star : Icons.location_on,
                          color: address.isDefault ? (isDark ? theme.colorScheme.primary : Colors.orange) : (isDark ? theme.colorScheme.primary : Colors.deepOrange),
                          size: 30,
                        ),
                        title: Text(address.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        subtitle: Text(address.address, style: theme.textTheme.bodyMedium),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _navigateToAddEdit(address: address);
                            } else if (value == 'delete') {
                              _showConfirmDelete(address.id);
                            } else if (value == 'default') {
                              _setDefault(address.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                            const PopupMenuItem(value: 'delete', child: Text('Xoá')),
                            if (!address.isDefault)
                              const PopupMenuItem(value: 'default', child: Text('Đặt làm mặc định')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? theme.colorScheme.primary : Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
