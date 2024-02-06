//
//  LibraryModel.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 03/02/2024.
//

import SwiftUI
import SwiftData

enum LibraryType: Codable { case pdf, image, url }

@Model
final class FileModel {
    let id: String = UUID().uuidString
    var name: String
    let type: LibraryType
    let date: Date = Date.now
    let path: String
    let progress: Int = 0
    var folder: String? = nil
    
    init(name: String, type: LibraryType, path: String) {
        self.name = name
        self.type = type
        self.path = path
    }
    
    var icon: Image {
        switch type {
        case .pdf:
            Symbols.doc
        case .image:
            Symbols.photo
        case .url:
            Symbols.link
        }
    }
}
