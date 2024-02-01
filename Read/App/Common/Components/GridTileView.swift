//
//  GridTileView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 31/01/2024.
//

import SwiftUI

struct GridTileView: View {
    let asset: String?
    let title: String
    let subtitle: String
    
    var body: some View {
        GroupBox {
            HStack {
                Spacer(minLength: 0)
                VStack {
                    if asset != nil {
                        Text(asset!)
                            .font(.title)
                    } else {
                        Symbols.flag
                            .font(.title)
                    }
                    
                    Spacer(minLength: 10)
                    
                    Text(title)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(.caption)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    
                }
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    GridTileView(asset: "DE".flag, title: "John", subtitle: "male")
}
