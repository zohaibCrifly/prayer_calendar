// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimes _$PrayerTimesFromJson(Map<String, dynamic> json) => PrayerTimes(
  fajr: json['fajr'] as String,
  sunrise: json['sunrise'] as String,
  dhuhr: json['dhuhr'] as String,
  asr: json['asr'] as String,
  maghrib: json['maghrib'] as String,
  isha: json['isha'] as String,
);

Map<String, dynamic> _$PrayerTimesToJson(PrayerTimes instance) =>
    <String, dynamic>{
      'fajr': instance.fajr,
      'sunrise': instance.sunrise,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
    };

PrayerTime _$PrayerTimeFromJson(Map<String, dynamic> json) => PrayerTime(
  name: json['name'] as String,
  time: json['time'] as String,
  type: $enumDecode(_$PrayerTypeEnumMap, json['type']),
);

Map<String, dynamic> _$PrayerTimeToJson(PrayerTime instance) =>
    <String, dynamic>{
      'name': instance.name,
      'time': instance.time,
      'type': _$PrayerTypeEnumMap[instance.type]!,
    };

const _$PrayerTypeEnumMap = {
  PrayerType.fajr: 'fajr',
  PrayerType.sunrise: 'sunrise',
  PrayerType.dhuhr: 'dhuhr',
  PrayerType.asr: 'asr',
  PrayerType.maghrib: 'maghrib',
  PrayerType.isha: 'isha',
};
