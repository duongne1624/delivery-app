class Addon {
  final String id;
  final String name;
  final double price;

  Addon({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
