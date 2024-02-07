//
//  AlertModel.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import Foundation

struct AlertModel: Hashable, Equatable {
    let iconType: IconType
    let title: String
    let message: String
    let hideCancelButton: Bool
    let onOKAction: () -> Void
    let onCancelAction: () -> Void
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(message)
    }

    static func == (lhs: AlertModel, rhs: AlertModel) -> Bool {
        return lhs.message == rhs.message
    }
}

import Foundation

struct AlertModelWithInput: Hashable, Equatable {
    let title: String
    let content: String
    let hideCancelButton: Bool
    let onOKAction: (String) -> Void
    let onCancelAction: () -> Void
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }

    static func == (lhs: AlertModelWithInput, rhs: AlertModelWithInput) -> Bool {
        return lhs.content == rhs.content
    }
}
