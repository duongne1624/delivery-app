import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/user_address_model.dart';
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
    }
  }

  Future<void> _delete(String id) async {
    await _service.deleteAddress(id);
    Fluttertoast.showToast(msg: 'Address deleted');
    _loadAddresses();
  }

  void _showConfirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete address?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _delete(id);
              },
              child: const Text('Delete')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return ListTile(
                  leading: Icon(address.isDefault ? Icons.star : Icons.location_on),
                  title: Text(address.name),
                  subtitle: Text(address.address),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'delete') _showConfirmDelete(address.id);
                      // TODO: add 'edit' and 'set default' actions
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add address screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
