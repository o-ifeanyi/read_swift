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
    @Environment(SpeechService.self) private var speechService
    
    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .bottom) {
            TabView(selection: $router.selectedTab) {
                NavigationStack(path: $router.homeRoutes) {
                    HomeView()
                        .navigationTitle("Home")
                        .navigationDestination(for: Routes.self, destination: { $0 })
                }
                .tag(Tabs.home)
                .tabItem {
                    Symbols.home
                    Text("Home")
                }
                
                NavigationStack(path: $router.libraryRoutes) {
                    LibraryView()
                        .navigationTitle("Library")
                        .navigationDestination(for: Routes.self, destination: { $0 })
                }
                .tag(Tabs.library)
                .tabItem {
                    Symbols.library
                    Text("Library")
                }
                
                NavigationStack(path: $router.settingsRoutes) {
                    SettingsView()
                        .navigationTitle("Settings")
                        .navigationDestination(for: Routes.self, destination: { $0 })
                }
                .tag(Tabs.settings)
                .tabItem {
                    Symbols.setting
                    Text("Settings")
                }
            }
            
            if (speechService.state.text != nil) {
                PlayerView(
                    isPlaying: speechService.state.isPlaying,
                    onPlay: {
                        speechService.play()
                    }, onPause: {
                        speechService.pause()
                    },
                    onStop: {
                        speechService.stop()
                    }
                )
            }
            
        }
        .overlay(alignment: .top) {
            if (snackbarService.state != nil) {
                SnackbarComponent(state: snackbarService.state!)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Router.shared)
        .environment(SnackBarService.shared)
}
