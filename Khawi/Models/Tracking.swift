//
//  Tracking.swift
//  Khawi
//
//  Created by Karim Amsha on 19.11.2023.
//

import Foundation
import FirebaseDatabase

struct Tracking {
    var orderId: String
    var userId: String
    var status: String
    var lat: Double
    var lng: Double
    var lastUpdate: Int64

    init(orderId: String, userId: String, status: String, lat: Double, lng: Double, lastUpdate: Int64) {
        self.orderId = orderId
        self.userId = userId
        self.status = status
        self.lat = lat
        self.lng = lng
        self.lastUpdate = lastUpdate
    }

    init(_ snapshot: DataSnapshot) {
        let dic = snapshot.value as? [String: Any] ?? [:]
        orderId = dic["orderId"] as? String ?? ""
        userId = dic["userId"] as? String ?? ""
        status = dic["status"] as? String ?? ""
        lat = dic["lat"] as? Double ?? 0.0
        lng = dic["lng"] as? Double ?? 0.0
        lastUpdate = dic["lastUpdate"] as? Int64 ?? 0
    }

    func toDictionary() -> [String: Any] {
        return [
            "orderId": self.orderId,
            "userId": self.userId,
            "status": self.status,
            "lat": self.lat,
            "lng": self.lng,
            "lastUpdate": self.lastUpdate
        ]
    }
}
