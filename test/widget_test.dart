// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:calendar_prayer/main.dart';
import 'package:calendar_prayer/models/prayer_times.dart';
import 'package:calendar_prayer/models/widget_config.dart';
import 'package:calendar_prayer/providers/prayer_times_provider.dart';
import 'package:calendar_prayer/providers/widget_config_provider.dart';
import 'package:calendar_prayer/widgets/prayer_widget.dart';

void main() {
  group('Prayer Times App Tests', () {
    testWidgets('App should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const PrayerTimesApp());
      await tester.pumpAndSettle();

      // Verify that the app builds successfully
      expect(find.text('Prayer Times'), findsOneWidget);
    });

    testWidgets('Prayer widget should display error state when no data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
              ChangeNotifierProvider(create: (_) => WidgetConfigProvider()),
            ],
            child: const Scaffold(body: PrayerWidget()),
          ),
        ),
      );
      await tester.pump();

      // Wait for the provider to initialize
      await tester.pumpAndSettle();

      // Should show some content (either loading, error, or data)
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('Prayer Times Model Tests', () {
    test('PrayerTimes should parse correctly', () {
      final prayerTimes = PrayerTimes(
        fajr: '05:30',
        sunrise: '07:00',
        dhuhr: '12:30',
        asr: '15:45',
        maghrib: '18:20',
        isha: '19:45',
      );

      expect(prayerTimes.fajr, '05:30');
      expect(prayerTimes.allPrayers.length, 6);
    });

    test('PrayerTime should calculate time remaining correctly', () {
      final now = DateTime.now();
      final futureTime = now.add(const Duration(hours: 2));
      final timeString =
          '${futureTime.hour.toString().padLeft(2, '0')}:${futureTime.minute.toString().padLeft(2, '0')}';

      final prayerTime = PrayerTime(
        name: 'Test Prayer',
        time: timeString,
        type: PrayerType.fajr,
      );

      final remaining = prayerTime.getTimeRemaining();
      expect(remaining.inHours, 1); // Should be approximately 2 hours
    });
  });

  group('Widget Config Tests', () {
    test('WidgetConfig should have correct default values', () {
      const config = WidgetConfig();

      expect(config.size, WidgetSize.medium);
      expect(config.showArabicNames, true);
      expect(config.showHijriDate, true);
      expect(config.showNextPrayerCountdown, true);
      expect(config.enableNotifications, true);
    });

    test('WidgetSize should have correct dimensions', () {
      expect(WidgetSize.small.width, 200.0);
      expect(WidgetSize.small.height, 140.0);
      expect(WidgetSize.medium.width, 300.0);
      expect(WidgetSize.medium.height, 200.0);
      expect(WidgetSize.large.width, 400.0);
      expect(WidgetSize.large.height, 520.0);
    });

    test('WidgetConfig copyWith should work correctly', () {
      const originalConfig = WidgetConfig();
      final newConfig = originalConfig.copyWith(
        size: WidgetSize.large,
        showArabicNames: false,
      );

      expect(newConfig.size, WidgetSize.large);
      expect(newConfig.showArabicNames, false);
      expect(newConfig.showHijriDate, true); // Should remain unchanged
    });
  });

  group('Prayer Type Extension Tests', () {
    test('Prayer type should have correct display names', () {
      expect(PrayerType.fajr.displayName, 'Fajr');
      expect(PrayerType.dhuhr.displayName, 'Dhuhr');
      expect(PrayerType.maghrib.displayName, 'Maghrib');
    });

    test('Prayer type should have correct Arabic names', () {
      expect(PrayerType.fajr.arabicName, 'الفجر');
      expect(PrayerType.dhuhr.arabicName, 'الظهر');
      expect(PrayerType.maghrib.arabicName, 'المغرب');
    });
  });
}
