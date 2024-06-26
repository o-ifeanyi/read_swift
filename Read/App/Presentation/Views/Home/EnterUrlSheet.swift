//
//  EnterUrlView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 05/02/2024.
//

import SwiftUI

struct EnterUrlSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SpeechService.self) private var speechService
    @Environment(LibraryViewModel.self) private var libraryVM
    
    @FocusState private var fieldIsFocused: Bool
    
    @State private var link: String = ""
    var body: some View {
        
        NavigationView {
            VStack(spacing: 15) {
                TextFieldView(hint: "Link", text: $link)
                    .focused($fieldIsFocused)
                                
                AppButton(text: "Continue", action: {
                    AnalyticService.shared.track(event: "enter_url")
                    let file = FileModel(name: link.trimUrl, type: .url, path: link)
                    speechService.updateModel(file) {
                        // insert on success of update model
                        libraryVM.insertItem(file: file)
                    }
                    dismiss()
                })
                .disabled(link.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Enter Link")
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
