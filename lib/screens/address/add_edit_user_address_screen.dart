import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/user_address_model.dart';
import '../../services/user_address_service.dart';
import 'map_location_picker.dart';

class AddEditUserAddressScreen extends StatefulWidget {
  final UserAddress? address;

  const AddEditUserAddressScreen({super.key, this.address});

  @override
  State<AddEditUserAddressScreen> createState() => _AddEditUserAddressScreenState();
}

class _AddEditUserAddressScreenState extends State<AddEditUserAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  String? _address;
  double? _latitude;
  double? _longitude;
  String? _placeId;
  bool _isDefault = false;

  final _service = UserAddressService();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      final a = widget.address!;
      _nameController.text = a.name;
      _noteController.text = a.note ?? '';
      _address = a.address;
      _latitude = a.latitude;
      _longitude = a.longitude;
      _placeId = a.placeId;
      _isDefault = a.isDefault;
    }
  }

  void _pickLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPicker(
          onSelected: (address, lat, lng, placeId) {
            setState(() {
              _address = address;
              _latitude = lat;
              _longitude = lng;
              _placeId = placeId;
            });
          },
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _latitude == null || _longitude == null || _address == null) {
      Fluttertoast.showToast(msg: 'Vui lòng chọn vị trí');
      return;
    }

    final address = UserAddress(
      id: widget.address?.id ?? '',
      name: _nameController.text.trim(),
      note: _noteController.text.trim(),
      address: _address!,
      latitude: _latitude!,
      longitude: _longitude!,
      placeId: _placeId ?? '',
      isDefault: _isDefault,
    );

    try {
      if (widget.address == null) {
        await _service.createAddress(address);
        Fluttertoast.showToast(msg: 'Thêm địa chỉ thành công');
      } else {
        await _service.updateAddress(widget.address!.id, address);
        Fluttertoast.showToast(msg: 'Cập nhật địa chỉ thành công');
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Lỗi: $e');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.address == null ? 'Thêm địa chỉ' : 'Chỉnh sửa địa chỉ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên địa chỉ (ví dụ: Nhà, Công ty)'),
                validator: (val) => val == null || val.isEmpty ? 'Bắt buộc' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickLocation,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Vị trí trên bản đồ'),
                  child: Text(_address ?? 'Chạm để chọn vị trí'),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (value) => setState(() => _isDefault = value ?? false),
                  ),
                  const Text('Đặt làm mặc định')
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.address == null ? 'Thêm địa chỉ' : 'Cập nhật địa chỉ'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
