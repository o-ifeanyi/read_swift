//
//  AppTheme.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 17/02/2024.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case system, light, dark
    var overrideTheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    var name: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
