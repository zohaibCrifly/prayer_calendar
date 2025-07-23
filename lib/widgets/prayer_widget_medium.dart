import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import 'prayer_widget.dart';

class PrayerWidgetMedium extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final PrayerTimesProvider prayerProvider;
  final WidgetConfigProvider configProvider;
  final String location;

  const PrayerWidgetMedium({
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
    final timeToNext = prayerProvider.timeToNextPrayer;
    final prayers = prayerTimes.allPrayers
        .take(4)
        .toList(); // Show 4 prayers for medium size

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: config.theme.gradient,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with location and date
          _buildHeader(config),

          const SizedBox(height: 12),

          // Next prayer countdown (if enabled)
          if (configProvider.showNextPrayerCountdown && nextPrayer != null) ...[
            _buildNextPrayerCountdown(nextPrayer, timeToNext, config),
            const SizedBox(height: 12),
          ],

          // Prayer times list
          Expanded(child: _buildPrayerTimesList(prayers, config)),
        ],
      ),
    );
  }

  Widget _buildHeader(config) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMM dd');

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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                dateFormat.format(now),
                style: TextStyle(
                  color: _getThemeSecondaryTextColor(config.theme),
                  fontSize: 12,
                ),
              ),
              if (configProvider.showHijriDate) ...[
                const SizedBox(height: 2),
                Text(
                  _getHijriDate(),
                  style: TextStyle(
                    color: _getThemeSecondaryTextColor(config.theme),
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.mosque,
            color: _getThemeTextColor(config.theme),
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCountdown(
    PrayerTime nextPrayer,
    Duration timeToNext,
    config,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.access_time, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Prayer',
                  style: TextStyle(
                    color: _getThemeSecondaryTextColor(config.theme),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      configProvider.showArabicNames
                          ? nextPrayer.type.arabicName
                          : nextPrayer.name,
                      style: TextStyle(
                        color: _getThemeTextColor(config.theme),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      prayerProvider.formatTimeRemaining(timeToNext),
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesList(List<PrayerTime> prayers, config) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: prayers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final isNext = prayerProvider.nextPrayer?.name == prayer.name;
        final isCurrent = prayerProvider.currentPrayer?.name == prayer.name;

        return _buildPrayerTimeItem(prayer, isNext, isCurrent, config);
      },
    );
  }

  Widget _buildPrayerTimeItem(
    PrayerTime prayer,
    bool isNext,
    bool isCurrent,
    config,
  ) {
    Color indicatorColor = _getThemeSecondaryTextColor(config.theme);
    if (isCurrent) indicatorColor = _getThemeTextColor(config.theme);
    if (isNext) indicatorColor = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (isNext || isCurrent)
            ? Colors.white.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  configProvider.showArabicNames
                      ? prayer.type.arabicName
                      : prayer.name,
                  style: TextStyle(
                    color: _getThemeTextColor(config.theme),
                    fontSize: 13,
                    fontWeight: (isNext || isCurrent)
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
                if (configProvider.showArabicNames &&
                    !configProvider.showArabicNames) ...[
                  const SizedBox(height: 2),
                  Text(
                    prayer.type.arabicName,
                    style: TextStyle(
                      color: _getThemeSecondaryTextColor(config.theme),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            prayer.time,
            style: TextStyle(
              color: _getThemeTextColor(config.theme),
              fontSize: 13,
              fontWeight: (isNext || isCurrent)
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
          if (isNext) ...[
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getHijriDate() {
    // This is a placeholder. In a real app, you would calculate the Hijri date
    // or get it from the API response
    return '12 Ramadan 1445';
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
