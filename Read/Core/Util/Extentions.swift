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
    
    var trimUrl: String {
        if let url = URL(string: self), let domain = url.host {
            let components = domain.components(separatedBy: ".")
            if let baseDomain = components.first {
                return baseDomain
            }
        }
        return self
    }
}

extension Date {
    var dwdm: String {
        self.formatted(.dateTime.day().weekday().month())
    }
}

extension URL {
    var name: String {
        let domain = self.lastPathComponent
        if let primary = domain.split(separator: ".").first {
            return primary.description
        }
        return domain
    }
}
