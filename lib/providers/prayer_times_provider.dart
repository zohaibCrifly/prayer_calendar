import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times.dart';
import '../models/location.dart';
import '../models/widget_config.dart';
import '../services/prayer_api_service.dart';
import '../services/location_service.dart';
import '../services/home_widget_service.dart';

class PrayerTimesProvider extends ChangeNotifier {
  final PrayerApiService _apiService = PrayerApiService();
  final LocationService _locationService = LocationService();

  PrayerTimes? _currentPrayerTimes;
  LocationData? _currentLocation;
  bool _isLoading = false;
  String? _error;
  DateTime _lastUpdated = DateTime.now();
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  Duration _timeToNextPrayer = Duration.zero;

  // Getters
  PrayerTimes? get currentPrayerTimes => _currentPrayerTimes;
  LocationData? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get lastUpdated => _lastUpdated;
  Duration get timeToNextPrayer => _timeToNextPrayer;

  PrayerTime? get nextPrayer => _currentPrayerTimes?.getNextPrayer();
  PrayerTime? get currentPrayer => _currentPrayerTimes?.getCurrentPrayer();

  PrayerTimesProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    await _loadSavedData();
    await _getCurrentLocationAndFetchPrayerTimes();
    _startPeriodicRefresh();
    _startCountdownTimer();
  }

  /// Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load saved location
      final savedLocationJson = prefs.getString('current_location');
      if (savedLocationJson != null) {
        _currentLocation = LocationData.fromJson(
          Map<String, dynamic>.from(Uri.splitQueryString(savedLocationJson)),
        );
      }

      // Load saved prayer times
      final savedPrayerTimesJson = prefs.getString('current_prayer_times');
      if (savedPrayerTimesJson != null) {
        _currentPrayerTimes = PrayerTimes.fromJson(
          Map<String, dynamic>.from(Uri.splitQueryString(savedPrayerTimesJson)),
        );
      }

      // Load last updated timestamp
      final lastUpdatedTimestamp = prefs.getInt('last_updated');
      if (lastUpdatedTimestamp != null) {
        _lastUpdated = DateTime.fromMillisecondsSinceEpoch(
          lastUpdatedTimestamp,
        );
      }
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

  /// Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_currentLocation != null) {
        await prefs.setString(
          'current_location',
          _currentLocation!.toJson().toString(),
        );
      }

      if (_currentPrayerTimes != null) {
        await prefs.setString(
          'current_prayer_times',
          _currentPrayerTimes!.toJson().toString(),
        );
      }

      await prefs.setInt('last_updated', _lastUpdated.millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  /// Get current location and fetch prayer times
  Future<void> _getCurrentLocationAndFetchPrayerTimes() async {
    try {
      _setLoading(true);
      _clearError();

      // Try to get current location
      final position = await _locationService.getCurrentLocation();

      // Get location info from API
      final locationData = await _apiService.getLocationInfo(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _currentLocation = locationData;

      // Fetch prayer times for current location
      await _fetchPrayerTimes();
    } catch (e) {
      _setError('Failed to get location: $e');

      // Try to use last known location if available
      if (_currentLocation != null) {
        await _fetchPrayerTimes();
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch prayer times for current location
  Future<void> _fetchPrayerTimes({DateTime? date}) async {
    if (_currentLocation == null) return;

    try {
      _setLoading(true);
      _clearError();

      final prayerTimes = await _apiService.getPrayerTimes(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        date: date,
      );

      _currentPrayerTimes = prayerTimes;
      _lastUpdated = DateTime.now();

      await _saveData();
      await _updateHomeWidget();
    } catch (e) {
      _setError('Failed to fetch prayer times: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh prayer times
  Future<void> refreshPrayerTimes() async {
    await _fetchPrayerTimes();
  }

  /// Manually update home widget
  Future<void> updateHomeWidget() async {
    await _updateHomeWidget();
  }

  /// Set location manually
  Future<void> setLocation(LocationData location) async {
    _currentLocation = location;
    await _fetchPrayerTimes();
    await _updateHomeWidget();
  }

  /// Update home widget with current prayer data
  Future<void> _updateHomeWidget() async {
    if (_currentPrayerTimes == null || _currentLocation == null) return;

    try {
      // Create a basic widget config
      final config = WidgetConfig(
        size: WidgetSize.medium,
        theme: 'default',
        showNextPrayerCountdown: true,
        showArabicNames: false,
      );

      await HomeWidgetService.updateWidget(
        prayerTimes: _currentPrayerTimes!,
        location: _currentLocation!,
        config: config,
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        timeToNextPrayer: _timeToNextPrayer,
      );

      debugPrint('Home widget updated with prayer data');
    } catch (e) {
      debugPrint('Error updating home widget: $e');
    }
  }

  /// Get prayer times for a specific date
  Future<PrayerTimes?> getPrayerTimesForDate(DateTime date) async {
    if (_currentLocation == null) return null;

    try {
      return await _apiService.getPrayerTimes(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        date: date,
      );
    } catch (e) {
      debugPrint('Error fetching prayer times for date $date: $e');
      return null;
    }
  }

  /// Start periodic refresh (every hour)
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(hours: 1),
      (_) => _fetchPrayerTimes(),
    );
  }

  /// Start countdown timer (updates every minute)
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateCountdown(),
    );
    _updateCountdown(); // Initial update
  }

  /// Update countdown to next prayer
  void _updateCountdown() {
    final nextPrayer = this.nextPrayer;
    if (nextPrayer != null) {
      _timeToNextPrayer = nextPrayer.getTimeRemaining();
      notifyListeners();

      // Update widget every 5 minutes to keep countdown fresh
      if (_timeToNextPrayer.inMinutes % 5 == 0) {
        _updateHomeWidget();
      }
    }
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

  /// Check if data needs refresh (older than 1 hour)
  bool get needsRefresh {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);
    return difference.inHours >= 1;
  }

  /// Format time remaining as string
  String formatTimeRemaining(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
