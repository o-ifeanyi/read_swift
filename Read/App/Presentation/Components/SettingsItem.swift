//
//  SettingsItem.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 08/02/2024.
//

import SwiftUI

struct SettingsItem<Icon: View, Trailing: View>: View {
    let title: String
    @ViewBuilder let icon: Icon
    let color: Color
    @ViewBuilder let trailing: Trailing
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
            
            trailing
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    SettingsItem(title: "Test", icon: { Symbols.check }, color: .blue, trailing: {})
}
