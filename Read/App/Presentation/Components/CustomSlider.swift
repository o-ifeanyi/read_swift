//
//  CustomSlider.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 31/01/2024.
//

import SwiftUI

struct CustomSlider: View {
    @State var progress: Float;
    let fullWidth = UIScreen.width - 30
    let onDone: (_ result: Float) -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("x0.1")
                Spacer()
                Text("x1.0")
                Spacer()
                Text("x2.0")
            }
            .padding(.horizontal, 16)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: fullWidth, height: 50)
                    .foregroundColor(.primary.opacity(0.3))
                
                Rectangle()
                    .frame(width: CGFloat(progress) * fullWidth, height: 50)
                    .foregroundColor(.primary)
                
            }
            .cornerRadius(8)
            .gesture(
                DragGesture().onChanged { action in
                    withAnimation(.spring) {
                        let pos = min(action.location.x, fullWidth) / fullWidth
                        progress = Float(max(0.05, pos))
                    }
                }.onEnded( { action in
                    
                    let rate = String(format: "%.1f", progress)
                    print(rate)
                    onDone(Float(rate) ?? 0.0)
                })
            )
        }
    }
}

#Preview {
    CustomSlider(progress: 0.5) { result in
    }
}
