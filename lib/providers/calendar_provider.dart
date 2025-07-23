import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/prayer_times.dart';
import '../models/widget_config.dart';
import '../services/prayer_api_service.dart';

class CalendarProvider extends ChangeNotifier {
  final PrayerApiService _apiService = PrayerApiService();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, PrayerTimes> _prayerTimesCache = {};
  Map<DateTime, List<CalendarEvent>> _eventsCache = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  CalendarFormat get calendarFormat => _calendarFormat;
  Map<DateTime, PrayerTimes> get prayerTimesCache => _prayerTimesCache;
  Map<DateTime, List<CalendarEvent>> get eventsCache => _eventsCache;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get prayer times for selected day
  PrayerTimes? get selectedDayPrayerTimes => _prayerTimesCache[_selectedDay];

  /// Get events for selected day
  List<CalendarEvent> get selectedDayEvents => _eventsCache[_selectedDay] ?? [];

  /// Update focused day
  void updateFocusedDay(DateTime day) {
    if (!isSameDay(_focusedDay, day)) {
      _focusedDay = day;
      notifyListeners();
    }
  }

  /// Update selected day
  void updateSelectedDay(DateTime day) {
    if (!isSameDay(_selectedDay, day)) {
      _selectedDay = day;
      notifyListeners();
    }
  }

  /// Update calendar format
  void updateCalendarFormat(CalendarFormat format) {
    if (_calendarFormat != format) {
      _calendarFormat = format;
      notifyListeners();
    }
  }

  /// Load prayer times for a month
  Future<void> loadPrayerTimesForMonth({
    required double latitude,
    required double longitude,
    DateTime? month,
  }) async {
    final targetMonth = month ?? _focusedDay;
    final monthKey = DateTime(targetMonth.year, targetMonth.month);

    // Check if we already have data for this month
    final hasDataForMonth = _prayerTimesCache.keys.any((date) =>
        date.year == targetMonth.year && date.month == targetMonth.month);

    if (hasDataForMonth && !_shouldRefreshData(monthKey)) {
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      final monthlyPrayerTimes = await _apiService.getPrayerTimesForMonth(
        latitude: latitude,
        longitude: longitude,
        month: targetMonth,
      );

      // Update cache
      _prayerTimesCache.addAll(monthlyPrayerTimes);

      // Generate events from prayer times
      _generateEventsFromPrayerTimes(monthlyPrayerTimes);

    } catch (e) {
      _setError('Failed to load prayer times: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Generate calendar events from prayer times
  void _generateEventsFromPrayerTimes(Map<DateTime, PrayerTimes> prayerTimes) {
    for (final entry in prayerTimes.entries) {
      final date = entry.key;
      final prayers = entry.value;
      
      final events = <CalendarEvent>[];
      
      // Add prayer time events
      for (final prayer in prayers.allPrayers) {
        if (prayer.type != PrayerType.sunrise) { // Exclude sunrise as it's not a prayer
          events.add(CalendarEvent(
            date: date,
            title: prayer.name,
            description: '${prayer.name} at ${prayer.time}',
            type: EventType.prayer,
          ));
        }
      }
      
      _eventsCache[date] = events;
    }
  }

  /// Get events for a specific day
  List<CalendarEvent> getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _eventsCache[normalizedDay] ?? [];
  }

  /// Get prayer times for a specific day
  PrayerTimes? getPrayerTimesForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _prayerTimesCache[normalizedDay];
  }

  /// Check if a day has events
  bool hasEventsForDay(DateTime day) {
    return getEventsForDay(day).isNotEmpty;
  }

  /// Get next prayer for selected day
  PrayerTime? getNextPrayerForSelectedDay() {
    final prayerTimes = selectedDayPrayerTimes;
    if (prayerTimes == null) return null;

    // If selected day is today, get actual next prayer
    if (isSameDay(_selectedDay, DateTime.now())) {
      return prayerTimes.getNextPrayer();
    }

    // For other days, return first prayer (Fajr)
    return prayerTimes.allPrayers.first;
  }

  /// Get current prayer for selected day
  PrayerTime? getCurrentPrayerForSelectedDay() {
    final prayerTimes = selectedDayPrayerTimes;
    if (prayerTimes == null) return null;

    // If selected day is today, get actual current prayer
    if (isSameDay(_selectedDay, DateTime.now())) {
      return prayerTimes.getCurrentPrayer();
    }

    // For other days, return null
    return null;
  }

  /// Add custom event
  void addCustomEvent(CalendarEvent event) {
    final normalizedDate = DateTime(event.date.year, event.date.month, event.date.day);
    
    if (_eventsCache.containsKey(normalizedDate)) {
      _eventsCache[normalizedDate]!.add(event);
    } else {
      _eventsCache[normalizedDate] = [event];
    }
    
    notifyListeners();
  }

  /// Remove custom event
  void removeCustomEvent(CalendarEvent event) {
    final normalizedDate = DateTime(event.date.year, event.date.month, event.date.day);
    
    if (_eventsCache.containsKey(normalizedDate)) {
      _eventsCache[normalizedDate]!.remove(event);
      if (_eventsCache[normalizedDate]!.isEmpty) {
        _eventsCache.remove(normalizedDate);
      }
    }
    
    notifyListeners();
  }

  /// Clear cache
  void clearCache() {
    _prayerTimesCache.clear();
    _eventsCache.clear();
    notifyListeners();
  }

  /// Check if data should be refreshed (older than 1 day)
  bool _shouldRefreshData(DateTime monthKey) {
    // For simplicity, always refresh if it's a new session
    // In a real app, you might want to store timestamps
    return false;
  }

  /// Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get formatted date string
  String getFormattedDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Get formatted day name
  String getDayName(DateTime date) {
    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    
    return days[date.weekday - 1];
  }
}
