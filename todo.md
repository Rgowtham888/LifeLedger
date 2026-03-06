# TODO: Supabase Integration Plan

## Goal
Add a free, cloud-based database (Supabase/Postgres) to LifeLedger for cross-device durability and backup.

## Steps

1. **Create Supabase Project**
   - Sign up at supabase.com
   - Create a new project (free tier)
   - Note database URL, API keys

2. **Design Database Schema**
   - Mirror `DailyEntry` model
   - Fields: date, numericValuesBlob, textValuesBlob, plus legacy fields if needed
   - Set up tables for user entries

3. **Set Up Swift Client**
   - Add Supabase Swift SDK to Xcode project
   - Configure with project URL and API keys

4. **Sync Logic**
   - Implement offline-first: keep SwiftData local
   - Add sync queue for pending operations
   - Push updates to Supabase on connectivity
   - Pull latest data on app launch (conflict policy: latest timestamp wins)

5. **Backup/Restore UI**
   - Add import/export options for cloud backup
   - Integrate with HistoryView export menu

6. **Testing**
   - Test sync, backup, and restore flows
   - Validate data integrity across devices

7. **Documentation**
   - Update README and DEVELOPMENT.md with Supabase setup and usage

## Notes
- Keep JSON export as fallback backup
- Free tier is sufficient for personal use
- No paid Apple services required

---

## Immediate Next Tasks
- [ ] Create Supabase project and database
- [ ] Design schema for DailyEntry
- [ ] Add Supabase Swift SDK to project
- [ ] Implement sync queue and cloud sync logic
- [ ] Add backup/restore UI
- [ ] Update documentation
