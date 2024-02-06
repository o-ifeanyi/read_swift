//
//  ContentView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(Router.self) private var router
    @Environment(SnackBarService.self) private var snackbarService
    
    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .bottom) {
            TabView(selection: $router.selectedTab) {
                NavigationStack(path: $router.homeRoutes) {
                    HomeView()
                        .navigationDestination(for: Routes.self, destination: { $0 })
                }
                .tag(Tabs.home)
                .tabItem {
                    Symbols.home
                    Text("Home")
                }
                
                NavigationStack(path: $router.libraryRoutes) {
                    LibraryView()
                        .navigationDestination(for: Routes.self, destination: { $0 })
                }
                .tag(Tabs.library)
                .tabItem {
                    Symbols.library
                    Text("Library")
                }
                
                NavigationStack(path: $router.settingsRoutes) {
                    SettingsView()
                        .navigationDestination(for: Routes.self, destination: { $0 })
                }
                .tag(Tabs.settings)
                .tabItem {
                    Symbols.setting
                    Text("Settings")
                }
            }
            
            PlayerView()
        }
        .overlay(alignment: .top) {
            if (snackbarService.state != nil) {
                SnackbarComponent(state: snackbarService.state!)
            }
        }
    }
}
