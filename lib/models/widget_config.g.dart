// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WidgetConfig _$WidgetConfigFromJson(Map<String, dynamic> json) => WidgetConfig(
  size:
      $enumDecodeNullable(_$WidgetSizeEnumMap, json['size']) ??
      WidgetSize.medium,
  showArabicNames: json['showArabicNames'] as bool? ?? true,
  showNextPrayerCountdown: json['showNextPrayerCountdown'] as bool? ?? true,
  showCalendar: json['showCalendar'] as bool? ?? false,
  theme: json['theme'] as String? ?? 'default',
  enableNotifications: json['enableNotifications'] as bool? ?? true,
);

Map<String, dynamic> _$WidgetConfigToJson(WidgetConfig instance) =>
    <String, dynamic>{
      'size': _$WidgetSizeEnumMap[instance.size]!,
      'showArabicNames': instance.showArabicNames,
      'showNextPrayerCountdown': instance.showNextPrayerCountdown,
      'showCalendar': instance.showCalendar,
      'theme': instance.theme,
      'enableNotifications': instance.enableNotifications,
    };

const _$WidgetSizeEnumMap = {
  WidgetSize.small: 'small',
  WidgetSize.medium: 'medium',
  WidgetSize.large: 'large',
};

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    CalendarEvent(
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'type': _$EventTypeEnumMap[instance.type]!,
    };

const _$EventTypeEnumMap = {
  EventType.prayer: 'prayer',
  EventType.islamic: 'islamic',
  EventType.reminder: 'reminder',
};
