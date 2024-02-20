//
//  AppButton.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/02/2024.
//

import SwiftUI

struct AppButton: View {
    let text: String
    let action: () -> Void
    
    
    var body: some View {
        Button(
            action: {
                Task { action() }
            },
            label: {
                Spacer()
                Text(text)
                    .padding(.vertical, 8)
                Spacer()
            }
        )
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    AppButton(text: "Continue", action: {})
}
