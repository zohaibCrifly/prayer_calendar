import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_times.dart';
import '../models/widget_config.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import 'prayer_widget_small.dart';
import 'prayer_widget_medium.dart';
import 'prayer_widget_large.dart';

class PrayerWidget extends StatelessWidget {
  final bool isHomeScreenWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PrayerWidget({
    super.key,
    this.isHomeScreenWidget = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrayerTimesProvider, WidgetConfigProvider>(
      builder: (context, prayerProvider, configProvider, child) {
        if (prayerProvider.isLoading && prayerProvider.currentPrayerTimes == null) {
          return _buildLoadingWidget(configProvider.config);
        }

        if (prayerProvider.error != null && prayerProvider.currentPrayerTimes == null) {
          return _buildErrorWidget(configProvider.config, prayerProvider.error!);
        }

        return _buildPrayerWidget(
          context,
          prayerProvider,
          configProvider,
        );
      },
    );
  }

  Widget _buildPrayerWidget(
    BuildContext context,
    PrayerTimesProvider prayerProvider,
    WidgetConfigProvider configProvider,
  ) {
    final config = configProvider.config;
    final prayerTimes = prayerProvider.currentPrayerTimes;
    final location = prayerProvider.currentLocation;

    if (prayerTimes == null) {
      return _buildErrorWidget(config, 'No prayer times available');
    }

    final widget = GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: config.size.width,
        height: config.size.height,
        child: _buildSizedWidget(
          config.size,
          prayerTimes,
          prayerProvider,
          configProvider,
          location?.toString() ?? 'Unknown Location',
        ),
      ),
    );

    if (isHomeScreenWidget) {
      return widget;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: widget,
    );
  }

  Widget _buildSizedWidget(
    WidgetSize size,
    PrayerTimes prayerTimes,
    PrayerTimesProvider prayerProvider,
    WidgetConfigProvider configProvider,
    String location,
  ) {
    switch (size) {
      case WidgetSize.small:
        return PrayerWidgetSmall(
          prayerTimes: prayerTimes,
          prayerProvider: prayerProvider,
          configProvider: configProvider,
          location: location,
        );
      case WidgetSize.medium:
        return PrayerWidgetMedium(
          prayerTimes: prayerTimes,
          prayerProvider: prayerProvider,
          configProvider: configProvider,
          location: location,
        );
      case WidgetSize.large:
        return PrayerWidgetLarge(
          prayerTimes: prayerTimes,
          prayerProvider: prayerProvider,
          configProvider: configProvider,
          location: location,
        );
    }
  }

  Widget _buildLoadingWidget(WidgetConfig config) {
    return Container(
      width: config.size.width,
      height: config.size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: _getThemeGradient(config.theme),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Loading Prayer Times...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(WidgetConfig config, String error) {
    return Container(
      width: config.size.width,
      height: config.size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: _getThemeGradient(config.theme),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Error',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static LinearGradient _getThemeGradient(String theme) {
    switch (theme) {
      case 'dark':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
        );
      case 'light':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFECF0F1), Color(0xFFBDC3C7)],
        );
      case 'islamic_green':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
        );
      case 'golden':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4AF37), Color(0xFFFFD700)],
        );
      case 'blue':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3498DB), Color(0xFF5DADE2)],
        );
      default: // default theme
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        );
    }
  }

  static Color getThemeTextColor(String theme) {
    switch (theme) {
      case 'light':
        return Colors.black87;
      default:
        return Colors.white;
    }
  }

  static Color getThemeSecondaryTextColor(String theme) {
    switch (theme) {
      case 'light':
        return Colors.black54;
      default:
        return Colors.white70;
    }
  }
}

// Extension to get theme colors
extension PrayerWidgetTheme on String {
  LinearGradient get gradient => PrayerWidget._getThemeGradient(this);
  Color get textColor => PrayerWidget.getThemeTextColor(this);
  Color get secondaryTextColor => PrayerWidget.getThemeSecondaryTextColor(this);
}
