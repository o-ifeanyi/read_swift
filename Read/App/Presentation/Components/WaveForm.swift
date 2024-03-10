//
//  WaveForm.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 24/02/2024.
//

import SwiftUI

struct WaveForm: View {
    let animating: Bool
    
    private var animation: Animation {
        .linear
        .speed(Double.random(in: 0.5...1.0))
        .repeat(if: animating)
    }
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0 ..< 6, id: \.self) { index in
                let height = (index < 2 || index > 3 ? CGFloat.random(in: 0.2...0.4) : CGFloat.random(in: 0.4...0.8)) * 50
                
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 4, height: animating ? height : 3)
                    .animation(animation, value: animating)
            }
        }
        .frame(height: 50)
    }
}
