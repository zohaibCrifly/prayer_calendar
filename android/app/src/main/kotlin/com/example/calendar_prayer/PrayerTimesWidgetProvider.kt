package com.example.calendar_prayer

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
        val views = RemoteViews(context.packageName, R.layout.prayer_times_widget)

        try {
            // Get widget dimensions to determine layout
            val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
            val width = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
            val height = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

            // Update basic info
            val location = widgetData.getString("location", "Current Location") ?: "Current Location"
            val lastUpdated = widgetData.getString("lastUpdated", "") ?: ""

            views.setTextViewText(R.id.widget_location, location)
            views.setTextViewText(R.id.widget_date, getCurrentDate())

            // Update current prayer
            val currentPrayer = widgetData.getString("currentPrayer", "") ?: ""
            val currentPrayerTime = widgetData.getString("currentPrayerTime", "") ?: ""

            if (currentPrayer.isNotEmpty()) {
                views.setTextViewText(R.id.current_prayer_name, currentPrayer)
                views.setTextViewText(R.id.current_prayer_time, currentPrayerTime)
            }

            // Update next prayer
            val nextPrayer = widgetData.getString("nextPrayer", "") ?: ""
            val nextPrayerTime = widgetData.getString("nextPrayerTime", "") ?: ""
            val timeToNext = widgetData.getString("timeToNext", "") ?: ""

            if (nextPrayer.isNotEmpty()) {
                views.setTextViewText(R.id.next_prayer_name, nextPrayer)
                views.setTextViewText(R.id.next_prayer_time, nextPrayerTime)
                if (timeToNext.isNotEmpty()) {
                    views.setTextViewText(R.id.time_remaining, "in $timeToNext")
                }
            }

            // Show prayer times grid for larger widgets
            if (width >= 300 && height >= 200) {
                views.setViewVisibility(R.id.prayer_times_grid, View.VISIBLE)
                
                // Update all prayer times
                updatePrayerTime(views, widgetData, "fajr", R.id.fajr_name, R.id.fajr_time)
                updatePrayerTime(views, widgetData, "dhuhr", R.id.dhuhr_name, R.id.dhuhr_time)
                updatePrayerTime(views, widgetData, "asr", R.id.asr_name, R.id.asr_time)
                updatePrayerTime(views, widgetData, "maghrib", R.id.maghrib_name, R.id.maghrib_time)
                updatePrayerTime(views, widgetData, "isha", R.id.isha_name, R.id.isha_time)
                updatePrayerTime(views, widgetData, "sunrise", R.id.sunrise_name, R.id.sunrise_time)
            } else {
                views.setViewVisibility(R.id.prayer_times_grid, View.GONE)
            }

            // Set up click intent to open the app
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.current_prayer_container, pendingIntent)

        } catch (e: Exception) {
            Log.e("PrayerWidget", "Error updating widget", e)
            // Show error state
            views.setTextViewText(R.id.widget_location, "Prayer Times")
            views.setTextViewText(R.id.current_prayer_name, "Error")
            views.setTextViewText(R.id.current_prayer_time, "Tap to refresh")
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
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
}
