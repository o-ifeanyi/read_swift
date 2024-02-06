//
//  GridTileView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 31/01/2024.
//

import SwiftUI

struct GridTileView<Asset: View>: View {
    let asset: Asset?
    let title: String
    let subtitle: String
    
    var body: some View {
        GroupBox {
            HStack {
                Spacer(minLength: 0)
                VStack {
                    if asset != nil {
                        asset
                            .font(.title)
                    } else {
                        Symbols.flag
                            .font(.title)
                    }
                    
                    Spacer(minLength: 10)
                    
                    Text(title)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                }
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    GridTileView(asset: Text("DE".flag ?? ""), title: "John", subtitle: "male")
}
