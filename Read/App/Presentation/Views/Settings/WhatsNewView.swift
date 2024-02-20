//
//  WhatsNewView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsViewModel.self) private var settingsVM
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(settingsVM.state.whatsNew) { whatsNew in
                    GroupBox(
                        label: Text("🚀 Version \(whatsNew.id)")
                            .font(.title3)
                            .fontWeight(.semibold),
                        content: {
                            VStack(alignment: .leading, spacing: 10) {
                                Spacer(minLength: 10)
                                ForEach(whatsNew.features.sorted(by: { first, second in
                                    first.id < second.id
                                })) { feature in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(feature.title)
                                                .fontWeight(.semibold)
                                                .multilineTextAlignment(.leading)
                                            Text(feature.body)
                                                .font(.subheadline)
                                                .multilineTextAlignment(.leading)
                                            
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("What's New")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
