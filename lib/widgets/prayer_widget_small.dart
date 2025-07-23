import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import 'prayer_widget.dart';

class PrayerWidgetSmall extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final PrayerTimesProvider prayerProvider;
  final WidgetConfigProvider configProvider;
  final String location;

  const PrayerWidgetSmall({
    super.key,
    required this.prayerTimes,
    required this.prayerProvider,
    required this.configProvider,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final config = configProvider.config;
    final nextPrayer = prayerProvider.nextPrayer;
    final currentPrayer = prayerProvider.currentPrayer;
    final timeToNext = prayerProvider.timeToNextPrayer;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: config.theme.gradient,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with location and date
          _buildHeader(config),

          const SizedBox(height: 8),

          // Current prayer info
          if (currentPrayer != null) ...[
            _buildCurrentPrayer(currentPrayer, config),
            const SizedBox(height: 6),
          ],

          // Next prayer info
          if (nextPrayer != null) ...[
            _buildNextPrayer(nextPrayer, timeToNext, config),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(config) {
    final now = DateTime.now();
    final dateFormat = DateFormat('MMM dd');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: TextStyle(
                  color: _getThemeTextColor(config.theme),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                dateFormat.format(now),
                style: TextStyle(
                  color: _getThemeSecondaryTextColor(config.theme),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.mosque, color: _getThemeTextColor(config.theme), size: 16),
      ],
    );
  }

  Widget _buildCurrentPrayer(PrayerTime currentPrayer, config) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: _getThemeTextColor(config.theme),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current',
                style: TextStyle(
                  color: _getThemeSecondaryTextColor(config.theme),
                  fontSize: 8,
                ),
              ),
              Row(
                children: [
                  Text(
                    configProvider.showArabicNames
                        ? currentPrayer.type.arabicName
                        : currentPrayer.name,
                    style: TextStyle(
                      color: _getThemeTextColor(config.theme),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentPrayer.time,
                    style: TextStyle(
                      color: _getThemeSecondaryTextColor(config.theme),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayer(PrayerTime nextPrayer, Duration timeToNext, config) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next',
                style: TextStyle(
                  color: _getThemeSecondaryTextColor(config.theme),
                  fontSize: 8,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        configProvider.showArabicNames
                            ? nextPrayer.type.arabicName
                            : nextPrayer.name,
                        style: TextStyle(
                          color: _getThemeTextColor(config.theme),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nextPrayer.time,
                        style: TextStyle(
                          color: _getThemeSecondaryTextColor(config.theme),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  if (configProvider.showNextPrayerCountdown)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        prayerProvider.formatTimeRemaining(timeToNext),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getThemeTextColor(String theme) {
    switch (theme) {
      case 'light':
        return Colors.black87;
      default:
        return Colors.white;
    }
  }

  Color _getThemeSecondaryTextColor(String theme) {
    switch (theme) {
      case 'light':
        return Colors.black54;
      default:
        return Colors.white70;
    }
  }
}
