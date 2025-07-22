import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapLocationPicker extends StatefulWidget {
  final Function(String address, double lat, double lng, String? placeId) onSelected;

  const MapLocationPicker({super.key, required this.onSelected});

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _center;
  late GooglePlace _googlePlace;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GOOGLE_MAPS_API_KEY is not set in .env');
    }
    _googlePlace = GooglePlace(apiKey);
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
        });
      } else {
        throw Exception('Location permission denied');
      }
    } catch (e) {
      print('Error getting location: $e');
      // Set fallback location (e.g., Ho Chi Minh)
      setState(() {
        _center = LatLng(10.762622, 106.660172);
      });
    }
  }

  Future<void> _selectLocation(LatLng latLng) async {
    try {
      final nearbyResult = await _googlePlace.search.getNearBySearch(
        Location(lat: latLng.latitude, lng: latLng.longitude),
        100,
      );

      print('Nearby result status: ${nearbyResult?.status}');


      String address = 'Vị trí chưa rõ';
      String? placeId;

      if (nearbyResult?.results != null && nearbyResult!.results!.isNotEmpty) {
        final first = nearbyResult.results!.first;
        placeId = first.placeId;

        if (placeId != null) {
          final detail = await _googlePlace.details.get(placeId);
          if (detail?.result != null) {
            address = detail!.result!.formattedAddress ?? address;
          }
        }
      }

      widget.onSelected(address, latLng.latitude, latLng.longitude, placeId);
    } catch (e) {
      print('Lỗi khi chọn vị trí: $e');
      widget.onSelected('Không thể lấy địa chỉ', latLng.latitude, latLng.longitude, null);
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn vị trí')),
      body: _center == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: _center!, zoom: 15),
              onMapCreated: (controller) => _mapController = controller,
              onTap: _selectLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
