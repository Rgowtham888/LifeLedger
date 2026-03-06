# Development Guide

## Project Layout
- `LifeLedger/`: main iOS app source
- `LifeLedgerWidget/`: widget extension source
- `LifeLedger.xcodeproj/`: Xcode project config
- `CHANGELOG.md`: change history

## Architecture
- UI: SwiftUI (`ContentView`, `DailyView`, `HistoryView`, `InsightsView`)
- Persistence: SwiftData model `DailyEntry`
- Form definition: single source file `TrackerFieldCatalog.swift`
- Charts: Apple `Charts` framework in `InsightsView`
- Widget: WidgetKit extension reading local defaults in free mode

## Storage Model
- Model: `DailyEntry`
- Dynamic payload:
  - `numericValuesBlob` -> JSON map `[String: Int]`
  - `textValuesBlob` -> JSON map `[String: String]`
- Data-type policy:
  - number/int only
  - text/string only
  - checkbox stored as int `0` or `1`
- Container setup: `LifeLedgerApp` creates `ModelContainer` with migration plan
- Migration file: `Migrations.swift` (currently schema v1, no stages)
- Legacy migration:
  - existing typed properties are copied once into dynamic maps (`applyLegacyMigrationIfNeeded`)
  - preserves older history while moving to config-driven fields

## DailyEntry Columns and Data Types

Active/core columns:
- `date`: `Date`
- `numericValuesBlob`: `Data` (JSON for `[String: Int]`)
- `textValuesBlob`: `Data` (JSON for `[String: String]`)
- `hasMigratedToDynamicStore`: `Bool`

Legacy compatibility columns (kept for migration/backward safety):
- `sleepQuality`: `Int`
- `digestionOK`: `Bool`
- `painDiscomfort`: `Bool`
- `acidReflux`: `Int`
- `headache`: `Int`
- `daytimeSleepy`: `Bool`
- `energyLevel`: `Int`
- `gym`: `Bool`
- `back`: `Bool`
- `legs`: `Bool`
- `shoulders`: `Bool`
- `chest`: `Bool`
- `biceps`: `Bool`
- `triceps`: `Bool`
- `forearmsGrip`: `Bool`
- `core`: `Bool`
- `addedSugar`: `Int`
- `junkMeal`: `Int`
- `lateEating`: `Bool`
- `hydrationOK`: `Bool`
- `proteinGrams`: `Int`
- `chicken`: `Bool`
- `eggs`: `Int`
- `otherMeat`: `Bool`
- `mentalClarity`: `Bool`
- `anxietyOverthinking`: `Bool`
- `learnedSomething`: `Bool`
- `readingDone`: `Bool`
- `meditationStillness`: `Bool`
- `deepWork`: `Bool`
- `focusQuality`: `Int`
- `currentTheme`: `String`
- `primaryThemeSlotUsed`: `Bool`
- `themeFollowed`: `Bool`
- `familyTime`: `Bool`
- `connectionFelt`: `Bool`
- `aloneTime`: `Bool`
- `selfCareDone`: `Bool`
- `socialInteraction`: `Bool`
- `patienceLevel`: `Int`
- `sexOccurred`: `Int`
- `feltCalm`: `Bool`
- `mood`: `Int`
- `dailyNotes`: `String`
- `cardioStepsMovement`: `Bool`

## Single-File Field Configuration
- File: `LifeLedger/TrackerFieldCatalog.swift`
- Edit only `TrackerFieldCatalog.fields`:
  - list order controls UI order
  - add/remove list rows to add/remove inputs
- Supported input formats:
  - `.incrementor(...)`
  - `.checkbox(...)` (stored as 0/1 int)
  - `.text(...)`

Entry pattern:
- `display_value`: label shown in UI
- `data_type`: `number` or `text`
- `input_type`: `incrementor` / `checkbox` / `text`

Example rows:
- `.incrementor("tea_count", displayValue: "Tea", range: 0...10, defaultNumber: 0)`
- `.checkbox("tea_taken", displayValue: "Tea Taken")`
- `.text("tea_notes", displayValue: "Tea Notes")`

## Export System
- File: `LifeLedger/DataExport.swift`
- JSON export:
  - Full payload snapshot for each `DailyEntry` (`numberValues` + `textValues`)
  - ISO-8601 date format
- CSV export:
  - Summary columns for spreadsheet analysis
- UI integration:
  - `HistoryView` toolbar `Export` menu
  - Uses `fileExporter` to save files via iOS Files picker

## Free vs Paid Signing Modes

### Free Personal Team mode (current)
- App Group entitlements removed.
- Widget runs standalone and does not share data with main app.
- Files:
  - `LifeLedger/LifeLedger.entitlements` -> empty dict
  - `LifeLedgerWidgetExtension.entitlements` -> empty dict
- Benefit: easier install on free account.
- Limitation: no shared app/widget storage.

### Paid Apple Developer mode (optional future)
- Re-enable App Groups capability for app + widget.
- Add group ID in both entitlements and Apple portal App IDs.
- Update widget and app to use `UserDefaults(suiteName: "group....")`.

## Why Data Can Seem "Lost"
- SwiftData is local in app sandbox.
- Reinstall/delete app removes local container data.
- Free provisioning often leads to frequent reinstalls during development.
- Without export or device backup, deleted local data cannot be recovered.

## Where Raw Data Exists

### On iPhone
- Inside app sandbox SwiftData SQLite store.
- Not directly browsable from normal Files app.

### On Simulator
- Under simulator app container path in `Library/Application Support/`.
- Xcode can inspect container contents while debugging.

### Practical Access
- Use in-app JSON export (implemented) for reliable raw-data extraction.

## Maintenance Checklist
- Before testing risky changes: export JSON.
- After schema changes: update `Migrations.swift`.
- Before app deletion/reinstall: export JSON/CSV.
- Keep the `LifeLedger` scheme selected when running (not widget scheme).

## Suggested Migration to Free Cloud Database

If you want cross-device durability without paid Apple services:

1. Supabase (Postgres, free tier)
2. Firebase Firestore (free tier)

Recommended migration path:
1. Keep SwiftData local as offline cache.
2. Add sync queue layer (`pending operations`).
3. Push updates to remote DB on connectivity.
4. Add pull-on-launch conflict policy (latest timestamp wins, then refine).
5. Keep JSON export as fallback backup.

This gives:
- Offline-first UX
- Better durability than local-only
- Reduced data-loss risk from reinstalls

## Immediate Next Engineering Tasks
1. Add JSON import to restore from backup.
2. Add auto-backup reminder banner (weekly).
3. Add optional cloud sync toggle.
