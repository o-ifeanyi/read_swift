//
//  VoiceSelectorView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import SwiftUI
import AVFAudio

struct VoiceSelectorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SpeechService.self) private var speechService
    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
    @Binding var showVoicesSheet: Bool
    let onTap: (_ voice: AVSpeechSynthesisVoice) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    LazyVGrid(columns: gridColumn) {
                        ForEach(speechService.state.voices, id: \.identifier) { voice in
                            
                            
                            let gender = if voice.gender.rawValue == 0 {
                                "unknown"
                            } else if voice.gender.rawValue == 1 {
                                "male"
                            } else {
                                "female"
                            }
                            let flag = voice.language.flag
                            GridTileView(asset: flag != nil ? Text(flag!) : nil, title: voice.name, subtitle: gender)
                                .onTapGesture { onTap(voice) }
                        }
                    }
                }
            }
            .navigationTitle("Select Voice")
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
