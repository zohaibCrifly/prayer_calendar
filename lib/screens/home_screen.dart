import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import '../widgets/prayer_widget.dart';
import '../widgets/prayer_calendar_widget.dart';
import '../models/widget_config.dart';
import 'settings_screen.dart';
import 'location_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Prayer Times',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        actions: [
          Consumer<PrayerTimesProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed: provider.isLoading
                    ? null
                    : () => provider.refreshPrayerTimes(),
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.white),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationSelectionScreen(),
                ),
              );
            },
            icon: const Icon(Icons.location_on, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildWidgetDemo(), _buildCalendarView()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Widget'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetDemo() {
    return Consumer<WidgetConfigProvider>(
      builder: (context, configProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Size selector
              _buildSizeSelector(configProvider),

              const SizedBox(height: 20),

              // Widget preview
              _buildWidgetPreview(),

              const SizedBox(height: 20),

              // Widget options
              _buildWidgetOptions(configProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSizeSelector(WidgetConfigProvider configProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: WidgetSize.values.map((size) {
                final isSelected = configProvider.currentSize == size;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => configProvider.updateSize(size),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFF667eea)
                            : Colors.grey[300],
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black87,
                      ),
                      child: Text(size.displayName),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Preview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Consumer<PrayerTimesProvider>(
                builder: (context, provider, child) {
                  if (provider.error != null &&
                      provider.currentPrayerTimes == null) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[600],
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Error loading prayer times',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.error!,
                            style: TextStyle(color: Colors.red[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return const PrayerWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetOptions(WidgetConfigProvider configProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Show Arabic Names'),
              subtitle: const Text('Display prayer names in Arabic'),
              value: configProvider.showArabicNames,
              onChanged: (_) => configProvider.toggleArabicNames(),
            ),
            SwitchListTile(
              title: const Text('Show Hijri Date'),
              subtitle: const Text('Display Islamic calendar date'),
              value: configProvider.showHijriDate,
              onChanged: (_) => configProvider.toggleHijriDate(),
            ),
            SwitchListTile(
              title: const Text('Show Countdown'),
              subtitle: const Text('Display time remaining to next prayer'),
              value: configProvider.showNextPrayerCountdown,
              onChanged: (_) => configProvider.toggleNextPrayerCountdown(),
            ),
            SwitchListTile(
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

  Widget _buildCalendarView() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: PrayerCalendarWidget(),
    );
  }
}
