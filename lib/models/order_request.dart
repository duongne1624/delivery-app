class OrderItem {
  final String productId;
  final int quantity;

  OrderItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
      };
}

class OrderRequest {
  final List<OrderItem> items;
  final String deliveryAddress;
  final String? note;
  final String paymentMethod;

  OrderRequest({
    required this.items,
    required this.deliveryAddress,
    this.note,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'delivery_address': deliveryAddress,
        'note': note,
        'payment_method': paymentMethod,
      };
}
