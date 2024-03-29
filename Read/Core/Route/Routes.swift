//
//  Routes.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

enum Tabs {
    case home, library, settings
}

enum Routes {
    case home
    case enterText
    case folderView(id: String, name: String)
    case aboutAppView
    case appearance
    case textToSpeech
}

extension Routes: View {
    var body: some View {
        switch self {
        case .home:
            ContentView()
        case .enterText:
            EnterTextView()
        case .folderView(let id, let name):
            FolderView(id: id, name: name)
        case .aboutAppView:
            AboutAppView()
        case .appearance:
            AppearanceView()
        case .textToSpeech:
            TextToSpeechView()
        }
    }
}

extension Routes: Hashable {
    static func == (lhs: Routes, rhs: Routes) -> Bool {
        return lhs.compareString == rhs.compareString
    }
    
    var compareString: String {
        switch self {
        case .home:
            return "home"
        case .enterText:
            return "enterText"
        case .folderView:
            return "folderView"
        case .aboutAppView:
            return "aboutAppView"
        case .appearance:
            return "appearance"
        case .textToSpeech:
            return "textToSpeech"
        }
    }
}

