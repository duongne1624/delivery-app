class WalletTransaction {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String createdAt;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'].toDouble(),
      type: json['type'],
      createdAt: json['created_at'],
    );
  }
}

class Wallet {
  final String userId;
  final double balance;
  final List<WalletTransaction> transactions;

  Wallet({
    required this.userId,
    required this.balance,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      userId: json['user_id'],
      balance: json['balance'].toDouble(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((transaction) => WalletTransaction.fromJson(transaction))
          .toList(),
    );
  }
}