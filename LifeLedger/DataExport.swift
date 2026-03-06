import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DataExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json, .commaSeparatedText, .plainText] }

    let data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        self.data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

enum DailyEntryExporter {
    enum ExportError: LocalizedError {
        case encodingFailed

        var errorDescription: String? {
            switch self {
            case .encodingFailed:
                return "Failed to encode entries for export."
            }
        }
    }

    struct Snapshot: Codable {
        let date: Date
        let numberValues: [String: Int]
        let textValues: [String: String]
    }

    static func makeJSON(entries: [DailyEntry]) throws -> Data {
        let snapshots = entries
            .sorted { $0.date < $1.date }
            .map { entry in
                entry.applyLegacyMigrationIfNeeded()
                return Snapshot(entry: entry)
            }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(snapshots) else {
            throw ExportError.encodingFailed
        }
        return data
    }

    static func makeCSV(entries: [DailyEntry]) -> Data {
        var rows = [String]()
        rows.append("date,sleepQuality,energyLevel,focusQuality,mood,proteinGrams,addedSugar,junkMeal,lateEating,hydrationOK,gym,cardioStepsMovement,currentTheme,dailyNotes")

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        for entry in entries.sorted(by: { $0.date < $1.date }) {
            entry.applyLegacyMigrationIfNeeded()
            let row = [
                formatter.string(from: entry.date),
                "\(entry.intValue(for: TrackerFieldKeys.sleepQuality))",
                "\(entry.intValue(for: TrackerFieldKeys.energyLevel))",
                "\(entry.intValue(for: TrackerFieldKeys.focusQuality))",
                "\(entry.intValue(for: TrackerFieldKeys.mood))",
                "\(entry.intValue(for: TrackerFieldKeys.proteinGrams))",
                "\(entry.intValue(for: TrackerFieldKeys.addedSugar))",
                "\(entry.intValue(for: TrackerFieldKeys.junkMeal))",
                "\(entry.intValue(for: TrackerFieldKeys.lateEating))",
                "\(entry.intValue(for: TrackerFieldKeys.hydrationOK))",
                "\(entry.intValue(for: TrackerFieldKeys.gym))",
                "\(entry.intValue(for: TrackerFieldKeys.cardioStepsMovement))",
                csvSafe(entry.textValue(for: TrackerFieldKeys.currentTheme)),
                csvSafe(entry.textValue(for: TrackerFieldKeys.dailyNotes))
            ].joined(separator: ",")
            rows.append(row)
        }

        return rows.joined(separator: "\n").data(using: .utf8) ?? Data()
    }

    private static func csvSafe(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
}

private extension DailyEntryExporter.Snapshot {
    init(entry: DailyEntry) {
        self.date = entry.date
        self.numberValues = entry.decodeNumbersForExport()
        self.textValues = entry.decodeTextsForExport()
    }
}

private extension DailyEntry {
    func decodeNumbersForExport() -> [String: Int] {
        (try? JSONDecoder().decode([String: Int].self, from: numericValuesBlob)) ?? [:]
    }

    func decodeTextsForExport() -> [String: String] {
        (try? JSONDecoder().decode([String: String].self, from: textValuesBlob)) ?? [:]
    }
}
