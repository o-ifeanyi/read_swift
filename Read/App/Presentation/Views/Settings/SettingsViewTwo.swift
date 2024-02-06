//
//  SettingsViewTwo.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct SettingsViewTwo: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        Text("Settings View Two")
        Button("Home View Two") {
            router.push(.hometwo)
        }
        .buttonStyle(.bordered)
        Button("Pop") {
            router.pop()
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    SettingsViewTwo()
        .environment(Router.shared)
}
