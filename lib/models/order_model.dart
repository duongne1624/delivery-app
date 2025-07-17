import 'order_item_model.dart';
import 'user_model.dart';

class OrderModel {
  final String id;
  final int totalPrice;
  final String status;
  final String deliveryAddress;
  final String? note;
  final UserModel customer;
  final UserModel? shipper;
  final List<OrderItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.deliveryAddress,
    this.note,
    required this.customer,
    this.shipper,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      totalPrice: (json['total_price'] is int)
          ? json['total_price']
          : int.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? 'unknown',
      deliveryAddress: json['delivery_address'] ?? '',
      note: json['note']?.toString(),
      customer: UserModel.fromJson(json['customer']),
      shipper: json['shipper'] != null ? UserModel.fromJson(json['shipper']) : null,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
