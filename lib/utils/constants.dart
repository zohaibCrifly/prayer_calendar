import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Prayer Times Widget';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Dynamic prayer times widget with calendar integration';
  
  // API Configuration
  static const String apiBaseUrl = 'http://api.aladhan.com/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int defaultCalculationMethod = 2; // ISNA
  
  // Widget Configuration
  static const double smallWidgetWidth = 200.0;
  static const double smallWidgetHeight = 120.0;
  static const double mediumWidgetWidth = 300.0;
  static const double mediumWidgetHeight = 200.0;
  static const double largeWidgetWidth = 400.0;
  static const double largeWidgetHeight = 300.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 600);
  static const Duration longAnimation = Duration(milliseconds: 1000);
  
  // Refresh Intervals
  static const Duration prayerTimesRefreshInterval = Duration(hours: 1);
  static const Duration countdownUpdateInterval = Duration(minutes: 1);
  static const Duration locationUpdateInterval = Duration(hours: 6);
  
  // Storage Keys
  static const String currentLocationKey = 'current_location';
  static const String currentPrayerTimesKey = 'current_prayer_times';
  static const String widgetConfigKey = 'widget_config';
  static const String lastUpdatedKey = 'last_updated';
  
  // Theme Colors
  static const Color primaryColor = Color(0xFF667eea);
  static const Color secondaryColor = Color(0xFF764ba2);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color successColor = Color(0xFF4ECDC4);
  static const Color warningColor = Color(0xFFFFE66D);
  static const Color errorColor = Color(0xFFFF6B6B);
  
  // Prayer Names in Different Languages
  static const Map<String, Map<String, String>> prayerNames = {
    'en': {
      'fajr': 'Fajr',
      'sunrise': 'Sunrise',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
    },
    'ar': {
      'fajr': 'الفجر',
      'sunrise': 'الشروق',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    },
  };
  
  // Default Locations (Major Islamic Cities)
  static const List<Map<String, dynamic>> defaultLocations = [
    {
      'city': 'Mecca',
      'country': 'Saudi Arabia',
      'latitude': 21.3891,
      'longitude': 39.8579,
      'timezone': 'Asia/Riyadh',
    },
    {
      'city': 'Medina',
      'country': 'Saudi Arabia',
      'latitude': 24.4539,
      'longitude': 39.6040,
      'timezone': 'Asia/Riyadh',
    },
    {
      'city': 'Jerusalem',
      'country': 'Palestine',
      'latitude': 31.7683,
      'longitude': 35.2137,
      'timezone': 'Asia/Jerusalem',
    },
    {
      'city': 'Istanbul',
      'country': 'Turkey',
      'latitude': 41.0082,
      'longitude': 28.9784,
      'timezone': 'Europe/Istanbul',
    },
    {
      'city': 'Cairo',
      'country': 'Egypt',
      'latitude': 30.0444,
      'longitude': 31.2357,
      'timezone': 'Africa/Cairo',
    },
  ];
  
  // Error Messages
  static const String noInternetError = 'No internet connection available';
  static const String locationPermissionError = 'Location permission denied';
  static const String locationServiceError = 'Location services are disabled';
  static const String apiError = 'Failed to fetch prayer times';
  static const String unknownError = 'An unknown error occurred';
  
  // Success Messages
  static const String locationUpdatedSuccess = 'Location updated successfully';
  static const String prayerTimesUpdatedSuccess = 'Prayer times updated';
  static const String settingsSavedSuccess = 'Settings saved successfully';
  
  // Widget Themes
  static const Map<String, LinearGradient> widgetThemes = {
    'default': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    'dark': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
    ),
    'light': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFECF0F1), Color(0xFFBDC3C7)],
    ),
    'islamic_green': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
    ),
    'golden': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD4AF37), Color(0xFFFFD700)],
    ),
    'blue': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3498DB), Color(0xFF5DADE2)],
    ),
  };
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  
  // Border Radius
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  
  // Padding and Margins
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  
  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  
  // Elevation
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;
}

class AppStrings {
  // Navigation
  static const String home = 'Home';
  static const String calendar = 'Calendar';
  static const String settings = 'Settings';
  static const String location = 'Location';
  
  // Prayer Times
  static const String prayerTimes = 'Prayer Times';
  static const String nextPrayer = 'Next Prayer';
  static const String currentPrayer = 'Current Prayer';
  static const String timeRemaining = 'Time Remaining';
  static const String lastUpdated = 'Last Updated';
  
  // Widget Configuration
  static const String widgetSize = 'Widget Size';
  static const String small = 'Small';
  static const String medium = 'Medium';
  static const String large = 'Large';
  static const String theme = 'Theme';
  static const String showArabicNames = 'Show Arabic Names';
  static const String showHijriDate = 'Show Hijri Date';
  static const String showCountdown = 'Show Countdown';
  static const String enableNotifications = 'Enable Notifications';
  
  // Location
  static const String currentLocation = 'Current Location';
  static const String selectLocation = 'Select Location';
  static const String autoDetectLocation = 'Auto-Detect Location';
  static const String majorCities = 'Major Cities';
  static const String useCurrentLocation = 'Use Current Location';
  static const String gettingLocation = 'Getting Location...';
  
  // Actions
  static const String refresh = 'Refresh';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String retry = 'Retry';
  static const String close = 'Close';
  
  // Status
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String noData = 'No Data Available';
  static const String offline = 'Offline';
  static const String online = 'Online';
}

class AppIcons {
  static const IconData mosque = Icons.mosque;
  static const IconData location = Icons.location_on;
  static const IconData calendar = Icons.calendar_month;
  static const IconData settings = Icons.settings;
  static const IconData refresh = Icons.refresh;
  static const IconData timer = Icons.access_time;
  static const IconData notification = Icons.notifications;
  static const IconData theme = Icons.palette;
  static const IconData language = Icons.language;
  static const IconData info = Icons.info;
  static const IconData error = Icons.error_outline;
  static const IconData success = Icons.check_circle;
  static const IconData warning = Icons.warning;
}
