# Changelog

## 2026-02-28
- Replaced hardcoded daily form with config-driven form rendering from a single file: `LifeLedger/TrackerFieldCatalog.swift`.
- Added support for three input formats:
  - incrementor
  - checkbox
  - text
- Standardized tracker payload to two persisted data types:
  - `Int` (including checkbox 0/1 values)
  - `String`
- Added dynamic per-entry storage maps in `DailyEntry` (`numericValuesBlob`, `textValuesBlob`).
- Added one-time legacy data migration into the new dynamic maps to preserve existing history.
- Updated History export to include dynamic payload format in JSON.
- Added documentation updates for field reordering/adding in `README.md` and `DEVELOPMENT.md`.

## 2026-02-26
- Added day-refresh logic so a new entry is created when the date changes (app active or significant time change).
- Introduced SwiftData migration scaffolding (schema v1 + migration plan) to preserve data across future changes.
- Updated app model container to use the migration plan.
