import 'package:json_annotation/json_annotation.dart';

part 'prayer_times.g.dart';

@JsonSerializable()
class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimesToJson(this);

  /// Get all prayer times as a list of PrayerTime objects
  List<PrayerTime> get allPrayers => [
    PrayerTime(name: 'Fajr', time: fajr, type: PrayerType.fajr),
    PrayerTime(name: 'Sunrise', time: sunrise, type: PrayerType.sunrise),
    PrayerTime(name: 'Dhuhr', time: dhuhr, type: PrayerType.dhuhr),
    PrayerTime(name: 'Asr', time: asr, type: PrayerType.asr),
    PrayerTime(name: 'Maghrib', time: maghrib, type: PrayerType.maghrib),
    PrayerTime(name: 'Isha', time: isha, type: PrayerType.isha),
  ];

  /// Get the next prayer time
  PrayerTime? getNextPrayer() {
    final now = DateTime.now();
    final prayers = allPrayers;

    for (final prayer in prayers) {
      final prayerDateTime = _parseTimeToDateTime(prayer.time);
      if (prayerDateTime.isAfter(now)) {
        return prayer;
      }
    }

    // If no prayer is found for today, return Fajr of tomorrow
    return prayers.first;
  }

  /// Get the current prayer time
  PrayerTime? getCurrentPrayer() {
    final now = DateTime.now();
    final prayers = allPrayers;
    PrayerTime? currentPrayer;

    for (final prayer in prayers) {
      final prayerDateTime = _parseTimeToDateTime(prayer.time);
      if (prayerDateTime.isBefore(now) ||
          prayerDateTime.isAtSameMomentAs(now)) {
        currentPrayer = prayer;
      } else {
        break;
      }
    }

    return currentPrayer;
  }

  DateTime _parseTimeToDateTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

@JsonSerializable()
class PrayerTime {
  final String name;
  final String time;
  final PrayerType type;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.type,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimeFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimeToJson(this);

  /// Get time remaining until this prayer
  Duration getTimeRemaining() {
    final now = DateTime.now();
    final prayerDateTime = _parseTimeToDateTime(time);

    if (prayerDateTime.isBefore(now)) {
      // Prayer has passed, calculate time until tomorrow
      final tomorrow = prayerDateTime.add(const Duration(days: 1));
      return tomorrow.difference(now);
    }

    return prayerDateTime.difference(now);
  }

  DateTime _parseTimeToDateTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

extension PrayerTypeExtension on PrayerType {
  String get displayName {
    switch (this) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.sunrise:
        return 'Sunrise';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }

  String get arabicName {
    switch (this) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.sunrise:
        return 'الشروق';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
    }
  }
}
