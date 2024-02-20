//
//  AboutAppView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import SwiftUI

struct AboutAppView: View {
    private var storeLink = URL(string: "https://www.hackingwithswift.com")!
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                GroupBox {
                    Link(destination: storeLink, label: {
                        SettingsItem(title: "Privacy Policy", icon: {Symbols.shield}, color: .purple, trailing: {})
                    })
                    
                    Link(destination: storeLink, label: {
                        SettingsItem(title: "Terms Of Service", icon: {Symbols.doc_ol}, color: .cyan, trailing: {})
                    })
                }
            }
            .navigationTitle("About App")
            .padding()
        }
    }
}

#Preview {
    AboutAppView()
}
