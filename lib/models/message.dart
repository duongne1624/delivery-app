import 'package:intl/intl.dart';

class Message {
  final String id;
  final String orderId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool read;

  Message({
    required this.id,
    required this.orderId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.read,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Handle custom timestamp format: "Wed Jul 30 2025 16:18:50 GMT+0700 (Indochina Time)"
    DateTime parseTimestamp(String? timestamp) {
      if (timestamp == null || timestamp.isEmpty) {
        return DateTime.now();
      }
      try {
        // Define the expected format
        final format = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z (zzzz)");
        return format.parse(timestamp);
      } catch (e) {
        print('Error parsing timestamp "$timestamp": $e');
        return DateTime.now(); // Fallback to current time
      }
    }

    return Message(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? json['conten'] ?? '', // Handle server typo
      timestamp: parseTimestamp(json['timestamp']),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    };
  }

  Message copyWith({
    String? id,
    String? orderId,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? read,
  }) {
    return Message(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }
}
