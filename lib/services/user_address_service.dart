import 'package:dio/dio.dart';
import '../models/user_address_model.dart';
import 'dio_service.dart';

class UserAddressService {
  final Dio _dio = DioService.instance;

  // Lấy tất cả địa chỉ của user
  Future<List<UserAddress>> getAddresses() async {
    try {
      final response = await _dio.get('/user-addresses');

      final List<dynamic> rawList = response.data['data'];

      return rawList
          .map((item) => UserAddress.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load addresses');
    }
  }

  // Tạo mới địa chỉ
  Future<UserAddress> createAddress(UserAddress address) async {
    try {
      final response = await _dio.post('/user-addresses', data: address.toJson());
      return UserAddress.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create address');
    }
  }

  // Cập nhật địa chỉ
  Future<UserAddress> updateAddress(String id, UserAddress address) async {
    try {
      final response = await _dio.put('/user-addresses/$id', data: address.toJson());
      return UserAddress.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update address');
    }
  }

  // Xóa địa chỉ
  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete('/user-addresses/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete address');
    }
  }

  // Đặt một địa chỉ làm mặc định
  Future<void> setDefaultAddress(String addressId) async {
    try {
      await _dio.post('/user-addresses/set-default', data: {
        'address_id': addressId,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to set default address');
    }
  }

  // (Tuỳ chọn) Lấy địa chỉ mặc định
  Future<UserAddress> getDefaultAddress() async {
    try {
      final response = await _dio.get('/user-addresses/default');
      return UserAddress.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get default address');
    }
  }
}
