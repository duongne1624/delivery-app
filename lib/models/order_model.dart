import 'order_item_model.dart';
import 'user_model.dart';

class PaymentModel {
  final String method;
  final String? transactionId;
  final String status;
  final String amount;

  PaymentModel({
    required this.method,
    this.transactionId,
    required this.status,
    required this.amount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    method: json['method'] ?? '',
    transactionId: json['transaction_id'],
    status: json['status'] ?? '',
    amount: json['amount']?.toString() ?? '',
  );
}

class OrderModel {
  final String id;
  final double totalPrice;
  final String status;
  final String deliveryAddress;
  final String? deliveryPlaceId;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? note;
  final UserModel customer;
  final UserModel? shipper;
  final DateTime? shipperConfirmedAt;
  final String? cancelReason;
  final List<OrderItemModel> items;
  final PaymentModel payment;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.deliveryAddress,
    this.deliveryPlaceId,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.note,
    required this.customer,
    this.shipper,
    this.shipperConfirmedAt,
    this.cancelReason,
    required this.items,
    required this.payment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      status: json['status'] ?? 'unknown',
      deliveryAddress: json['delivery_address'] ?? '',
      deliveryPlaceId: json['delivery_place_id'],
      deliveryLatitude: (json['delivery_latitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num?)?.toDouble(),
      note: json['note'],
      customer: UserModel.fromJson(json['customer']),
      shipper: json['shipper'] != null ? UserModel.fromJson(json['shipper']) : null,
      shipperConfirmedAt: json['shipper_confirmed_at'] != null && json['shipper_confirmed_at'] != ''
          ? DateTime.parse(json['shipper_confirmed_at'])
          : null,
      cancelReason: json['cancel_reason'],
      items: (json['items'] as List).map((item) => OrderItemModel.fromJson(item)).toList(),
      payment: PaymentModel.fromJson(json['payment']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_price': totalPrice,
      'status': status,
      'delivery_address': deliveryAddress,
      'delivery_place_id': deliveryPlaceId,
      'delivery_latitude': deliveryLatitude,
      'delivery_longitude': deliveryLongitude,
      'note': note,
      'customer': customer.toJson(),
      'shipper_confirmed_at': shipperConfirmedAt?.toIso8601String(),
      'cancel_reason': cancelReason,
      'items': items.map((item) => item.toJson()).toList(),
      'payment': payment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
