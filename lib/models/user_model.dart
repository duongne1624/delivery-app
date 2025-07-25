class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? image;
  final String? role;
  final bool? isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.image,
    this.role,
    this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      image: json['image'],
      role: json['role'],
      isActive: json['is_active'] is bool
          ? json['is_active']
          : (json['is_active']?.toString().toLowerCase() == 'true'),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'role': role,
      'is_active': isActive,
    };
  }
}
