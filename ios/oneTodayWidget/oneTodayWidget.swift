//
//  oneTodayWidget.swift
//  oneTodayWidget
//
//  Created by yonghee on 11/29/25.
//

import WidgetKit
import SwiftUI

// 위젯에 표시할 데이터 구조
struct GoalEntry: TimelineEntry {
    let date: Date
    let hasGoal: Bool
    let goalName: String
    let remainingHours: Int
    let remainingMinutes: Int
}

// 위젯 데이터를 제공하는 Provider
struct Provider: TimelineProvider {
    // App Group ID (Flutter와 동일해야 함)
    let appGroupId = "group.com.smileDragon.onetoday"
    
    func placeholder(in context: Context) -> GoalEntry {
        GoalEntry(
            date: Date(),
            hasGoal: false,
            goalName: "목표를 설정하세요",
            remainingHours: 0,
            remainingMinutes: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (GoalEntry) -> ()) {
        completion(loadGoalData())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoalEntry>) -> ()) {
        let entry = loadGoalData()
        
        // 1분마다 업데이트
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    // App Group의 UserDefaults에서 데이터 읽기
    private func loadGoalData() -> GoalEntry {
        guard let defaults = UserDefaults(suiteName: appGroupId) else {
            return GoalEntry(
                date: Date(),
                hasGoal: false,
                goalName: "목표를 설정하세요",
                remainingHours: 0,
                remainingMinutes: 0
            )
        }
        
        let hasGoal = defaults.bool(forKey: "has_goal")
        let goalName = defaults.string(forKey: "goal_name") ?? "목표를 설정하세요"
        let remainingHours = defaults.integer(forKey: "remaining_hours")
        let remainingMinutes = defaults.integer(forKey: "remaining_minutes")
        
        return GoalEntry(
            date: Date(),
            hasGoal: hasGoal,
            goalName: goalName,
            remainingHours: remainingHours,
            remainingMinutes: remainingMinutes
        )
    }
}

// 위젯 UI
struct oneTodayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if entry.hasGoal && !entry.goalName.isEmpty && entry.goalName != "목표를 설정하세요" {
            // 목표가 있는 경우
            VStack(alignment: .leading, spacing: 8) {
                Text("오늘의 목표")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.388, green: 0.4, blue: 0.945))
                
                Text(entry.goalName)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                // 시간과 분을 더 컴팩트하게 표시 (숫자 생략 방지)
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    // 시간 영역
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(entry.remainingHours)")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color(red: 0.388, green: 0.4, blue: 0.945))
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        
                        Text("시간")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // 분 영역
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(entry.remainingMinutes)")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color(red: 0.388, green: 0.4, blue: 0.945))
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        
                        Text("분")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("자정까지")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .widgetURL(URL(string: "onetoday://"))
        } else {
            // 목표가 없는 경우
            VStack {
                Text("목표를 설정하세요")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .widgetURL(URL(string: "onetoday://"))
        }
    }
}

// 위젯 정의
struct oneTodayWidget: Widget {
    let kind: String = "oneTodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            oneTodayWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("One Today")
        .description("오늘의 목표와 남은 시간을 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
