//
//  MoveFilesView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 05/02/2024.
//

import SwiftUI

struct MoveFilesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LibraryViewModel.self) private var libraryViewModel
    
    let files: [FileModel]
    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        let folders = libraryViewModel.state.folders
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    LazyVGrid(columns: gridColumn) {
                        ForEach(folders) { folder in
                            GridTileView(asset: Symbols.folder
                                .font(.title), title: folder.name, subtitle: "\(folder.date.dwdm)")
                            .onTapGesture {
                                Task {
                                    libraryViewModel.moveToFolder(id: folder.id, files: files)
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
