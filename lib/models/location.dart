import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class LocationData {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String timezone;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.timezone,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);

  @override
  String toString() => '$city, $country';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationData &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

@JsonSerializable()
class PrayerApiResponse {
  final PrayerApiData data;
  final int code;
  final String status;

  const PrayerApiResponse({
    required this.data,
    required this.code,
    required this.status,
  });

  factory PrayerApiResponse.fromJson(Map<String, dynamic> json) =>
      _$PrayerApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerApiResponseToJson(this);
}

@JsonSerializable()
class PrayerApiData {
  final Map<String, String> timings;
  final PrayerDate date;
  final PrayerMeta meta;

  const PrayerApiData({
    required this.timings,
    required this.date,
    required this.meta,
  });

  factory PrayerApiData.fromJson(Map<String, dynamic> json) =>
      _$PrayerApiDataFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerApiDataToJson(this);
}

@JsonSerializable()
class PrayerDate {
  final String readable;
  final String timestamp;
  final PrayerHijri hijri;
  final PrayerGregorian gregorian;

  const PrayerDate({
    required this.readable,
    required this.timestamp,
    required this.hijri,
    required this.gregorian,
  });

  factory PrayerDate.fromJson(Map<String, dynamic> json) =>
      _$PrayerDateFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerDateToJson(this);
}

@JsonSerializable()
class PrayerHijri {
  final String date;
  final String format;
  final String day;
  final String weekday;
  final PrayerMonth month;
  final String year;
  final String designation;
  final List<String> holidays;

  const PrayerHijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
  });

  factory PrayerHijri.fromJson(Map<String, dynamic> json) =>
      _$PrayerHijriFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerHijriToJson(this);
}

@JsonSerializable()
class PrayerGregorian {
  final String date;
  final String format;
  final String day;
  final PrayerWeekday weekday;
  final PrayerMonth month;
  final String year;
  final String designation;

  const PrayerGregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });

  factory PrayerGregorian.fromJson(Map<String, dynamic> json) =>
      _$PrayerGregorianFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerGregorianToJson(this);
}

@JsonSerializable()
class PrayerMonth {
  final int number;
  final String en;
  final String ar;

  const PrayerMonth({required this.number, required this.en, required this.ar});

  factory PrayerMonth.fromJson(Map<String, dynamic> json) =>
      _$PrayerMonthFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerMonthToJson(this);
}

@JsonSerializable()
class PrayerWeekday {
  final String en;
  final String ar;

  const PrayerWeekday({required this.en, required this.ar});

  factory PrayerWeekday.fromJson(Map<String, dynamic> json) =>
      _$PrayerWeekdayFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerWeekdayToJson(this);
}

@JsonSerializable()
class PrayerMeta {
  final double latitude;
  final double longitude;
  final String timezone;
  final PrayerMethod method;
  final String latitudeAdjustmentMethod;
  final String midnightMode;
  final String school;
  final Map<String, int> offset;

  const PrayerMeta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.method,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.school,
    required this.offset,
  });

  factory PrayerMeta.fromJson(Map<String, dynamic> json) =>
      _$PrayerMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerMetaToJson(this);
}

@JsonSerializable()
class PrayerMethod {
  final int id;
  final String name;
  final Map<String, dynamic> params;
  final LocationData location;

  const PrayerMethod({
    required this.id,
    required this.name,
    required this.params,
    required this.location,
  });

  factory PrayerMethod.fromJson(Map<String, dynamic> json) =>
      _$PrayerMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerMethodToJson(this);
}
