import 'dio_service.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class ShipperService {
  // Lấy danh sách đơn hàng chưa nhận
  static Future<List<OrderModel>> getPendingOrders() async {
    final res = await DioService.instance.get('/shipper/orders/pending');
    return (res.data['data'] as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  // Đăng ký nhận đơn
  static Future<bool> acceptOrder(String orderId) async {
    final res = await DioService.instance.post('/shipper/orders/$orderId/accept');
    return res.data['success'] == true;
  }

  // Lấy danh sách đơn hàng đã nhận
  static Future<List<OrderModel>> getMyOrders() async {
    final res = await DioService.instance.get('/shipper/orders/my');
    return (res.data['data'] as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  // Lấy thống kê shipper: số đơn đã giao, thu nhập ngày, thu nhập tháng, số đơn đang giao
  static Future<Map<String, dynamic>> getStats() async {
    final res = await DioService.instance.get('/shipper/stats');
    return Map<String, dynamic>.from(res.data['data']);
  }

  // Xem chi tiết đơn hàng
  static Future<OrderModel> getOrderDetail(String orderId) async {
    final res = await DioService.instance.get('/shipper/orders/$orderId');
    return OrderModel.fromJson(res.data['data']);
  }

  // Cập nhật trạng thái đơn hàng
  static Future<bool> updateOrderStatus(String orderId, String status) async {
    final res = await DioService.instance.patch('/shipper/orders/$orderId/status', data: {'status': status});
    return res.data['success'] == true;
  }

  // Lấy thông tin cá nhân shipper
  static Future<UserModel> getProfile() async {
    final res = await DioService.instance.get('/shipper/profile');
    return UserModel.fromJson(res.data['data']);
  }
}
