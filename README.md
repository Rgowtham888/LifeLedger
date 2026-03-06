# LifeLedger

LifeLedger is an iOS habit/health tracker built with SwiftUI + SwiftData.

## Current Status
- App runs on iPhone with free Apple Personal Team signing.
- Widget is enabled in standalone mode for free accounts.
- App Group sharing is disabled in free mode (no shared storage between app and widget).

## Features
- Config-driven daily tracker form (single file controls order/inputs)
- History list with editable past entries
- Insights charts (energy, focus, sleep)
- Widget banner (standalone mode on free account)
- Data export from History:
  - JSON (full entry payload)
  - CSV (summary fields)

## Data Storage
- Primary store: SwiftData local persistent store on device.
- Data is local to app sandbox.
- Tracker payload is stored as only 2 data types:
  - `Int` (includes incrementors and checkbox 0/1 values)
  - `String` (text fields)
- Deleting the app deletes sandbox data unless restored from device backup.

## Reorder/Add Fields (Single File)
- Edit [`/Users/gowtham/personal_projects1/LifeLedger/LifeLedger/TrackerFieldCatalog.swift`](/Users/gowtham/personal_projects1/LifeLedger/LifeLedger/TrackerFieldCatalog.swift).
- `TrackerFieldCatalog.fields` order = UI order.
- Reorder lines to reorder UI.
- Append a new line to add a new field.

Examples:
- `.incrementor("tea_count", displayValue: "Tea", range: 0...10, defaultNumber: 0)`
- `.checkbox("tea_taken", displayValue: "Tea Taken")`
- `.text("tea_notes", displayValue: "Tea Notes")`

Equivalent format mapping:
- `display_value: Tea`, `data_type: number/int`, `input_type: incrementor`
- `display_value: Tea Taken`, `data_type: number/int (0 or 1)`, `input_type: checkbox`
- `display_value: Tea Notes`, `data_type: text/string`, `input_type: text`

## Export / Backup (Recommended)
1. Open `History` tab.
2. Tap `Export` in top-right.
3. Choose:
   - `Export JSON (full data)`
   - `Export CSV (summary)`
4. Save to Files/iCloud Drive.

Do weekly export if you use a free developer account and reinstall frequently.

## Recovery Notes
- If app was deleted and no backup/export exists, data is typically not recoverable.
- Possible recovery paths:
  - Restore iPhone from an older Finder/iTunes/iCloud backup.
  - Check if an exported JSON/CSV file exists in Files/iCloud/Drive.

## Build
- Open `LifeLedger.xcodeproj` in Xcode.
- Select `LifeLedger` scheme.
- Run on iPhone or simulator.

## Tech Stack
- SwiftUI
- SwiftData
- WidgetKit
- Charts

## Next Suggested Improvement
- Add automatic cloud sync + backup restore:
  - CloudKit with SwiftData (Apple-native), or
  - Supabase/Firebase (free tier backend).
