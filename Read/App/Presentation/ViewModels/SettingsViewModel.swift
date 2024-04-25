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
    var iconNames: [String?] = [nil]
}

@MainActor
@Observable
final class SettingsViewModel {
    var modelContext: ModelContext
    private (set) var state = SettingsState()
    var showWhatsNew: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        checkWhatsNew(id: latestUpdate.id)
        getAllUpdates()
        getAlternateIconNames()
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
    
    func getAlternateIconNames(){
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
            
            for (_, value) in alternateIcons {
                //Accessing the name of icon list inside the dictionary
                guard let iconList = value as? Dictionary<String,Any> else { return }
                //Accessing the name of icon files
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                else { return }
                //Accessing the name of the icon
                guard let icon = iconFiles.first else { return }
                state.iconNames.append(icon)
            }
        }
    }
}
