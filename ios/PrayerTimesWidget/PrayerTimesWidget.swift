import WidgetKit
import SwiftUI

struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrayerTimesProvider()) { entry in
            PrayerTimesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Prayer Times")
        .description("Shows current and upcoming prayer times")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct PrayerTimesProvider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerTimesEntry {
        PrayerTimesEntry(date: Date(), location: "Current Location", currentPrayer: "Fajr", currentTime: "05:30", nextPrayer: "Dhuhr", nextTime: "12:30", timeRemaining: "2h 30m")
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerTimesEntry) -> ()) {
        let entry = PrayerTimesEntry(date: Date(), location: "Current Location", currentPrayer: "Fajr", currentTime: "05:30", nextPrayer: "Dhuhr", nextTime: "12:30", timeRemaining: "2h 30m")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.example.calendar_prayer")
        
        let location = userDefaults?.string(forKey: "location") ?? "Current Location"
        let currentPrayer = userDefaults?.string(forKey: "currentPrayer") ?? "Fajr"
        let currentTime = userDefaults?.string(forKey: "currentPrayerTime") ?? "05:30"
        let nextPrayer = userDefaults?.string(forKey: "nextPrayer") ?? "Dhuhr"
        let nextTime = userDefaults?.string(forKey: "nextPrayerTime") ?? "12:30"
        let timeRemaining = userDefaults?.string(forKey: "timeToNext") ?? "2h 30m"
        
        let entry = PrayerTimesEntry(
            date: Date(),
            location: location,
            currentPrayer: currentPrayer,
            currentTime: currentTime,
            nextPrayer: nextPrayer,
            nextTime: nextTime,
            timeRemaining: timeRemaining
        )
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct PrayerTimesEntry: TimelineEntry {
    let date: Date
    let location: String
    let currentPrayer: String
    let currentTime: String
    let nextPrayer: String
    let nextTime: String
    let timeRemaining: String
}

struct PrayerTimesWidgetEntryView: View {
    var entry: PrayerTimesProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Text(entry.location)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(DateFormatter.shortDate.string(from: entry.date))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Current Prayer
                HStack {
                    Text(entry.currentPrayer)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(entry.currentTime)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Next Prayer (for medium and large widgets)
                if family != .systemSmall {
                    HStack {
                        Text("Next: \(entry.nextPrayer)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text(entry.nextTime)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("in \(entry.timeRemaining)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .cornerRadius(16)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
}
