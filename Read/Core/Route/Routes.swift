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
    case hometwo
    case librarytwo
    case settingstwo
    case settingsthree
}

extension Routes: View {
    var body: some View {
        switch self {
        case .home:
            ContentView()
        case .hometwo:
            HomeViewTwo()
        case .librarytwo:
            LibraryViewTwo()
        case .settingstwo:
            SettingsViewTwo()
        case .settingsthree:
            SettingsViewThree()
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
        case .hometwo:
            return "hometwo"
        case .librarytwo:
            return "librarytwo"
        case .settingstwo:
            return "settingstwo"
        case .settingsthree:
            return "settingsthree"
        }
    }
}

