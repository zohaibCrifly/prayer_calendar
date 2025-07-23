import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import '../models/prayer_times.dart';
import '../models/location.dart';
import '../models/widget_config.dart';

class HomeWidgetService {
  static const String _androidWidgetName = 'PrayerTimesWidgetProvider';
  static const String _iOSWidgetName = 'PrayerTimesWidget';

  /// Initialize home widget
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.example.calendar_prayer');
    } catch (e) {
      debugPrint('Error initializing home widget: $e');
    }
  }

  /// Update home widget with prayer times data
  static Future<void> updateWidget({
    required PrayerTimes prayerTimes,
    required LocationData location,
    required WidgetConfig config,
    PrayerTime? nextPrayer,
    PrayerTime? currentPrayer,
    Duration? timeToNextPrayer,
  }) async {
    try {
      // Prepare data for widget
      final widgetData = _prepareWidgetData(
        prayerTimes: prayerTimes,
        location: location,
        config: config,
        nextPrayer: nextPrayer,
        currentPrayer: currentPrayer,
        timeToNextPrayer: timeToNextPrayer,
      );

      // Save data to shared storage
      for (final entry in widgetData.entries) {
        await HomeWidget.saveWidgetData(entry.key, entry.value);
      }

      // Update widget
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );

      debugPrint('Home widget updated successfully');
    } catch (e) {
      debugPrint('Error updating home widget: $e');
    }
  }

  /// Prepare widget data
  static Map<String, dynamic> _prepareWidgetData({
    required PrayerTimes prayerTimes,
    required LocationData location,
    required WidgetConfig config,
    PrayerTime? nextPrayer,
    PrayerTime? currentPrayer,
    Duration? timeToNextPrayer,
  }) {
    final now = DateTime.now();

    return {
      // Basic info (keys match Android widget expectations)
      'location': '${location.city}, ${location.country}',
      'lastUpdated': now.millisecondsSinceEpoch.toString(),
      'theme': config.theme,

      // Prayer times (keys match Android widget expectations)
      'fajr': prayerTimes.fajr,
      'sunrise': prayerTimes.sunrise,
      'dhuhr': prayerTimes.dhuhr,
      'asr': prayerTimes.asr,
      'maghrib': prayerTimes.maghrib,
      'isha': prayerTimes.isha,

      // Current prayer info (keys match Android widget expectations)
      'currentPrayer': currentPrayer?.name ?? 'Fajr',
      'currentPrayerTime': currentPrayer?.time ?? prayerTimes.fajr,

      // Next prayer info (keys match Android widget expectations)
      'nextPrayer': nextPrayer?.name ?? 'Dhuhr',
      'nextPrayerTime': nextPrayer?.time ?? prayerTimes.dhuhr,
      'timeToNext': timeToNextPrayer != null
          ? _formatDuration(timeToNextPrayer)
          : '2h 30m',

      // Widget configuration
      'showArabicNames': config.showArabicNames.toString(),
      'showHijriDate': config.showHijriDate.toString(),
      'showCountdown': config.showNextPrayerCountdown.toString(),
    };
  }

  /// Format duration for display
  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Format date for display
  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Get Hijri date (placeholder)
  static String _getHijriDate() {
    // This is a placeholder. In a real app, you would calculate the Hijri date
    return '12 Ramadan 1445';
  }

  /// Register widget update callback
  static Future<void> registerBackgroundCallback() async {
    try {
      await HomeWidget.registerBackgroundCallback(_backgroundCallback);
    } catch (e) {
      debugPrint('Error registering background callback: $e');
    }
  }

  /// Background callback for widget updates
  static Future<void> _backgroundCallback(Uri? uri) async {
    try {
      // This callback is triggered when the widget needs to be updated
      // You can implement logic here to fetch fresh prayer times
      debugPrint('Background callback triggered: $uri');

      // For now, we'll just log the callback
      // In a real implementation, you might want to:
      // 1. Fetch current location
      // 2. Get fresh prayer times
      // 3. Update the widget
    } catch (e) {
      debugPrint('Error in background callback: $e');
    }
  }

  /// Check if home widget is available
  static Future<bool> isAvailable() async {
    try {
      // This is a simple check - in a real app you might want more sophisticated detection
      return true;
    } catch (e) {
      debugPrint('Error checking home widget availability: $e');
      return false;
    }
  }

  /// Get widget data for debugging
  static Future<Map<String, dynamic>> getWidgetData() async {
    try {
      final keys = [
        'location',
        'last_updated',
        'widget_size',
        'theme',
        'fajr_time',
        'dhuhr_time',
        'asr_time',
        'maghrib_time',
        'isha_time',
        'next_prayer_name',
        'next_prayer_time',
        'time_to_next_prayer',
      ];

      final data = <String, dynamic>{};
      for (final key in keys) {
        final value = await HomeWidget.getWidgetData(key);
        if (value != null) {
          data[key] = value;
        }
      }

      return data;
    } catch (e) {
      debugPrint('Error getting widget data: $e');
      return {};
    }
  }

  /// Clear widget data
  static Future<void> clearWidgetData() async {
    try {
      // Clear all widget-related data
      final keys = [
        'location',
        'last_updated',
        'widget_size',
        'theme',
        'show_arabic_names',
        'show_hijri_date',
        'show_countdown',
        'fajr_time',
        'sunrise_time',
        'dhuhr_time',
        'asr_time',
        'maghrib_time',
        'isha_time',
        'fajr_arabic',
        'sunrise_arabic',
        'dhuhr_arabic',
        'asr_arabic',
        'maghrib_arabic',
        'isha_arabic',
        'current_prayer_name',
        'current_prayer_arabic',
        'current_prayer_time',
        'next_prayer_name',
        'next_prayer_arabic',
        'next_prayer_time',
        'time_to_next_prayer',
        'current_date',
        'hijri_date',
        'max_prayers_to_show',
        'widget_width',
        'widget_height',
      ];

      for (final key in keys) {
        await HomeWidget.saveWidgetData(key, null);
      }

      debugPrint('Widget data cleared');
    } catch (e) {
      debugPrint('Error clearing widget data: $e');
    }
  }

  /// Handle widget tap actions
  static Future<void> handleWidgetTap(String action) async {
    try {
      debugPrint('Widget tap action: $action');

      switch (action) {
        case 'open_app':
          // App will be opened automatically
          break;
        case 'refresh':
          // Trigger a refresh of prayer times
          // This would typically be handled by the main app
          break;
        case 'next_prayer':
          // Show next prayer details
          break;
        case 'settings':
          // Open widget settings
          break;
        default:
          debugPrint('Unknown widget action: $action');
      }
    } catch (e) {
      debugPrint('Error handling widget tap: $e');
    }
  }
}
