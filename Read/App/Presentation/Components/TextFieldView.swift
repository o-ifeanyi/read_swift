//
//  InputFieldView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 19/03/2024.
//

import SwiftUI

struct TextFieldView: View {
    @State var hint: String
    @Binding var text: String
    
    var body: some View {
        TextField(hint, text: $text)
            .padding(10)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
