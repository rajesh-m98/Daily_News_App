import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Location model
class LocationData {
  final String city;
  final String country;
  final String countryCode;
  final double lat;
  final double lon;

  LocationData({
    required this.city,
    required this.country,
    required this.countryCode,
    required this.lat,
    required this.lon,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      city: json['city'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? 'Unknown',
      countryCode: (json['countryCode'] as String? ?? 'in').toLowerCase(),
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Location Service using IP-based geolocation
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  LocationData? _cachedLocation;

  /// Get current location using IP API
  Future<LocationData> getCurrentLocation() async {
    // Return cached location if available
    if (_cachedLocation != null) {
      return _cachedLocation!;
    }

    try {
      final response = await http
          .get(Uri.parse(ApiConstants.ipApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cachedLocation = LocationData.fromJson(data);
        return _cachedLocation!;
      } else {
        // Return default location (India) if API fails
        return _getDefaultLocation();
      }
    } catch (e) {
      // Return default location on error
      return _getDefaultLocation();
    }
  }

  /// Get city name from cached location
  String? getCityName() {
    return _cachedLocation?.city;
  }

  /// Get country code from cached location
  String getCountryCode() {
    return _cachedLocation?.countryCode ?? 'in';
  }

  /// Clear cached location
  void clearCache() {
    _cachedLocation = null;
  }

  /// Get default location (India)
  LocationData _getDefaultLocation() {
    return LocationData(
      city: 'India',
      country: 'India',
      countryCode: 'in',
      lat: 20.5937,
      lon: 78.9629,
    );
  }
}
