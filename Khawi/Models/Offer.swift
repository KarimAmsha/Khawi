//
//  Offer.swift
//  Khawi
//
//  Created by Karim Amsha on 7.11.2023.
//

import Foundation

struct Offer: Codable, Identifiable {
    let id: String?
    let user: User?
    let f_address: String?
    let t_address: String?
    let f_lat: Double?
    let f_lng: Double?
    let t_lat: Double?
    let t_lng: Double?
    let price: Double?
    let notes: String?
    let dt_date: String?
    let dt_time: String?
    let status: String?
    
    // Private CodingKeys enum to customize the coding keys
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case f_address
        case t_address
        case f_lat
        case f_lng
        case t_lat
        case t_lng
        case price
        case notes
        case dt_date
        case dt_time
        case status
    }

    // Add a computed property to map status to OrderType
    var offerStatus: OfferStatus? {
        return OfferStatus(rawValue: status ?? "")
    }
    
    var formattedDate: String? {
        guard let dateString = dt_date else {
            return nil
        }
        return formatDateToString(createDateFromString(dateString, format: "yyyy-MM-dd") ?? Date(), format: "yyyy-MM-dd")
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
}

extension Offer: Equatable {
    static func == (lhs: Offer, rhs: Offer) -> Bool {
        // Define your equality criteria here.
        return lhs.id == rhs.id
    }
}

extension Offer: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(f_address)
        hasher.combine(t_address)
        hasher.combine(f_lat)
        hasher.combine(f_lng)
        hasher.combine(t_lat)
        hasher.combine(t_lng)
        hasher.combine(price)
        hasher.combine(notes)
        hasher.combine(dt_date)
        hasher.combine(dt_time)
        hasher.combine(status)

        if let user = user {
            hasher.combine(user) // Assuming User is Hashable
        }
    }
}
