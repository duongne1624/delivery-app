class UserAddress {
  final String id;
  final String name;
  final String address;
  final bool isDefault;
  final double latitude;
  final double longitude;
  final String? placeId;
  final String? note;

  UserAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeId,
    required this.isDefault,
    this.note,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      placeId: json['place_id']?.toString(),
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      note: json['note']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'place_id': placeId,
      'is_default': isDefault,
      'note': note,
    };
  }
}
