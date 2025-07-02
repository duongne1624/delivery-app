class ReviewTag {
  final String id;
  final String name;

  ReviewTag({
    required this.id,
    required this.name,
  });

  factory ReviewTag.fromJson(Map<String, dynamic> json) {
    return ReviewTag(
      id: json['id'],
      name: json['name'],
    );
  }
}