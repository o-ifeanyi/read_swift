//
//  LoaderComponent.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 13/04/2024.
//

import SwiftUI

struct LoaderComponent: View {
    @State private var isAnimating: Bool = false
    @State var loader: LoadingState
    
    var body: some View {
        ZStack {
            Color.primary.opacity(0.3)
            GroupBox {
                ProgressView(label: { Text(loader.messasge) })
                    .padding()
            }
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : -20)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    isAnimating.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }
}
