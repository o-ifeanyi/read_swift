//
//  EditNameView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 06/02/2024.
//

import SwiftUI

struct RenameSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryVM
    
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
                    
                    AppButton(text: "Continue", action: {
                        if file != nil {
                            file!.name = name
                        } else if folder != nil {
                            folder!.name = name
                        }
                        dismiss()
                    })
                    .disabled(name.isEmpty)
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
            .task {
                fieldIsFocused = true
                name = file?.name ?? folder?.name ?? ""
            }
        }
    }
}
