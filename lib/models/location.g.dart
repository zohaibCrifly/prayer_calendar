// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  city: json['city'] as String,
  country: json['country'] as String,
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'country': instance.country,
      'timezone': instance.timezone,
    };

PrayerApiResponse _$PrayerApiResponseFromJson(Map<String, dynamic> json) =>
    PrayerApiResponse(
      data: PrayerApiData.fromJson(json['data'] as Map<String, dynamic>),
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$PrayerApiResponseToJson(PrayerApiResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'code': instance.code,
      'status': instance.status,
    };

PrayerApiData _$PrayerApiDataFromJson(Map<String, dynamic> json) =>
    PrayerApiData(
      timings: Map<String, String>.from(json['timings'] as Map),
      date: PrayerDate.fromJson(json['date'] as Map<String, dynamic>),
      meta: PrayerMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrayerApiDataToJson(PrayerApiData instance) =>
    <String, dynamic>{
      'timings': instance.timings,
      'date': instance.date,
      'meta': instance.meta,
    };

PrayerDate _$PrayerDateFromJson(Map<String, dynamic> json) => PrayerDate(
  readable: json['readable'] as String,
  timestamp: json['timestamp'] as String,
  hijri: PrayerHijri.fromJson(json['hijri'] as Map<String, dynamic>),
  gregorian: PrayerGregorian.fromJson(
    json['gregorian'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PrayerDateToJson(PrayerDate instance) =>
    <String, dynamic>{
      'readable': instance.readable,
      'timestamp': instance.timestamp,
      'hijri': instance.hijri,
      'gregorian': instance.gregorian,
    };

PrayerHijri _$PrayerHijriFromJson(Map<String, dynamic> json) => PrayerHijri(
  date: json['date'] as String,
  format: json['format'] as String,
  day: json['day'] as String,
  weekday: json['weekday'] as String,
  month: PrayerMonth.fromJson(json['month'] as Map<String, dynamic>),
  year: json['year'] as String,
  designation: json['designation'] as String,
  holidays: (json['holidays'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PrayerHijriToJson(PrayerHijri instance) =>
    <String, dynamic>{
      'date': instance.date,
      'format': instance.format,
      'day': instance.day,
      'weekday': instance.weekday,
      'month': instance.month,
      'year': instance.year,
      'designation': instance.designation,
      'holidays': instance.holidays,
    };

PrayerGregorian _$PrayerGregorianFromJson(Map<String, dynamic> json) =>
    PrayerGregorian(
      date: json['date'] as String,
      format: json['format'] as String,
      day: json['day'] as String,
      weekday: PrayerWeekday.fromJson(json['weekday'] as Map<String, dynamic>),
      month: PrayerMonth.fromJson(json['month'] as Map<String, dynamic>),
      year: json['year'] as String,
      designation: json['designation'] as String,
    );

Map<String, dynamic> _$PrayerGregorianToJson(PrayerGregorian instance) =>
    <String, dynamic>{
      'date': instance.date,
      'format': instance.format,
      'day': instance.day,
      'weekday': instance.weekday,
      'month': instance.month,
      'year': instance.year,
      'designation': instance.designation,
    };

PrayerMonth _$PrayerMonthFromJson(Map<String, dynamic> json) => PrayerMonth(
  number: (json['number'] as num).toInt(),
  en: json['en'] as String,
  ar: json['ar'] as String,
);

Map<String, dynamic> _$PrayerMonthToJson(PrayerMonth instance) =>
    <String, dynamic>{
      'number': instance.number,
      'en': instance.en,
      'ar': instance.ar,
    };

PrayerWeekday _$PrayerWeekdayFromJson(Map<String, dynamic> json) =>
    PrayerWeekday(en: json['en'] as String, ar: json['ar'] as String);

Map<String, dynamic> _$PrayerWeekdayToJson(PrayerWeekday instance) =>
    <String, dynamic>{'en': instance.en, 'ar': instance.ar};

PrayerMeta _$PrayerMetaFromJson(Map<String, dynamic> json) => PrayerMeta(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  timezone: json['timezone'] as String,
  method: PrayerMethod.fromJson(json['method'] as Map<String, dynamic>),
  latitudeAdjustmentMethod: json['latitudeAdjustmentMethod'] as String,
  midnightMode: json['midnightMode'] as String,
  school: json['school'] as String,
  offset: Map<String, int>.from(json['offset'] as Map),
);

Map<String, dynamic> _$PrayerMetaToJson(PrayerMeta instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
      'method': instance.method,
      'latitudeAdjustmentMethod': instance.latitudeAdjustmentMethod,
      'midnightMode': instance.midnightMode,
      'school': instance.school,
      'offset': instance.offset,
    };

PrayerMethod _$PrayerMethodFromJson(Map<String, dynamic> json) => PrayerMethod(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  params: json['params'] as Map<String, dynamic>,
  location: LocationData.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PrayerMethodToJson(PrayerMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'params': instance.params,
      'location': instance.location,
    };
