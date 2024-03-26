//
//  AboutAppView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import SwiftUI

struct AboutAppView: View {    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                GroupBox {
                    Button(action: {
                        if let url = URL(string: Constants.privacyLink) {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        SettingsItem(title: "Privacy Policy", icon: {Symbols.shield}, color: .purple, trailing: {})
                    })
                    
                    Button(action: {
                        if let url = URL(string: Constants.termsLink) {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        SettingsItem(title: "Terms Of Service", icon: {Symbols.doc_ol}, color: .cyan, trailing: {})
                    })
                }
            }
            .navigationTitle("About App")
            .padding()
        }
    }
}
