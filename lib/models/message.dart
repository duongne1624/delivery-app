class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}