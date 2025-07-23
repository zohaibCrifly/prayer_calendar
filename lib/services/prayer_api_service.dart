import 'dart:convert';
import 'dart:io';
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
