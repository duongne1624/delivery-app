import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/report.dart';

class ReportProvider with ChangeNotifier {
  List<Report> get reports =>
      (MockData.data['reports'] as List<dynamic>)
          .map((report) => Report.fromJson(report))
          .toList();

  void addReport(Report report) {
    // Mô phỏng gửi báo cáo
    notifyListeners();
  }
}
