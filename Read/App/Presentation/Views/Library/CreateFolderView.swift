//
//  CreatFolderView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 04/02/2024.
//

import SwiftUI

struct CreateFolderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryViewModel
    
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
                            let folder = FolderModel(name: name)
                            libraryViewModel.insertItem(folder: folder)
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
            .navigationTitle("Create Folder")
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
