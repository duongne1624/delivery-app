import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/review.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> getReviews(String productId) {
    return (MockData.data['reviews'] as List<dynamic>)
        .map((review) => Review.fromJson(review))
        .where((review) => review.productId == productId)
        .toList();
  }

  void addReview(Review review) {
    // Mô phỏng thêm đánh giá
    notifyListeners();
  }
}
