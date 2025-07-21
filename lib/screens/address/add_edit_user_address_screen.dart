import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/user_address_model.dart';
import '../../services/user_address_service.dart';
import 'map_location_picker.dart';

class AddEditUserAddressScreen extends StatefulWidget {
  final UserAddress? existing;

  const AddEditUserAddressScreen({super.key, this.existing});

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
    if (widget.existing != null) {
      final a = widget.existing!;
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

    final data = {
      'name': _nameController.text.trim(),
      'note': _noteController.text.trim(),
      'address': _address,
      'latitude': _latitude,
      'longitude': _longitude,
      'place_id': _placeId,
      'is_default': _isDefault,
    };

    try {
      if (widget.existing == null) {
        await _service.createAddress(data);
        Fluttertoast.showToast(msg: 'Thêm địa chỉ thành công');
      } else {
        await _service.updateAddress(widget.existing!.id, data);
        Fluttertoast.showToast(msg: 'Cập nhật địa chỉ thành công');
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Thêm địa chỉ' : 'Chỉnh sửa địa chỉ')),
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
                child: Text(widget.existing == null ? 'Thêm địa chỉ' : 'Cập nhật địa chỉ'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
