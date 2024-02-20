//
//  ListTileView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 28/01/2024.
//

import SwiftUI

struct ListTileView<Asset: View>: View {
    let asset: Asset?
    let title: String
    let subtitle: String
    
    var body: some View {
        GroupBox {
            HStack(spacing: 15) {
                if asset != nil {
                    asset!
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ListTileView<AnyView>(asset: nil, title: "Pick document", subtitle: "SizeTransform defines how the size should animate between the.")
}
