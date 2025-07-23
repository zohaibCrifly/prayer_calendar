import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/widget_config.dart';

class WidgetConfigProvider extends ChangeNotifier {
  WidgetConfig _config = const WidgetConfig();
  bool _isLoading = false;

  // Getters
  WidgetConfig get config => _config;
  bool get isLoading => _isLoading;

  WidgetSize get currentSize => _config.size;
  bool get showArabicNames => _config.showArabicNames;

  bool get showNextPrayerCountdown => _config.showNextPrayerCountdown;
  bool get showCalendar => _config.showCalendar;
  String get theme => _config.theme;
  bool get enableNotifications => _config.enableNotifications;

  WidgetConfigProvider() {
    _loadConfig();
  }

  /// Load configuration from SharedPreferences
  Future<void> _loadConfig() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString('widget_config');

      if (configJson != null) {
        final configMap = json.decode(configJson) as Map<String, dynamic>;
        _config = WidgetConfig.fromJson(configMap);
      }
    } catch (e) {
      debugPrint('Error loading widget config: $e');
      // Use default config if loading fails
      _config = const WidgetConfig();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save configuration to SharedPreferences
  Future<void> _saveConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(_config.toJson());
      await prefs.setString('widget_config', configJson);
    } catch (e) {
      debugPrint('Error saving widget config: $e');
    }
  }

  /// Update widget size
  Future<void> updateSize(WidgetSize size) async {
    if (_config.size != size) {
      _config = _config.copyWith(size: size);
      await _saveConfig();
      notifyListeners();
    }
  }

  /// Toggle Arabic names display
  Future<void> toggleArabicNames() async {
    _config = _config.copyWith(showArabicNames: !_config.showArabicNames);
    await _saveConfig();
    notifyListeners();
  }

  /// Toggle next prayer countdown
  Future<void> toggleNextPrayerCountdown() async {
    _config = _config.copyWith(
      showNextPrayerCountdown: !_config.showNextPrayerCountdown,
    );
    await _saveConfig();
    notifyListeners();
  }

  /// Toggle calendar display
  Future<void> toggleCalendar() async {
    _config = _config.copyWith(showCalendar: !_config.showCalendar);
    await _saveConfig();
    notifyListeners();
  }

  /// Update theme
  Future<void> updateTheme(String theme) async {
    if (_config.theme != theme) {
      _config = _config.copyWith(theme: theme);
      await _saveConfig();
      notifyListeners();
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    _config = _config.copyWith(
      enableNotifications: !_config.enableNotifications,
    );
    await _saveConfig();
    notifyListeners();
  }

  /// Update entire configuration
  Future<void> updateConfig(WidgetConfig newConfig) async {
    if (_config != newConfig) {
      _config = newConfig;
      await _saveConfig();
      notifyListeners();
    }
  }

  /// Reset to default configuration
  Future<void> resetToDefault() async {
    _config = const WidgetConfig();
    await _saveConfig();
    notifyListeners();
  }

  /// Get available themes
  List<String> get availableThemes => [
    'default',
    'dark',
    'light',
    'islamic_green',
    'golden',
    'blue',
  ];

  /// Get theme display name
  String getThemeDisplayName(String theme) {
    switch (theme) {
      case 'default':
        return 'Default';
      case 'dark':
        return 'Dark';
      case 'light':
        return 'Light';
      case 'islamic_green':
        return 'Islamic Green';
      case 'golden':
        return 'Golden';
      case 'blue':
        return 'Blue';
      default:
        return 'Unknown';
    }
  }

  /// Get maximum prayers to show based on current size
  int get maxPrayersToShow => _config.size.maxPrayersToShow;

  /// Get widget dimensions based on current size
  double get widgetHeight => _config.size.height;
  double get widgetWidth => _config.size.width;

  /// Check if widget should show expanded view
  bool get isExpandedView => _config.size == WidgetSize.large;

  /// Check if widget should show compact view
  bool get isCompactView => _config.size == WidgetSize.small;

  /// Get configuration summary for debugging
  Map<String, dynamic> get configSummary => {
    'size': _config.size.displayName,
    'showArabicNames': _config.showArabicNames,

    'showNextPrayerCountdown': _config.showNextPrayerCountdown,
    'showCalendar': _config.showCalendar,
    'theme': _config.theme,
    'enableNotifications': _config.enableNotifications,
    'maxPrayersToShow': maxPrayersToShow,
    'dimensions': '${widgetWidth}x${widgetHeight}',
  };
}
