package com.example.calendar_prayer

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class PrayerTimesWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val widgetData = HomeWidgetPlugin.getData(context)

        val views = try {
            // Get widget dimensions to determine layout
            val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
            val width = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
            val height = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

            Log.d("PrayerWidget", "Widget size: ${width}x${height}")

            // Determine widget size and use appropriate layout
            val widgetSize = when {
                width < 200 || height < 120 -> WidgetSize.SMALL
                width < 300 || height < 200 -> WidgetSize.MEDIUM
                else -> WidgetSize.LARGE
            }

            val widgetViews = when (widgetSize) {
                WidgetSize.SMALL -> createSmallWidget(context, widgetData)
                WidgetSize.MEDIUM -> createMediumWidget(context, widgetData)
                WidgetSize.LARGE -> createLargeWidget(context, widgetData)
            }

            // Set up click intent to open the app
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            widgetViews.setOnClickPendingIntent(android.R.id.background, pendingIntent)

            widgetViews
        } catch (e: Exception) {
            Log.e("PrayerWidget", "Error updating widget", e)
            createErrorWidget(context)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    enum class WidgetSize {
        SMALL, MEDIUM, LARGE
    }

    private fun createSmallWidget(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.prayer_times_widget_small)

        // Get basic data
        val location = widgetData.getString("location", "Current Location") ?: "Current Location"
        val currentPrayer = widgetData.getString("currentPrayer", "Fajr") ?: "Fajr"
        val currentPrayerTime = widgetData.getString("currentPrayerTime", "--:--") ?: "--:--"
        val nextPrayer = widgetData.getString("nextPrayer", "Dhuhr") ?: "Dhuhr"

        // Update views
        views.setTextViewText(R.id.widget_location, location)
        views.setTextViewText(R.id.current_prayer_name, currentPrayer)
        views.setTextViewText(R.id.current_prayer_time, currentPrayerTime)
        views.setTextViewText(R.id.next_prayer_name, "Next: $nextPrayer")

        return views
    }

    private fun createMediumWidget(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.prayer_times_widget_medium)

        // Get basic data
        val location = widgetData.getString("location", "Current Location") ?: "Current Location"
        val currentPrayer = widgetData.getString("currentPrayer", "Fajr") ?: "Fajr"
        val currentPrayerTime = widgetData.getString("currentPrayerTime", "--:--") ?: "--:--"
        val nextPrayer = widgetData.getString("nextPrayer", "Dhuhr") ?: "Dhuhr"
        val nextPrayerTime = widgetData.getString("nextPrayerTime", "--:--") ?: "--:--"

        // Update header
        views.setTextViewText(R.id.widget_location, location)
        views.setTextViewText(R.id.widget_date, getCurrentDate())

        // Update current prayer
        views.setTextViewText(R.id.current_prayer_name, currentPrayer)
        views.setTextViewText(R.id.current_prayer_time, currentPrayerTime)

        // Update next prayer
        views.setTextViewText(R.id.next_prayer_name, nextPrayer)
        views.setTextViewText(R.id.next_prayer_time, nextPrayerTime)

        // Update 4 main prayers
        updatePrayerTime(views, widgetData, "fajr", R.id.fajr_name, R.id.fajr_time)
        updatePrayerTime(views, widgetData, "dhuhr", R.id.dhuhr_name, R.id.dhuhr_time)
        updatePrayerTime(views, widgetData, "asr", R.id.asr_name, R.id.asr_time)
        updatePrayerTime(views, widgetData, "maghrib", R.id.maghrib_name, R.id.maghrib_time)

        return views
    }

    private fun createLargeWidget(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.prayer_times_widget_large)

        // Get basic data
        val location = widgetData.getString("location", "Current Location") ?: "Current Location"
        val currentPrayer = widgetData.getString("currentPrayer", "Fajr") ?: "Fajr"
        val currentPrayerTime = widgetData.getString("currentPrayerTime", "--:--") ?: "--:--"
        val nextPrayer = widgetData.getString("nextPrayer", "Dhuhr") ?: "Dhuhr"
        val nextPrayerTime = widgetData.getString("nextPrayerTime", "--:--") ?: "--:--"

        // Update header
        views.setTextViewText(R.id.widget_location, location)
        views.setTextViewText(R.id.widget_date, getCurrentDate())

        // Update current prayer
        views.setTextViewText(R.id.current_prayer_name, currentPrayer)
        views.setTextViewText(R.id.current_prayer_time, currentPrayerTime)

        // Update next prayer
        views.setTextViewText(R.id.next_prayer_name, nextPrayer)
        views.setTextViewText(R.id.next_prayer_time, nextPrayerTime)

        // Update all 6 prayers
        updatePrayerTime(views, widgetData, "fajr", R.id.fajr_name, R.id.fajr_time)
        updatePrayerTime(views, widgetData, "sunrise", R.id.sunrise_name, R.id.sunrise_time)
        updatePrayerTime(views, widgetData, "dhuhr", R.id.dhuhr_name, R.id.dhuhr_time)
        updatePrayerTime(views, widgetData, "asr", R.id.asr_name, R.id.asr_time)
        updatePrayerTime(views, widgetData, "maghrib", R.id.maghrib_name, R.id.maghrib_time)
        updatePrayerTime(views, widgetData, "isha", R.id.isha_name, R.id.isha_time)

        return views
    }

    private fun createErrorWidget(context: Context): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.prayer_times_widget_small)
        views.setTextViewText(R.id.widget_location, "Prayer Times")
        views.setTextViewText(R.id.current_prayer_name, "Error")
        views.setTextViewText(R.id.current_prayer_time, "Tap to refresh")
        views.setTextViewText(R.id.next_prayer_name, "")
        return views
    }

    private fun updatePrayerTime(views: RemoteViews, widgetData: SharedPreferences, prayerKey: String, nameId: Int, timeId: Int) {
        val time = widgetData.getString(prayerKey, "") ?: ""
        if (time.isNotEmpty()) {
            views.setTextViewText(nameId, prayerKey.replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() })
            views.setTextViewText(timeId, time)
        }
    }

    private fun getCurrentDate(): String {
        val formatter = java.text.SimpleDateFormat("MMM dd", java.util.Locale.getDefault())
        return formatter.format(java.util.Date())
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: android.os.Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        updateAppWidget(context, appWidgetManager, appWidgetId)
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        // Start periodic updates when first widget is added
        scheduleWidgetUpdates(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        // Cancel periodic updates when last widget is removed
        cancelWidgetUpdates(context)
    }

    private fun scheduleWidgetUpdates(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PrayerTimesWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Update every 15 minutes
        val updateInterval = 15 * 60 * 1000L // 15 minutes in milliseconds
        alarmManager.setRepeating(
            AlarmManager.RTC,
            System.currentTimeMillis() + updateInterval,
            updateInterval,
            pendingIntent
        )
    }

    private fun cancelWidgetUpdates(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PrayerTimesWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}
