class Report {
  final String id;
  final String userId;
  final String message;
  final String createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}
