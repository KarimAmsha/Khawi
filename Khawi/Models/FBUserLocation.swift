//
//  FBUserLocation.swift
//  Khawi
//
//  Created by Karim Amsha on 11.11.2023.
//

import Foundation
import FirebaseDatabase

struct FBUserLocation {
    var driverName    : String
    var driverPhone   : Int64
    var g             : String
    var l             = [Double]()

    init(driverName: String, driverPhone: Int64, g: String, l: [Double]) {
        self.driverName       = driverName
        self.driverPhone      = driverPhone
        self.g                = g
        self.l                = l
    }
    
    init(_ snapshot: DataSnapshot) {
        let dic     = snapshot.value as? [String:Any] ?? [:]
        driverName        = dic["driverName"] as? String ?? ""
        driverPhone       = dic["driverPhone"] as? Int64 ?? 0
        g                 = dic["g"] as? String ?? ""
        l                 = dic["l"] as? [Double] ?? []
    }
    
    func toDictionary() -> [String: Any] {
        return
            [
                "driverName"        : self.driverName,
                "driverPhone"       : self.driverPhone,
                "g"                 : self.g,
                "l"                 : self.l
        ]
    }
}


