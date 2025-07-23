import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/prayer_times.dart';
import '../models/widget_config.dart';
import '../providers/calendar_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';

class PrayerCalendarWidget extends StatefulWidget {
  const PrayerCalendarWidget({super.key});

  @override
  State<PrayerCalendarWidget> createState() => _PrayerCalendarWidgetState();
}

class _PrayerCalendarWidgetState extends State<PrayerCalendarWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCalendarData();
    });
  }

  void _loadCalendarData() {
    final prayerProvider = context.read<PrayerTimesProvider>();
    final calendarProvider = context.read<CalendarProvider>();

    if (prayerProvider.currentLocation != null) {
      calendarProvider.loadPrayerTimesForMonth(
        latitude: prayerProvider.currentLocation!.latitude,
        longitude: prayerProvider.currentLocation!.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      CalendarProvider,
      PrayerTimesProvider,
      WidgetConfigProvider
    >(
      builder:
          (context, calendarProvider, prayerProvider, configProvider, child) {
            final config = configProvider.config;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _getThemeGradient(config.theme),
              ),
              child: Column(
                children: [
                  // Calendar header
                  _buildCalendarHeader(calendarProvider, config),

                  // Calendar widget
                  _buildCalendar(calendarProvider, prayerProvider, config),

                  // Selected day prayer times
                  if (calendarProvider.selectedDayPrayerTimes != null)
                    _buildSelectedDayPrayerTimes(calendarProvider, config),
                ],
              ),
            );
          },
    );
  }

  Widget _buildCalendarHeader(CalendarProvider calendarProvider, config) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(calendarProvider.focusedDay),
            style: TextStyle(
              color: _getThemeTextColor(config.theme),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  final newDate = DateTime(
                    calendarProvider.focusedDay.year,
                    calendarProvider.focusedDay.month - 1,
                  );
                  calendarProvider.updateFocusedDay(newDate);
                  _loadCalendarData();
                },
                icon: Icon(
                  Icons.chevron_left,
                  color: _getThemeTextColor(config.theme),
                ),
              ),
              IconButton(
                onPressed: () {
                  final newDate = DateTime(
                    calendarProvider.focusedDay.year,
                    calendarProvider.focusedDay.month + 1,
                  );
                  calendarProvider.updateFocusedDay(newDate);
                  _loadCalendarData();
                },
                icon: Icon(
                  Icons.chevron_right,
                  color: _getThemeTextColor(config.theme),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(
    CalendarProvider calendarProvider,
    PrayerTimesProvider prayerProvider,
    config,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TableCalendar<CalendarEvent>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: calendarProvider.focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(calendarProvider.selectedDay, day);
        },
        eventLoader: calendarProvider.getEventsForDay,
        calendarFormat: calendarProvider.calendarFormat,
        onDaySelected: (selectedDay, focusedDay) {
          calendarProvider.updateSelectedDay(selectedDay);
          calendarProvider.updateFocusedDay(focusedDay);
        },
        onFormatChanged: (format) {
          calendarProvider.updateCalendarFormat(format);
        },
        onPageChanged: (focusedDay) {
          calendarProvider.updateFocusedDay(focusedDay);
          _loadCalendarData();
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: _getThemeTextColor(config.theme)),
          holidayTextStyle: TextStyle(color: _getThemeTextColor(config.theme)),
          defaultTextStyle: TextStyle(color: _getThemeTextColor(config.theme)),
          selectedTextStyle: const TextStyle(color: Colors.white),
          todayTextStyle: TextStyle(color: _getThemeTextColor(config.theme)),
          selectedDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: _getThemeTextColor(config.theme).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
          titleTextStyle: TextStyle(
            color: _getThemeTextColor(config.theme),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: _getThemeSecondaryTextColor(config.theme),
          ),
          weekendStyle: TextStyle(
            color: _getThemeSecondaryTextColor(config.theme),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayPrayerTimes(
    CalendarProvider calendarProvider,
    config,
  ) {
    final prayerTimes = calendarProvider.selectedDayPrayerTimes!;
    final selectedDate = calendarProvider.selectedDay;
    final isToday = isSameDay(selectedDate, DateTime.now());

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                calendarProvider.getFormattedDate(selectedDate),
                style: TextStyle(
                  color: _getThemeTextColor(config.theme),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPrayerTimesList(prayerTimes, calendarProvider, config, isToday),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesList(
    PrayerTimes prayerTimes,
    CalendarProvider calendarProvider,
    config,
    bool isToday,
  ) {
    final prayers = prayerTimes.allPrayers;

    return Column(
      children: prayers.map((prayer) {
        final isNext =
            isToday &&
            context.read<PrayerTimesProvider>().nextPrayer?.name == prayer.name;
        final isCurrent =
            isToday &&
            context.read<PrayerTimesProvider>().currentPrayer?.name ==
                prayer.name;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: (isNext || isCurrent)
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? _getThemeTextColor(config.theme)
                      : isNext
                      ? Colors.orange
                      : _getThemeSecondaryTextColor(config.theme),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.read<WidgetConfigProvider>().showArabicNames
                      ? prayer.type.arabicName
                      : prayer.name,
                  style: TextStyle(
                    color: _getThemeTextColor(config.theme),
                    fontSize: 14,
                    fontWeight: (isNext || isCurrent)
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ),
              Text(
                prayer.time,
                style: TextStyle(
                  color: _getThemeTextColor(config.theme),
                  fontSize: 14,
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
      }).toList(),
    );
  }

  LinearGradient _getThemeGradient(String theme) {
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
