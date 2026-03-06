//
//  LifeLedgerApp.swift
//  LifeLedger
//
//  Created by Gowtham on 04/02/26.
//

import SwiftUI
import SwiftData

@main
struct LifeLedgerApp: App {
    private let modelContainer: ModelContainer = {
        let schema = Schema([DailyEntry.self])
        let configuration = ModelConfiguration(schema: schema)
        return try! ModelContainer(for: schema, migrationPlan: LifeLedgerMigrationPlan.self, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
