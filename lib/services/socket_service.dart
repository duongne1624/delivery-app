import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dio_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  void connect(String userId) {
    _socket = IO.io(DioService.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'userId': userId},
    });

    _socket?.connect();

    _socket?.onConnect((_) {
      print('Connected to socket server');
      _socket?.emit('join', userId);
    });

    _socket?.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  void joinChat(String orderId) {
    _socket?.emit('joinChat', orderId);
  }

  void sendMessage(Map<String, dynamic> message) {
    _socket?.emit('sendMessage', message);
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _socket?.on('message', (data) => callback(data));
  }

  void disconnect() {
    _socket?.disconnect();
  }

  bool get isConnected => _socket?.connected ?? false;
}
