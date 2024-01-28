//
//  PlayerView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI

struct PlayerView: View {
    @Environment(SpeechService.self) private var speechService
    @State private var expanded: Bool = false
    
    var body: some View {
        if expanded {
            SpeechScreen(expanded: $expanded)
        } else {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 50, height: 50)
                    
                    Spacer()
                    
                    Symbols.stop
                        .font(.title2)
                        .onTapGesture {
                            speechService.stop()
                        }

                    if speechService.state.isPlaying {
                        Symbols.pause
                            .font(.title2)
                            .onTapGesture {
                                speechService.pause()
                            }
                    } else {
                        Symbols.play
                            .font(.title2)
                            .onTapGesture {
                                speechService.play()
                            }
                    }
                }
                ProgressView(value: speechService.state.progress)
            }
            .padding(8)
            .background(.thinMaterial)
            .cornerRadius(8)
            .padding(.horizontal, 8)
            .padding(.bottom, speechService.state.canPlay ? 56 : -56)
            .opacity(speechService.state.canPlay ? 1.0 : 0.0)
            .animation(.spring(duration: 0.3), value: speechService.state.canPlay)
            .onTapGesture {
                withAnimation(.snappy(duration: 0.5)) {
                    expanded = true
                }
            }
        }
    }
}
