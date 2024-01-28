//
//  ListTileView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 28/01/2024.
//

import SwiftUI

struct ListTileView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        GroupBox {
            HStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

#Preview {
    ListTileView(title: "Pick document", subtitle: "SizeTransform defines how the size should animate between the.")
}
