//
//  SpeechScreen.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 28/01/2024.
//

import SwiftUI
import AVFAudio

struct SpeechScreen: View {
    @Environment(SpeechService.self) private var speechService
    @Binding var expanded: Bool
    @State private var showVoicesSheet: Bool = false
    @State private var showRateSheet: Bool = false
    
    var body: some View {
        let state = speechService.state
        NavigationView {
            VStack(spacing: 15) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if state.canPlay {
                            HighlightedTextView(text: state.text, highlightedRange: state.wordRange)
                                .frame(minHeight: UIScreen.height)
                        }
                    }
                }
                ProgressView(value: speechService.state.progress)
                HStack {
                    Spacer()
                    Symbols.speaker
                        .font(.title2)
                        .onTapGesture {
                            showVoicesSheet.toggle()
                        }
                    Spacer()
                    Symbols.rewind
                        .font(.title)
                        .onTapGesture {
                            speechService.rewind()
                        }
                    Spacer()
                    if state.isPlaying {
                        Symbols.pause
                            .resizable()
                            .frame(width: 35, height: 35)
                            .onTapGesture {
                                speechService.pause()
                            }
                    } else {
                        Symbols.play
                            .resizable()
                            .frame(width: 35, height: 35)
                            .onTapGesture {
                                speechService.play()
                            }
                    }
                    Spacer()
                    Symbols.forward
                        .font(.title)
                        .onTapGesture {
                            speechService.forward()
                        }
                    Spacer()
                    Symbols.speed
                        .font(.title2)
                        .onTapGesture {
                            showRateSheet.toggle()
                        }
                    Spacer()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Player")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Symbols.down
                        .onTapGesture {
                            withAnimation(.snappy(duration: 0.5)) {
                                $expanded.wrappedValue = false
                            }
                            
                        }
                }
            }
            .sheet(isPresented: $showVoicesSheet) {
                VoiceSelectorSheet(showVoicesSheet: $showVoicesSheet) { voice in
                    UserDefaults.standard.setValue(voice.identifier, forKey: Constants.voice)
                    showVoicesSheet.toggle()
                    speechService.stopAndPlay()
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showRateSheet) {
                CustomSliderSheet(progress: UserDefaults.standard.value(forKey: Constants.speechRate) as? Float ?? 0.5) { result in
                    UserDefaults.standard.setValue(result, forKey: Constants.speechRate)
                    showRateSheet.toggle()
                    speechService.stopAndPlay()
                }
                .presentationDetents([.medium])
            }
        }
    }
}
