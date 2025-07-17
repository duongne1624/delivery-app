import 'dio_service.dart';

class PaymentService {
  static Future<bool> verifyPayment(String orderId) async {
    final res = await DioService.instance.get('/payment/verify/$orderId');
    return res.data['success'] == true;
  }
}
