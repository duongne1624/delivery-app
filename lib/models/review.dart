class Review {
  final String id;
  final String productId;
  final String userId;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}
