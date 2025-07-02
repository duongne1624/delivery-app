class Voucher {
  final String id;
  final String code;
  final double discount;
  final String expiryDate;

  Voucher({
    required this.id,
    required this.code,
    required this.discount,
    required this.expiryDate,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      code: json['code'],
      discount: json['discount'].toDouble(),
      expiryDate: json['expiry_date'],
    );
  }
}