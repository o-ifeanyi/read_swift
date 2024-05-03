//
//  WhatsNewModel.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 20/02/2024.
//

import Foundation
import SwiftData

@Model
final class WhatsNewModel {
    let id: String
    let features: [NewFeature]
    
    init(id: String, features: [NewFeature]) {
        self.id = id
        self.features = features
    }
}

@Model
final class NewFeature {
    let id: Int
    let title: String
    let body: String
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}

let latestUpdate = WhatsNewModel(id: "1.0.7", features: [
    NewFeature(id: 0, title: "Scan page 📖", body: "Scan the pages of your favourite books with your camera and listen to them"),
])
