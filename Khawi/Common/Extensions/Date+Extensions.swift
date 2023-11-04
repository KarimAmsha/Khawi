//
//  Date+Extensions.swift
//  Khawi
//
//  Created by Karim Amsha on 28.10.2023.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
