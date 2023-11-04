//
//  CustomAnnotation.swift
//  Khawi
//
//  Created by Karim Amsha on 27.10.2023.
//

import SwiftUI
import MapKit

struct CustomAnnotation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String
}
