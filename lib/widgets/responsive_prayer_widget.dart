import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_times.dart';
import '../models/widget_config.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import 'prayer_widget_small.dart';
import 'prayer_widget_medium.dart';
import 'prayer_widget_large.dart';

class ResponsivePrayerWidget extends StatelessWidget {
  final PrayerTimes? prayerTimes;
  final String location;

  const ResponsivePrayerWidget({
    super.key,
    this.prayerTimes,
    this.location = 'Current Location',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrayerTimesProvider, WidgetConfigProvider>(
      builder: (context, prayerProvider, configProvider, child) {
        final currentPrayerTimes =
            prayerTimes ?? prayerProvider.currentPrayerTimes;

        if (currentPrayerTimes == null) {
          return _buildLoadingWidget();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine widget size based on available space
            final widgetSize = _determineWidgetSize(constraints);

            // Update config provider with the determined size
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (configProvider.currentSize != widgetSize) {
                configProvider.updateSize(widgetSize);
              }
            });

            // Return appropriate widget based on size
            switch (widgetSize) {
              case WidgetSize.small:
                return PrayerWidgetSmall(
                  prayerTimes: currentPrayerTimes,
                  prayerProvider: prayerProvider,
                  configProvider: configProvider,
                  location: location,
                );
              case WidgetSize.medium:
                return PrayerWidgetMedium(
                  prayerTimes: currentPrayerTimes,
                  prayerProvider: prayerProvider,
                  configProvider: configProvider,
                  location: location,
                );
              case WidgetSize.large:
                return PrayerWidgetLarge(
                  prayerTimes: currentPrayerTimes,
                  prayerProvider: prayerProvider,
                  configProvider: configProvider,
                  location: location,
                );
            }
          },
        );
      },
    );
  }

  WidgetSize _determineWidgetSize(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    // Define breakpoints for different sizes
    if (width < 250 || height < 150) {
      return WidgetSize.small;
    } else if (width < 350 || height < 250) {
      return WidgetSize.medium;
    } else {
      return WidgetSize.large;
    }
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
          SizedBox(height: 12),
          Text(
            'Loading Prayer Times...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
