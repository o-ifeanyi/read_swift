//
//  SearchView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct LibraryView: View {
    @Environment(Router.self) private var router
    @Environment(SpeechService.self) private var speechService
    @Environment(LibraryViewModel.self) private var libraryVM
    @AppStorage(Constants.displayStyle) private var displayStyle = DisplayStyle.grid

    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var createFolder: Bool = false
    @State private var renameItem: Bool = false
    
    @State private var searching: Bool = false
    @State private var moveFiles: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var isSelecting: Bool = false
    @State private var selectedFiles: [FileModel] = []
    @State private var selectedFolders: [FolderModel] = []
    
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
    
    
    @MainActor func onFolderTapped(folder: FolderModel) {
        guard isSelecting else {
            router.push(.folderView(id: folder.id, name: folder.name))
            return
        }
        if selectedFolders.contains(folder), let index = selectedFolders.firstIndex(of: folder) {
            selectedFolders.remove(at: index)
        } else {
            selectedFolders.append(folder)
        }
    }
    
    var body: some View {
        let allCount = selectedFiles.count + selectedFolders.count
        let files = searching ? libraryVM.state.searchedFiles : libraryVM.state.files
        let folders = searching ? libraryVM.state.searchedFolders : libraryVM.state.folders
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                if folders.isEmpty && files.isEmpty {
                    VStack(alignment: .center, spacing: 10) {
                        Spacer(minLength: UIScreen.height * 0.2)
                        Symbols.folder
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Nothing to see yet")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        Text("Items you previously listened to will show up here")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                }
                if !folders.isEmpty {
                    Text("Folders")
                        .fontWeight(.semibold)
                    
                    switch displayStyle {
                    case .list:
                        ForEach(folders) { folder in
                            let count = libraryVM.getFolderFilesCount(id: folder.id)
                            
                            ListTileView(asset: Symbols.folder
                                .font(.title), title: folder.name, subtitle: "\(count) items • \(folder.date.dwdm)")
                            .onTapGesture { onFolderTapped(folder: folder) }
                            .onLongPressGesture {
                                if !isSelecting {
                                    selectedFolders.append(folder)
                                    withAnimation(.spring) {
                                        isSelecting.toggle()
                                    }
                                }
                            }
                            .overlay(alignment: .topTrailing) {
                                if isSelecting && selectedFolders.contains(folder) {
                                    Symbols.checkFill
                                }
                            }
                        }
                    case .grid:
                        LazyVGrid(columns: gridColumn) {
                            ForEach(folders) { folder in
                                let count = libraryVM.getFolderFilesCount(id: folder.id)
                                
                                GridTileView(asset: Symbols.folder
                                    .font(.title), title: folder.name, subtitle: "\(count) items\n\(folder.date.dwdm)")
                                .onTapGesture { onFolderTapped(folder: folder) }
                                .onLongPressGesture {
                                    if !isSelecting {
                                        selectedFolders.append(folder)
                                        withAnimation(.spring) {
                                            isSelecting.toggle()
                                        }
                                    }
                                }
                                .overlay(alignment: .topTrailing) {
                                    if isSelecting && selectedFolders.contains(folder) {
                                        Symbols.checkFill
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                if !files.isEmpty {
                    Text("Files")
                        .fontWeight(.semibold)
                    
                    switch displayStyle {
                    case .list:
                        ForEach(files) { file in
                            ListTileView(asset: file.icon.font(.title), title: file.name, subtitle: "\(file.type) • \(file.absProgress)% • \(file.date.dwdm)")
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
                    case .grid:
                        LazyVGrid(columns: gridColumn) {
                            ForEach(files) { file in
                                GridTileView(asset: file.icon, title: file.name, subtitle: "\(file.type) • \(file.absProgress)%\n\(file.date.dwdm)")
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
                }
                
                Spacer(minLength: 100)
            }
            .navigationTitle(isSelecting ? "\(allCount) Selected" : "Library")
            .searchable(text: $searchText, prompt: "Search")
            .onChange(of: searchText) {
                searching = !searchText.isEmpty
                if !searchText.isEmpty {
                    libraryVM.search(query: searchText)
                }
            }
            .toolbar {
                if isSelecting {
                    SelectingToolBar(isSelecting: $isSelecting, moveFiles: $moveFiles, renameItem: $renameItem, selectedFiles: $selectedFiles, selectedFolders: $selectedFolders, files: files, folders: folders)
                } else {
                    DefaultToolBar(isSelecting: $isSelecting, createFolder: $createFolder, displayStyle: $displayStyle)
                }
            }
            .sheet(isPresented: $createFolder) {
                CreateFolderSheet()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $renameItem) {
                RenameSheet(file: selectedFiles.first, folder: selectedFolders.first)
                    .onDisappear {
                        withAnimation(.spring) {
                            isSelecting = false
                            selectedFiles = []
                            selectedFolders = []
                        }
                    }
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $moveFiles) {
                MoveFilesView(files: selectedFiles)
                    .onDisappear {
                        withAnimation(.spring) {
                            isSelecting = false
                            selectedFiles = []
                            selectedFolders = []
                        }
                    }
            }
            .task {
                libraryVM.getAllFolders()
                libraryVM.getAllFiles()
            }
        }
        .padding(.horizontal, 15)
    }
}
