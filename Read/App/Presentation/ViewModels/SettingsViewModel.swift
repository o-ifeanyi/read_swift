//
//  SettingsViewModel.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import Foundation
import SwiftData

struct SettingsState {
    var whatsNew: [WhatsNewModel] = []
}

@MainActor
@Observable
final class SettingsViewModel {
    var modelContext: ModelContext
    private (set) var state = SettingsState()
    var showWhatsNew: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        print("SETTINGS INIT RAN")
        checkWhatsNew(id: latestUpdate.id)
        getAllUpdates()
    }
    
    func checkWhatsNew(id: String) {
        let descriptor = FetchDescriptor<WhatsNewModel>(
            predicate: #Predicate<WhatsNewModel> { $0.id == id }
        )
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        if count == 0 {
            modelContext.insert(latestUpdate)
            showWhatsNew = true
        }
    }
    
    func getAllUpdates() {
        do {
            let descriptor = FetchDescriptor<WhatsNewModel>(
                sortBy: [SortDescriptor(\.id)]
            )
            let whatsNew = try modelContext.fetch(descriptor)
            state.whatsNew = whatsNew.reversed()
        } catch {
            print(error)
        }
    }
}
