//
//  Notification.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct Notification: Identifiable, Hashable {
    var id = UUID()
    var name: String?
    var date: String?
    var title: String?
    var message: String?
    var isFromAdmin: Bool?
    var requestType: RequestType?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.id == rhs.id
    }
}
