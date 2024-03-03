//
//  PlayerView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI

struct PlayerView: View {
    @Environment(SpeechService.self) private var speechService
    @Binding var expanded: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                WaveForm(animating: !expanded && speechService.state.isPlaying)
                
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
    }
}
