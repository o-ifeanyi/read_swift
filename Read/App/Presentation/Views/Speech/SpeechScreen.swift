//
//  SpeechScreen.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 28/01/2024.
//

import SwiftUI

struct SpeechScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SpeechService.self) private var speechService
    @AppStorage(Constants.voice) private var voiceIdentifier = ""
    @State private var showPageSheet: Bool = false
    @State private var showVoicesSheet: Bool = false
    @State private var showRateSheet: Bool = false
        
    var body: some View {
        let state = speechService.state
        NavigationStack {
            VStack(spacing: 15) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if state.canPlay {
                            HighlightedTextView(text: state.text, highlightedRange: state.wordRange)
                        }
                    }
                    .frame(minHeight: UIScreen.height)
                }
                ProgressView(value: speechService.state.progress)
                HStack {
                    Spacer()
                    Symbols.speaker
                        .font(.title2)
                        .onTapGesture {
                            showVoicesSheet = true
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
                            showRateSheet = true
                        }
                    Spacer()
                }
            }
            .onTapGesture { location in
                let width = UIScreen.width
                if location.x <= width * 0.35 {
                    speechService.prevPage()
                } else if location.x >= width * 0.65 {
                    speechService.nextPage()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Player")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Symbols.down
                    })
                }
                if state.model != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        let model = state.model!
                        Button(action: {
                            showPageSheet = true
                        }, label: {
                            Text("Page \(model.currentPage) of \(model.totalPages)")
                                .fontWeight(.semibold)
                        })
                    }
                }
            }
            .sheet(isPresented: $showPageSheet) {
                GoToPageSheet()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showVoicesSheet) {
                VoiceSelectorSheet(showVoicesSheet: $showVoicesSheet, initial: voiceIdentifier) { voice in
                    UserDefaults.standard.setValue(voice.identifier, forKey: Constants.voice)
                    showVoicesSheet = false
                    speechService.stopAndPlay()
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showRateSheet) {
                CustomSliderSheet(progress: UserDefaults.standard.value(forKey: Constants.speechRate) as? Float ?? 0.5) { result in
                    UserDefaults.standard.setValue(result, forKey: Constants.speechRate)
                    showRateSheet = false
                    speechService.stopAndPlay()
                }
                .presentationDetents([.medium])
            }
        }
    }
}
