//
//  Notification.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI

struct NotificationItem: Identifiable, Codable, Hashable {
    let id: String?
    let fromId: String?
    let userId: String?
    let title: String?
    let message: String?
    let dateTime: String?
    let type: String?
    let bodyParams: String?
    let isRead: Bool?
    let fromName: String?
    let toName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fromId
        case userId = "user_id"
        case title
        case message = "msg"
        case dateTime = "dt_date"
        case type
        case bodyParams = "body_parms"
        case isRead
        case fromName
        case toName
    }
    
    // Add a computed property to map status to OrderType
    var notificationType: NotificationType? {
        return NotificationType(rawValue: type ?? "")
    }

    var formattedDate: String? {
        guard let dateString = dateTime else {
            return nil
        }
        return formatDateToString(createDateFromString(dateString, format: "yyyy-MM-dd") ?? Date(), format: "yyyy-MM-dd, hh:mm a")
    }

    // Convert Date to date string with specific format
    private func formatDateToString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    // Convert date string to Date with specific format
    private func createDateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
}

