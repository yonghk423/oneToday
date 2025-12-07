package com.example.onetoday

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.example.onetoday.R
import java.time.LocalDateTime

/**
 * One Today 홈 화면 위젯 Provider
 */
class OneTodayWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // 모든 위젯 인스턴스 업데이트
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // 첫 번째 위젯이 추가될 때
    }

    override fun onDisabled(context: Context) {
        // 마지막 위젯이 제거될 때
    }

    companion object {
        // home_widget 패키지에서 사용하는 SharedPreferences 이름
        // home_widget 패키지는 "HomeWidgetPreferences"를 사용합니다
        private const val PREFS_NAME = "HomeWidgetPreferences"
        
        // 위젯 데이터 키 (WidgetService에서 사용하는 키와 동일)
        private const val KEY_HAS_GOAL = "has_goal"
        private const val KEY_GOAL_NAME = "goal_name"
        private const val KEY_REMAINING_HOURS = "remaining_hours"
        private const val KEY_REMAINING_MINUTES = "remaining_minutes"

        internal fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // home_widget 패키지의 SharedPreferences에서 데이터 읽기
            // home_widget 패키지는 MODE_PRIVATE로 SharedPreferences를 생성합니다
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            
            val hasGoal = prefs.getBoolean(KEY_HAS_GOAL, false)
            val goalName = prefs.getString(KEY_GOAL_NAME, "") ?: ""

            // RemoteViews 생성
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            // 목표가 있고, 자정이 지나지 않았는지 확인
            if (hasGoal && goalName.isNotEmpty()) {
                // 현재 시간을 기준으로 자정까지 남은 시간 계산
                val (remainingHours, remainingMinutes) = calculateRemainingTime()
                
                // 자정이 지났거나 남은 시간이 0 이하면 목표 종료
                if (remainingHours < 0 || (remainingHours == 0 && remainingMinutes <= 0)) {
                    // 목표가 만료된 경우 (자정 이후)
                    views.setViewVisibility(R.id.widget_goal_layout, android.view.View.GONE)
                    views.setViewVisibility(R.id.widget_empty_layout, android.view.View.VISIBLE)
                } else {
                    // 목표가 유효한 경우
                    views.setViewVisibility(R.id.widget_goal_layout, android.view.View.VISIBLE)
                    views.setViewVisibility(R.id.widget_empty_layout, android.view.View.GONE)
                    
                    views.setTextViewText(R.id.widget_goal_name, goalName)
                    views.setTextViewText(R.id.widget_hours, remainingHours.toString())
                    views.setTextViewText(R.id.widget_minutes, remainingMinutes.toString())
                }
            } else {
                // 목표가 없는 경우
                views.setViewVisibility(R.id.widget_goal_layout, android.view.View.GONE)
                views.setViewVisibility(R.id.widget_empty_layout, android.view.View.VISIBLE)
            }

            // 위젯 탭 시 앱 열기 위한 PendingIntent 설정
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            // 위젯 전체에 클릭 리스너 설정 (루트 레이아웃에 ID 추가 필요)
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            // 위젯 업데이트
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        
        /**
         * 현재 시간을 기반으로 자정까지 남은 시간 계산
         */
        private fun calculateRemainingTime(): Pair<Int, Int> {
            val now = LocalDateTime.now()
            val midnight = now.toLocalDate().plusDays(1).atStartOfDay()
            
            // 남은 시간 계산
            val diff = java.time.Duration.between(now, midnight)
            val totalMinutes = diff.toMinutes().toInt()
            val hours = totalMinutes / 60
            val minutes = totalMinutes % 60
            
            return Pair(hours, minutes)
        }
    }
}

