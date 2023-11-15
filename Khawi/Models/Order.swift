//
//  Order.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import Foundation

struct Order: Codable, Identifiable {
    let id: String?
    let loc: Location?
    let days: [String]?
    let passengers: [String]?
    let title: String?
    let f_lat: Double?
    let f_lng: Double?
    let t_lat: Double?
    let t_lng: Double?
    let max_price: Double?
    let min_price: Double?
    let price: Double?
    let f_address: String?
    let t_address: String?
    let order_no: String?
    let tax: Double?
    let totalDiscount: Double?
    let netTotal: Double?
    let status: String?
    let createAt: String?
    let dt_date: String?
    let dt_time: String?
    let is_repeated: Bool?
    let couponCode: String?
    let paymentType: Int?
    let orderType: Int?
    let max_passenger: Int?
    let offers: [Offer]?
//    let user_id: String?
    let user: User?
    let notes: String?
    let canceled_note: String?
    
    // Use CodingKeys to customize key mapping
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case loc
        case days
        case passengers
        case title
        case f_lat
        case f_lng
        case t_lat
        case t_lng
        case max_price
        case min_price
        case price
        case f_address
        case t_address
        case order_no
        case tax
        case totalDiscount
        case netTotal
        case status
        case createAt
        case dt_date
        case dt_time
        case is_repeated
        case couponCode
        case paymentType
        case orderType
        case max_passenger
        case offers
//        case user_id
        case user
        case notes
        case canceled_note
    }

    // Encode id as _id
    var _id: String? {
        return id
    }

    // Add a computed property to map status to OrderType
    var type: OrderType? {
        return OrderType(rawValue: orderType ?? 0)
    }

    // Add a computed property to map status to OrderStatus
    var orderStatus: OrderStatus? {
        return OrderStatus(rawValue: status ?? "")
    }
    
    var displayedOrderStatus: OrderStatus? {
        return OrderStatus(rawValue: status ?? "")
    }
    
    var formattedDate: String? {
        guard let dateString = dt_date else {
            return nil
        }
        return formatDateToString(createDateFromString(dateString, format: "yyyy-MM-dd") ?? Date(), format: "yyyy-MM-dd")
    }

    var formattedCreatedDate: String? {
        guard let dateString = createAt else {
            return nil
        }
        return formatDateToString(createDateFromString(dateString, format: "yyyy-MM-dd") ?? Date(), format: "MMMM dd, yyyy")
    }

    // Convert date string to Date with specific format
    private func createDateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }

    // Convert Date to date string with specific format
    private func formatDateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    private func formattedDateFromString(_ dateString: String, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
}

extension Order: Equatable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        // Define your equality criteria here.
        return lhs.order_no == rhs.order_no
    }
}

extension Order: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(order_no)
    }
}
