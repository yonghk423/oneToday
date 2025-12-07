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
        var entries: [GoalEntry] = []
        let now = Date()
        let calendar = Calendar.current
        
        // 다음 60분 동안의 엔트리 생성 (매 분마다)
        for minuteOffset in 0..<60 {
            guard let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: now) else {
                continue
            }
            
            // 각 시간에 맞는 남은 시간 계산
            let entry = createEntryForDate(entryDate)
            entries.append(entry)
        }
        
        // 다음 업데이트는 60분 후
        guard let nextUpdate = calendar.date(byAdding: .minute, value: 60, to: now) else {
            let singleEntry = createEntryForDate(now)
            let timeline = Timeline(entries: [singleEntry], policy: .after(now))
            completion(timeline)
            return
        }
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
    
    // App Group의 UserDefaults에서 데이터 읽기
    private func loadGoalData() -> GoalEntry {
        return createEntryForDate(Date())
    }
    
    // 특정 날짜/시간에 대한 엔트리 생성 (동적 시간 계산)
    private func createEntryForDate(_ date: Date) -> GoalEntry {
        guard let defaults = UserDefaults(suiteName: appGroupId) else {
            return GoalEntry(
                date: date,
                hasGoal: false,
                goalName: "목표를 설정하세요",
                remainingHours: 0,
                remainingMinutes: 0
            )
        }
        
        let hasGoal = defaults.bool(forKey: "has_goal")
        let goalName = defaults.string(forKey: "goal_name") ?? ""
        
        // 목표가 있는 경우에만 동적 시간 계산
        if hasGoal && !goalName.isEmpty && goalName != "목표를 설정하세요" {
            // 특정 시간을 기준으로 자정까지 남은 시간 계산
            let (remainingHours, remainingMinutes) = calculateRemainingTime(for: date)
        
            // 자정이 지났거나 남은 시간이 0 이하면 목표 종료
            if remainingHours < 0 || (remainingHours == 0 && remainingMinutes <= 0) {
                // 목표가 만료된 경우 (자정 이후)
                return GoalEntry(
                    date: date,
                    hasGoal: false,
                    goalName: "목표를 설정하세요",
                    remainingHours: 0,
                    remainingMinutes: 0
                )
            }
            
            // 목표가 유효한 경우
        return GoalEntry(
                date: date,
                hasGoal: true,
            goalName: goalName,
            remainingHours: remainingHours,
            remainingMinutes: remainingMinutes
        )
        } else {
            // 목표가 없는 경우
            return GoalEntry(
                date: date,
                hasGoal: false,
                goalName: "목표를 설정하세요",
                remainingHours: 0,
                remainingMinutes: 0
            )
        }
    }
    
    // 특정 날짜를 기준으로 자정까지 남은 시간 계산
    private func calculateRemainingTime(for date: Date = Date()) -> (hours: Int, minutes: Int) {
        let calendar = Calendar.current
        
        // 다음 날 자정 시간 계산
        guard let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: date) ?? date) else {
            return (0, 0)
        }
        
        // 남은 시간 계산
        let timeInterval = midnight.timeIntervalSince(date)
        let totalMinutes = Int(timeInterval / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        return (hours, minutes)
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
