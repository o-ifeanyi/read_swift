//
//  LibraryToolBar.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 04/02/2024.
//

import SwiftUI

struct SelectingToolBar: ToolbarContent {
    @Environment(LibraryViewModel.self) private var libraryViewModel
    @Binding var isSelecting: Bool
    @Binding var moveFiles: Bool
    @Binding var renameItem: Bool
    @Binding var selectedFiles: [FileModel]
    @Binding var selectedFolders: [FolderModel]
    let files: [FileModel]
    let folders: [FolderModel]
    
    var body: some ToolbarContent {
        let allCount = selectedFiles.count + selectedFolders.count
        let allSelected = allCount > 0 && files.count == selectedFiles.count && folders.count == selectedFolders.count
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
                selectedFiles = []
                selectedFolders = []
                withAnimation(.spring) {
                    isSelecting.toggle()
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                if allSelected {
                    selectedFiles = []
                    selectedFolders = []
                } else {
                    selectedFiles = []
                    selectedFolders = []
                    selectedFiles.append(contentsOf: files)
                    selectedFolders.append(contentsOf: folders)
                }
            }, label: {
                if allSelected {
                    Text("Deselect All")
                    
                } else {
                    Text("Select All")
                }
            })
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu(content: {
                Button(action: {
                    Task {
                        await libraryViewModel.deleteItems(folders: selectedFolders)
                        await libraryViewModel.deleteItems(files: selectedFiles)
                        
                        selectedFiles = []
                        selectedFolders = []
                        withAnimation(.spring) {
                            isSelecting.toggle()
                        }
                    }
                }, label: {
                    Label("Delete", systemImage: "trash")
                })
                if !selectedFiles.isEmpty {
                    Button(action: {
                        moveFiles.toggle()
                    }, label: {
                        Label("Move to folder", systemImage: "folder")
                    })
                }
                if allCount == 1 {
                    Button(action: {
                        withAnimation(.spring) {
                            renameItem.toggle()
                        }
                    }, label: {
                        Label("Rename", systemImage: "square.and.pencil")
                    })
                }
            }, label: {
                Symbols.ellipsis
            })
            .disabled(allCount == 0)
        }
    }
}
