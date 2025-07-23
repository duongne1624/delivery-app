import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../widgets/search_location_input.dart';

class MapLocationPicker extends StatefulWidget {
  final String? initialAddress;
  final double? initialLatitude;
  final double? initialLongitude;

  const MapLocationPicker({
    super.key,
    this.initialAddress,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _center;
  Marker? _marker;
  String? _selectedAddress;
  String? _placeId;
  double? _latitude;
  double? _longitude;
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    // Nếu có tọa độ cũ, sử dụng chúng
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      final initialLatLng = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      await _setMarkerAndCamera(
        initialLatLng,
        address: widget.initialAddress ?? 'Địa chỉ đã chọn',
      );
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    // Nếu không có tọa độ cũ, lấy vị trí hiện tại
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Dịch vụ định vị chưa được bật');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Quyền truy cập vị trí bị từ chối');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _setMarkerAndCamera(LatLng(position.latitude, position.longitude));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi lấy vị trí: $e')),
        );
        await _setMarkerAndCamera(const LatLng(10.762622, 106.660172));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _setMarkerAndCamera(LatLng latLng, {String? address}) async {
    String? newAddress = address;

    if (newAddress == null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latLng.latitude,
          latLng.longitude,
        );
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          newAddress = [
            placemark.street,
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea,
            placemark.country
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          if (newAddress.isEmpty) {
            newAddress = 'Không rõ địa chỉ';
          }
        } else {
          newAddress = 'Không rõ địa chỉ';
        }
      } catch (e) {
        newAddress = 'Không rõ địa chỉ';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi lấy địa chỉ: $e')),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _marker = Marker(
          markerId: const MarkerId('selected'),
          position: latLng,
          draggable: true,
          onDragEnd: (newPos) => _setMarkerAndCamera(newPos),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        _center = latLng;
        _latitude = latLng.latitude;
        _longitude = latLng.longitude;
        _selectedAddress = newAddress;
        _placeId = null; // Không có placeId từ geocoding
        _controller.text = newAddress ?? '';
      });
      await _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    }
  }

  void _handlePlaceSelected(String address, double lat, double lng) {
    _setMarkerAndCamera(LatLng(lat, lng), address: address);
  }

  void _confirmSelection() {
    if (_selectedAddress != null && _latitude != null && _longitude != null && _selectedAddress != 'Không rõ địa chỉ') {
      Navigator.pop(context, {
        'address': _selectedAddress,
        'latitude': _latitude,
        'longitude': _longitude,
        'placeId': _placeId,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một địa chỉ hợp lệ')),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn vị trí'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading || _center == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchLocationInput(
                    controller: _controller,
                    onSelected: _handlePlaceSelected,
                  ),
                ),
                if (_selectedAddress != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        const Icon(Icons.place, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedAddress!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: _center!, zoom: 15),
                    onMapCreated: (controller) => _mapController = controller,
                    markers: _marker != null ? {_marker!} : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onTap: _setMarkerAndCamera,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Xác nhận địa chỉ'),
                    onPressed: _confirmSelection,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
