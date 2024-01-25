//
//  PlayerView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 25/01/2024.
//

import SwiftUI

struct PlayerView: View {
    @State private var animate: Bool = false
    let isPlaying: Bool
    let onPlay: () -> Void
    let onPause: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 50, height: 50)
            
            Spacer()
            
            Symbols.stop
                .font(.title2)
                .onTapGesture {
                    onStop()
                }

            if isPlaying {
                Symbols.pause
                    .font(.title2)
                    .onTapGesture {
                        onPause()
                    }
            } else {
                Symbols.play
                    .font(.title2)
                    .onTapGesture {
                        onPlay()
                    }
            }
        }
        .onAppear {
            animate.toggle()
        }
        .padding(8)
        .background(.thinMaterial)
        .cornerRadius(8)
        .padding(.horizontal, 8)
        .padding(.bottom, animate ? 56 : -56)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.spring(duration: 0.3), value: animate)
    }
}
