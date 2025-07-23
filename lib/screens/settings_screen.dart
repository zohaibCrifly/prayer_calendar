import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/widget_config_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../models/widget_config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer2<WidgetConfigProvider, PrayerTimesProvider>(
        builder: (context, configProvider, prayerProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget Settings
                _buildWidgetSettings(configProvider),

                const SizedBox(height: 20),

                // Display Settings
                _buildDisplaySettings(configProvider),

                const SizedBox(height: 20),

                // Theme Settings
                _buildThemeSettings(configProvider),

                const SizedBox(height: 20),

                // Data Settings
                _buildDataSettings(prayerProvider),

                const SizedBox(height: 20),

                // About Section
                _buildAboutSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWidgetSettings(WidgetConfigProvider configProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_size_select_large),
              title: const Text('Widget Size'),
              subtitle: Text(configProvider.currentSize.displayName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSizeSelector(configProvider),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive prayer time notifications'),
              value: configProvider.enableNotifications,
              onChanged: (_) => configProvider.toggleNotifications(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySettings(WidgetConfigProvider configProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Display Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              secondary: const Icon(Icons.language),
              title: const Text('Show Arabic Names'),
              subtitle: const Text('Display prayer names in Arabic'),
              value: configProvider.showArabicNames,
              onChanged: (_) => configProvider.toggleArabicNames(),
            ),

            SwitchListTile(
              secondary: const Icon(Icons.timer),
              title: const Text('Show Countdown'),
              subtitle: const Text('Display time remaining to next prayer'),
              value: configProvider.showNextPrayerCountdown,
              onChanged: (_) => configProvider.toggleNextPrayerCountdown(),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.calendar_month),
              title: const Text('Show Calendar'),
              subtitle: const Text('Display calendar view in widget'),
              value: configProvider.showCalendar,
              onChanged: (_) => configProvider.toggleCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSettings(WidgetConfigProvider configProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Widget Theme'),
              subtitle: Text(
                configProvider.getThemeDisplayName(configProvider.theme),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeSelector(configProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSettings(PrayerTimesProvider prayerProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh Prayer Times'),
              subtitle: Text(
                'Last updated: ${_formatLastUpdated(prayerProvider.lastUpdated)}',
              ),
              trailing: prayerProvider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: prayerProvider.isLoading
                  ? null
                  : () => prayerProvider.refreshPrayerTimes(),
            ),
            if (prayerProvider.currentLocation != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Current Location'),
                subtitle: Text(prayerProvider.currentLocation!.toString()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // This would navigate to location selection
                  // For now, we'll just show a message
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('Version'),
              subtitle: Text('1.0.0'),
            ),
            const ListTile(
              leading: Icon(Icons.code),
              title: Text('Developer'),
              subtitle: Text('Prayer Times Widget'),
            ),
            ListTile(
              leading: const Icon(Icons.api),
              title: const Text('Prayer Times API'),
              subtitle: const Text('Powered by Aladhan API'),
              onTap: () {
                // Show API info dialog
                _showApiInfoDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSizeSelector(WidgetConfigProvider configProvider) {
    // This would show a dialog or bottom sheet for size selection
    // For now, we'll just cycle through sizes
    final currentIndex = WidgetSize.values.indexOf(configProvider.currentSize);
    final nextIndex = (currentIndex + 1) % WidgetSize.values.length;
    configProvider.updateSize(WidgetSize.values[nextIndex]);
  }

  void _showThemeSelector(WidgetConfigProvider configProvider) {
    // This would show a dialog or bottom sheet for theme selection
    // For now, we'll just cycle through themes
    final themes = configProvider.availableThemes;
    final currentIndex = themes.indexOf(configProvider.theme);
    final nextIndex = (currentIndex + 1) % themes.length;
    configProvider.updateTheme(themes[nextIndex]);
  }

  void _showApiInfoDialog() {
    // This would show information about the API
    // Implementation would depend on the specific context
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
