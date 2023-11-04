//
//  WelcomeItem.swift
//  Khawi
//
//  Created by Karim Amsha on 20.10.2023.
//

import Foundation

struct WelcomeItem {
    let imageName: String
    let titleKey: String
    let descriptionKey: String

    var title: String {
        return titleKey.localized
    }

    var description: String {
        return descriptionKey.localized
    }
}


