import 'package:json_annotation/json_annotation.dart';

part 'widget_config.g.dart';

enum WidgetSize { small, medium, large }

extension WidgetSizeExtension on WidgetSize {
  String get displayName {
    switch (this) {
      case WidgetSize.small:
        return 'Small';
      case WidgetSize.medium:
        return 'Medium';
      case WidgetSize.large:
        return 'Large';
    }
  }

  double get height {
    switch (this) {
      case WidgetSize.small:
        return 140.0;
      case WidgetSize.medium:
        return 200.0;
      case WidgetSize.large:
        return 520.0;
    }
  }

  double get width {
    switch (this) {
      case WidgetSize.small:
        return 200.0;
      case WidgetSize.medium:
        return 300.0;
      case WidgetSize.large:
        return 400.0;
    }
  }

  int get maxPrayersToShow {
    switch (this) {
      case WidgetSize.small:
        return 2; // Show next 2 prayers
      case WidgetSize.medium:
        return 4; // Show next 4 prayers
      case WidgetSize.large:
        return 6; // Show all prayers
    }
  }
}

@JsonSerializable()
class WidgetConfig {
  final WidgetSize size;
  final bool showArabicNames;
  final bool showHijriDate;
  final bool showNextPrayerCountdown;
  final bool showCalendar;
  final String theme;
  final bool enableNotifications;

  const WidgetConfig({
    this.size = WidgetSize.medium,
    this.showArabicNames = true,
    this.showHijriDate = true,
    this.showNextPrayerCountdown = true,
    this.showCalendar = false,
    this.theme = 'default',
    this.enableNotifications = true,
  });

  factory WidgetConfig.fromJson(Map<String, dynamic> json) =>
      _$WidgetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetConfigToJson(this);

  WidgetConfig copyWith({
    WidgetSize? size,
    bool? showArabicNames,
    bool? showHijriDate,
    bool? showNextPrayerCountdown,
    bool? showCalendar,
    String? theme,
    bool? enableNotifications,
  }) {
    return WidgetConfig(
      size: size ?? this.size,
      showArabicNames: showArabicNames ?? this.showArabicNames,
      showHijriDate: showHijriDate ?? this.showHijriDate,
      showNextPrayerCountdown:
          showNextPrayerCountdown ?? this.showNextPrayerCountdown,
      showCalendar: showCalendar ?? this.showCalendar,
      theme: theme ?? this.theme,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetConfig &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          showArabicNames == other.showArabicNames &&
          showHijriDate == other.showHijriDate &&
          showNextPrayerCountdown == other.showNextPrayerCountdown &&
          showCalendar == other.showCalendar &&
          theme == other.theme &&
          enableNotifications == other.enableNotifications;

  @override
  int get hashCode =>
      size.hashCode ^
      showArabicNames.hashCode ^
      showHijriDate.hashCode ^
      showNextPrayerCountdown.hashCode ^
      showCalendar.hashCode ^
      theme.hashCode ^
      enableNotifications.hashCode;
}

@JsonSerializable()
class CalendarEvent {
  final DateTime date;
  final String title;
  final String description;
  final EventType type;

  const CalendarEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.type,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}

enum EventType { prayer, islamic, reminder }

extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.prayer:
        return 'Prayer';
      case EventType.islamic:
        return 'Islamic Event';
      case EventType.reminder:
        return 'Reminder';
    }
  }
}
