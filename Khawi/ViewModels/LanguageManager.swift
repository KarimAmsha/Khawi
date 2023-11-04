//
//  LanguageManager.swift
//  Khawi
//
//  Created by Karim Amsha on 21.10.2023.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Locale = Locale(identifier: "ar")

    var isRTL: Bool {
        return currentLanguage.language.languageCode?.identifier == "ar"
    }

    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language.locale
//        UserDefaults.standard.set([currentLanguage.identifier], forKey: "AppleLanguages")
    }

    func currentLanguageKey() -> String {
        return isRTL ? "ar" : "en"
    }
}

enum AppLanguage {
    case english
    case arabic

    var locale: Locale {
        switch self {
        case .english:
            return Locale(identifier: "en")
        case .arabic:
            return Locale(identifier: "ar")
        }
    }
}
