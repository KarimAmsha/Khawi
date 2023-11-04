//
//  String+Extensions.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func toInt() -> Int? {
        return Int(self)
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
}
