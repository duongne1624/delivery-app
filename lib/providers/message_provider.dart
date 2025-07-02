import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/message.dart';

class MessageProvider with ChangeNotifier {
  List<Message> get messages =>
      (MockData.data['messages'] as List<dynamic>)
          .map((message) => Message.fromJson(message))
          .toList();

  void sendMessage(Message message) {
    // Mô phỏng gửi tin nhắn
    notifyListeners();
  }
}