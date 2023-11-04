//
//  Trip.swift
//  Khawi
//
//  Created by Karim Amsha on 25.10.2023.
//

import SwiftUI
import MapKit

class Trip: NSObject, ObservableObject, Identifiable, MKAnnotation {
    let id = UUID()
    let tripNumber: String?
    let imageURL: URL?
    let date: String?
    let status: OrderType?
    let fromDestination: String?
    let toDestination: String?
    let price: String?
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let type: RequestType?

    init(tripNumber: String?, imageURL: URL?, date: String?, status: OrderType?, fromDestination: String?, toDestination: String?, price: String?, title: String?, coordinate: CLLocationCoordinate2D, type: RequestType?) {
        self.tripNumber = tripNumber
        self.imageURL = imageURL
        self.date = date
        self.status = status
        self.fromDestination = fromDestination
        self.toDestination = toDestination
        self.price = price
        self.title = title
        self.coordinate = coordinate
        self.type = type
    }
}
