import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import 'prayer_widget.dart';

class PrayerWidgetLarge extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final PrayerTimesProvider prayerProvider;
  final WidgetConfigProvider configProvider;
  final String location;

  const PrayerWidgetLarge({
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
    final prayers = prayerTimes.allPrayers;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: config.theme.gradient,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with location and date
          _buildHeader(config),

          const SizedBox(height: 16),

          // Next prayer countdown (if enabled)
          if (configProvider.showNextPrayerCountdown && nextPrayer != null) ...[
            _buildNextPrayerCountdown(nextPrayer, timeToNext, config),
            const SizedBox(height: 16),
          ],

          // Prayer times grid
          Expanded(child: _buildPrayerTimesGrid(prayers, config)),
          const SizedBox(height: 12),

          // Footer with last updated info
          _buildFooter(config),
        ],
      ),
    );
  }

  Widget _buildHeader(config) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: _getThemeTextColor(config.theme),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                        color: _getThemeTextColor(config.theme),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dateFormat.format(now),
                style: TextStyle(
                  color: _getThemeSecondaryTextColor(config.theme),
                  fontSize: 14,
                ),
              ),
              if (configProvider.showHijriDate) ...[
                const SizedBox(height: 2),
                Text(
                  _getHijriDate(),
                  style: TextStyle(
                    color: _getThemeSecondaryTextColor(config.theme),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.mosque,
                color: _getThemeTextColor(config.theme),
                size: 32,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeFormat.format(now),
              style: TextStyle(
                color: _getThemeSecondaryTextColor(config.theme),
                fontSize: 12,
              ),
            ),
          ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.access_time, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Prayer',
                  style: TextStyle(
                    color: _getThemeSecondaryTextColor(config.theme),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          nextPrayer.time,
                          style: TextStyle(
                            color: _getThemeSecondaryTextColor(config.theme),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        prayerProvider.formatTimeRemaining(timeToNext),
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
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
      ),
    );
  }

  Widget _buildPrayerTimesGrid(List<PrayerTime> prayers, config) {
    return GridView.builder(
      padding: EdgeInsets.zero,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // childAspectRatio: 1.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final isNext = prayerProvider.nextPrayer?.name == prayer.name;
        final isCurrent = prayerProvider.currentPrayer?.name == prayer.name;

        return _buildPrayerTimeCard(prayer, isNext, isCurrent, config);
      },
    );
  }

  Widget _buildPrayerTimeCard(
    PrayerTime prayer,
    bool isNext,
    bool isCurrent,
    config,
  ) {
    Color cardColor = Colors.white.withOpacity(0.1);
    Color borderColor = Colors.transparent;

    if (isCurrent) {
      cardColor = Colors.white.withOpacity(0.2);
      borderColor = _getThemeTextColor(config.theme).withOpacity(0.3);
    }
    if (isNext) {
      cardColor = Colors.orange.withOpacity(0.15);
      borderColor = Colors.orange.withOpacity(0.3);
    }

    return Container(
      // height: 150,
      // width: 50,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  configProvider.showArabicNames
                      ? prayer.type.arabicName
                      : prayer.name,
                  style: TextStyle(
                    color: _getThemeTextColor(config.theme),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isNext)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              if (isCurrent)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getThemeTextColor(config.theme),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            prayer.time,
            style: TextStyle(
              color: _getThemeTextColor(config.theme),
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildFooter(config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Last updated: ${DateFormat('HH:mm').format(prayerProvider.lastUpdated)}',
          style: TextStyle(
            color: _getThemeSecondaryTextColor(config.theme),
            fontSize: 10,
          ),
        ),
        if (prayerProvider.isLoading)
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getThemeSecondaryTextColor(config.theme),
              ),
            ),
          ),
      ],
    );
  }

  String _getHijriDate() {
    // This is a placeholder. In a real app, you would calculate the Hijri date
    // or get it from the API response
    return '12 Ramadan 1445 AH';
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
