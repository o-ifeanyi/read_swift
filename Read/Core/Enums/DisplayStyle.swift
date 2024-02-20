//
//  DisplayStyle.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import Foundation

enum DisplayStyle: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case list, grid
    
    var name: String {
        switch self {
        case .list:
            return "List View"
        case .grid:
            return "Grid  View"
        }
    }
}
