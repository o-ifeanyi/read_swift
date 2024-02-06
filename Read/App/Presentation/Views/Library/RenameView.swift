//
//  EditNameView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 06/02/2024.
//

import SwiftUI

struct RenameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryViewModel
    
    let file: FileModel?
    let folder: FolderModel?
    
    @FocusState private var fieldIsFocused: Bool
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $name)
                        .focused($fieldIsFocused)
                    Button(action: {
                        Task {
                            if file != nil {
                                file!.name = name
                            } else if folder != nil {
                                folder!.name = name
                            }
                            dismiss()
                        }
                    }, label: {
                        Spacer()
                        Text("Continue")
                            .padding(.vertical, 8)
                        Spacer()
                    })
                    .disabled(name.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .navigationTitle("Rename")
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
