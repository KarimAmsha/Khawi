//
//  User.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import Foundation

struct User: Codable {
    let createAt: String?
    let isVerify: Bool?
    let isBlock: Bool?
    let wallet: Int?
    let _id: String?
    let full_name: String?
    let email: String?
    let password: String?
    let phone_number: String?
    let os: String?
    let lat: Double?
    let lng: Double?
    let fcmToken: String?
    let verify_code: String?
    let isEnableNotifications: Bool?
    let token: String?
    let image: String?
    let address: String?
    let carColor: String?
    let carModel: String?
    let carNumber: String?
    let carType: String?
    let hasCar: Bool?
    let rate: Double?
    let orders: Int?
    let delivery_address: [DeliveryAddress]?
        
    init(fromDictionary dictionary: [String: Any]) {
        createAt = dictionary["createAt"] as? String ?? ""
        isVerify = dictionary["isVerify"] as? Bool ?? false
        isBlock = dictionary["isBlock"] as? Bool ?? false
        wallet = dictionary["wallet"] as? Int ?? 0
        _id = dictionary["_id"] as? String ?? ""
        full_name = dictionary["full_name"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        password = dictionary["password"] as? String ?? ""
        phone_number = dictionary["phone_number"] as? String ?? ""
        os = dictionary["os"] as? String ?? ""
        lat = dictionary["lat"] as? Double ?? 0.0
        lng = dictionary["lng"] as? Double ?? 0.0
        fcmToken = dictionary["fcmToken"] as? String ?? ""
        verify_code = dictionary["verify_code"] as? String ?? ""
        isEnableNotifications = dictionary["isEnableNotifications"] as? Bool ?? false
        token = dictionary["token"] as? String ?? ""
        image = dictionary["image"] as? String ?? ""
        address = dictionary["address"] as? String ?? ""
        carColor = dictionary["carColor"] as? String ?? ""
        carModel = dictionary["carModel"] as? String ?? ""
        carNumber = dictionary["carNumber"] as? String ?? ""
        carType = dictionary["carType"] as? String ?? ""
        hasCar = dictionary["hasCar"] as? Bool ?? false
//        rate = dictionary["rate"] as? Double ?? 0.0
        if let rateValue = dictionary["rate"] as? Double {
            rate = rateValue
        } else if let rateValue = dictionary["rate"] as? Int {
            rate = Double(rateValue)
        } else {
            rate = nil
        }

        orders = dictionary["orders"] as? Int ?? 0
        delivery_address = dictionary["delivery_address"] as? [DeliveryAddress] ?? []
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        // Define your equality criteria here.
        return lhs._id == rhs._id
        // You can choose any property for comparison depending on your needs.
    }
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        // Combine hash values for all properties
        hasher.combine(createAt)
        hasher.combine(isVerify)
        hasher.combine(isBlock)
        hasher.combine(wallet)
        hasher.combine(_id)
        hasher.combine(full_name)
        hasher.combine(email)
        hasher.combine(password)
        hasher.combine(phone_number)
        hasher.combine(os)
        hasher.combine(lat)
        hasher.combine(lng)
        hasher.combine(fcmToken)
        hasher.combine(verify_code)
        hasher.combine(isEnableNotifications)
        hasher.combine(token)
        hasher.combine(image)
        hasher.combine(address)
        hasher.combine(carColor)
        hasher.combine(carModel)
        hasher.combine(carNumber)
        hasher.combine(carType)
        hasher.combine(hasCar)
        hasher.combine(rate)
        hasher.combine(orders)

        // If `delivery_address` is not nil, include its hash value
        if let deliveryAddress = delivery_address {
            for address in deliveryAddress {
                hasher.combine(address)
            }
        }
    }
}
