import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';

class MapLocationPicker extends StatefulWidget {
  final Function(String address, double lat, double lng, String? placeId) onSelected;

  const MapLocationPicker({super.key, required this.onSelected});

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(10.762622, 106.660172); // Default: Hồ Chí Minh
  late GooglePlace _googlePlace;
  String _apiKey = 'YOUR_GOOGLE_API_KEY'; // Replace with real key

  @override
  void initState() {
    super.initState();
    _googlePlace = GooglePlace(_apiKey);
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_center));
  }

  void _selectLocation(LatLng latLng) async {
    final response = await _googlePlace.search.getNearBySearch(Location(lat: latLng.latitude, lng: latLng.longitude), 1);
    final first = response.results?.first;

    String address = 'Unnamed location';
    String? placeId;

    if (first != null) {
      address = first.name ?? address;
      placeId = first.placeId;
    }

    widget.onSelected(address, latLng.latitude, latLng.longitude, placeId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn vị trí')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 15),
        onMapCreated: (controller) => _mapController = controller,
        onTap: _selectLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
