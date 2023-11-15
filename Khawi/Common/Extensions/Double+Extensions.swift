//
//  Double+Extensions.swift
//  Khawi
//
//  Created by Karim Amsha on 8.11.2023.
//

import Foundation

extension Double {
    func rounded(toDecimalPlaces decimalPlaces: Int) -> Double {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func formattedString(toDecimalPlaces decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
    
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
}

