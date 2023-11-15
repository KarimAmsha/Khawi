//
//  Mark.swift
//  Khawi
//
//  Created by Karim Amsha on 15.11.2023.
//

import Foundation
import MapKit

struct Mark: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var coordinate: CLLocationCoordinate2D
    var show: Bool = false
    var imageName: String // Name of the image for the map annotation
}

