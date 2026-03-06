import Foundation
import SwiftData
import WidgetKit

enum WidgetMetricsStore {
    static func update(from entries: [DailyEntry]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        let todayCount = entries.filter { calendar.isDate($0.date, inSameDayAs: today) }.count
        let streak = currentStreak(from: entries, calendar: calendar)

        let defaults = UserDefaults.standard
        defaults.set(streak, forKey: "streak")
        defaults.set(todayCount, forKey: "todayCount")
        defaults.set(Date(), forKey: "updatedAt")

        WidgetCenter.shared.reloadAllTimelines()
    }

    private static func currentStreak(from entries: [DailyEntry], calendar: Calendar) -> Int {
        let daysWithEntries = Set(entries.map { calendar.startOfDay(for: $0.date) })
        var streak = 0
        var day = calendar.startOfDay(for: .now)

        while daysWithEntries.contains(day) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else {
                break
            }
            day = previous
        }
        return streak
    }
}
