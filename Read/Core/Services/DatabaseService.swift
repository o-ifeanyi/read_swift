//
//  DatabaseService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 03/02/2024.
//

import SwiftData

final class DatabaseService {
    static let shared = DatabaseService()

    var container: ModelContainer = {
        let schema = Schema([FileModel.self, FolderModel.self, WhatsNewModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create LibraryContainer: \(error)")
        }
    }()
}
