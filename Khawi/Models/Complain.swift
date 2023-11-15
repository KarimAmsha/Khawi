//
//  Complain.swift
//  Khawi
//
//  Created by Karim Amsha on 15.11.2023.
//

import Foundation

struct Complain: Identifiable, Codable, Hashable  {
    let id: String?
    let fullName: String?
    let email: String?
    let phoneNumber: String?
    let details: String?
    let dtDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName = "full_name"
        case email
        case phoneNumber = "phone_number"
        case details = "details"
        case dtDate = "dt_date"
    }
}
