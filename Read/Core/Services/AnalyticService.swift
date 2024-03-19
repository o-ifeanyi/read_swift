//
//  AnalyticService.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 18/03/2024.
//

import Foundation
import Mixpanel

final class AnalyticService {
    static let shared = AnalyticService()
    
    func initialise() {
        Mixpanel.initialize(token: Secrets.mixPanelKey, trackAutomaticEvents: true)
    }
    
    func track(event: String) {
        #if DEBUG
            print("TRACK DEBUG: \(event)")
        #else
            print("TRACK RELEASE")
            Mixpanel.mainInstance().track(event: event)
        #endif
    }
}
