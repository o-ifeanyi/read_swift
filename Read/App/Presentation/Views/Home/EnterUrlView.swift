//
//  EnterUrlView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 05/02/2024.
//

import SwiftUI

struct EnterUrlView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SpeechService.self) private var speechService
    @Environment(LibraryViewModel.self) private var libraryViewModel
    
    @FocusState private var fieldIsFocused: Bool
    
    @State private var link: String = ""
    var body: some View {
        
        NavigationView {
            VStack {
                Form {
                    TextField("Link", text: $link)
                        .focused($fieldIsFocused)
                    Button(action: {
                        let file = FileModel(name: link.trimUrl, type: .url, path: link)
                        // TODO: should be inserted on success of update model
                        libraryViewModel.insertItem(file: file)
                        speechService.updateModel(file)
                        dismiss()
                    }, label: {
                        Spacer()
                        Text("Continue")
                            .padding(.vertical, 8)
                        Spacer()
                    })
                    .disabled(link.isEmpty)
                    .buttonStyle(.borderedProminent)
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
