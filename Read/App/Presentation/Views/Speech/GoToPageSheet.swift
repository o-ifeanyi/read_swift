//
//  GotoPageSheet.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 09/03/2024.
//

import SwiftUI

struct GoToPageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SpeechService.self) private var speechService
    
    @FocusState private var fieldIsFocused: Bool
    
    @State private var text: String = ""
    var body: some View {
        
        NavigationView {
            VStack {
                Form {
                    TextField("Page", text: $text)
                        .keyboardType(.numberPad)
                        .focused($fieldIsFocused)
                    
                    AppButton(text: "Coninue", action: {
                        if let page = Int(text) {
                            speechService.goToPage(page: page)
                        }
                        dismiss()
                    })
                    .disabled(text.isEmpty)
                }
                
            }
            .navigationTitle("Go To Page")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                fieldIsFocused = true
            }
        }
    }
}
