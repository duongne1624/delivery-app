class UserAddress {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? placeId;
  final String? note;
  final bool isDefault;

  UserAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.placeId,
    this.note,
    required this.isDefault,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      placeId: json['place_id'],
      note: json['note'],
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'place_id': placeId,
      'note': note,
      'is_default': isDefault,
    };
  }
}
