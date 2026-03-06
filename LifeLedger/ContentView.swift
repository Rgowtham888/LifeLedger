//
//  ContentView.swift
//  LifeLedger
//
//  Created by Gowtham on 04/02/26.
//
import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @State private var showLanding = true

    var body: some View {
        ZStack {
            TabView {
                DailyView()
                    .tabItem {
                        Label("Daily", systemImage: "checklist")
                    }

                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "calendar")
                    }

                InsightsView()
                    .tabItem {
                        Label("Insights", systemImage: "chart.xyaxis.line")
                    }
            }

            if showLanding {
                LandingView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            showLanding = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.35)) {
                    showLanding = false
                }
            }
        }
    }
}

struct DailyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]

    @State private var todayEntry: DailyEntry?

    var body: some View {
        NavigationStack {
            Group {
                if let entry = todayEntry {
                    DailyEntryForm(entry: entry)
                } else {
                    ProgressView("Loading today...")
                }
            }
            .navigationTitle("Daily Tracker")
            .onAppear {
                loadOrCreateToday()
                entries.forEach { $0.applyLegacyMigrationIfNeeded() }
                WidgetMetricsStore.update(from: entries)
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    loadOrCreateToday()
                    entries.forEach { $0.applyLegacyMigrationIfNeeded() }
                    WidgetMetricsStore.update(from: entries)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                loadOrCreateToday()
                WidgetMetricsStore.update(from: entries)
            }
        }
    }

    private func loadOrCreateToday() {
        if let existing = entries.first(where: { $0.isSameDay(as: .now) }) {
            existing.applyLegacyMigrationIfNeeded()
            todayEntry = existing
            return
        }

        let newEntry = DailyEntry(date: .now)
        newEntry.applyLegacyMigrationIfNeeded()
        modelContext.insert(newEntry)
        todayEntry = newEntry
        WidgetMetricsStore.update(from: entries + [newEntry])
    }
}

struct DailyEntryForm: View {
    @Bindable var entry: DailyEntry

    var body: some View {
        Form {
            Section("Tracker Fields") {
                ForEach(TrackerFieldCatalog.fields) { field in
                    switch field.inputType {
                    case .incrementor:
                        IncrementorFieldRow(
                            title: field.displayValue,
                            value: Binding(
                                get: { entry.intValue(for: field.key, default: field.defaultNumber) },
                                set: { entry.setIntValue($0, for: field.key) }
                            ),
                            range: field.range ?? 0...100
                        )
                    case .checkbox:
                        Toggle(
                            field.displayValue,
                            isOn: Binding(
                                get: { entry.intValue(for: field.key, default: 0) == 1 },
                                set: { entry.setIntValue($0 ? 1 : 0, for: field.key) }
                            )
                        )
                    case .text:
                        TextField(
                            field.displayValue,
                            text: Binding(
                                get: { entry.textValue(for: field.key) },
                                set: { entry.setTextValue($0, for: field.key) }
                            ),
                            axis: field.key == TrackerFieldKeys.dailyNotes ? .vertical : .horizontal
                        )
                        .lineLimit(field.key == TrackerFieldKeys.dailyNotes ? 3...8 : 1...1)
                    }
                }
            }
        }
        .onAppear {
            entry.applyLegacyMigrationIfNeeded()
        }
    }
}

struct IncrementorFieldRow: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        Stepper(value: $value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value)")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct LandingView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.ignoresSafeArea()
                Image("LandingPage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .ignoresSafeArea()
            }
        }
    }
}
