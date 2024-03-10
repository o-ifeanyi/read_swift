//
//  LibraryViewModel.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 03/02/2024.
//

import SwiftUI
import SwiftData

struct LibraryState {
    var files: [FileModel] = []
    var searchedFiles: [FileModel] = []
    var folders: [FolderModel] = []
    var searchedFolders: [FolderModel] = []
    var folderFiles: [FileModel] = []
}

@MainActor
@Observable
final class LibraryViewModel {
    var modelContext: ModelContext
    private (set) var state = LibraryState()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllFiles() {
        do {
            let descriptor = FetchDescriptor<FileModel>(
                predicate: #Predicate<FileModel> { $0.parent == nil },
                sortBy: [SortDescriptor(\.date)]
            )
            let files = try modelContext.fetch(descriptor)
            state.files = files
            state.searchedFiles = files
        } catch {
            print("Fetch models failed")
        }
    }
    
    func getAllFolders() {
        do {
            let descriptor = FetchDescriptor<FolderModel>(
                sortBy: [SortDescriptor(\.date)]
            )
            let folders = try modelContext.fetch(descriptor)
            state.folders = folders
            state.searchedFolders = folders
        } catch {
            print("Fetch folders failed")
        }
    }
    
    func getFolderFiles(id: String) {
        do {
            let descriptor = FetchDescriptor<FileModel>(
                predicate: #Predicate<FileModel> { $0.parent == id },
                sortBy: [SortDescriptor(\.date)]
            )
            let files = try modelContext.fetch(descriptor)
            state.folderFiles = files
        } catch {
            print("Fetch folderFiles failed")
        }
    }
    
    
    func getFolderFilesCount(id: String) -> Int {
        let descriptor = FetchDescriptor<FileModel>(
            predicate: #Predicate<FileModel> { $0.parent == id }
        )
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
    
    
    func search(query: String) {
        withAnimation(.spring) {
            state.searchedFiles = state.files.filter( {$0.name.lowercased().contains(query.lowercased())} )
            state.searchedFolders = state.folders.filter( {$0.name.lowercased().contains(query.lowercased())} )
        }
    }
    
    
    func sort(type: SortType) {
        withAnimation(.spring) {
            state.files = state.files.sorted(by: { first, second in
                switch type {
                case .name:
                    first.name < second.name
                case .date:
                    first.date < second.date
                }
            })
            state.folders = state.folders.sorted(by: { first, second in
                switch type {
                case .name:
                    first.name < second.name
                case .date:
                    first.date < second.date
                }
            })
        }
    }
    
    func insertItem(file: FileModel) {
        modelContext.insert(file)
        getAllFiles()
    }
    
    func deleteItems(files: [FileModel]) {
        for file in files {
            if FileManager.default.fileExists(atPath: file.fullPath) {
               try? FileManager.default.removeItem(atPath: file.fullPath)
            }
            modelContext.delete(file)
        }
        // from library
        if files.filter( {$0.parent != nil} ).isEmpty {
            withAnimation(.spring) {
                getAllFiles()
            }
        // from folder
        } else {
            withAnimation(.spring) {
                getFolderFiles(id: files.first!.parent!)
            }
        }
    }
    
    func insertItem(folder: FolderModel) {
        modelContext.insert(folder)
        withAnimation(.spring) {
            getAllFolders()
        }
    }
    
    func deleteItems(folders: [FolderModel]) {
        for folder in folders {
            getFolderFiles(id: folder.id)
            if !state.folderFiles.isEmpty {
                deleteItems(files: state.folderFiles)
            }
            modelContext.delete(folder)
        }
        withAnimation(.spring) {
            getAllFolders()
        }
    }
    
    
    func moveToFolder(id: String, files: [FileModel]) {
        var currentFolderId: String?
        for file in files {
            currentFolderId = file.parent
            file.parent = id
        }
        // from library
        if currentFolderId == nil {
            withAnimation(.spring) {
                getAllFiles()
            }
        // from folder
        } else {
            withAnimation(.spring) {
                getFolderFiles(id: currentFolderId!)
            }
        }
    }
}
