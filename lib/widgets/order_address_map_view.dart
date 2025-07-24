import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderAddressMapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String address;
  const OrderAddressMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng latLng = LatLng(latitude, longitude);
    return Scaffold(
      appBar: AppBar(title: const Text('Vị trí giao hàng')), 
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: latLng, zoom: 16),
        markers: {
          Marker(
            markerId: const MarkerId('delivery'),
            position: latLng,
            infoWindow: InfoWindow(title: 'Địa chỉ khách', snippet: address),
          ),
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
