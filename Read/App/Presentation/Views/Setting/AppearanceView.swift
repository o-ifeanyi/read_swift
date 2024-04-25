//
//  AppearanceView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct AppearanceView: View {
    @Environment(SettingsViewModel.self) private var settingsVM
    @AppStorage(Constants.theme) private var theme = AppTheme.system
    @AppStorage(Constants.displayStyle) private var style = DisplayStyle.grid
    
    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)

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
                
                if UIApplication.shared.supportsAlternateIcons {
                    Text("Change Icon")
                        .fontWeight(.semibold)
                    
                    GroupBox {
                        LazyVGrid(columns: gridColumn) {
                            ForEach(settingsVM.state.iconNames, id: \.self) { icon in
                                Image(uiImage: UIImage(named: icon ?? "AppIconRed") ?? .init())
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(height: (UIScreen.width - 70) / 3)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        UIApplication.shared.setAlternateIconName(icon) { error in
                                            if let error = error {
                                                AppStateService.shared.displayMessage(error.localizedDescription)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Appearance")
            .padding()
        }
    }
}

