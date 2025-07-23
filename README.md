# Prayer Times Widget

A professional Flutter application featuring dynamic prayer times widgets with calendar integration and home screen widget support.

## 🌟 Features

### Dynamic Widget System
- **Three Size Variants**: Small (200x120), Medium (300x200), Large (400x300)
- **Real-time Prayer Times**: Fetched from Aladhan API with location-based accuracy
- **Multiple Themes**: Default, Dark, Light, Islamic Green, Golden, Blue
- **Responsive Design**: Adapts beautifully to different screen sizes

### Prayer Times Integration
- **Live Data**: Real prayer times from Islamic API (no mock data)
- **Location-based**: Automatic GPS detection or manual city selection
- **Next Prayer Countdown**: Real-time countdown to next prayer
- **Current Prayer Indicator**: Highlights current prayer time
- **Arabic Support**: Display prayer names in Arabic or English

### Calendar Integration
- **Monthly View**: Full calendar with prayer times overlay
- **Date Navigation**: Easy month-to-month navigation
- **Prayer Events**: Visual indicators for prayer times on calendar
- **Selected Day Details**: Detailed prayer times for selected date

### Home Screen Widget
- **Native Widget Support**: Android/iOS home screen widgets
- **Auto-refresh**: Periodic updates of prayer times
- **Configurable**: Size and theme options for home screen
- **Background Updates**: Keeps data fresh even when app is closed

### Professional UI/UX
- **Smooth Animations**: Elegant transitions and micro-interactions
- **Material Design 3**: Modern, clean interface
- **Provider State Management**: Efficient and scalable architecture
- **Error Handling**: Graceful error states with retry options

## 📱 Screenshots

The app features three dynamic widget sizes that adapt to different use cases:

- **Small Widget**: Perfect for quick glances, shows current and next prayer
- **Medium Widget**: Balanced view with prayer list and countdown
- **Large Widget**: Full-featured with all prayers in grid layout

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/calendar_prayer.git
   cd calendar_prayer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Location Permissions
Add the following permissions to your platform-specific files:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to provide accurate prayer times.</string>
```

## 🏗️ Architecture

### Project Structure
```
lib/
├── models/           # Data models with JSON serialization
├── providers/        # State management with Provider
├── services/         # API and location services
├── widgets/          # Reusable UI components
├── screens/          # App screens
├── utils/           # Constants and utilities
└── main.dart        # App entry point
```

### Key Components

#### Models
- `PrayerTimes`: Core prayer times data structure
- `LocationData`: Location information with coordinates
- `WidgetConfig`: Widget configuration and preferences
- `CalendarEvent`: Calendar events and Islamic dates

#### Providers
- `PrayerTimesProvider`: Manages prayer times state and API calls
- `WidgetConfigProvider`: Handles widget configuration and preferences
- `CalendarProvider`: Manages calendar state and events

#### Services
- `PrayerApiService`: Interfaces with Aladhan API for prayer times
- `LocationService`: Handles GPS and location detection
- `HomeWidgetService`: Manages home screen widget functionality

## 🎨 Customization

### Widget Themes
The app supports multiple themes that can be easily customized:

```dart
// Available themes
'default', 'dark', 'light', 'islamic_green', 'golden', 'blue'
```

### Adding New Themes
1. Add theme colors to `AppConstants.widgetThemes`
2. Update theme selector in settings
3. Implement theme-specific styling

### Widget Sizes
Customize widget dimensions in `WidgetSize` enum:

```dart
enum WidgetSize {
  small,   // 200x120
  medium,  // 300x200
  large,   // 400x300
}
```

## 🔧 API Integration

### Aladhan API
The app uses the Aladhan API for accurate prayer times:

- **Base URL**: `http://api.aladhan.com/v1`
- **Endpoints**: `/timings/{date}`, `/methods`
- **Parameters**: Latitude, longitude, calculation method
- **Response**: JSON with prayer times and metadata

### Calculation Methods
Supports multiple Islamic calculation methods:
- ISNA (Islamic Society of North America) - Default
- Muslim World League
- Egyptian General Authority of Survey
- And many more...

## 📍 Location Services

### Automatic Detection
- Uses device GPS for precise location
- Handles permission requests gracefully
- Falls back to last known location

### Manual Selection
- Pre-configured list of major Islamic cities
- Custom location input support
- Timezone-aware calculations

### Major Cities Included
- Mecca, Saudi Arabia
- Medina, Saudi Arabia
- Jerusalem, Palestine
- Istanbul, Turkey
- Cairo, Egypt
- And 25+ more cities

## 🏠 Home Screen Widget

### Android Widget
- Configurable sizes (2x1, 3x2, 4x3)
- Auto-refresh every hour
- Tap actions for quick access
- Material Design styling

### iOS Widget
- Small, Medium, Large sizes
- WidgetKit integration
- Background refresh support
- iOS design guidelines compliant

### Widget Features
- Shows next prayer time
- Countdown timer
- Current location
- Theme customization
- Offline support

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Coverage
- Unit tests for models and utilities
- Widget tests for UI components
- Integration tests for user flows
- Provider tests for state management

## 📦 Dependencies

### Core Dependencies
- `provider`: State management
- `http`: API requests
- `geolocator`: Location services
- `table_calendar`: Calendar widget
- `home_widget`: Home screen widgets
- `shared_preferences`: Local storage
- `intl`: Internationalization

### Development Dependencies
- `build_runner`: Code generation
- `json_serializable`: JSON serialization
- `flutter_test`: Testing framework

## 🚀 Deployment

### Android
1. Build APK: `flutter build apk`
2. Build App Bundle: `flutter build appbundle`
3. Sign and upload to Play Store

### iOS
1. Build iOS: `flutter build ios`
2. Archive in Xcode
3. Upload to App Store Connect

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Aladhan API** for providing accurate prayer times
- **Flutter Team** for the amazing framework
- **Islamic Community** for guidance on prayer time calculations
- **Contributors** who help improve this project

## 📞 Support

For support, email support@prayertimeswidget.com or create an issue on GitHub.

---

**Made with ❤️ for the Muslim community**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
