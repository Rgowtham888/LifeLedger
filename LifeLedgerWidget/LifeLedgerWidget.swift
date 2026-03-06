import WidgetKit
import SwiftUI

struct LifeLedgerWidgetEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let todayCount: Int
    let isStandalone: Bool
}

struct LifeLedgerWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> LifeLedgerWidgetEntry {
        LifeLedgerWidgetEntry(date: Date(), streak: 3, todayCount: 1, isStandalone: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (LifeLedgerWidgetEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LifeLedgerWidgetEntry>) -> Void) {
        let entry = loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date().addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadEntry() -> LifeLedgerWidgetEntry {
        let defaults = UserDefaults.standard
        let streak = defaults.integer(forKey: "streak")
        let todayCount = defaults.integer(forKey: "todayCount")
        return LifeLedgerWidgetEntry(date: Date(), streak: streak, todayCount: todayCount, isStandalone: true)
    }
}

struct LifeLedgerWidgetView: View {
    let entry: LifeLedgerWidgetEntry

    var body: some View {
        GeometryReader { proxy in
            let bannerHeight = proxy.size.height * 1.25

            ZStack {
                Color(red: 0.82, green: 0.90, blue: 0.84)

                Image("WidgetBanner")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: bannerHeight)
                    .offset(y: -12)

                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("The data says you showed up — \(entry.streak) days straight")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.black)

                        if entry.todayCount > 0 {
                            Text("Today: logged \(entry.todayCount) times")
                                .font(.system(size: 10))
                                .foregroundStyle(.black.opacity(0.8))
                        } else {
                            Text("Nothing logged yet today")
                                .font(.system(size: 10))
                                .foregroundStyle(.black.opacity(0.8))
                        }

                        if entry.isStandalone {
                            Text("Standalone widget mode")
                                .font(.system(size: 9))
                                .foregroundStyle(.black.opacity(0.65))
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct LifeLedgerWidget: Widget {
    let kind: String = "LifeLedgerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifeLedgerWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                LifeLedgerWidgetView(entry: entry)
                    .containerBackground(Color(red: 0.82, green: 0.90, blue: 0.84), for: .widget)
            } else {
                LifeLedgerWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("LifeLedger Banner")
        .description("Quick glance at your streak and today’s logs.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    LifeLedgerWidget()
} timeline: {
    LifeLedgerWidgetEntry(date: .now, streak: 5, todayCount: 1, isStandalone: false)
}
