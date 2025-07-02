class Coordinates {
  final double lat;
  final double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String openHours;
  final Coordinates coordinates;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.openHours,
    required this.coordinates,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      openHours: json['open_hours'],
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }
}