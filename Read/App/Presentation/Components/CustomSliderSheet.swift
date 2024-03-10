//
//  CustomSlider.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 31/01/2024.
//

import SwiftUI

struct CustomSliderSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var progress: Float;
    let fullWidth = UIScreen.width - 30
    let onDone: (_ result: Float) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Text("slow")
                    Spacer()
                    Text("normal")
                    Spacer()
                    Text("fast")
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
                            progress = Float(max(0.1, pos))
                        }
                    }.onEnded( { action in
                        
                        let rate = String(format: "%.1f", progress)
                        print(rate)
                        onDone(Float(rate) ?? 0.0)
                    })
                )
            }
            .navigationTitle("Speech Rate")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
