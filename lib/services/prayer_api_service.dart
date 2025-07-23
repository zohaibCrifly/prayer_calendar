import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';
import '../models/location.dart';

class PrayerApiService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';
  static const Duration _timeout = Duration(seconds: 30);

  /// Fetch prayer times for a specific location and date
  Future<PrayerTimes> getPrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
    int method = 1, // Islamic Society of North America (ISNA)
  }) async {
    try {
      final targetDate = date ?? DateTime.now();
      final formattedDate =
          '${targetDate.day.toString().padLeft(2, '0')}-'
          '${targetDate.month.toString().padLeft(2, '0')}-'
          '${targetDate.year}';

      final uri = Uri.parse(
        '$_baseUrl/timings/$formattedDate'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&method=$method'
        '&format=json',
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle the response more safely without using the complex model
        if (jsonData['code'] == 200 && jsonData['data'] != null) {
          final data = jsonData['data'];
          final timings = data['timings'];

          // Convert dynamic map to Map<String, String>
          final Map<String, String> stringTimings = {};
          timings.forEach((key, value) {
            stringTimings[key] = value.toString();
          });

          return _convertApiTimingsToPrayerTimes(stringTimings);
        } else {
          throw PrayerApiException(
            'API returned error: ${jsonData['status'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw PrayerApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw PrayerApiException('No internet connection');
    } on http.ClientException {
      throw PrayerApiException('Network error occurred');
    } on FormatException {
      throw PrayerApiException('Invalid response format');
    } catch (e) {
      if (e is PrayerApiException) rethrow;
      throw PrayerApiException('Unexpected error: $e');
    }
  }

  /// Fetch prayer times for multiple days
  Future<Map<DateTime, PrayerTimes>> getPrayerTimesForMonth({
    required double latitude,
    required double longitude,
    DateTime? month,
    int method = 2,
  }) async {
    final targetMonth = month ?? DateTime.now();
    // final firstDay = ;(targetMonth.year, targetMonth.month, 1);
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    final Map<DateTime, PrayerTimes> monthlyTimes = {};

    // Fetch prayer times for each day of the month
    for (int day = 1; day <= lastDay.day; day++) {
      final currentDate = DateTime(targetMonth.year, targetMonth.month, day);
      try {
        final prayerTimes = await getPrayerTimes(
          latitude: latitude,
          longitude: longitude,
          date: currentDate,
          method: method,
        );
        monthlyTimes[currentDate] = prayerTimes;

        // Add small delay to avoid overwhelming the API
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        // Log error but continue with other days
        // print('Failed to fetch prayer times for $currentDate: $e');
      }
    }

    return monthlyTimes;
  }

  /// Get location information from coordinates
  Future<LocationData> getLocationInfo({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // First try to get location info from reverse geocoding API
      final locationData = await _getLocationFromReverseGeocoding(
        latitude,
        longitude,
      );
      if (locationData != null) {
        return locationData;
      }

      // Fallback to prayer API
      final uri = Uri.parse(
        '$_baseUrl/timings/now'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&method=1',
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Handle the response more safely
        if (jsonData['code'] == 200 && jsonData['data'] != null) {
          final data = jsonData['data'];
          final meta = data['meta'];

          // Extract location info safely
          String city = 'Unknown City';
          String country = 'Unknown Country';

          // Try to get location from different possible fields
          if (meta['method'] != null && meta['method']['location'] != null) {
            final location = meta['method']['location'];
            city = location['city'] ?? city;
            country = location['country'] ?? country;
          }

          return LocationData(
            latitude: (meta['latitude'] as num).toDouble(),
            longitude: (meta['longitude'] as num).toDouble(),
            city: city,
            country: country,
            timezone: meta['timezone'] ?? 'UTC',
          );
        } else {
          throw PrayerApiException(
            'API returned error: ${jsonData['status'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw PrayerApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is PrayerApiException) rethrow;
      throw PrayerApiException('Failed to get location info: $e');
    }
  }

  /// Get location from reverse geocoding API
  Future<LocationData?> _getLocationFromReverseGeocoding(
    double latitude,
    double longitude,
  ) async {
    // Try OpenStreetMap Nominatim first
    final nominatimResult = await _tryNominatimGeocoding(latitude, longitude);
    if (nominatimResult != null) {
      return nominatimResult;
    }

    // If Nominatim fails or doesn't provide good city data, try alternative
    return await _tryAlternativeGeocoding(latitude, longitude);
  }

  /// Try OpenStreetMap Nominatim API for reverse geocoding
  Future<LocationData?> _tryNominatimGeocoding(
    double latitude,
    double longitude,
  ) async {
    try {
      // Using OpenStreetMap Nominatim API for reverse geocoding (free)
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json'
        '&lat=$latitude'
        '&lon=$longitude'
        '&zoom=10'
        '&addressdetails=1',
      );

      final response = await http
          .get(uri, headers: {'User-Agent': 'PrayerTimesApp/1.0'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Debug logging
        debugPrint('Reverse geocoding response: ${jsonData.toString()}');

        if (jsonData['address'] != null) {
          final address = jsonData['address'];
          debugPrint('Address data: ${address.toString()}');

          // Extract city and country from address - try multiple fields
          String city =
              address['city'] ??
              address['town'] ??
              address['village'] ??
              address['municipality'] ??
              address['county'] ??
              address['state_district'] ??
              address['suburb'] ??
              address['neighbourhood'] ??
              address['hamlet'] ??
              'Unknown City';

          // If still no city found, try to extract from display_name
          if (city == 'Unknown City' && jsonData['display_name'] != null) {
            final displayName = jsonData['display_name'] as String;
            final parts = displayName.split(',');
            if (parts.isNotEmpty) {
              city = parts[0].trim();
            }
          }

          String country = address['country'] ?? 'Unknown Country';

          // Debug logging
          debugPrint('Extracted city: $city, country: $country');

          // Get timezone (approximate based on coordinates)
          String timezone = _getTimezoneFromCoordinates(latitude, longitude);

          return LocationData(
            latitude: latitude,
            longitude: longitude,
            city: city,
            country: country,
            timezone: timezone,
          );
        }
      }
    } catch (e) {
      // If reverse geocoding fails, return null to fallback to prayer API
      debugPrint('Reverse geocoding failed: $e');
    }

    return null;
  }

  /// Try alternative geocoding service
  Future<LocationData?> _tryAlternativeGeocoding(
    double latitude,
    double longitude,
  ) async {
    try {
      // Using a simple coordinate-based city lookup
      // This is a fallback when reverse geocoding fails

      // For now, let's create a basic location with coordinates
      // In a production app, you might want to use a paid geocoding service

      String city = 'City';
      String country = 'Country';

      // Try to determine approximate location based on coordinates
      if (latitude >= 21.0 &&
          latitude <= 32.0 &&
          longitude >= 34.0 &&
          longitude <= 56.0) {
        country = 'Saudi Arabia';
        if (latitude >= 24.0 &&
            latitude <= 25.0 &&
            longitude >= 46.0 &&
            longitude <= 47.0) {
          city = 'Riyadh';
        } else if (latitude >= 21.0 &&
            latitude <= 22.0 &&
            longitude >= 39.0 &&
            longitude <= 40.0) {
          city = 'Jeddah';
        } else if (latitude >= 26.0 &&
            latitude <= 27.0 &&
            longitude >= 49.0 &&
            longitude <= 51.0) {
          city = 'Dammam';
        }
      } else if (latitude >= 25.0 &&
          latitude <= 26.0 &&
          longitude >= 55.0 &&
          longitude <= 56.0) {
        city = 'Dubai';
        country = 'UAE';
      } else if (latitude >= 24.0 &&
          latitude <= 25.0 &&
          longitude >= 54.0 &&
          longitude <= 55.0) {
        city = 'Abu Dhabi';
        country = 'UAE';
      }

      debugPrint('Using fallback location: $city, $country');

      return LocationData(
        latitude: latitude,
        longitude: longitude,
        city: city,
        country: country,
        timezone: _getTimezoneFromCoordinates(latitude, longitude),
      );
    } catch (e) {
      debugPrint('Alternative geocoding failed: $e');
      return null;
    }
  }

  /// Get approximate timezone from coordinates
  String _getTimezoneFromCoordinates(double latitude, double longitude) {
    // This is a simplified timezone detection
    // In a production app, you might want to use a proper timezone API

    // Rough timezone estimation based on longitude
    final offsetHours = (longitude / 15).round();

    if (offsetHours >= 0) {
      return 'UTC+$offsetHours';
    } else {
      return 'UTC$offsetHours';
    }
  }

  /// Convert API timings to PrayerTimes model
  PrayerTimes _convertApiTimingsToPrayerTimes(Map<String, String> timings) {
    return PrayerTimes(
      fajr: _cleanTime(timings['Fajr'] ?? ''),
      sunrise: _cleanTime(timings['Sunrise'] ?? ''),
      dhuhr: _cleanTime(timings['Dhuhr'] ?? ''),
      asr: _cleanTime(timings['Asr'] ?? ''),
      maghrib: _cleanTime(timings['Maghrib'] ?? ''),
      isha: _cleanTime(timings['Isha'] ?? ''),
    );
  }

  /// Clean time string by removing timezone info
  String _cleanTime(String time) {
    // Remove timezone info like " (UTC+05:00)"
    final cleanTime = time.split(' ').first;
    return cleanTime;
  }

  /// Get available calculation methods
  Future<List<CalculationMethod>> getCalculationMethods() async {
    try {
      final uri = Uri.parse('$_baseUrl/methods');
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final methods = <CalculationMethod>[];

        if (jsonData['data'] != null) {
          for (final entry in jsonData['data'].entries) {
            methods.add(
              CalculationMethod(
                id: int.parse(entry.key),
                name: entry.value['name'] ?? '',
                description: entry.value['description'] ?? '',
              ),
            );
          }
        }

        return methods;
      } else {
        throw PrayerApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is PrayerApiException) rethrow;
      throw PrayerApiException('Failed to get calculation methods: $e');
    }
  }
}

class CalculationMethod {
  final int id;
  final String name;
  final String description;

  const CalculationMethod({
    required this.id,
    required this.name,
    required this.description,
  });
}

class PrayerApiException implements Exception {
  final String message;

  const PrayerApiException(this.message);

  @override
  String toString() => 'PrayerApiException: $message';
}
