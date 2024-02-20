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
            VStack {
                Form {
                    TextField("Link", text: $link)
                        .focused($fieldIsFocused)
                    
                    AppButton(text: "Coninue", action: {
                        let file = FileModel(name: link.trimUrl, type: .url, path: link)
                        // TODO: should be inserted on success of update model
                        libraryVM.insertItem(file: file)
                        speechService.updateModel(file)
                        dismiss()
                    })
                    .disabled(link.isEmpty)
                }
                
            }
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
