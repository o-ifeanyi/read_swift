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
        VStack {
            NavigationLink("Settings View Two", value: Routes.settingstwo)
                .buttonStyle(.bordered)
            Button("Settings View Two") {
                router.push(.settingstwo)
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environment(Router.shared)
}
