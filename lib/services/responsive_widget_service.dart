import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../models/prayer_times.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';

class ResponsiveWidgetService {
  static const String _widgetName = 'PrayerTimesWidget';
  static const String _androidWidgetName = 'PrayerTimesWidgetProvider';
  static const String _iOSWidgetName = 'PrayerTimesWidget';

  /// Initialize the responsive home widget
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.example.calendar_prayer');
      // Skip callback registration if it causes issues
      // await _registerBackgroundCallback();
    } catch (e) {
      debugPrint('Error initializing responsive widget: $e');
    }
  }

  /// Update widget with current prayer times and responsive sizing
  static Future<void> updateWidget({
    required PrayerTimes prayerTimes,
    required WidgetConfigProvider configProvider,
    required PrayerTimesProvider prayerProvider,
    String location = 'Current Location',
  }) async {
    try {
      // Get current prayer info
      final currentPrayer = prayerProvider.currentPrayer;
      final nextPrayer = prayerProvider.nextPrayer;
      final timeToNext = prayerProvider.timeToNextPrayer;

      // Prepare data for all widget sizes
      final widgetData = {
        // Basic info
        'location': location,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        'theme': configProvider.config.theme,

        // Prayer times
        'fajr': prayerTimes.fajr,
        'sunrise': prayerTimes.sunrise,
        'dhuhr': prayerTimes.dhuhr,
        'asr': prayerTimes.asr,
        'maghrib': prayerTimes.maghrib,
        'isha': prayerTimes.isha,

        // Current status
        'currentPrayer': currentPrayer?.name ?? '',
        'currentPrayerTime': currentPrayer?.time ?? '',
        'nextPrayer': nextPrayer?.name ?? '',
        'nextPrayerTime': nextPrayer?.time ?? '',
        'timeToNext': _formatDuration(timeToNext),

        // Configuration
        'showArabicNames': configProvider.showArabicNames,

        'showCountdown': configProvider.showNextPrayerCountdown,

        // Arabic names
        'fajrArabic': 'الفجر',
        'sunriseArabic': 'الشروق',
        'dhuhrArabic': 'الظهر',
        'asrArabic': 'العصر',
        'maghribArabic': 'المغرب',
        'ishaArabic': 'العشاء',

        // Size-specific data
        'smallWidgetData': _getSmallWidgetData(
          prayerTimes,
          prayerProvider,
          configProvider,
        ),
        'mediumWidgetData': _getMediumWidgetData(
          prayerTimes,
          prayerProvider,
          configProvider,
        ),
        'largeWidgetData': _getLargeWidgetData(
          prayerTimes,
          prayerProvider,
          configProvider,
        ),
      };

      // Save data to shared preferences for widget access
      for (final entry in widgetData.entries) {
        await HomeWidget.saveWidgetData(entry.key, entry.value);
      }

      // Update the widget
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );

      debugPrint('Responsive widget updated successfully');
    } catch (e) {
      debugPrint('Error updating responsive widget: $e');
    }
  }

  /// Get data specific to small widget
  static Map<String, dynamic> _getSmallWidgetData(
    PrayerTimes prayerTimes,
    PrayerTimesProvider prayerProvider,
    WidgetConfigProvider configProvider,
  ) {
    return {
      'showNext': true,
      'showCurrent': true,
      'maxPrayers': 2,
      'compactMode': true,
    };
  }

  /// Get data specific to medium widget
  static Map<String, dynamic> _getMediumWidgetData(
    PrayerTimes prayerTimes,
    PrayerTimesProvider prayerProvider,
    WidgetConfigProvider configProvider,
  ) {
    final prayers = prayerTimes.allPrayers.take(4).toList();
    return {
      'showNext': true,
      'showCurrent': true,
      'maxPrayers': 4,
      'prayers': prayers
          .map(
            (p) => {
              'name': p.name,
              'time': p.time,
              'arabicName': p.type.arabicName,
              'isCurrent': prayerProvider.currentPrayer?.name == p.name,
              'isNext': prayerProvider.nextPrayer?.name == p.name,
            },
          )
          .toList(),
    };
  }

  /// Get data specific to large widget
  static Map<String, dynamic> _getLargeWidgetData(
    PrayerTimes prayerTimes,
    PrayerTimesProvider prayerProvider,
    WidgetConfigProvider configProvider,
  ) {
    final prayers = prayerTimes.allPrayers;
    return {
      'showAll': true,
      'showNext': true,
      'showCurrent': true,
      'maxPrayers': prayers.length,
      'prayers': prayers
          .map(
            (p) => {
              'name': p.name,
              'time': p.time,
              'arabicName': p.type.arabicName,
              'isCurrent': prayerProvider.currentPrayer?.name == p.name,
              'isNext': prayerProvider.nextPrayer?.name == p.name,
            },
          )
          .toList(),
    };
  }

  /// Format duration for display
  static String _formatDuration(Duration? duration) {
    if (duration == null) return '';

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Remove widget data
  static Future<void> clearWidgetData() async {
    try {
      // Clear all widget-related data
      final keys = [
        'location',
        'lastUpdated',
        'theme',
        'fajr',
        'sunrise',
        'dhuhr',
        'asr',
        'maghrib',
        'isha',
        'currentPrayer',
        'nextPrayer',
        'timeToNext',
        'showArabicNames',
        'showHijriDate',
        'showCountdown',
      ];

      for (final key in keys) {
        await HomeWidget.saveWidgetData(key, null);
      }

      debugPrint('Widget data cleared');
    } catch (e) {
      debugPrint('Error clearing widget data: $e');
    }
  }
}
