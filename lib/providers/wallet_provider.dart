import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/wallet.dart';

class WalletProvider with ChangeNotifier {
  Wallet? _wallet;

  Wallet? get wallet => _wallet;

  void loadWallet(String userId) {
    if (MockData.data['wallet']['user_id'] == userId) {
      _wallet = Wallet.fromJson(MockData.data['wallet']);
      notifyListeners();
    }
  }
}