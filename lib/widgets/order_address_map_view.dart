import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Vị trí giao hàng')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: theme.cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.place, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions),
                    label: const Text('Mở Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () async {
                      final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không mở được Google Maps.')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: latLng, zoom: 16),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('delivery'),
                  position: latLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    HSVColor.fromColor(theme.colorScheme.primary).hue,
                  ),
                  infoWindow: InfoWindow(title: 'Địa chỉ giao', snippet: address),
                  draggable: false,
                ),
              },
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
              mapType: isDark ? MapType.hybrid : MapType.normal,
            ),
          ),
        ],
      ),
    );
  }
}
