//
//  ApiKey.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 23/04/2024.
//

import Foundation

enum APIKey {
    static private func plistValue(_ key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "Secrets-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'Secrets-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'Secrets-Info.plist'.")
        }
        if value.starts(with: "_") || value.isEmpty {
            fatalError(
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
    
    static var mixPanel: String {
        return plistValue("MIX_PANEL")
    }
    
    static var gemini: String {
        return plistValue("GEMINI")
    }
}
