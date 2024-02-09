//
//  SettingsItem.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 08/02/2024.
//

import SwiftUI

struct SettingsItem<Asset: View>: View {
    let title: String
    let icon: Asset
    let color: Color
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(color)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                icon
                    .foregroundColor(.white)
            }
            .frame(width: 30, height: 30, alignment: .center)
            .padding(.trailing, 8)
            
            Text(title)
            
            
            Spacer()
        }
    }
}

#Preview {
    SettingsItem(title: "Test", icon: Symbols.check, color: .blue)
}
