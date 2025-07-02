class User {
  final String id;
  final String phone;
  final String email;
  final String role;
  final String name;

  User({
    required this.id,
    required this.phone,
    required this.email,
    required this.role,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
      name: json['name'],
    );
  }
}