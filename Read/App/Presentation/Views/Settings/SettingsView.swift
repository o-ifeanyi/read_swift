//
//  SettingsView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Text("General")
                    .fontWeight(.semibold)
                GroupBox {
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Appearance", icon: Symbols.theme, color: .blue)
                    })
                    
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Speaking Voice", icon: Symbols.speaker, color: .pink)
                    })
                    
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Speech Rate", icon: Symbols.speed, color: .orange)
                    })
                }
                
                Text("Support")
                    .fontWeight(.semibold)
                GroupBox {
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Leave A Review", icon: Symbols.star, color: .blue)
                    })
                    
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Contact Support", icon: Symbols.question, color: .green)
                    })
                    
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Share The App", icon: Symbols.share, color: .mint)
                    })
                }
                
                Text("Legal")
                    .fontWeight(.semibold)
                GroupBox {
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Privacy Policy", icon: Symbols.shield, color: .purple)
                    })
                    
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "Terms of Service", icon: Symbols.doc_ol, color: .cyan)
                    })
                }
                
                Text("About")
                    .fontWeight(.semibold)
                GroupBox {
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "What's New", icon: Symbols.new, color: .red)
                    })
                    
                    NavigationLink(value: Routes.settingstwo, label: {
                        SettingsItem(title: "About This App", icon: Symbols.info, color: .black)
                    })
                }
                
                Spacer(minLength: 100)
            }
            .navigationTitle("Settings")
            .padding()
        }
    }
}

#Preview {
    SettingsView()
        .environment(Router.shared)
}
