import '../models/order_model.dart';
import 'dio_service.dart';

class OrderService {
  // Tạo đơn hàng mới
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
    double? latitude,
    double? longitude,
    String? placeId,
    String? note,
    required String paymentMethod,
  }) async {
    final res = await DioService.instance.post(
      '/orders',
      data: {
        'items': items,
        'delivery_address': deliveryAddress,
        'delivery_latitude': latitude,
        'delivery_longitude': longitude,
        'delivery_place_id': placeId,
        'note': note,
        'payment_method': paymentMethod,
      },
    );
    return res.data;
  }

  // Lấy danh sách đơn hàng của người dùng
  static Future<List<OrderModel>> getMyOrders() async {
    final res = await DioService.instance.get(
      '/orders/get-history',
    );
    final List data = res.data['data'];
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  // Lấy danh sách đơn hàng đang đặt mà chưa hoàn thành hoặc bị hủy
  static Future<List<OrderModel>> getCurrentOrders() async {
    final res = await DioService.instance.get(
      '/orders/get-current',
    );
    final List data = res.data['data'];
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  // Lấy chi tiết đơn hàng theo ID
  static Future<OrderModel> getOrderDetail(String orderId) async {
    final res = await DioService.instance.get('/orders/$orderId');
    return OrderModel.fromJson(res.data['data']);
  }

  // Hủy đơn hàng
  static Future<bool> cancelOrder(String orderId) async {
    final res = await DioService.instance.patch('/orders/$orderId/cancel-by-user');
    return res.data['success'] == true;
  }

  // Lấy danh sách đơn hàng cho shipper (status = pending)
  static Future<List<OrderModel>> getOrdersForShipper() async {
    final res = await DioService.instance.get(
      '/orders/get-for-shipper',
    );
    final List data = res.data['data'];
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  // Shipper nhận đơn
  static Future<bool> acceptOrder(String orderId) async {
    final res = await DioService.instance.post(
      '/assignments/$orderId/respond',
    );
    return res.data['success'] == true;
  }

  // Shipper xác nhận giao hàng hoàn tất
  static Future<bool> completeOrder(String orderId) async {
    final res = await DioService.instance.patch(
      '/orders/$orderId/complete-by-shipper',
    );
    return res.data['success'] == true;
  }

  // Xác minh thanh toán VNPAY
  static Future<bool> verifyVnPayPayment(String vnpTxnRef) async {
    final res = await DioService.instance.post(
      '/payments/verify',
      data: {
        'vnp_TxnRef': vnpTxnRef,
      },
    );
    return res.data['success'] == true;
  }
}
