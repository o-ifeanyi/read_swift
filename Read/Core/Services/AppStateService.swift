//
//  AppStateService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct SnackBarState {
    let messasge: String
    let isError: Bool
}

struct LoadingState {
    let messasge: String
}

@Observable
final class AppStateService {
    static let shared = AppStateService()
    
    private (set) var snackbar: SnackBarState?
    private (set) var loader: LoadingState?
    
    @MainActor
    func displayMessage(_ messasge: String, isError: Bool = true) {
        snackbar = SnackBarState(messasge: messasge, isError: isError)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            withAnimation(.easeOut(duration: 0.3)) {
                self.snackbar = nil
            }
        })
    }
    
    @MainActor
    func displayLoader(_ messasge: String = "loading ...") {
        loader = LoadingState(messasge: messasge)
    }
    
    @MainActor
    func removeLoader() {
        withAnimation(.easeOut(duration: 0.3)) {
            self.loader = nil
        }
    }
}
