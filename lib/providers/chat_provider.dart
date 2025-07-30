import 'package:flutter/material.dart';
import '../models/message.dart';
import '../screens/chat/chat_screen.dart';
import '../services/chat_service.dart';
import '../services/chat_service_singleton.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatServiceSingleton.getInstance((message) {
    // Callback to handle received messages
  });
  List<Message> _messages = [];
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> fetchMessages(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _chatService.fetchMessages(orderId);
    } catch (e) {
      print('Error fetching messages: $e');
      _messages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String orderId, String senderId, String receiverId, String content) async {
    await _chatService.sendMessage(orderId, senderId, receiverId, content);
    // Refresh messages after sending
    await fetchMessages(orderId);
    notifyListeners();
  }

  Future<void> markAsRead(String messageId) async {
    await _chatService.markAsRead(messageId);
    // Refresh messages after marking as read
    await fetchMessages(_messages.isNotEmpty ? _messages.first.orderId : '');
    notifyListeners();
  }

  void addMessage(Message message) {
    if (!_messages.any((m) => m.id == message.id)) {
      _messages.add(message);
      notifyListeners();
    }
  }

  void joinChat(String orderId) {
    _chatService.joinChat(orderId);
  }

  void setupChatListeners() {
    _chatService.onMessageReceived = (message) {
      addMessage(message);
    };
  }

  void setChatScreenState(ChatScreenState state) {
    _chatService.setChatScreenState(state);
  }
}
