//
//  FolderModel.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 04/02/2024.
//

import Foundation
import SwiftData

@Model
final class FolderModel {
    let id: String = UUID().uuidString
    var name: String
    let date: Date = Date.now
    
    init(name: String) {
        self.name = name
    }
}
