class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? image;
  final String role;
  final bool isActive;

  UserModel({
    required this.id, 
    required this.name,
    required this.phone,
    this.email,
    this.image,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      role: json['role'],
      isActive: json['is_active'],
    );
  }
}
