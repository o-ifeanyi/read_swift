//
//  ReadApp.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import SwiftData

@main
struct ReadApp: App {
    let database = DatabaseService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(Router.shared)
                .environment(SnackBarService.shared)
                .environment(SpeechService.shared)
                .environment(LibraryViewModel(modelContext: database.container.mainContext))
                .environment(SettingsViewModel(modelContext: database.container.mainContext))
        }
        .modelContainer(database.container)
    }
}
