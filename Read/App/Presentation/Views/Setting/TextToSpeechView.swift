//
//  TextToSpeechView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import SwiftUI
import AVFAudio

struct TextToSpeechView: View {
    @AppStorage(Constants.speechRate) private var speechRate = 0.5
    @AppStorage(Constants.voice) private var voiceIdentifier = ""
    @Environment(SpeechService.self) private var speechService
    @State private var showVoicesSheet: Bool = false
    @State private var showRateSheet: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                GroupBox {
                    Button(action: {
                        showVoicesSheet = true
                    }, label: {
                        SettingsItem(title: "Speaker Voice", icon: {Symbols.speaker}, color: .orange, trailing: {
                            let voice = speechService.state.voices.first(where: { $0.identifier == voiceIdentifier}) ?? AVSpeechSynthesisVoice(language: "en-GB")
                            Text(voice?.name ?? "")
                                .lineLimit(1)
                        })
                    })
                    
                    Button(action: {
                        showRateSheet = true
                    }, label: {
                        SettingsItem(title: "Speech Rate", icon: {Symbols.speed}, color: .blue, trailing: {
                            Text(String(format: "%.1f", speechRate))
                        })
                    })
                }
            }
            .navigationTitle("Text To Speech")
            .padding()
        }
        .sheet(isPresented: $showVoicesSheet) {
            VoiceSelectorSheet(showVoicesSheet: $showVoicesSheet, initial: voiceIdentifier) { voice in
                UserDefaults.standard.setValue(voice.identifier, forKey: Constants.voice)
                showVoicesSheet = false
                if speechService.state.model != nil {
                    speechService.stopAndPlay()
                }
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showRateSheet) {
            CustomSliderSheet(progress: UserDefaults.standard.value(forKey: Constants.speechRate) as? Float ?? 0.5) { result in
                UserDefaults.standard.setValue(result, forKey: Constants.speechRate)
                showRateSheet = false
                if speechService.state.model != nil {
                    speechService.stopAndPlay()
                }
            }
            .presentationDetents([.medium])
        }
    }
}
