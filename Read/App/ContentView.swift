//
//  ContentView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) private var scheme
    @AppStorage(Constants.theme) private var theme = AppTheme.system
    @Environment(Router.self) private var router
    @Environment(SnackBarService.self) private var snackbarService
    
    @State private var expanded: Bool = false
    
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
            
            PlayerView(expanded: $expanded)
                .onTapGesture {
                    withAnimation(.spring) {
                        expanded = true
                    }
                }
            
            if expanded {
                SpeechScreen {
                    withAnimation(.spring) {
                        expanded = false
                    }
                }
                .transition(.push(from: .bottom))
            }
        }
        .overlay(alignment: .top) {
            if (snackbarService.state != nil) {
                SnackbarComponent(state: snackbarService.state!)
            }
        }
        .task {
            AnalyticService.shared.initialise()
        }
        .preferredColorScheme(theme.overrideTheme)
        .environment(\.colorScheme, theme.overrideTheme ?? scheme)
    }
}
