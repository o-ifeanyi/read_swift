//
//  FolderView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 05/02/2024.
//

import SwiftUI

struct FolderView: View {
    @Environment(LibraryViewModel.self) private var libraryViewModel
    @Environment(SpeechService.self) private var speechService
    
    @State private var renameItem: Bool = false
    @State private var moveFiles: Bool = false
    @State private var isSelecting: Bool = false
    @State private var selectedFiles: [FileModel] = []
    
    let id: String
    let name: String
    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
    @MainActor func onFileTapped(file: FileModel) {
        guard isSelecting else {
            speechService.updateModel(file)
            return
        }
        if selectedFiles.contains(file), let index = selectedFiles.firstIndex(of: file) {
            selectedFiles.remove(at: index)
        } else {
            selectedFiles.append(file)
        }
    }
    
    var body: some View {
        let files = libraryViewModel.state.folderFiles
        
        ScrollView(.vertical, showsIndicators: false) {
            if !files.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Files")
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: gridColumn) {
                        ForEach(files) { file in
                            GridTileView(asset: file.icon, title: file.name, subtitle: "\(file.type) • \(file.progress)%\n\(file.date.dwdm)")
                                .onTapGesture { onFileTapped(file: file) }
                                .onLongPressGesture {
                                    if !isSelecting {
                                        selectedFiles.append(file)
                                        withAnimation(.spring) {
                                            isSelecting.toggle()
                                        }
                                    }
                                }
                                .overlay(alignment: .topTrailing) {
                                    if isSelecting && selectedFiles.contains(file) {
                                        Symbols.checkFill
                                    }
                                }
                        }
                    }
                }
            } else {
                EmptyView()
            }
            Spacer(minLength: 100)
        }
        .task {
            libraryViewModel.getFolderFiles(id: id)
        }
        .padding(.horizontal, 15)
        .navigationTitle(isSelecting ? "\(selectedFiles.count) Selected" : name)
        .toolbar {
            if isSelecting {
                SelectingToolBar(isSelecting: $isSelecting, moveFiles: $moveFiles, renameItem: $renameItem, selectedFiles: $selectedFiles, selectedFolders: .constant([]), files: files, folders: [])
            }
        }
        .sheet(isPresented: $renameItem) {
            RenameView(file: selectedFiles.first, folder: nil)
                .onDisappear {
                    isSelecting = false
                    selectedFiles = []
                }
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $moveFiles) {
            MoveFilesView(files: selectedFiles)
                .onDisappear {
                    isSelecting = false
                    selectedFiles = []
                }
        }
    }
}
