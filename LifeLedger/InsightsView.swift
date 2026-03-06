import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    summarySection
                    energyChart
                    focusChart
                    sleepChart
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
            .navigationTitle("Insights")
        }
    }

    private var summarySection: some View {
        let stats = statsSummary
        return VStack(alignment: .leading, spacing: 12) {
            Text("Last 30 Days")
                .font(.headline)

            HStack(spacing: 12) {
                MetricCard(title: "Energy Avg", value: stats.energyAverageText)
                MetricCard(title: "Focus Avg", value: stats.focusAverageText)
                MetricCard(title: "Sleep %", value: stats.sleepPercentText)
            }
        }
    }

    private var energyChart: some View {
        GroupBox("Energy Trend") {
            Chart {
                ForEach(dayMetrics.compactMap { metric in
                    metric.energy.map { (metric.date, $0) }
                }, id: \.0) { date, value in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Energy", value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color("EnergyColor"))
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    PointMark(
                        x: .value("Date", date),
                        y: .value("Energy", value)
                    )
                    .foregroundStyle(Color("EnergyColor"))
                }
            }
            .chartYScale(domain: 1...5)
            .frame(height: 180)
        }
    }

    private var focusChart: some View {
        GroupBox("Focus Trend") {
            Chart {
                ForEach(dayMetrics.compactMap { metric in
                    metric.focus.map { (metric.date, $0) }
                }, id: \.0) { date, value in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Focus", value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color("FocusColor"))
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    PointMark(
                        x: .value("Date", date),
                        y: .value("Focus", value)
                    )
                    .foregroundStyle(Color("FocusColor"))
                }
            }
            .chartYScale(domain: 1...5)
            .frame(height: 180)
        }
    }

    private var sleepChart: some View {
        GroupBox("Sleep Quality") {
            Chart {
                ForEach(dayMetrics.compactMap { metric in
                    metric.sleepQuality.map { (metric.date, $0) }
                }, id: \.0) { date, value in
                    BarMark(
                        x: .value("Date", date),
                        y: .value("Sleep", value)
                    )
                    .foregroundStyle(Color("SleepColor"))
                }
            }
            .chartYScale(domain: 0...10)
            .frame(height: 180)
        }
    }

    private var dayMetrics: [DayMetric] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        guard let startDate = calendar.date(byAdding: .day, value: -29, to: today) else {
            return []
        }

        var lookup: [Date: DailyEntry] = [:]
        for entry in entries {
            let day = calendar.startOfDay(for: entry.date)
            lookup[day] = entry
        }

        return (0..<30).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }
            let entry = lookup[date]
            return DayMetric(
                date: date,
                energy: entry.map { numberValue(for: $0, key: TrackerFieldKeys.energyLevel, fallback: $0.energyLevel) },
                focus: entry.map { numberValue(for: $0, key: TrackerFieldKeys.focusQuality, fallback: $0.focusQuality) },
                sleepQuality: entry.map { numberValue(for: $0, key: TrackerFieldKeys.sleepQuality, fallback: $0.sleepQuality) }
            )
        }
    }

    private var statsSummary: StatsSummary {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let startDate = calendar.date(byAdding: .day, value: -29, to: today) ?? today

        let relevantEntries = entries.filter { entry in
            let day = calendar.startOfDay(for: entry.date)
            return day >= startDate && day <= today
        }

        let energyValues = relevantEntries.map { numberValue(for: $0, key: TrackerFieldKeys.energyLevel, fallback: $0.energyLevel) }
        let focusValues = relevantEntries.map { numberValue(for: $0, key: TrackerFieldKeys.focusQuality, fallback: $0.focusQuality) }
        let sleepValues = relevantEntries.map { numberValue(for: $0, key: TrackerFieldKeys.sleepQuality, fallback: $0.sleepQuality) }

        return StatsSummary(
            energyAverage: average(of: energyValues),
            focusAverage: average(of: focusValues),
            sleepPercent: percent(of: sleepValues, max: 10)
        )
    }

    private func average(of values: [Int]) -> Double? {
        guard !values.isEmpty else { return nil }
        let total = values.reduce(0, +)
        return Double(total) / Double(values.count)
    }

    private func percent(of values: [Int], max: Int) -> Double? {
        guard !values.isEmpty else { return nil }
        let total = values.reduce(0, +)
        return Double(total) / Double(values.count) / Double(max)
    }

    private func numberValue(for entry: DailyEntry, key: String, fallback: Int) -> Int {
        entry.intValue(for: key, default: fallback, legacy: { fallback })
    }
}

struct DayMetric: Identifiable {
    let date: Date
    let energy: Int?
    let focus: Int?
    let sleepQuality: Int?

    var id: Date { date }
}

struct StatsSummary {
    let energyAverage: Double?
    let focusAverage: Double?
    let sleepPercent: Double?

    var energyAverageText: String {
        guard let energyAverage else { return "--" }
        return String(format: "%.1f", energyAverage)
    }

    var focusAverageText: String {
        guard let focusAverage else { return "--" }
        return String(format: "%.1f", focusAverage)
    }

    var sleepPercentText: String {
        guard let sleepPercent else { return "--" }
        return String(format: "%.0f%%", sleepPercent * 100)
    }
}

struct MetricCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
