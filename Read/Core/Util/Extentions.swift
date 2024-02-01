//
//  Extentions.swift
//  Read
//
//  Created by Ifeanyi Onuoha on 28/01/2024.
//

import SwiftUI

extension UIScreen{
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let size = UIScreen.main.bounds.size
}

extension String {
    var country: String? {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: self)
    }
    
    var flag: String? {
        let base : UInt32 = 127397
        var s = ""
        for v in (self.split(separator: "-").last ?? "").unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        if s.count > 1 {
            return nil
        }
        return String(s)
    }
}
