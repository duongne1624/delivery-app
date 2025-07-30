import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message.dart';
import '../screens/chat/chat_screen.dart';
import '../services/dio_service.dart';
import '../services/notification_service_singleton.dart';
import '../models/notification_model.dart';

class ChatService {
  final IO.Socket? socket;
  Function(Message)? onMessageReceived;
  GlobalKey<NavigatorState>? _navigatorKey;
  ChatScreenState? _chatScreenState;

  ChatService({this.onMessageReceived})
      : socket = NotificationServiceSingleton.getInstance((_) {}).socket;

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    print('ChatService: _navigatorKey set to ${navigatorKey.toString()} at ${DateTime.now()}');
  }

  void setChatScreenState(ChatScreenState state) {
    _chatScreenState = state;
  }

  Future<void> initChat() async {
    socket?.on('message', (data) {
      _handleReceivedMessage(data);
    });
  }

  Future<void> _handleReceivedMessage(Map<String, dynamic> data) async {
    try {
      final message = Message.fromJson(data);
      print('Message received: ${message.content} at ${DateTime.now()}');

      if (_navigatorKey?.currentContext != null) {
        final notification = NotificationModel(
          id: 'CHAT_${message.id}',
          title: 'New Message',
          body: message.content,
          status: 1,
          time: message.timestamp,
          read: false,
          orderId: message.orderId,
        );
        NotificationServiceSingleton.getInstance((_) {}).showInAppNotification(notification);
      }

      // Defer reload to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _chatScreenState?.reload();
      });

      if (onMessageReceived != null) {
        onMessageReceived!(message);
      }
    } catch (e) {
      print('Error handling received message: $e');
    }
  }

  void joinChat(String orderId) {
    socket?.emit('joinChat', orderId);
    print('Joined chat room: $orderId at ${DateTime.now()}');
  }

  Future<void> sendMessage(String orderId, String senderId, String receiverId, String content) async {
    final message = Message(
      id: '',
      orderId: orderId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
      read: false,
    );
    socket?.emit('sendMessage', message.toJson());
    // Defer reload to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatScreenState?.reload();
    });
  }

  Future<List<Message>> fetchMessages(String orderId) async {
    try {
      final response = await DioService.instance.get('/chat/$orderId');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List<dynamic>) {
          return data.map((json) => Message.fromJson(json)).toList();
        } else if (data is Map<String, dynamic> && data['messages'] is List) {
          final List<dynamic> messageList = data['messages'];
          return messageList.map((json) => Message.fromJson(json)).toList();
        } else {
          print('Unexpected response format: $data');
          return [];
        }
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
    return [];
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await DioService.instance.patch('/chat/message/$messageId/read');
      // Defer reload to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _chatScreenState?.reload();
      });
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  void disconnect() {
    socket?.off('message');
  }
}
