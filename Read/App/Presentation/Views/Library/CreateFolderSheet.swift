//
//  CreatFolderView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 04/02/2024.
//

import SwiftUI

struct CreateFolderSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryVM
    
    @FocusState private var fieldIsFocused: Bool
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: $name)
                        .focused($fieldIsFocused)
                    
                    AppButton(text: "Continue", action: {
                        let folder = FolderModel(name: name)
                        libraryVM.insertItem(folder: folder)
                        dismiss()
                    })
                    .disabled(name.isEmpty)
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
            .task {
                fieldIsFocused = true
            }
        }
    }
}
