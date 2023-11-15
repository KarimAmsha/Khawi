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
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    static func randomStringWithDigits(_ numberOfDigits: Int, prefix: String = "seb3") -> String {
        // Ensure numberOfDigits is at least 6
        let totalDigits = numberOfDigits < 6 ? 6 : numberOfDigits

        // Generate a random string with the last 6 digits
        let randomSuffix = String(format: "%06d", arc4random_uniform(1000000))

        // Combine with the fixed "seb3" prefix
        let result = prefix + String(randomSuffix.suffix(totalDigits - 4))

        return result
    }
}
