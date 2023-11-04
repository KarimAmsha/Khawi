//
//  Color+Extensions.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static
    func primary() -> Color {
        return Color(hex: "EEA007")
    }
   
    static
    func black131313() -> Color {
        return Color(hex: "131313")
    }
    
    static
    func black141F1F() -> Color {
        return Color(hex: "141F1F")
    }
    
    static
    func black4E5556() -> Color {
        return Color(hex: "4E5556")
    }
    
    static
    func black666666() -> Color {
        return Color(hex: "666666")
    }
    
    static
    func gray898989() -> Color {
        return Color(hex: "898989")
    }
    
    static
    func grayE8E8E8() -> Color {
        return Color(hex: "E8E8E8")
    }
    
    static
    func grayDDDFDF() -> Color {
        return Color(hex: "DDDFDF")
    }
    
    static
    func gray4E5556() -> Color {
        return Color(hex: "4E5556")
    }

    static
    func grayF9FAFA() -> Color {
        return Color(hex: "F9FAFA")
    }

    static
    func grayE6E9EA() -> Color {
        return Color(hex: "E6E9EA")
    }

    static
    func gray918A8A() -> Color {
        return Color(hex: "918A8A")
    }
    
    static
    func grayA4ACAD() -> Color {
        return Color(hex: "A4ACAD")
    }
    
    static
    func grayECECEC() -> Color {
        return Color(hex: "ECECEC")
    }
    
    static
    func gray595959() -> Color {
        return Color(hex: "595959")
    }
    
    static
    func grayA1A1A1() -> Color {
        return Color(hex: "A1A1A1")
    }
    
    static
    func grayF9F9F9() -> Color {
        return Color(hex: "F9F9F9")
    }
    
    static
    func grayF8F8F8() -> Color {
        return Color(hex: "F8F8F8")
    }
    
    static
    func grayDEDEDE() -> Color {
        return Color(hex: "DEDEDE")
    }
    
    static
    func grayF5F5F5() -> Color {
        return Color(hex: "F5F5F5")
    }
    
    static
    func grayF2F2F3() -> Color {
        return Color(hex: "F2F2F3")
    }
    
    static
    func gray929292() -> Color {
        return Color(hex: "929292")
    }
    
    static
    func blue288599() -> Color {
        return Color(hex: "288599")
    }
    
    static
    func blue0094FF() -> Color {
        return Color(hex: "0094FF")
    }
    
    static
    func blue006E85() -> Color {
        return Color(hex: "006E85")
    }
    
    static
    func green0CB057() -> Color {
        return Color(hex: "0CB057")
    }
    
    static
    func green46CF85() -> Color {
        return Color(hex: "46CF85")
    }
    
    static
    func redFF5B5B() -> Color {
        return Color(hex: "FF5B5B")
    }

    static
    func redFF3F3F() -> Color {
        return Color(hex: "FF3F3F")
    }
    
    static
    func yellowFFFCF6() -> Color {
        return Color(hex: "FFFCF6")
    }
}
