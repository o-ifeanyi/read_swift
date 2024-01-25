//
//  Router.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

@Observable
final class Router {
    static let shared = Router()
    
    var homeRoutes = [Routes]()
    var libraryRoutes = [Routes]()
    var settingsRoutes = [Routes]()
    
    var selectedTab: Tabs = .home
    
    func push(_ screen: Routes) {
        switch selectedTab {
        case .home:
            homeRoutes.append(screen)
        case .library:
            libraryRoutes.append(screen)
        case .settings:
            settingsRoutes.append(screen)
        }
        
    }
    
    func pushReplacement(_ screen: Routes) {
        switch selectedTab {
        case .home:
            if homeRoutes.isEmpty {
                homeRoutes.append(screen)
            } else {
                homeRoutes[homeRoutes.count - 1] = screen
            }
        case .library:
            if libraryRoutes.isEmpty {
                libraryRoutes.append(screen)
            } else {
                libraryRoutes[libraryRoutes.count - 1] = screen
            }
        case .settings:
            if settingsRoutes.isEmpty {
                settingsRoutes.append(screen)
            } else {
                settingsRoutes[settingsRoutes.count - 1] = screen
            }
        }
        
    }
    
    func pop() {
        switch selectedTab {
        case .home:
            homeRoutes.removeLast()
        case .library:
            libraryRoutes.removeLast()
        case .settings:
            settingsRoutes.removeLast()
        }
    }

    func reset() {
        switch selectedTab {
        case .home:
            homeRoutes = []
        case .library:
            libraryRoutes = []
        case .settings:
            settingsRoutes = []
        }
    }
}
