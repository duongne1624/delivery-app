class DeliveryNotification {
  final String id;
  final String recipientId;
  final String content;
  final bool isRead;
  final String createdAt;

  DeliveryNotification({
    required this.id,
    required this.recipientId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  factory DeliveryNotification.fromJson(Map<String, dynamic> json) {
    return DeliveryNotification(
      id: json['id'],
      recipientId: json['recipient_id'],
      content: json['content'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
    );
  }
}