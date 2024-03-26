//
//  AppearanceView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct AppearanceView: View {
    @AppStorage(Constants.theme) private var theme = AppTheme.system
    @AppStorage(Constants.displayStyle) private var style = DisplayStyle.grid
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                GroupBox {
                    SettingsItem(title: "Theme Mode", icon: {
                        switch theme {
                        case .system:
                            Symbols.theme
                        case .dark:
                            Symbols.dark
                        case .light:
                            Symbols.light
                        }
                    }, color: .purple, trailing: {
                        Picker("Theme Mode", selection: $theme) {
                            ForEach(AppTheme.allCases) { item in
                                Text(item.name)
                                    .tag(item)
                            }
                        }
                        .pickerStyle(.menu)
                    })
                    SettingsItem(title: "Display Style", icon: {
                        switch style {
                        case .list:
                            Symbols.listView
                        case .grid:
                            Symbols.gridView
                        }
                    }, color: .pink, trailing: {
                        Picker("Display Style", selection: $style) {
                            ForEach(DisplayStyle.allCases) { item in
                                Text(item.name)
                                    .tag(item)
                            }
                        }
                        .pickerStyle(.menu)
                    })
                }
                
            }
            .navigationTitle("Appearance")
            .padding()
        }
    }
}

#Preview {
    AppearanceView()
}
