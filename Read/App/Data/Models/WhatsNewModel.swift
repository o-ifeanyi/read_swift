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

let latestUpdate = WhatsNewModel(id: "1.0.4", features: [
    NewFeature(id: 0, title: "Welcome to Read", body: "A powerful text to speech app"),
    NewFeature(id: 1, title: "PDF to text", body: "Listen to your PDFs"),
    NewFeature(id: 2, title: "Image to text", body: "Listen to your Images"),
    NewFeature(id: 3, title: "Web to text", body: "Listen to websites")
])
