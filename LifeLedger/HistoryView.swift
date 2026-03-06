//
//  HistoryView.swift
//  LifeLedger
//
//  Created by Gowtham on 08/02/26.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct HistoryView: View {
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]
    @State private var exportDocument: DataExportDocument?
    @State private var exportType: UTType = .json
    @State private var exportFilename = "lifeledger_export.json"
    @State private var isExporting = false
    @State private var exportErrorMessage: String?

    var body: some View {
        NavigationStack {
            List(entries) { entry in
                NavigationLink {
                    DailyEntryForm(entry: entry)
                        .navigationTitle(formattedDate(entry.date))
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formattedDate(entry.date))
                        let theme = entry.textValue(for: TrackerFieldKeys.currentTheme) {
                            entry.currentTheme
                        }
                        Text(theme.isEmpty ? "No theme" : theme)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Export", systemImage: "square.and.arrow.up") {
                        Button("Export JSON (full data)") {
                            prepareJSONExport()
                        }
                        Button("Export CSV (summary)") {
                            prepareCSVExport()
                        }
                    }
                }
            }
            .fileExporter(
                isPresented: $isExporting,
                document: exportDocument,
                contentType: exportType,
                defaultFilename: exportFilename
            ) { result in
                if case let .failure(error) = result {
                    exportErrorMessage = error.localizedDescription
                }
            }
            .alert("Export Failed", isPresented: Binding(
                get: { exportErrorMessage != nil },
                set: { if !$0 { exportErrorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { exportErrorMessage = nil }
            } message: {
                Text(exportErrorMessage ?? "Unknown error")
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    private func prepareJSONExport() {
        do {
            let data = try DailyEntryExporter.makeJSON(entries: entries)
            exportDocument = DataExportDocument(data: data)
            exportType = .json
            exportFilename = "lifeledger_export_\(Date().formatted(.iso8601.year().month().day())).json"
            isExporting = true
        } catch {
            exportErrorMessage = error.localizedDescription
        }
    }

    private func prepareCSVExport() {
        let data = DailyEntryExporter.makeCSV(entries: entries)
        exportDocument = DataExportDocument(data: data)
        exportType = .commaSeparatedText
        exportFilename = "lifeledger_export_\(Date().formatted(.iso8601.year().month().day())).csv"
        isExporting = true
    }
}
