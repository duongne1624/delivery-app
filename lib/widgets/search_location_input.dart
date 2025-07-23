import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class SearchLocationInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String address, double lat, double lng) onSelected;

  const SearchLocationInput({
    super.key,
    required this.controller,
    required this.onSelected,
  });

  @override
  State<SearchLocationInput> createState() => _SearchLocationInputState();
}

class _SearchLocationInputState extends State<SearchLocationInput> {
  List<Map<String, dynamic>> _predictions = [];
  Timer? _debounce;
  bool _isLoading = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _dio.options.headers['User-Agent'] = 'DeliveryOnlineApp/0.1.0 (your.email@example.com)';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
  }

  void _onChanged(String value) {
    print('Input value: $value'); // Log để kiểm tra giá trị nhập
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.isEmpty) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      setState(() => _isLoading = true);
      try {
        final response = await _dio.get(
          'https://nominatim.openstreetmap.org/search',
          queryParameters: {
            'q': value,
            'format': 'json',
            'countrycodes': 'vn',
            'limit': 5,
            'accept-language': 'vi',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> results = response.data;
          final predictions = results.map((r) => {
                'display_name': r['display_name'] ?? '',
                'lat': double.tryParse(r['lat'] ?? '0') ?? 0.0,
                'lon': double.tryParse(r['lon'] ?? '0') ?? 0.0,
              }).toList();

          if (mounted) {
            setState(() {
              _predictions = predictions;
              _isLoading = false;
            });
          }
        } else {
          throw Exception('Lỗi gọi API Nominatim: ${response.statusCode}');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _predictions = [];
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi lấy gợi ý địa chỉ: $e')),
          );
        }
      }
    });
  }

  void _onTapPrediction(Map<String, dynamic> prediction) {
    final address = prediction['display_name'] ?? 'Không rõ địa chỉ';
    final lat = prediction['lat'] ?? 0.0;
    final lng = prediction['lon'] ?? 0.0;

    widget.onSelected(address, lat, lng);
    widget.controller.text = address;
    setState(() {
      _predictions = [];
      _isLoading = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _clearInput() {
    widget.controller.clear();
    setState(() {
      _predictions = [];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: "Nhập địa chỉ...",
              prefixIcon: Icon(Icons.search, color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074), size: 26),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.redAccent, size: 22),
                      onPressed: _clearInput,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: isDark ? theme.colorScheme.primary.withOpacity(0.18) : Color(0xFFFFB074).withOpacity(0.18)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: isDark ? theme.colorScheme.primary.withOpacity(0.18) : Color(0xFFFFB074).withOpacity(0.18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074), width: 2.2),
              ),
              filled: true,
              fillColor: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              hintStyle: TextStyle(
                color: isDark ? theme.colorScheme.onSurface.withOpacity(0.7) : Colors.black38,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isDark ? theme.colorScheme.onSurface : Color(0xFF212121),
              fontFamily: 'Poppins',
            ),
          ),
        ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074),
              minHeight: 3.2,
            ),
          ),
        if (_predictions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: isDark ? Colors.black38 : Colors.black12, blurRadius: 8, spreadRadius: 2),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _onTapPrediction(prediction),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: isDark ? theme.colorScheme.primary : Color(0xFFFFB074), size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            prediction['display_name'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? theme.colorScheme.onSurface : Color(0xFF212121),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
