//
//  SnackbarComponent.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct SnackbarComponent: View {
    @State private var isAnimating: Bool = false
    @State var state: SnackBarState
    
    var body: some View {
        HStack {
            Text(state.messasge)
                .foregroundColor(.white)
                .lineLimit(1...2)
                .multilineTextAlignment(.leading)
                .padding()
            
            Spacer()
        }
        .background(state.isError ? .red : .green)
        .cornerRadius(10)
        .padding()
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 20 : -20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                isAnimating.toggle()
            }
        }
    }
}
