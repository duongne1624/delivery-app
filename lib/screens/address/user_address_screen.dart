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
    return Scaffold(
      appBar: AppBar(title: const Text('Địa chỉ giao hàng')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? const Center(child: Text('Chưa có địa chỉ nào'))
              : ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return ListTile(
                      leading: Icon(
                        address.isDefault ? Icons.star : Icons.location_on,
                        color: address.isDefault ? Colors.orange : null,
                      ),
                      title: Text(address.name),
                      subtitle: Text(address.address),
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
                          const PopupMenuItem(
                              value: 'edit', child: Text('Chỉnh sửa')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Xoá')),
                          if (!address.isDefault)
                            const PopupMenuItem(
                                value: 'default',
                                child: Text('Đặt làm mặc định')),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
