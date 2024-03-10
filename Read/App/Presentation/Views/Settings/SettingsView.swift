//
//  SettingsView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Router.self) private var router
    @Environment(SpeechService.self) private var speechService
    @State private var showWhatsNew: Bool = false
    private var storeLink = URL(string: "https://www.hackingwithswift.com")!
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Text("General")
                    .fontWeight(.semibold)
                GroupBox {
                    NavigationLink(value: Routes.appearance, label: {
                        SettingsItem(title: "Appearance", icon: {Symbols.theme}, color: .blue, trailing: {})
                    })
                    
                    NavigationLink(value: Routes.textToSpeech, label: {
                        SettingsItem(title: "Text To Speech", icon: {Symbols.waveform}, color: .pink, trailing: {})
                    })
                }
                
                Text("Support")
                    .fontWeight(.semibold)
                GroupBox {
                    Link(destination: storeLink, label: {
                        SettingsItem(title: "Leave A Review", icon: {Symbols.star}, color: .blue, trailing: {})
                    })
                    
                    Button(action: {
                        let email = "ifeanyi@gmail.com"
                        if let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        SettingsItem(title: "Contact Support", icon: {Symbols.question}, color: .green, trailing: {})
                    })
                    
                    ShareLink(item: storeLink) {
                        SettingsItem(title: "Share App", icon: {Symbols.share}, color: .orange, trailing: {})
                    }
                }
                
                Text("About")
                    .fontWeight(.semibold)
                GroupBox {
                    Button(action: {
                        showWhatsNew = true
                    }, label: {
                        SettingsItem(title: "What's New", icon: {Symbols.new}, color: .red, trailing: {})
                    })
                    
                    NavigationLink(value: Routes.aboutAppView, label: {
                        SettingsItem(title: "About App", icon: {Symbols.info}, color: .black, trailing: {})
                    })
                }
                
                if Bundle.appVersion != nil {
                    HStack {
                        Spacer()
                        Text("VER \(Bundle.appVersion!)")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
                
                Spacer(minLength: 100)
            }
            .navigationTitle("Settings")
            .padding()
        }
        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView()
                .presentationDetents([.medium, .large])
        }
        .task {
            speechService.initTTSVoices()
        }
    }
}
