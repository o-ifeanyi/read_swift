//
//  SnackbarService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/01/2024.
//

import SwiftUI

struct SnackBarState {
    let messasge: String
    let isError: Bool
}

@Observable
final class SnackBarService {
    static let shared = SnackBarService()
    
    private (set) var state: SnackBarState?
    
    @MainActor
    func displayMessage(_ messasge: String, isError: Bool = true) {
        state = SnackBarState(messasge: messasge, isError: isError)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            withAnimation(.easeOut(duration: 0.3)) {
                self.state = nil
            }
        })
    }
}
