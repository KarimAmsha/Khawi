//
//  User.swift
//  Khawi
//
//  Created by Karim Amsha on 22.10.2023.
//

import Foundation

struct User: Codable, Hashable {
    var id: Int?
    var name: String?
    var company_name: String?
    var company_image: String?
    var bio: String?
    var email: String?
    var mobile: String?
    var image: String?
    var city_name: String?
    var city_id: Int?
    var address: String?
    var personal_id: String?
    var nationality: String?
    var license_number: String?
    var license_image: String?
    var bank_account: String?
    var iban: String?
    var type: Int?
    var verified: Bool?
    var enabled: Bool?
    var access_token: String?
    var dob: String?
    var rate: Int?
    var rate_count: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, company_name, company_image, bio, email, mobile, image, city_name, city_id, address, personal_id, nationality, license_number, bank_account, iban, type, verified, enabled, access_token, dob, rate, rate_count
    }

    init(_ userData: [String: Any]) {
        self.id = userData["id"] as? Int
        self.name = userData["name"] as? String
        self.company_name = userData["company_name"] as? String
        self.company_image = userData["company_image"] as? String
        self.bio = userData["bio"] as? String
        self.email = userData["email"] as? String
        self.mobile = userData["mobile"] as? String
        self.image = userData["image"] as? String
        self.city_name = userData["city_name"] as? String
        self.city_id = userData["city_id"] as? Int
        self.address = userData["address"] as? String
        self.personal_id = userData["personal_id"] as? String
        self.nationality = userData["nationality"] as? String
        self.license_number = userData["license_number"] as? String
        self.bank_account = userData["bank_account"] as? String
        self.iban = userData["iban"] as? String
        self.type = userData["type"] as? Int
        self.verified = userData["verified"] as? Bool
        self.enabled = userData["enabled"] as? Bool
        self.access_token = userData["access_token"] as? String
        self.dob = userData["dob"] as? String
        self.rate = userData["rate"] as? Int
        self.rate_count = userData["rate_count"] as? Int
    }
}
