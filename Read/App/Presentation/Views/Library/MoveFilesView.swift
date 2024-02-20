//
//  MoveFilesView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 05/02/2024.
//

import SwiftUI

struct MoveFilesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryVM
    
    let files: [FileModel]
    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        let folders = libraryVM.state.folders
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    LazyVGrid(columns: gridColumn) {
                        ForEach(folders) { folder in
                            let count = libraryVM.getFolderFilesCount(id: folder.id)
                            
                            GridTileView(asset: Symbols.folder
                                .font(.title), title: folder.name, subtitle: "\(count) items\n\(folder.date.dwdm)")
                            .onTapGesture {
                                Task {
                                    libraryVM.moveToFolder(id: folder.id, files: files)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Select Folder")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
