//
//  LibraryModel.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 03/02/2024.
//

import SwiftUI
import SwiftData

enum LibraryType: Codable { case pdf, img, txt, url }

@Model
final class FileModel {
    let id: String = UUID().uuidString
    var name: String
    let type: LibraryType
    let date: Date = Date.now
    let path: String
    var cache: String? = nil
    var wordRange: [Int] = []
    var wordIndex: Int = 0
    var progress: Int = 0
    var currentPage: Int = 1
    var totalPages: Int = 1
    var parent: String? = nil
    
    init(name: String, type: LibraryType, path: String) {
        self.name = name
        self.type = type
        self.path = path
    }
    
    var icon: Image {
        switch type {
        case .pdf:
            Symbols.doc
        case .img:
            Symbols.photo
        case .txt:
            Symbols.text
        case .url:
            Symbols.link
        }
    }
    
    var fullPath: String {
        URL.documentsDirectory.path() + path
    }
    
    var absProgress: Int {
        if totalPages > 1 {
            let value = (Double(currentPage) / Double(totalPages)) * 100
            return Int(value)
        }
        return progress
    }
    
    func readCache() -> String? {
        do {
            guard cache != nil else { return nil }
            let path = URL.documentsDirectory.path() + cache!
            let url = URL(fileURLWithPath: path)
            let content = try String(contentsOf: url)
            return content.formatted
        } catch {
            return nil
        }
    }
    
    func writeCache(text: String) {
        do {
            let docName = "\(Date.now.ISO8601Format()).txt"
            let docUrl = URL.documentsDirectory.appending(path: docName)
            
            // needed to prevent error reading file issue
            let _ = docUrl.startAccessingSecurityScopedResource()
            
            try text.write(to: docUrl, atomically: true, encoding: String.Encoding.utf8)
            
            cache = docUrl.lastPathComponent
        } catch {}
    }
}
