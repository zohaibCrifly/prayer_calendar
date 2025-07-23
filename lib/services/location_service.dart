import 'package:geolocator/geolocator.dart';
import '../models/location.dart';

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Get current location
  Future<Position> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException('Location services are disabled');
    }

    // Check and request permission
    LocationPermission permission = await checkLocationPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestLocationPermission();
      if (permission == LocationPermission.denied) {
        throw LocationServiceException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw LocationServiceException('Failed to get current location: $e');
    }
  }

  /// Get last known location
  Future<Position?> getLastKnownLocation() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two points
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Get location stream for real-time updates
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
  }

  /// Convert Position to LocationData
  LocationData positionToLocationData(
    Position position, {
    String city = 'Unknown',
    String country = 'Unknown',
    String timezone = 'UTC',
  }) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
      country: country,
      timezone: timezone,
    );
  }

  /// Predefined major cities for manual selection
  static const List<LocationData> majorCities = [
    LocationData(
      latitude: 21.3891,
      longitude: 39.8579,
      city: 'Mecca',
      country: 'Saudi Arabia',
      timezone: 'Asia/Riyadh',
    ),
    LocationData(
      latitude: 24.4539,
      longitude: 39.6040,
      city: 'Medina',
      country: 'Saudi Arabia',
      timezone: 'Asia/Riyadh',
    ),
    LocationData(
      latitude: 24.7136,
      longitude: 46.6753,
      city: 'Riyadh',
      country: 'Saudi Arabia',
      timezone: 'Asia/Riyadh',
    ),
    LocationData(
      latitude: 25.2048,
      longitude: 55.2708,
      city: 'Dubai',
      country: 'UAE',
      timezone: 'Asia/Dubai',
    ),
    LocationData(
      latitude: 30.0444,
      longitude: 31.2357,
      city: 'Cairo',
      country: 'Egypt',
      timezone: 'Africa/Cairo',
    ),
    LocationData(
      latitude: 33.8938,
      longitude: 35.5018,
      city: 'Beirut',
      country: 'Lebanon',
      timezone: 'Asia/Beirut',
    ),
    LocationData(
      latitude: 31.7683,
      longitude: 35.2137,
      city: 'Jerusalem',
      country: 'Palestine',
      timezone: 'Asia/Jerusalem',
    ),
    LocationData(
      latitude: 33.5138,
      longitude: 36.2765,
      city: 'Damascus',
      country: 'Syria',
      timezone: 'Asia/Damascus',
    ),
    LocationData(
      latitude: 33.3152,
      longitude: 44.3661,
      city: 'Baghdad',
      country: 'Iraq',
      timezone: 'Asia/Baghdad',
    ),
    LocationData(
      latitude: 29.3117,
      longitude: 47.4818,
      city: 'Kuwait City',
      country: 'Kuwait',
      timezone: 'Asia/Kuwait',
    ),
    LocationData(
      latitude: 25.3548,
      longitude: 51.1839,
      city: 'Doha',
      country: 'Qatar',
      timezone: 'Asia/Qatar',
    ),
    LocationData(
      latitude: 26.0667,
      longitude: 50.5577,
      city: 'Manama',
      country: 'Bahrain',
      timezone: 'Asia/Bahrain',
    ),
    LocationData(
      latitude: 23.6850,
      longitude: 58.5692,
      city: 'Muscat',
      country: 'Oman',
      timezone: 'Asia/Muscat',
    ),
    LocationData(
      latitude: 15.5527,
      longitude: 48.5164,
      city: 'Sana\'a',
      country: 'Yemen',
      timezone: 'Asia/Aden',
    ),
    LocationData(
      latitude: 36.8065,
      longitude: 10.1815,
      city: 'Tunis',
      country: 'Tunisia',
      timezone: 'Africa/Tunis',
    ),
    LocationData(
      latitude: 36.7538,
      longitude: 3.0588,
      city: 'Algiers',
      country: 'Algeria',
      timezone: 'Africa/Algiers',
    ),
    LocationData(
      latitude: 34.0209,
      longitude: -6.8416,
      city: 'Rabat',
      country: 'Morocco',
      timezone: 'Africa/Casablanca',
    ),
    LocationData(
      latitude: 32.6407,
      longitude: 13.1594,
      city: 'Tripoli',
      country: 'Libya',
      timezone: 'Africa/Tripoli',
    ),
    LocationData(
      latitude: 15.5007,
      longitude: 32.5599,
      city: 'Khartoum',
      country: 'Sudan',
      timezone: 'Africa/Khartoum',
    ),
    LocationData(
      latitude: 35.6892,
      longitude: 51.3890,
      city: 'Tehran',
      country: 'Iran',
      timezone: 'Asia/Tehran',
    ),
    LocationData(
      latitude: 41.0082,
      longitude: 28.9784,
      city: 'Istanbul',
      country: 'Turkey',
      timezone: 'Europe/Istanbul',
    ),
    LocationData(
      latitude: 31.5204,
      longitude: 74.3587,
      city: 'Lahore',
      country: 'Pakistan',
      timezone: 'Asia/Karachi',
    ),
    LocationData(
      latitude: 24.8607,
      longitude: 67.0011,
      city: 'Karachi',
      country: 'Pakistan',
      timezone: 'Asia/Karachi',
    ),
    LocationData(
      latitude: 28.7041,
      longitude: 77.1025,
      city: 'New Delhi',
      country: 'India',
      timezone: 'Asia/Kolkata',
    ),
    LocationData(
      latitude: 23.8103,
      longitude: 90.4125,
      city: 'Dhaka',
      country: 'Bangladesh',
      timezone: 'Asia/Dhaka',
    ),
    LocationData(
      latitude: 3.1390,
      longitude: 101.6869,
      city: 'Kuala Lumpur',
      country: 'Malaysia',
      timezone: 'Asia/Kuala_Lumpur',
    ),
    LocationData(
      latitude: -6.2088,
      longitude: 106.8456,
      city: 'Jakarta',
      country: 'Indonesia',
      timezone: 'Asia/Jakarta',
    ),
  ];
}

class LocationServiceException implements Exception {
  final String message;

  const LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}
