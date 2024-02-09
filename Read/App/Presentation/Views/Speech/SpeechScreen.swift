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
    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
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
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        LazyVGrid(columns: gridColumn) {
                            ForEach(speechService.state.voices, id: \.self) { voice in
                                
                                
                                let gender = if voice.gender.rawValue == 0 {
                                    "unknown"
                                } else if voice.gender.rawValue == 1 {
                                    "male"
                                } else {
                                    "female"
                                }
                                let flag = voice.language.flag
                                GridTileView(asset: flag != nil ? Text(flag!) : nil, title: voice.name, subtitle: gender)
                                .onTapGesture {
                                    speechService.changeVoice(voice: voice)
                                    showVoicesSheet.toggle()
                                }
                            }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showRateSheet) {
                VStack {
                    CustomSlider(progress: 0.5) { result in
                        speechService.changeRate(rate: result)
                        showRateSheet.toggle()
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}
