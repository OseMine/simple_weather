package de.osemine.simple_weather

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class SimpleWeatherWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.simple_weather_widget).apply {
                val temperature = widgetData.getString("temperature", "--°")
                val description = widgetData.getString("description", "Loading...")
                setTextViewText(R.id.widget_temperature, temperature)
                setTextViewText(R.id.widget_description, description)

                val bgColor = widgetData.getLong("bgColor", -1L).toInt()
                val textColor = widgetData.getLong("textColor", -1L).toInt()
                val subtextColor = widgetData.getLong("subtextColor", -1L).toInt()

                if (bgColor != -1) {
                    setInt(R.id.widget_root, "setBackgroundColor", bgColor)
                }
                if (textColor != -1) {
                    setInt(R.id.widget_temperature, "setTextColor", textColor)
                }
                if (subtextColor != -1) {
                    setInt(R.id.widget_description, "setTextColor", subtextColor)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
