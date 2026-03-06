import Foundation
import SwiftData

enum LifeLedgerSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [DailyEntry.self]
    }
}

enum LifeLedgerMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [LifeLedgerSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
