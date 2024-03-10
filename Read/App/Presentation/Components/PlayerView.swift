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
        let state = speechService.state
        
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                WaveForm(animating: !expanded && state.isPlaying)
                
                if state.model != nil {
                    Text(state.model!.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                
                Spacer()
                

                if state.isPlaying {
                    Button(action: {
                        speechService.pause()
                    }, label: {
                        Symbols.pause
                            .font(.title2)
                    })
                } else {
                    Button(action: {
                        speechService.play()
                    }, label: {
                        Symbols.play
                            .font(.title2)
                    })
                }
            }
            ProgressView(value: state.progress)
        }
        
        .padding(10)
        .background(.thinMaterial)
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .padding(.bottom, state.canPlay ? 56 : -56)
        .opacity(state.canPlay ? 1.0 : 0.0)
        .animation(.spring(duration: 0.3), value: state.canPlay)
    }
}
