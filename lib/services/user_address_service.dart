import 'package:dio/dio.dart';
import '../models/user_address_model.dart';
import '../services/dio_service.dart';

class UserAddressService {
  final Dio _dio = DioService.instance;

  Future<List<UserAddress>> getAddresses() async {
    try {
      final response = await _dio.get('/user-addresses');
      return (response.data as List)
          .map((item) => UserAddress.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load addresses');
    }
  }

  Future<UserAddress> createAddress(UserAddress address) async {
    try {
      final response = await _dio.post('/user-addresses', data: address.toJson());
      return UserAddress.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create address');
    }
  }

  Future<UserAddress> updateAddress(String id, UserAddress address) async {
    try {
      final response = await _dio.put('/user-addresses/$id', data: address.toJson());
      return UserAddress.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update address');
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete('/user-addresses/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete address');
    }
  }
}
