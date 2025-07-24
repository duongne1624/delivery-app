class NotificationModel {
  final String title;
  final String body;
  final int status;
  final DateTime time;
  final bool read;
  final String? orderId;

  NotificationModel({
    required this.title,
    required this.body,
    required this.status,
    required this.time,
    required this.read,
    this.orderId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      status: json['status'],
      time: DateTime.parse(json['time']),
      read: json['read'],
      orderId: json['orderId'],
    );
  }
}