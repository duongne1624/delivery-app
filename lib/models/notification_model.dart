class NotificationModel {
  final String id;
  final String title;
  final String body;
  final int status;
  final DateTime time;
  final bool read;
  final String? orderId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.time,
    required this.read,
    this.orderId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'],
      body: json['body'],
      status: json['status'],
      time: DateTime.parse(json['time']),
      read: json['read'] ?? false,
      orderId: json['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'status': status,
      'time': time.toIso8601String(),
      'read': read,
      'orderId': orderId,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    int? status,
    DateTime? time,
    bool? read,
    String? orderId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      time: time ?? this.time,
      read: read ?? this.read,
      orderId: orderId ?? this.orderId,
    );
  }
}
