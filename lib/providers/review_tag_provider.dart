import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/review_tag.dart';

class ReviewTagProvider with ChangeNotifier {
  List<ReviewTag> get reviewTags =>
      (MockData.data['review_tags'] as List<dynamic>)
          .map((tag) => ReviewTag.fromJson(tag))
          .toList();
}
