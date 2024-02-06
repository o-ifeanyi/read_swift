//
//  SearchView.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI
import SwiftData
import PDFKit

enum ListStyle { case list, grid }

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Router.self) private var router
    @Environment(SpeechService.self) private var speechService
    @Environment(LibraryViewModel.self) private var libraryViewModel

    let gridColumn = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var listStyle: ListStyle = .grid
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
        let files = searching ? libraryViewModel.state.searchedFiles : libraryViewModel.state.files
        let folders = searching ? libraryViewModel.state.searchedFolders : libraryViewModel.state.folders
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                if !folders.isEmpty {
                    GroupBox(label: Text("Folders"), content: {
                        switch listStyle {
                        case .list:
                            ForEach(folders) { folder in
                                ListTileView(asset: Symbols.folder
                                    .font(.title), title: folder.name, subtitle: "\(folder.date.dwdm)")
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
                                    GridTileView(asset: Symbols.folder
                                        .font(.title), title: folder.name, subtitle: "\(folder.date.dwdm)")
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
                    })
                }
                
                
                if !files.isEmpty {
                    GroupBox(label: Text("Files"), content: {
                        switch listStyle {
                        case .list:
                            ForEach(files) { file in
                                ListTileView(asset: file.icon.font(.title), title: file.name, subtitle: "\(file.type) • \(file.progress)% • \(file.date.dwdm)")
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
                    })
                }
                
                Spacer(minLength: 100)
            }
            .navigationTitle(isSelecting ? "\(allCount) Selected" : "Library")
            .searchable(text: $searchText, prompt: "Search")
            .onChange(of: searchText) {
                print(searchText)
                searching = !searchText.isEmpty
                if !searchText.isEmpty {
                    libraryViewModel.search(query: searchText)
                }
            }
            .toolbar {
                if isSelecting {
                    SelectingToolBar(isSelecting: $isSelecting, moveFiles: $moveFiles, renameItem: $renameItem, selectedFiles: $selectedFiles, selectedFolders: $selectedFolders, files: files, folders: folders)
                } else {
                    DefaultToolBar(isSelecting: $isSelecting, createFolder: $createFolder, listStyle: $listStyle)
                }
            }
            .sheet(isPresented: $createFolder) {
                CreateFolderView()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $renameItem) {
                RenameView(file: selectedFiles.first, folder: selectedFolders.first)
                    .onDisappear {
                        isSelecting = false
                        selectedFiles = []
                        selectedFolders = []
                    }
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $moveFiles) {
                MoveFilesView(files: selectedFiles)
                    .onDisappear {
                        isSelecting = false
                        selectedFiles = []
                        selectedFolders = []
                    }
            }
            .task {
                libraryViewModel.getAllFolders()
                libraryViewModel.getAllFiles()
            }
        }
        .padding(.horizontal, 15)
    }
}
