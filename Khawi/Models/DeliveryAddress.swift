//
//  DeliveryAddress.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import Foundation

struct DeliveryAddress: Codable {
    var id: String?
    let createAt: String?
    let title: String?
    let lat: Double?
    let lng: Double?
    let address: String?
    let user_id: String?
    let isDefault: Bool?
    let discount: Int?
}

extension DeliveryAddress: Equatable {
    static func == (lhs: DeliveryAddress, rhs: DeliveryAddress) -> Bool {
        // Define your equality criteria here.
        return lhs.id == rhs.id
        // You can choose any property for comparison depending on your needs.
    }
}

extension DeliveryAddress: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(createAt)
        hasher.combine(title)
        hasher.combine(lat)
        hasher.combine(lng)
        hasher.combine(address)
        hasher.combine(user_id)
        hasher.combine(isDefault)
        hasher.combine(discount)
    }
}
