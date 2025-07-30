import 'package:flutter/material.dart';
import 'chat_service.dart';
import '../models/message.dart';

class ChatServiceSingleton {
  static ChatService? _instance;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static bool _initialized = false;

  static ChatService getInstance(Function(Message) onMessageReceived) {
    if (_instance == null) {
      _instance = ChatService(
        onMessageReceived: onMessageReceived,
      );
      // Initialize chat
      if (!_initialized) {
        _instance!.initChat();
        _initialized = true;
        print('ChatServiceSingleton: Initialized at ${DateTime.now()}');
      }
      // Assign navigator key if available
      if (_navigatorKey != null) {
        _instance!.setNavigatorKey(_navigatorKey!);
      }
    }
    return _instance!;
  }

  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    if (_instance != null) {
      _instance!.setNavigatorKey(navigatorKey);
      print('ChatServiceSingleton: Navigator key set at ${DateTime.now()}');
    }
  }

  static void dispose() {
    if (_instance != null) {
      _instance!.disconnect();
      _instance = null;
      _navigatorKey = null;
      _initialized = false;
      print('ChatServiceSingleton: Disposed at ${DateTime.now()}');
    }
  }
}
