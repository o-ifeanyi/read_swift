//
//  DefaultToolBar.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 05/02/2024.
//

import SwiftUI

enum SortType {case name, date }

struct DefaultToolBar: ToolbarContent {
    @Environment(LibraryViewModel.self) private var libraryViewModel
    @Binding var isSelecting: Bool
    @Binding var createFolder: Bool
    @Binding var listStyle: ListStyle
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu(content: {
                Button(action: {
                    createFolder.toggle()
                }, label: {
                    Label("New Folder", systemImage: "folder.badge.plus")
                })
                
                Menu {
                    Button("Name") { 
                        Task {
                           await libraryViewModel.sort(type: .name)
                        }
                    }
                    Button("Date") { 
                        Task {
                           await libraryViewModel.sort(type: .date)
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "list.bullet.indent")
                }
                Button(action: {
                    withAnimation(.spring) {
                        isSelecting.toggle()
                    }
                }, label: {
                    Label("Select Multiple", systemImage: "checklist")
                })
                Divider()
                Button(action: {
                    withAnimation(.spring) {
                        listStyle = .list
                    }
                }, label: {
                    Label("List View", systemImage: "list.bullet")
                })
                Button(action: {
                    withAnimation(.spring) {
                        listStyle = .grid
                    }
                }, label: {
                    Label("Grid View", systemImage: "square.grid.2x2")
                })
                
            }, label: {
                Symbols.ellipsis
            })
            
        }
    }
}
